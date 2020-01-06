//
//  ListeTableViewController.swift
//  Minimalist
//
//  Created by Leuleu on 21/12/2019.
//  Copyright © 2019 Leuleu. All rights reserved.
//

import UIKit
import CoreData

class ListeTableViewController: UITableViewController {
    
    var listes = [Liste]()
    var indexNumber = Int()
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }

    // MARK: - Table view data source
    
    override func viewWillAppear(_ animated: Bool) {
        if let coreDataListe = try? context.fetch(Liste.fetchRequest()) as? [Liste]{
            listes = coreDataListe
            tableView.reloadData()
        }
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return listes.count + 3
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
       
        // Configure the cell...
        
        switch  indexPath.row {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "staticCell1", for: indexPath)
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "staticCell2", for: indexPath)
            return cell
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: "staticCell3", for: indexPath)
            return cell
        default:
            let liste = listes[indexPath.row - 3]
            let cell = tableView.dequeueReusableCell(withIdentifier: "dynamicCell", for: indexPath)
            cell.textLabel?.text = liste.listeName
            return cell
        }
        
        
    }
    
    
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
    switch  indexPath.row {
    case 0:
        self.performSegue(withIdentifier: "goToTask", sender: self)
    case 1:
        self.performSegue(withIdentifier: "goToImportant", sender: self)
    case 2:
        self.performSegue(withIdentifier: "goToPlanned", sender: self)
    default:
        self.performSegue(withIdentifier: "goToTask1", sender: self)
    }
       
    }
    
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    let identifier = segue.identifier
    switch identifier {
    case "goToTask":
        return
    case "goToImportant":
        return
    case "goToPlanned":
        return
    default:
        let destination = segue.destination as! TaskDynamicTableViewController
            if let indexPath = tableView.indexPathForSelectedRow{
                destination.selectedListe = listes[indexPath.row - 3]
            }
        
    }
    }
    
    func saveFiles() {
        
        do{
            try context.save()
        }catch {
            print("Error saving context \(error)")
        }
        
        self.tableView.reloadData()
    }
    
    @IBAction func addListeButton(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Ajouter Nouvelle Liste", message: "Nouvelle Liste", preferredStyle: .alert)
        
        let add = UIAlertAction(title: "Ajouter", style: .default) { (action) in
            
            if !textField.text!.isEmpty {
                
                let newListe = Liste(context: self.context)
                
                newListe.listeName = textField.text!
                
                self.listes.append(newListe)
                
                self.saveFiles()
            }
        }
        
        let cancel = UIAlertAction(title: "Cancel", style: .default) { (action) in
            
            self.dismiss(animated: true, completion: nil)
        }
        
        alert.addTextField { (alertTextField) in
            
            alertTextField.placeholder = "Créer nouvelle Liste"
            
            textField = alertTextField
        }
        
        alert.addAction(cancel)
        alert.addAction(add)
        
        present(alert, animated: true, completion: nil)
    }
    
    
    // Override to support editing the table view.
      override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
             if editingStyle == .delete {
                 // Delete the row from the data source
              
                    context.delete(listes[indexPath.row - 3])
                    listes.remove(at: indexPath.row - 3)
                    tableView.deleteRows(at: [indexPath], with: .fade)
                    
                    do {
                            try context.save()
                    } catch {
                        
                    }
                    
                    tableView.reloadData()
              }
    
             }
             
             
         }
    

