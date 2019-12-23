//
//  TaskTableViewCell.swift
//  Minimalist
//
//  Created by Leuleu on 21/12/2019.
//  Copyright © 2019 Leuleu. All rights reserved.
//

import UIKit

class TaskTableViewCell: UITableViewCell {

    @IBOutlet weak var importantButton: UIButton!
    @IBOutlet weak var taskLabel: UILabel!
    @IBOutlet weak var deadlineLabel: UILabel!
    
    @IBOutlet weak var hourLabel: UILabel!
    
    @IBOutlet weak var taskLabel1: UILabel!
    @IBOutlet weak var deadlineLabel1: UILabel!
    @IBOutlet weak var hourLabel1: UILabel!
    
    @IBOutlet weak var importantButton2: UIButton!
    @IBOutlet weak var taskLabel2: UILabel!
    @IBOutlet weak var deadlineLabel2: UILabel!
    @IBOutlet weak var hourLabel2: UILabel!
    
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setCell(task : Task){
        
        if let date = task.dueDate {
            deadlineLabel.text = listDate(date)
            hourLabel.text = hourDate(date)
        }else {
            deadlineLabel.text = ""
            hourLabel.text = ""
        }
    }
    
    func setCell1(task : Task){
           
           if let date = task.dueDate {
               deadlineLabel1.text = listDate(date)
               hourLabel1.text = hourDate(date)
           }else {
               deadlineLabel1.text = ""
               hourLabel1.text = ""
           }
       }
    
    func setCell2(task : Task){
        
        if let date = task.dueDate {
            deadlineLabel2.text = listDate(date)
            hourLabel2.text = hourDate(date)
        }else {
            deadlineLabel2.text = ""
            hourLabel2.text = ""
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func listDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM."
        return formatter.string(from: date)
    }
    
    func hourDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter.string(from: date)
    }

}
