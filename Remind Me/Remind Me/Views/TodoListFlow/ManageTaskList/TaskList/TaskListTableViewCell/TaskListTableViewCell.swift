//
//  TaskListTableViewCell.swift
//  Remind Me
//
//  Created by huy.dang on 9/30/24.
//

import UIKit

class TaskListTableViewCell: UITableViewCell {
    
    var taskListItem: TaskList? {
        didSet {
            setupUIWithData()
        }
    }

    @IBOutlet weak var icon1ImageView: UIImageView!
    @IBOutlet weak var icon2ImageView: UIImageView!
    @IBOutlet weak var taskListNameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    private func setupUIWithData() {
        if let taskListItem = self.taskListItem {
            icon1ImageView.tintColor = UIColor().colorFrom(hex: taskListItem.tintColor.tint)
            icon2ImageView.tintColor = UIColor().colorFrom(hex: taskListItem.tintColor.tint)
            taskListNameLabel.text = taskListItem.name
        }
    }

}
