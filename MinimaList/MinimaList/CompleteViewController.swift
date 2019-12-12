//
//  CompleteViewController.swift
//  Minimalist
//
//  Created by Leuleu on 10/12/2019.
//  Copyright © 2019 Leuleu. All rights reserved.
//

import UIKit

class CompleteViewController: UIViewController {

   

    @IBOutlet weak var taskLabel: UILabel!
    @IBOutlet weak var importantTask: UIButton!
    
    var task : Task? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if task != nil {
            if task!.important {
                if let name = task?.name {
                    taskLabel.text = name
                    importantTask.isHidden = false
                }
            } else {
                taskLabel.text = task!.name
            }
        }

        // Do any additional setup after loading the view.
    }
    

    
    @IBAction func doneButton(_ sender: Any) {
        
        if let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext {
                if task != nil {
                    context.delete(task!)
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
