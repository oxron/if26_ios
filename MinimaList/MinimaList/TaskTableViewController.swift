//
//  TaskTableViewController.swift
//  Minimalist
//
//  Created by Leuleu on 10/12/2019.
//  Copyright © 2019 Leuleu. All rights reserved.
//

import UIKit
import CoreData

class TaskTableViewController: UITableViewController {

    var task : Task? = nil
    var liste : Liste? = nil
    
    var tasks : [Task] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        
         self.tableView.reloadData()
        
    }

    // MARK: - Table view data source
    
    override func viewWillAppear(_ animated: Bool) {
        if let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext {
            if let coreDataTask = try? context.fetch(Task.fetchRequest()) as? [Task] {
                tasks = coreDataTask
                tableView.reloadData()
            }
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return tasks.count
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomCell", for: indexPath) as! CustomCellTableViewCell
              
              let task = tasks[indexPath.row]
              
              cell.taskLabel.text = task.name
        
              if task.important {
                if let name = task.name {
                    cell.taskLabel.text = name
                    cell.importantButton.isHidden = false
                  }
              } else {
                
                  cell.taskLabel.text = task.name
              }

        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedtask = tasks[indexPath.row]
        performSegue(withIdentifier: "goToTask", sender: selectedtask)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        
        if let taskDetail = segue.destination as? CompleteViewController {
            if let task = sender as? Task {
                taskDetail.task = task
                
            }
        }
    }
  
   // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    

    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tasks.remove(at: indexPath.row)
            self.tableView.deleteRows(at: [indexPath], with: .fade)
            self.tableView.reloadData()
        }
        
        
    }
    

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
