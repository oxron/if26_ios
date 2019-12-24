//
//  TaskDynamicTableViewController.swift
//  Minimalist
//
//  Created by Leuleu on 21/12/2019.
//  Copyright © 2019 Leuleu. All rights reserved.
//

import UIKit
import CoreData

class TaskDynamicTableViewController: UITableViewController {
    
    var tasks = [Task]()
    var sortedTasks = [Task]()
    var selectedListe: Liste?{
        didSet{
            loadTasks()
        }
    }
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    override func viewDidLoad() {
        super.viewDidLoad()
        

        navigationItem.title = selectedListe?.listeName
    
    }

    //MARK : Data Manipulation Methods

    override func viewWillAppear(_ animated: Bool) {
        
        loadTasks()
        sortedTasks = tasks.sorted{
            ($0.dueDate ?? .distantFuture) < ($1.dueDate ?? .distantFuture)
        }
        
    tableView.reloadData()
    }
    
    //    Loads Tasks entity from CoreData
    func loadTasks(){
        let request: NSFetchRequest<Task> = Task.fetchRequest()
        request.returnsObjectsAsFaults = false
        request.predicate = NSPredicate(format: "liste MATCHES %@", selectedListe!.listeName!)
        
        do {
            tasks = try context.fetch(request)
        }catch{
            print("Error fetching data from context \(error)")
        }
        tableView.reloadData()
    }
    
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
               if sortedTasks.count == 0 {
                   self.tableView.setEmptyMessage("Toute les tâches sont complétées")
               } else {
                   self.tableView.restore()
               }
               return sortedTasks.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "taskCell", for: indexPath) as! TaskTableViewCell

        // Configure the cell...
        let task = sortedTasks[indexPath.row]
        
        cell.taskLabel.text = task.name
        cell.setCell(task: task)
     
        if task.important == true {
            
            cell.importantButton.isHidden = false
        }else if task.important == false{
            cell.importantButton.isHidden = true
        }
        
        if task.done {
            cell.backgroundColor = #colorLiteral(red: 0.0671977813, green: 0.8235294223, blue: 0.0006074571761, alpha: 1)
        } else {
            cell.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        }

        return cell
    }
    
   override func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
            let taskCompletion = sortedTasks[indexPath.row].done ? "Refaire" : "Complete"
            let action = UIContextualAction(style: .normal, title: taskCompletion) { (action, view, completion) in
                self.sortedTasks[indexPath.row].done = !self.sortedTasks[indexPath.row].done
                
                do{
                    try self.context.save()
                    
                    completion(true)
                }catch {
                    print("Error saving item with \(error)")
                }
                tableView.reloadData()
            }
            action.backgroundColor = .green
            
            return UISwipeActionsConfiguration(actions: [action])
        }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
           return true
       }
       
       override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
           performSegue(withIdentifier: "toDetail", sender: tableView.cellForRow(at: indexPath))
           
       }
    
   
     
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
         
        if let destinationVC = segue.destination as? NewTaskViewController {
            if let indexPath = tableView.indexPathForSelectedRow {
                destinationVC.selectedTask = sortedTasks[indexPath.row]
                
            }
        }
            
        }
         
    
    @IBAction func addTask(_ sender: UIBarButtonItem) {
        
        performSegue(withIdentifier: "toDetail", sender: UITabBarItem.self)
        
        let newTask = Task(context: self.context)
        newTask.parentListe = self.selectedListe
        self.saveFiles()
    }
    
    func saveFiles() {
        
        do {
            try context.save()
        } catch {
            print("Error saving context \(error)")
        }
        
        self.tableView.reloadData()
    }

    

    
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
    if editingStyle == .delete {
        // Delete the row from the data source
        
        context.delete(sortedTasks[indexPath.row])
        sortedTasks.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .fade)
        
        do {
                try context.save()
           
        } catch {
            
        }
        
        tableView.reloadData()
    }
        
    
        

    
        
    
    
   

}
}

extension UITableView {
    //    Adds an info message when there are no tasks in the app.
    func setEmptyMessage(_ message: String) {
        let messageLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.bounds.size.width, height: self.bounds.size.height))
        messageLabel.text = message
        messageLabel.textColor = .black
        messageLabel.numberOfLines = 0;
        messageLabel.textAlignment = .center;
        messageLabel.sizeToFit()
        
        self.backgroundView = messageLabel;
        self.separatorStyle = .none;
    }
    
    func restore() {
        self.backgroundView = nil
        self.separatorStyle = .singleLine
    }
}
