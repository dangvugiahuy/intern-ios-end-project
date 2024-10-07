//
//  TaskListTodoTableViewCell.swift
//  Remind Me
//
//  Created by huy.dang on 10/3/24.
//

import UIKit

protocol TaskListTodoTableViewCellDelegate: AnyObject {
    func setTaskComplete(cell: UITableViewCell, task: Todo)
    func deleteTaskHandle(cell: UITableViewCell, task: Todo)
    func editTaskHandle(cell: UITableViewCell, task: Todo)
}

class TaskListTodoTableViewCell: UITableViewCell {
    
    var todo: Todo? {
        didSet {
            setUIWithData()
        }
    }
    
    var indexPath: IndexPath?
    weak var delegate: TaskListTodoTableViewCellDelegate?

    @IBOutlet weak var editTaskButton: UIButton!
    @IBOutlet weak var cellContainView: UIView!
    @IBOutlet weak var taskDateLabel: UILabel!
    @IBOutlet weak var taskTimeIcon: UIImageView!
    @IBOutlet weak var taskCompleteCheckButton: UIButton!
    @IBOutlet weak var taskPriorityLabel: UILabel!
    @IBOutlet weak var taskTitleLabel: UILabel!
    @IBOutlet weak var taskTimeLabel: UILabel!
    @IBOutlet weak var taskPriorityIcon: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func prepareForReuse() {
        taskCompleteCheckButton.isSelected = false
    }
    
    private func setupUI() {
        cellContainView.layer.shadowRadius = 5
        cellContainView.layer.shadowColor = UIColor.black.cgColor
        cellContainView.layer.shadowOpacity = 0.2
        cellContainView.layer.shadowOffset = .zero
        cellContainView.layer.cornerRadius = 15
        cellContainView.clipsToBounds = true
        cellContainView.layer.masksToBounds = false
        taskCompleteCheckButton.setImage(UIImage(systemName: "square")?.withRenderingMode(.automatic), for: .normal)
        let config = UIImage.SymbolConfiguration(paletteColors: [.redscale900, .greyscale800])
        taskCompleteCheckButton.setImage(UIImage(systemName: "checkmark.square")?.applyingSymbolConfiguration(config), for: .selected)
        editTaskButton.showsMenuAsPrimaryAction = true
    }
    
    private func setUIWithData() {
        if let todo = self.todo {
            taskPriorityLabel.text = Priority.toString(prior: todo.priority)
            taskPriorityLabel.textColor = Priority.setColor(prior: todo.priority)
            taskPriorityIcon.tintColor = Priority.setColor(prior: todo.priority)
            taskTitleLabel.text = todo.title
            taskDateLabel.text = todo.date != nil ? Date.dateToString(date: todo.date!, format: "EEE, d MMM yyyy") : "No due date"
            taskTimeIcon.isHidden = todo.time != nil ? false : true
            taskTimeLabel.isHidden = todo.time != nil ? false : true
            taskTimeLabel.text = taskTimeLabel.isHidden ? "" : DateFormatter().formated(from: Date(timeIntervalSince1970: todo.time!), with: "h:mm a")
            editTaskButton.menu = createMenu()
        }
    }
    
    @IBAction func taskCompleteCheckButtonClicked(_ sender: Any) {
        taskCompleteCheckButton.isSelected.toggle()
        todo?.completed = true
        delegate?.setTaskComplete(cell: self, task: todo!)
    }
    
    private func createMenu() -> UIMenu {
        return UIMenu(children: [
            UIAction(title: "Detail", image: UIImage(systemName: "info.circle"), handler: { [self] _ in
                delegate?.editTaskHandle(cell: self, task: todo!)
            }),
            UIAction(title: "Delete", image: UIImage(systemName: "trash"), attributes: .destructive, handler: { [self] _ in
                delegate?.deleteTaskHandle(cell: self, task: todo!)
            })
        ])
    }
}
