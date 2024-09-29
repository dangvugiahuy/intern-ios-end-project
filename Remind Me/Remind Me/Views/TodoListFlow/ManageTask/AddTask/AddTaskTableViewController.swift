//
//  AddTaskTableViewController.swift
//  Remind Me
//
//  Created by huy.dang on 9/26/24.
//

import UIKit

protocol AddTaskTableViewControllerDelegate: AnyObject {
    func addNewTaskSuccessHandle()
}

class AddTaskTableViewController: UITableViewController {
    
    private var priority: Priority?
    private var date: TimeInterval?
    private var time: TimeInterval?
    private var dateShowType: DateShowType = .Other("")
    weak var delegate: AddTaskTableViewControllerDelegate?
    
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
        cancelButton.setupPlainLightTitleButton()
        addButton.setupPlainBoldTitleButton()
        taskTitleTextField.becomeFirstResponder()
        addButton.isEnabled = false
        taskNotesTextViewPlaceholderLabel.isHidden = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tableView.selectRow(at: nil, animated: true, scrollPosition: .none)
        updateDateTime()
    }
    
    private func updateDateTime() {
        taskDetailLabel.isHidden = date == nil && time == nil ? true : false
        if let date = date {
            if Calendar.current.isDateInToday(Date(timeIntervalSinceNow: date)) {
                dateShowType = .Today
            } else if Calendar.current.isDateInYesterday(Date(timeIntervalSinceNow: date)) {
                dateShowType = .Yesterday
            } else if Calendar.current.isDateInTomorrow(Date(timeIntervalSinceNow: date)) {
                dateShowType = .Tomorrow
            } else {
                dateShowType = .Other(DateFormatter().formated(from: Date(timeIntervalSinceNow: date), with: "MMM d, yyyy"))
            }
        }
        let dateString: String = date != nil ? dateShowType.dateStringFormat() : ""
        let timeString: String = time != nil ? " at " + DateFormatter().formated(from: Date(timeIntervalSinceNow: time!), with: "h:mm a") : ""
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
        self.dismiss(animated: true)
        delegate?.addNewTaskSuccessHandle()
    }
    
    @IBSegueAction func goToAddDetailTaskVC(_ coder: NSCoder) -> EditTaskDetailTableViewController? {
        let vc = EditTaskDetailTableViewController(coder: coder, priority: priority, date: date, time: time)
        vc?.delegate = self
        return vc
    }
}

extension AddTaskTableViewController: UITextFieldDelegate, UITextViewDelegate, EditTaskDetailTableViewControllerDelegate {
    
    func screenCallBack(priority: Priority?, date: TimeInterval?, time: TimeInterval?) {
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
