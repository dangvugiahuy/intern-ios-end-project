//
//  ChooseTaskListTableViewCell.swift
//  Remind Me
//
//  Created by huy.dang on 10/1/24.
//

import UIKit

class ChooseTaskListTableViewCell: UITableViewCell {
    
    var taskList: TaskList? {
        didSet {
            setupUIWithData()
        }
    }
    
    var taskListChoosen: TaskList?
    
    @IBOutlet weak var iconTaskListImageView: UIImageView!
    @IBOutlet weak var choosenTaskListIconImageView: UIImageView!
    @IBOutlet weak var taskListLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        choosenTaskListIconImageView.isHidden = self.isSelected ? false : true
    }
    
    private func setupUIWithData() {
        if let taskList = self.taskList {
            taskListLabel.text = taskList.name
            iconTaskListImageView.tintColor = UIColor().colorFrom(hex: taskList.tintColor)
        }
    }
}
