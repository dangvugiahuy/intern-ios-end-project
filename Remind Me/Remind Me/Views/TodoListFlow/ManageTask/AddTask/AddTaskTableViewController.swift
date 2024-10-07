//
//  AddTaskTableViewController.swift
//  Remind Me
//
//  Created by huy.dang on 9/26/24.
//

import UIKit

protocol AddTaskTableViewControllerDelegate: AnyObject {
    func addNewTaskSuccessHandle(task: Todo)
}

class AddTaskTableViewController: UITableViewController {
    
    private let vm: AddTaskViewModel =  AddTaskViewModel()
    private var priority: Priority = .None
    private var date: TimeInterval?
    private var time: TimeInterval?
    private var dateShowType: DateShowType = .Other("")
    var list: [TaskList] = [TaskList]()
    var taskListChoosen: TaskList?
    weak var delegate: AddTaskTableViewControllerDelegate?
    
    @IBOutlet weak var selectTaskListCell: UITableViewCell!
    @IBOutlet weak var taskListNameLabel: UILabel!
    @IBOutlet weak var taskDetailLabel: UILabel!
    @IBOutlet weak var taskNotesTextViewPlaceholderLabel: UILabel!
    @IBOutlet weak var taskNotesTextView: UITextView!
    @IBOutlet weak var taskTitleTextField: UITextField!
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    @IBOutlet weak var addButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "New Task"
        self.navigationController?.navigationBar.backIndicatorImage = UIImage(systemName: "chevron.left")
        self.navigationController?.navigationBar.backIndicatorTransitionMaskImage = UIImage(systemName: "chevron.left")
        self.navigationItem.backButtonTitle = ""
        if !list.isEmpty {
            taskListChoosen = list[0]
        }
        selectTaskListCell.isHidden = list.isEmpty ? true : false
        cancelButton.setupPlainLightTitleButton()
        addButton.setupPlainBoldTitleButton()
        taskTitleTextField.becomeFirstResponder()
        addButton.isEnabled = false
        taskNotesTextViewPlaceholderLabel.isHidden = false
        vm.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if let taskListChoosen = self.taskListChoosen {
            taskListNameLabel.text = taskListChoosen.name
        }
        tableView.selectRow(at: nil, animated: true, scrollPosition: .none)
        updateDateTime()
    }
    
    private func updateDateTime() {
        taskDetailLabel.isHidden = date == nil && time == nil ? true : false
        if let date = date {
            if Calendar.current.isDateInToday(Date(timeIntervalSince1970: date)) {
                dateShowType = .Today
            } else if Calendar.current.isDateInYesterday(Date(timeIntervalSince1970: date)) {
                dateShowType = .Yesterday
            } else if Calendar.current.isDateInTomorrow(Date(timeIntervalSince1970: date)) {
                dateShowType = .Tomorrow
            } else {
                dateShowType = .Other(DateFormatter().formated(from: Date(timeIntervalSince1970: date), with: "MMM d, yyyy"))
            }
        }
        let dateString: String = date != nil ? dateShowType.dateStringFormat() : ""
        let timeString: String = time != nil ? " at " + DateFormatter().formated(from: Date(timeIntervalSince1970: time!), with: "h:mm a") : ""
        taskDetailLabel.text = dateString + timeString
    }
    
    @IBAction func taskTitleTextFieldChangeHandle(_ sender: Any) {
        addButton.isEnabled = taskTitleTextField.text != "" ? true : false
    }
    
    @IBAction func cancelButtonClicked(_ sender: Any) {
        if taskTitleTextField.text != "" {
            view.endEditing(true)
            let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
            actionSheet.addAction(UIAlertAction(title: "Discard Changes", style: .destructive, handler: { _ in
                self.dismiss(animated: true)
            }))
            actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel))
            actionSheet.view.tintColor = .greyscale800
            present(actionSheet, animated: true)
        } else {
            self.dismiss(animated: true)
        }
    }
    
    @IBAction func addButton(_ sender: Any) {
        guard let taskListChoosen = self.taskListChoosen else { return }
        vm.taskListChoosen = taskListChoosen
        let task = Todo(id: UUID().uuidString, title: taskTitleTextField.text!, note: taskNotesTextView.text, date: date, time: time, priority: priority.rawValue, taskList: taskListChoosen)
        vm.task = task
        vm.addTask()
    }
    
    @IBSegueAction func goToAddDetailTaskVC(_ coder: NSCoder) -> EditTaskDetailTableViewController? {
        let vc = EditTaskDetailTableViewController(coder: coder, priority: priority, date: date, time: time)
        vc?.delegate = self
        return vc
    }
    
    @IBSegueAction func goToChooseTaskListVC(_ coder: NSCoder) -> ChooseTaskListViewController? {
        let vc = ChooseTaskListViewController(coder: coder, list: list, taskListChoosen: taskListChoosen!)
        vc?.delegate = self
        return vc
    }
}

extension AddTaskTableViewController: UITextFieldDelegate, UITextViewDelegate, EditTaskDetailTableViewControllerDelegate, AddTaskViewModelDelegate, ChooseTaskListViewControllerDelegate {
    
    func chooseTaskListCallBack(list: [TaskList], taskListChoosen: TaskList) {
        self.list = list
        self.taskListChoosen = taskListChoosen
    }
    
    func addTaskSuccessHandle(task: Todo) {
        self.dismiss(animated: true)
        delegate?.addNewTaskSuccessHandle(task: task)
    }
    
    func screenCallBack(priority: Priority, date: TimeInterval?, time: TimeInterval?) {
        self.priority = priority
        self.date = date
        self.time = time
        updateDateTime()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
    }
    
    func textViewDidChange(_ textView: UITextView) {
        taskNotesTextViewPlaceholderLabel.isHidden = taskNotesTextView.text != "" ? true : false
    }
}
