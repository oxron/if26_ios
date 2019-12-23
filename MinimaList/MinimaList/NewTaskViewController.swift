//
//  NewTaskViewController.swift
//  Minimalist
//
//  Created by Leuleu on 22/12/2019.
//  Copyright © 2019 Leuleu. All rights reserved.
//

import UIKit
import CoreData

class NewTaskViewController: UIViewController, UITextFieldDelegate, UIPickerViewDelegate {

    @IBOutlet weak var taskTextField: UITextField!
    @IBOutlet weak var importantButton: UISwitch!
    @IBOutlet weak var dueDateTextField: UITextField!
    @IBOutlet weak var noteTextField: UITextField!
    let datePicker = UIDatePicker()
    var dueDate : Date?
    
    var tasks = [Task]()
       
       var listes = [Liste]()
       
       let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var selectedTask: Task?
    
    var selectedListe: Liste?
  
    
    override func viewDidLoad() {
        super.viewDidLoad()

        taskTextField.delegate = self
        noteTextField.delegate = self
        // Do any additional setup after loading the view.
        
        showDatePicker()
        taskTextField.becomeFirstResponder()
        
        if let task = selectedTask {
            taskTextField.text = task.name
            if task.important == true {
                importantButton.isOn = true
            } else{
                importantButton.isOn = false
            }
        
            if let date = task.dueDate {
                dueDateTextField.isHidden = false
                dueDateTextField.text = fullStringFromDate(date)
                datePicker.date = date
                dueDate = date
            }
            
            noteTextField.text = task.note
        }
    }
    
    
    
    @IBAction func importantButton(_ sender: Any) {
    }
    @IBAction func saveTask(_ sender: Any) {
        
        if let task = self.selectedTask {
                   
                   task.name = taskTextField.text
            if importantButton.isOn == true {
                    task.important = true
            }else{
                    task.important = false
            }
                   task.dueDate = dueDate
                   task.note = noteTextField.text
               } else {
                   let newTask = Task(context: context)
                   
                   newTask.name = taskTextField.text
                   newTask.important = importantButton.isOn
                   newTask.dueDate = dueDate
                   newTask.note = noteTextField.text
                  
               }
               
               do {
                   try context.save()
                   navigationController?.popViewController(animated: true)
               } catch {
                   print("Error saving task: \(error)")
               }
    }
    
    
    
    func showDatePicker(){
        
        datePicker.datePickerMode = .dateAndTime
        datePicker.minuteInterval = 15
        datePicker.locale = Locale(identifier: "en_GB")
        
        //Date picker ToolBar
        let toolbar = UIToolbar();
        toolbar.sizeToFit()
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelDatePicker));
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(doneDatePicker));
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        toolbar.setItems([cancelButton,spaceButton,doneButton], animated: false)
        
        dueDateTextField.inputAccessoryView = toolbar
        dueDateTextField.inputView = datePicker
    }
    
    @objc func doneDatePicker(){
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy HH:mm"
        dueDateTextField.text = formatter.string(from: datePicker.clampedDate)
        dueDate = datePicker.clampedDate
        self.view.endEditing(true)
    }
    
    @objc func cancelDatePicker(){
        self.view.endEditing(true)
    }
    
    func dateFromString(date: String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy HH:mm"
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.locale = Locale.current
        return dateFormatter.date(from: date)
    }
    
    func fullStringFromDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy HH:mm"
        return formatter.string(from: date)
    }
    
}

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
   
        return true
    }

extension UIDatePicker {
/// Returns the date that reflects the displayed date clamped to the `minuteInterval` of the picker.
public var clampedDate: Date {
    let referenceTimeInterval = self.date.timeIntervalSinceReferenceDate
    let remainingSeconds = referenceTimeInterval.truncatingRemainder(dividingBy: TimeInterval(minuteInterval*60))
    let timeRoundedToInterval = referenceTimeInterval - remainingSeconds
    return Date(timeIntervalSinceReferenceDate: timeRoundedToInterval)
}
}
