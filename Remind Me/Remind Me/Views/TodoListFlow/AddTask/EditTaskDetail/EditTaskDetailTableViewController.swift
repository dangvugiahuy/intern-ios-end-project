//
//  EditTaskDetailTableViewController.swift
//  Remind Me
//
//  Created by huy.dang on 9/26/24.
//

import UIKit

class EditTaskDetailTableViewController: UITableViewController {

    @IBOutlet weak var taskDatePicker: UIDatePicker!
    @IBOutlet weak var taskPriorityLabel: UILabel!
    @IBOutlet weak var taskTimePicker: UIDatePicker!
    @IBOutlet weak var hideShowTimeSwitch: UISwitch!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var hideShowDateSwitch: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Details"
        hideShowDateSwitch.isOn = false
        hideShowTimeSwitch.isOn = false
        dateLabel.isHidden = true
        timeLabel.isHidden = true
        dateLabel.text = "Today"
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
            let name = $0
            let action = UIAction(title: "\($0)", image: UIImage(systemName: taskPriorityLabel.text == "\(name)" ? "checkmark" : "")) { [self] _ in
                taskPriorityLabel.text = "\(name)"
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
        tableView.beginUpdates()
        tableView.endUpdates()
    }
    
    @IBAction func hideShowTimeSwitchChange(_ sender: UISwitch) {
        if hideShowTimeSwitch.isOn && !hideShowDateSwitch.isOn {
            hideShowDateSwitch.isOn = true
            dateLabel.isHidden = hideShowDateSwitch.isOn ? false : true
        }
        timeLabel.isHidden = hideShowTimeSwitch.isOn ? false : true
        taskTimePicker.alpha = hideShowTimeSwitch.isOn ? 1 : 0
        tableView.beginUpdates()
        tableView.endUpdates()
    }
}
