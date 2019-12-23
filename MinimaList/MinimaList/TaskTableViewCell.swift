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
