//
//  TaskViewController.swift
//  Minimalist
//
//  Created by Leuleu on 10/12/2019.
//  Copyright © 2019 Leuleu. All rights reserved.
//

import UIKit
import CoreData

class TaskViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var taskField: UITextField!
    @IBOutlet weak var importantButton: UISwitch!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        taskField.delegate = self
        // Do any additional setup after loading the view.
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
   
        return true
    }
    
    @IBAction func addButton(_ sender: UIButton) {
        
        if let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext {
        let newTask = Task(context: context)
        if let task =  taskField.text {
            newTask.name = task
            newTask.important = importantButton.isOn
            (UIApplication.shared.delegate as? AppDelegate)?.saveContext()
            navigationController?.popViewController(animated: true)
            }
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
