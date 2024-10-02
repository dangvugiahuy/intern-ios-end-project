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
    
    
    @IBOutlet weak var completedTaskCheckButton: UIButton!
    @IBOutlet weak var timeIconImageView: UIImageView!
    @IBOutlet weak var cellContainView: UIView!
    @IBOutlet weak var taskPriorityLabel: UILabel!
    @IBOutlet weak var taskTimeStackView: UIStackView!
    @IBOutlet weak var taskTimeLabel: UILabel!
    @IBOutlet weak var taskNameLabel: UILabel!
    @IBOutlet weak var taskDateLabel: UILabel!
    @IBOutlet weak var priorityIconImageView: UIImageView!
    @IBOutlet weak var taskListButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupInitUI()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func prepareForReuse() {
        completedTaskCheckButton.isSelected = false
    }
    
    private func setupInitUI() {
        let corner = cellContainView.frame.height / 15
        cellContainView.layer.shadowRadius = 5
        cellContainView.layer.shadowColor = UIColor.black.cgColor
        cellContainView.layer.shadowOpacity = 0.2
        cellContainView.layer.shadowOffset = .zero
        cellContainView.layer.cornerRadius = corner
        cellContainView.clipsToBounds = true
        cellContainView.layer.masksToBounds = false
        taskListButton.setupFilledButton()
        completedTaskCheckButton.setImage(UIImage(systemName: "square")?.withRenderingMode(.automatic), for: .normal)
        let config = UIImage.SymbolConfiguration(paletteColors: [.redscale900, .greyscale800])
        completedTaskCheckButton.setImage(UIImage(systemName: "checkmark.square")?.applyingSymbolConfiguration(config), for: .selected)
    }
    
    private func setupUIWithData() {
        if let task = self.task {
            completedTaskCheckButton.isSelected = task.completed ? true : false
            taskPriorityLabel.text = Priority.toString(prior: task.priority)
            taskPriorityLabel.textColor = Priority.setColor(prior: task.priority)
            priorityIconImageView.tintColor = Priority.setColor(prior: task.priority)
            taskNameLabel.text = task.title
            taskDateLabel.isHidden = task.date != nil ? false : true
            taskDateLabel.text = taskDateLabel.isHidden ? "" : Date.dateToString(date: task.date!, format: "EEE, d MMM yyyy")
            taskTimeLabel.text = task.time != nil ? DateFormatter().formated(from: Date(timeIntervalSince1970: task.time!), with: "h:mm a") : ""
            timeIconImageView.isHidden = task.time != nil ? false : true
            taskListButton.setAttributedTitle(NSMutableAttributedString(string: task.taskList!.name, attributes: [NSAttributedString.Key.font : UIFont(name: "Poppins-Regular", size: 12) ?? UIFont.systemFont(ofSize: 12)]), for: .normal)
            taskListButton.tintColor = UIColor().colorFrom(hex: task.taskList!.tintColor)
        }
    }
    
    @IBAction func completeTaskCheckButtonClicked(_ sender: Any) {
        completedTaskCheckButton.isSelected.toggle()
    }
    
}
