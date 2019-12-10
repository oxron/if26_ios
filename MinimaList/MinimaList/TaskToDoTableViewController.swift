//
//  TaskTableViewController.swift
//  Minimalist
//
//  Created by Leuleu on 10/12/2019.
//  Copyright © 2019 Leuleu. All rights reserved.
//

import UIKit

class TaskToDoTableViewController: UITableViewController {
    
    var liste : Liste? = nil

    var tasks : [Task] = []

       override func viewDidLoad() {
           super.viewDidLoad()
           

       }
       

       
       
      override func viewWillAppear(_ animated: Bool) {
             if let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext {
                 if let coreDataList = try? context.fetch(Liste.fetchRequest()) as? [Task] {
                     tasks = coreDataList
                     tableView.reloadData()
                 }
             }
         }

       // MARK: - Table view data source

    /*   override func numberOfSections(in tableView: UITableView) -> Int {
           // #warning Incomplete implementation, return the number of sections
           return 0
       } */

       override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
           // #warning Incomplete implementation, return the number of rows
           return tasks.count
       }
       
       
       override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
           let cell = UITableViewCell()

           // Configure the cell...
           let task = tasks[indexPath.row]
           
        cell.textLabel?.text = task.name

           return cell
       }
       
       override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
           let selectedtask = tasks[indexPath.row]
           performSegue(withIdentifier: "goToTask", sender: selectedtask)
       }
       
       override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
           
           
           if let listeDetail = segue.destination as? TaskTableViewController {
               if let task = sender as? Task {
                   listeDetail.task = task
                   
               }
           }
       }

}
