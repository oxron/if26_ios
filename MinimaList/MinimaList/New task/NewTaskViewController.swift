//
//  NewTaskViewController.swift
//  Minimalist
//
//  Created by Leuleu on 22/12/2019.
//  Copyright © 2019 Leuleu. All rights reserved.
//

import UIKit
import CoreData

class NewTaskViewController: UIViewController, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    
    

    @IBOutlet weak var taskTextField: UITextField!
    @IBOutlet weak var importantButton: UISwitch!
    @IBOutlet weak var dueDateTextField: UITextField!
    @IBOutlet weak var noteTextField: UITextField!
    @IBOutlet weak var pickerTextField: UITextField!
    
    let datePicker = UIDatePicker()
    let pickerView = UIPickerView()
    var dueDate : Date?
    var listeName : String!
    
    var tasks = [Task]()
       
    var listes = [Liste]()
       
       let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var selectedTask: Task?
  
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = selectedTask?.name
        
        taskTextField.delegate = self
        noteTextField.delegate = self
        pickerView.delegate = self
        // Do any additional setup after loading the view.
        
        showDatePicker()
        showListePicker()
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
            pickerTextField.text = task.liste
            listeName = task.liste
            noteTextField.text = task.note
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        let request: NSFetchRequest<Liste> = Liste.fetchRequest()
        
        do {
            listes = try context.fetch(request)
            pickerView.reloadAllComponents()
        }catch{
            print("Error fetching data from context \(error)")
        }
    }
    
    
    @IBAction func importantButton(_ sender: Any) {
    }
    
    
    @IBAction func saveTask(_ sender: Any) {
        
        if let task = self.selectedTask {
                   
                   task.name = taskTextField.text
            if importantButton.isOn == true {
                    task.important = true
            }else if importantButton.isOn == false{
                    task.important = false
            }
                   task.dueDate = dueDate
                   task.note = noteTextField.text
                   task.liste = listeName
               } else {
                   let newTask = Task(context: context)
                   
                   newTask.name = taskTextField.text
                   newTask.important = importantButton.isOn
                   newTask.dueDate = dueDate
                   newTask.note = noteTextField.text
                   newTask.liste = listeName
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
    
    //    Listes picker
      func showListePicker() {
          
          let toolbar = UIToolbar();
          toolbar.sizeToFit()
          let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(cancelListePicker));
          let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
          
          toolbar.setItems([spaceButton,doneButton], animated: false)
          
          pickerTextField.inputAccessoryView = toolbar
          pickerTextField.inputView = pickerView
          
      }
      
      @objc func cancelListePicker(){
          self.view.endEditing(true)
      }
      func numberOfComponents(in pickerView: UIPickerView) -> Int {
          1
      }
      
      func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
       return listes.count
      }
      func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
          return listes[row].listeName
      }
      
      func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
          let liste = listes[row].listeName
          pickerTextField.text = liste
          listeName = liste
          
      }
      
      

       func textFieldShouldReturn(_ textField: UITextField) -> Bool {
           textField.resignFirstResponder()
      
           return true
       }
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
           if text == "\n"  // Recognizes enter key in keyboard
           {
               textView.resignFirstResponder()
               return false
           }
           return true
       }
    
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
