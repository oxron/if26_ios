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
    

    var tasks = [Task]()

    

    var sortedTasks = [Task]()
    
    var selectedListe:Liste?
    

    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    override func viewDidLoad() {
        super.viewDidLoad()
      
      
    }
    
    override func viewWillAppear(_ animated: Bool) {
    
        importantTasks()
        sortedTasks = tasks.sorted{
            ($0.dueDate ?? .distantFuture) < ($1.dueDate ?? .distantFuture)
        }
      
    }
    
    func importantTasks(){
        let request: NSFetchRequest<Task> = Task.fetchRequest()
        request.returnsObjectsAsFaults = false
        request.predicate = NSPredicate(format: "important == true")

        do {
            tasks = try context.fetch(request)
        }catch{
            print("Error fetching data from context \(error)")
        }
        tableView.reloadData()
    }


       

    // MARK: - Table view data source

   
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
       if sortedTasks.count == 0 {
            self.tableView.setEmptyMessage("Il n'y a pas de tâches importante")
        } else {
            self.tableView.restore()
        }
        return sortedTasks.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "taskCell", for: indexPath) as! TaskTableViewCell

        // Configure the cell...
        let task = sortedTasks[indexPath.row]
        cell.taskLabel1.text = task.name
           cell.setCell1(task: task)
        
           
           if task.done {
               cell.backgroundColor = #colorLiteral(red: 0.8320295215, green: 0.9826709628, blue: 0, alpha: 1)
           } else {
               cell.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
           }
        

        return cell
    }
    
    override func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
             let taskCompletion = sortedTasks[indexPath.row].done ? "Restart" : "Complete"
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
            performSegue(withIdentifier: "toDetail1", sender: tableView.cellForRow(at: indexPath))
            
        }
     
    
      
      override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
          
         if let destinationVC = segue.destination as? NewTaskViewController {
             if let indexPath = tableView.indexPathForSelectedRow {
                 destinationVC.selectedTask = sortedTasks[indexPath.row]
             }
         }
             
         }
          
     

    @IBAction func addTask(_ sender: Any) {
        
        performSegue(withIdentifier: "toDetail1", sender: UITabBarItem.self)
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
