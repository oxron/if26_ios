//
//  ImportantTableViewController.swift
//  Minimalist
//
//  Created by Leuleu on 23/12/2019.
//  Copyright © 2019 Leuleu. All rights reserved.
//

import UIKit
import CoreData

class ImportantTableViewController: UITableViewController {
    

    var tasks = [Task](){
        didSet{
            importantData()
        }
    }
    var sortedTasks = [Task]()

    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    override func viewDidLoad() {
        super.viewDidLoad()

        importantData()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
       
      
    }

    
   func importantData(){
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Task")
        request.returnsObjectsAsFaults = false
        do {
            let result = try? context.fetch(request)
            for r in result as! [NSManagedObject]{
                let tasks = r as! Task
                if tasks.important == true {
                    
                    print(tasks)
                  
                   
                    }
            
            }
        }
    }
       

    // MARK: - Table view data source

   
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return tasks.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "taskCell", for: indexPath) as! TaskTableViewCell

        // Configure the cell...
        let task = tasks[indexPath.row]
        if task.important == true {
            cell.textLabel?.text = task.name
        }
        

        return cell
    }

}
