//
//  EditTaskDetailTableViewController.swift
//  Remind Me
//
//  Created by huy.dang on 9/26/24.
//

import UIKit

protocol EditTaskDetailTableViewControllerDelegate: AnyObject {
    func screenCallBack(priority: Priority, date: TimeInterval?, time: TimeInterval?)
}

class EditTaskDetailTableViewController: UITableViewController {
    
    public var priority: Priority
    public var date: TimeInterval?
    public var time: TimeInterval?
    private var dateShowType: DateShowType = .Other("")
    var menuItem: [UIAction] = [UIAction]()
    
    weak var delegate: EditTaskDetailTableViewControllerDelegate?

    @IBOutlet weak var priorityButton: UIButton!
    @IBOutlet weak var taskDatePicker: UIDatePicker!
    @IBOutlet weak var taskPriorityLabel: UILabel!
    @IBOutlet weak var taskTimePicker: UIDatePicker!
    @IBOutlet weak var hideShowTimeSwitch: UISwitch!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var hideShowDateSwitch: UISwitch!
    
    
    init?(coder: NSCoder, priority: Priority, date: TimeInterval?, time: TimeInterval?) {
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
        priorityButton.showsMenuAsPrimaryAction = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        hideShowDateSwitch.isOn = date != nil ? true : false
        hideShowTimeSwitch.isOn = time != nil ? true : false
        dateLabel.isHidden = hideShowDateSwitch.isOn ? false : true
        timeLabel.isHidden = hideShowTimeSwitch.isOn ? false : true
        setupDateUIWithData()
        setupTimeUIWithData()
        taskPriorityLabel.text = "\(priority)"
        refreshMenuState()
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
    
    private func setupDateUIWithData() {
        if let date = date {
            let dateFromInterval = Date(timeIntervalSinceNow: date)
            taskDatePicker.setDate(dateFromInterval, animated: true)
            dateLabel.text = Date.dateToString(date: date, format: "EEEE, MMMM d, yyyy")
        }
    }
    
    private func setupTimeUIWithData() {
        if let time = time {
            let timeFromInterval = Date(timeIntervalSince1970: time)
            taskTimePicker.setDate(timeFromInterval, animated: true)
            timeLabel.text = DateFormatter().formated(from: timeFromInterval, with: "h:mm a")
        }
    }
    
    private func setMenuAction() -> [UIAction] {
        var actions = [UIAction]()
        _ = Priority.allCases.map {
            let priority = $0
            let action = UIAction(title: "\(priority)", image: UIImage(systemName: taskPriorityLabel.text == "\(priority)" ? "checkmark" : "")) { [self] action in
                taskPriorityLabel.text = "\(priority)"
                self.priority = priority
                refreshMenuState()
            }
            actions.append(action)
        }
        return actions
    }
    
    private func refreshMenuState() {
        menuItem = setMenuAction()
        priorityButton.menu = UIMenu(children: menuItem)
    }
    
    @IBAction func hideShowDateSwitchChange(_ sender: UISwitch) {
        if !hideShowDateSwitch.isOn && hideShowTimeSwitch.isOn {
            hideShowTimeSwitch.isOn = false
            timeLabel.isHidden = hideShowTimeSwitch.isOn ? false : true
            self.time = hideShowTimeSwitch.isOn ? taskTimePicker.date.timeIntervalSinceNow : nil
        }
        dateLabel.isHidden = hideShowDateSwitch.isOn ? false : true
        self.date = hideShowDateSwitch.isOn ? taskDatePicker.date.timeIntervalSinceNow : nil
        setupDateUIWithData()
        tableView.beginUpdates()
        tableView.endUpdates()
    }
    
    @IBAction func hideShowTimeSwitchChange(_ sender: UISwitch) {
        if hideShowTimeSwitch.isOn && !hideShowDateSwitch.isOn {
            hideShowDateSwitch.isOn = true
            dateLabel.isHidden = hideShowDateSwitch.isOn ? false : true
            self.date = hideShowDateSwitch.isOn ? taskDatePicker.date.timeIntervalSinceNow : nil
            setupDateUIWithData()
        }
        timeLabel.isHidden = hideShowTimeSwitch.isOn ? false : true
        taskTimePicker.alpha = hideShowTimeSwitch.isOn ? 1 : 0
        self.time = hideShowTimeSwitch.isOn ? taskTimePicker.date.timeIntervalSinceNow : nil
        setupTimeUIWithData()
        tableView.beginUpdates()
        tableView.endUpdates()
    }
    
    
    @IBAction func taskDatePickerChange(_ sender: Any) {
        self.date = taskDatePicker.date.timeIntervalSinceNow
        setupDateUIWithData()
    }
    
    @IBAction func taskTimePickerChange(_ sender: Any) {
        self.time = taskTimePicker.date.timeIntervalSince1970
        setupTimeUIWithData()
    }
    
}
