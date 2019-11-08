//
//  CreateToDoViewController.swift
//  MinimaList
//
//  Created by Leuleu on 08/11/2019.
//  Copyright © 2019 Leuleu. All rights reserved.
//

import UIKit

class CreateToDoViewController: UIViewController {

   
   
    @IBOutlet weak var TaskTextField: UITextField!
    var toDoTableVC : ToDoTableViewController? = nil
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    
    


    @IBAction func AddTask(_ sender: Any) {
        
        let newTask = ToDo()
        if let name = TaskTextField.text {
            newTask.name = name
            toDoTableVC?.toDos.append(newTask)
            toDoTableVC?.tableView.reloadData()
            navigationController?.popViewController(animated: true)
        }

    }
    

}
