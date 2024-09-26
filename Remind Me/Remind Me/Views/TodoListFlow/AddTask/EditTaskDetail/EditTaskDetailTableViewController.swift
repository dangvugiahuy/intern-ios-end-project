//
//  EditTaskDetailTableViewController.swift
//  Remind Me
//
//  Created by huy.dang on 9/26/24.
//

import UIKit

protocol EditTaskDetailTableViewControllerDelegate: AnyObject {
    func screenCallBack(priority: Priority?, date: TimeInterval?, time: TimeInterval?)
}

class EditTaskDetailTableViewController: UITableViewController {
    
    public var priority: Priority?
    public var date: TimeInterval?
    public var time: TimeInterval?
    
    weak var delegate: EditTaskDetailTableViewControllerDelegate?

    @IBOutlet weak var taskDatePicker: UIDatePicker!
    @IBOutlet weak var taskPriorityLabel: UILabel!
    @IBOutlet weak var taskTimePicker: UIDatePicker!
    @IBOutlet weak var hideShowTimeSwitch: UISwitch!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var hideShowDateSwitch: UISwitch!
    
    
    init?(coder: NSCoder, priority: Priority?, date: TimeInterval?, time: TimeInterval?) {
        self.priority = priority
        self.date = date
        self.time = time
        super.init(coder: coder)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Details"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        hideShowDateSwitch.isOn = date != nil ? true : false
        hideShowTimeSwitch.isOn = time != nil ? true : false
        dateLabel.isHidden = hideShowDateSwitch.isOn ? false : true
        timeLabel.isHidden = hideShowTimeSwitch.isOn ? false : true
        taskPriorityLabel.text = "\(priority ?? Priority.None)"
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        delegate?.screenCallBack(priority: self.priority, date: self.date, time: self.time)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath {
        case IndexPath(row: 1, section: 0):
            return hideShowDateSwitch.isOn ? UITableView.automaticDimension : 0
        case IndexPath(row: 3, section: 0):
            return hideShowTimeSwitch.isOn ? UITableView.automaticDimension : 0
        default:
            return UITableView.automaticDimension
        }
    }
    
    override func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        
        let config = UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { [self] _ in
            let menu = UIMenu(title: "", options: .displayInline, children: setContextMenuAction())
            return menu
        }
        
        return config
    }
    
    private func setContextMenuAction() -> [UIMenuElement] {
        var actions = [UIMenuElement]()
        Priority.allCases.map {
            let priority = $0
            let action = UIAction(title: "\(priority)", image: UIImage(systemName: taskPriorityLabel.text == "\(priority)" ? "checkmark" : "")) { [self] _ in
                taskPriorityLabel.text = "\(priority)"
                self.priority = priority
            }
            actions.append(action)
        }
        return actions
    }
    
    
    @IBAction func hideShowDateSwitchChange(_ sender: UISwitch) {
        if !hideShowDateSwitch.isOn && hideShowTimeSwitch.isOn {
            hideShowTimeSwitch.isOn = false
            timeLabel.isHidden = hideShowTimeSwitch.isOn ? false : true
        }
        dateLabel.isHidden = hideShowDateSwitch.isOn ? false : true
        self.date = hideShowDateSwitch.isOn ? taskDatePicker.date.timeIntervalSinceNow : nil
        tableView.beginUpdates()
        tableView.endUpdates()
    }
    
    @IBAction func hideShowTimeSwitchChange(_ sender: UISwitch) {
        if hideShowTimeSwitch.isOn && !hideShowDateSwitch.isOn {
            hideShowDateSwitch.isOn = true
            dateLabel.isHidden = hideShowDateSwitch.isOn ? false : true
        }
        timeLabel.isHidden = hideShowTimeSwitch.isOn ? false : true
        self.time = hideShowTimeSwitch.isOn ? taskTimePicker.date.timeIntervalSinceNow : nil
        taskTimePicker.alpha = hideShowTimeSwitch.isOn ? 1 : 0
        tableView.beginUpdates()
        tableView.endUpdates()
    }
}
