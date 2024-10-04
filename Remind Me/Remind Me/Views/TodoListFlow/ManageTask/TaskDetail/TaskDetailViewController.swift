//
//  TaskDetailViewController.swift
//  Remind Me
//
//  Created by Huy Gia on 11/9/24.
//

import UIKit

class TaskDetailViewController: UIViewController {
    
    var task: Todo?

    @IBOutlet weak var textViewPlaceHolderLabel: UILabel!
    @IBOutlet weak var taskNotesTextView: UITextView!
    @IBOutlet weak var dateTimeLabel: UILabel!
    @IBOutlet weak var taskTitleTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        taskTitleTextField.becomeFirstResponder()
        setupUIWithData()
    }
    
    private func setupUIWithData() {
        if let task = self.task {
            taskTitleTextField.text = task.title
            taskNotesTextView.text = task.note != nil ? task.note! : ""
            textViewPlaceHolderLabel.isHidden = taskNotesTextView.text != "" ? true : false
            if let date = task.date {
                dateTimeLabel.text = Date.dateToString(date: date, format: "EEE, d MMM yyyy")
                if let time = task.time {
                    dateTimeLabel.text = dateTimeLabel.text! + " - " + DateFormatter().formated(from: Date(timeIntervalSince1970: task.time!), with: "h:mm a")
                }
            } else {
                dateTimeLabel.text = "No due date"
            }
        }
    }
    
    @IBAction func closeButtonClicked(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
}

extension TaskDetailViewController: UITextViewDelegate {
    
    func textViewDidChange(_ textView: UITextView) {
        textViewPlaceHolderLabel.isHidden = taskNotesTextView.text != "" ? true : false
    }
}
