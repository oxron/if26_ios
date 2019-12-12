//
//  ListeTableViewController.swift
//  Minimalist
//
//  Created by Leuleu on 10/12/2019.
//  Copyright © 2019 Leuleu. All rights reserved.
//

import UIKit
import CoreData

class ListeTableViewController: UITableViewController {

    
    @IBOutlet weak var TaskLabel: UIView!
    @IBOutlet weak var ImportantLabel: UIView!
    @IBOutlet weak var PlannedLabel: UIView!
    
    var listes : [Liste] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        
        
        
        

    }

    override func viewWillAppear(_ animated: Bool) {
           if let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext {
               if let coreDataList = try? context.fetch(Liste.fetchRequest()) as? [Liste] {
                   listes = coreDataList
                   tableView.reloadData()
               }
           }
       }

    // MARK: - Table view data source

    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return listes.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "StaticCell", for: indexPath)

        let list = listes[indexPath.row]
        
        cell.textLabel?.text = list.liste


        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedList = listes[indexPath.row]
        performSegue(withIdentifier: "goToList", sender: selectedList)
    }
    
   override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        
       if let listeDetail = segue.destination as? TaskTableViewController {
            if let liste = sender as? Liste {
                listeDetail.liste = liste
                
            }
        }
    }
    

 


}
