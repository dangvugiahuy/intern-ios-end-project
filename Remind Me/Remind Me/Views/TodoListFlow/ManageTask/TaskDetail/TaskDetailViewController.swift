//
//  TaskDetailViewController.swift
//  Remind Me
//
//  Created by Huy Gia on 11/9/24.
//

import UIKit

protocol TaskDetailViewControllerDelegate: AnyObject {
    func deleteTaskFromDetailSuccessHandle(cell: UITableViewCell)
    func editTaskFromDetailSuccessHandle(cell: UITableViewCell, task: Todo)
}

class TaskDetailViewController: UIViewController {
    
    private let vm: TaskDetailViewModel = TaskDetailViewModel()
    var cell: UITableViewCell?
    var task: Todo?
    weak var delegate: TaskDetailViewControllerDelegate?
    private var priority: Priority = .None
    private var menuItem: [UIAction] = [UIAction]()

    @IBOutlet var viewTapGesture: UITapGestureRecognizer!
    @IBOutlet weak var datePickerStackView: UIStackView!
    @IBOutlet weak var saveTaskDetailButton: UIButton!
    @IBOutlet weak var checkCompleteButton: UIButton!
    @IBOutlet weak var textViewPlaceHolderLabel: UILabel!
    @IBOutlet weak var taskTimeButton: UIButton!
    @IBOutlet weak var taskNotesTextView: UITextView!
    @IBOutlet weak var taskDateButton: UIButton!
    @IBOutlet weak var dateTimeLabel: UILabel!
    @IBOutlet weak var taskDateSwitch: UISwitch!
    @IBOutlet weak var taskTimeSwitch: UISwitch!
    @IBOutlet weak var taskTimePicker: UIDatePicker!
    @IBOutlet weak var priorityButton: UIButton!
    @IBOutlet weak var taskDatePicker: UIDatePicker!
    @IBOutlet weak var timePickerStackView: UIStackView!
    @IBOutlet weak var taskTitleTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        taskTitleTextField.becomeFirstResponder()
        datePickerStackView.isHidden = true
        timePickerStackView.isHidden = true
        checkCompleteButton.setImage(UIImage(systemName: "checkmark.square")?.withRenderingMode(.automatic), for: .normal)
        let config = UIImage.SymbolConfiguration(paletteColors: [.redscale900, .greyscale800])
        checkCompleteButton.setImage(UIImage(systemName: "checkmark.square")?.applyingSymbolConfiguration(config), for: .selected)
        setupUIWithData()
        vm.delegate = self
        priorityButton.showsMenuAsPrimaryAction = true
        refreshMenuState()
        viewTapGesture.isEnabled = false
        saveTaskDetailButton.setupFilledButton()
    }
    
    private func setupUIWithData() {
        if let task = self.task {
            taskTitleTextField.text = task.title
            taskNotesTextView.text = task.note != nil ? task.note! : ""
            textViewPlaceHolderLabel.isHidden = taskNotesTextView.text != "" ? true : false
            setUpDateTimeWithData()
            for prioCase in Priority.allCases {
                if prioCase.rawValue == task.priority {
                    priority = prioCase
                    break
                }
            }
            priorityButton.tintColor = Priority.setColor(prior: task.priority)
            checkCompleteButton.isSelected = task.completed
            taskDateSwitch.isOn = task.date != nil ? true : false
            taskTimeSwitch.isOn = task.time != nil ? true : false
            taskDatePicker.isEnabled = taskDateSwitch.isOn ? true : false
            taskTimePicker.isEnabled = taskTimeSwitch.isOn ? true : false
        }
    }
    
    private func setUpDateTimeWithData() {
        if let date = task?.date {
            let dateFromInterval = Date(timeIntervalSince1970: date)
            taskDatePicker.setDate(dateFromInterval, animated: true)
            dateTimeLabel.text = Date.dateToString(date: date, format: "EEE, d MMM yyyy")
            if let time = task?.time {
                let timeFromInterval = Date(timeIntervalSince1970: time)
                taskTimePicker.setDate(timeFromInterval, animated: true)
                dateTimeLabel.text = dateTimeLabel.text! + " - " + DateFormatter().formated(from: Date(timeIntervalSince1970: time), with: "h:mm a")
            }
        } else {
            dateTimeLabel.text = "No due date"
        }
    }
    
    private func setMenuAction() -> [UIAction] {
        let actions: [UIAction] = Priority.allCases.map {
            let priority = $0
            return UIAction(title: "\(priority)", image: UIImage(systemName: self.priority == priority ? "checkmark" : "")) { [self] action in
                self.priority = priority
                priorityButton.tintColor = Priority.setColor(prior: self.priority.rawValue)
                refreshMenuState()
            }
        }
        return actions
    }
    
    private func refreshMenuState() {
        menuItem = setMenuAction()
        priorityButton.menu = UIMenu(children: menuItem)
    }
    
    private func animateDateStackView() {
        UIView.animate(withDuration: 0.35) { [self] in
            switch datePickerStackView.isHidden {
            case true:
                datePickerStackView.isHidden = false
                datePickerStackView.alpha = 1
            case false:
                datePickerStackView.isHidden = true
                datePickerStackView.alpha = 0
            }
        }
    }
    
    private func animateTimeStackView() {
        UIView.animate(withDuration: 0.35) { [self] in
            switch timePickerStackView.isHidden {
            case true:
                timePickerStackView.isHidden = false
                timePickerStackView.alpha = 1
            case false:
                timePickerStackView.isHidden = true
                timePickerStackView.alpha = 0
            }
        }
    }
    
    private func closeDateTimePicker() {
        if datePickerStackView.isHidden == false {
            UIView.animate(withDuration: 0.35) { [self] in
                datePickerStackView.isHidden = true
                datePickerStackView.alpha = 0
            }
        }
        if timePickerStackView.isHidden == false {
            UIView.animate(withDuration: 0.35) { [self] in
                timePickerStackView.isHidden = true
                timePickerStackView.alpha = 0
            }
        }
    }
    
    @IBAction func closeButtonClicked(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    @IBAction func deleteTaskButtonClicked(_ sender: Any) {
        let actionSheet = UIAlertController.createSimpleAlert(with: "Remind Me", and: "This todo will be deleted. This cannot be undone.", style: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { [self] _ in
            vm.deleteTask(task: task!)
        }))
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(actionSheet, animated: true)
    }
    
    @IBAction func saveTaskDetailButtonClicked(_ sender: Any) {
        task?.priority = priority.rawValue
        task?.title = taskTitleTextField.text!
        task?.note = taskNotesTextView.text != "" ? taskNotesTextView.text! : nil
        vm.updateTask(task: task!)
    }
    
    @IBAction func taskTitleTextFieldValueChange(_ sender: UITextField) {
        saveTaskDetailButton.isEnabled = taskTitleTextField.text != "" ? true : false
    }
    
    @IBAction func checkCompleteButtonClick(_ sender: Any) {
        checkCompleteButton.isSelected.toggle()
        task?.completed = checkCompleteButton.isSelected
    }
    
    @IBAction func taskDateButtonClicked(_ sender: Any) {
        if taskTitleTextField.isEditing || taskNotesTextView.isEditable {
            view.endEditing(true)
        }
        animateDateStackView()
    }
    
    @IBAction func taskTimeButtonClicked(_ sender: Any) {
        if taskTitleTextField.isEditing || taskNotesTextView.isEditable {
            view.endEditing(true)
        }
        animateTimeStackView()
    }
    
    @IBAction func taskDateSwitchValueChange(_ sender: Any) {
        if !taskDateSwitch.isOn && taskTimeSwitch.isOn {
            taskTimeSwitch.isOn = false
            taskTimePicker.isEnabled = taskTimeSwitch.isOn ? true : false
            task?.time = taskTimeSwitch.isOn ? Date().timeIntervalSince1970 : nil
        }
        taskDatePicker.isEnabled = taskDateSwitch.isOn ? true : false
        task?.date = taskDateSwitch.isOn ? Date().timeIntervalSince1970 : nil
        setUpDateTimeWithData()
    }
    
    @IBAction func taskTimeSwitchValueChange(_ sender: Any) {
        if taskTimeSwitch.isOn && !taskDateSwitch.isOn {
            taskDateSwitch.isOn = true
            taskDatePicker.isEnabled = taskDateSwitch.isOn ? true : false
            task?.date = taskDateSwitch.isOn ? Date().timeIntervalSince1970 : nil
        }
        taskTimePicker.isEnabled = taskTimeSwitch.isOn ? true : false
        task?.time = taskTimeSwitch.isOn ? Date().timeIntervalSince1970 : nil
        setUpDateTimeWithData()
    }
    
    @IBAction func taskDatePickerValueChange(_ sender: UIDatePicker) {
        task?.date = taskDatePicker.date.dateToTimeInterVal()
        setUpDateTimeWithData()
    }
    
    @IBAction func taskTimePickerValueChange(_ sender: UIDatePicker) {
        task?.time = taskTimePicker.date.timeToTimeInterVal()
        setUpDateTimeWithData()
    }
    
    @IBAction func hideKeyboard(_ sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }
}

extension TaskDetailViewController: UITextViewDelegate, TaskDetailViewModelDelegate, UITextFieldDelegate {
    
    func editTaskHandle() {
        self.dismiss(animated: true)
        delegate?.editTaskFromDetailSuccessHandle(cell: self.cell!, task: self.task!)
    }
    
    func deleteTaskHandle() {
        self.dismiss(animated: true)
        delegate?.deleteTaskFromDetailSuccessHandle(cell: self.cell!)
    }
    
    func textViewDidChange(_ textView: UITextView) {
        textViewPlaceHolderLabel.isHidden = taskNotesTextView.text != "" ? true : false
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        viewTapGesture.isEnabled = true
        closeDateTimePicker()
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        viewTapGesture.isEnabled = true
        closeDateTimePicker()
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        viewTapGesture.isEnabled = false
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        viewTapGesture.isEnabled = false
    }
}
