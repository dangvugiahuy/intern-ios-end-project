//
//  TaskTableViewCell.swift
//  Remind Me
//
//  Created by Huy Gia on 1/10/24.
//

import UIKit

class TaskTableViewCell: UITableViewCell {
    
    var task: Todo? {
        didSet {
            setupUIWithData()
        }
    }
    
    
    @IBOutlet weak var taskPriorityLabel: UILabel!
    @IBOutlet weak var taskTimeStackView: UIStackView!
    @IBOutlet weak var taskTimeLabel: UILabel!
    @IBOutlet weak var taskNameLabel: UILabel!
    @IBOutlet weak var taskDateLabel: UILabel!
    @IBOutlet weak var taskListButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupInitUI()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    private func setupInitUI() {
        self.layer.cornerRadius = 8
        self.layer.shadowOffset = CGSize(width: 0, height: 3)
        self.layer.shadowRadius = 3
        self.layer.shadowOpacity = 0.3
        self.layer.shadowPath = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: .allCorners, cornerRadii: CGSize(width: 8, height: 8)).cgPath
        self.layer.shouldRasterize = true
        self.layer.rasterizationScale = UIScreen.main.scale
        taskListButton.setupFilledButton()
    }
    
    private func setupUIWithData() {
        if let task = self.task {
            taskPriorityLabel.text = "Priority: \(Priority.toString(prior: task.priority))"
            taskNameLabel.text = task.title
            taskTimeStackView.isHidden = task.time != nil ? false : true
            taskDateLabel.isHidden = task.date != nil ? false : true
            taskTimeLabel.text =  taskTimeStackView.isHidden ? "" : DateFormatter().formated(from: Date(timeIntervalSinceNow: task.time!), with: "h:mm a")
            taskDateLabel.text = taskDateLabel.isHidden ? "" : Date.dateToString(date: task.date!)
            taskListButton.setTitle(task.taskList?.name, for: .normal) 
            taskListButton.tintColor = UIColor().colorFrom(hex: (task.taskList?.tintColor.tint)!)
            taskListButton.backgroundColor = UIColor().colorFrom(hex: (task.taskList?.tintColor.backgroundTint)!)
        }
    }

}
