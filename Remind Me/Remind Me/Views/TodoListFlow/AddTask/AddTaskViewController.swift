//
//  AddTaskViewController.swift
//  Remind Me
//
//  Created by huy.dang on 9/24/24.
//

import UIKit

class AddTaskViewController: BaseViewController {

    @IBOutlet weak var listTaskNavigateView: UIView!
    @IBOutlet weak var detailTaskNavigateView: UIView!
    @IBOutlet weak var editTaskView: UIView!
    @IBOutlet weak var addTaskButton: UIBarButtonItem!
    @IBOutlet weak var taskDescriptionTextView: UITextView!
    @IBOutlet weak var taskTitleTextField: UITextField!
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupFirstLoadVC()
    }
    
    private func setupFirstLoadVC() {
        self.title = "New Task"
        self.setupLeftNavigationBarItem()
        editTaskView.layer.masksToBounds = true
        editTaskView.layer.cornerRadius = 10
        taskDescriptionTextView.text = "Notes"
        taskDescriptionTextView.textColor = .placeholderText
        cancelButton.setupPlainLightTitleButton()
        addTaskButton.setupPlainBoldTitleButton()
        detailTaskNavigateView.textFieldViewConfig()
        listTaskNavigateView.textFieldViewConfig()
        addTaskButton.isEnabled = false
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
    
    @IBAction func taskTileTextFieldChangingHandle(_ sender: Any) {
        addTaskButton.isEnabled = taskTitleTextField.text != "" ? true : false
    }
    
}

extension AddTaskViewController: UITextViewDelegate, UITextFieldDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == "Notes" {
            textView.text = ""
            textView.textColor = .greyscale800
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text == "" {
            taskDescriptionTextView.text = "Notes"
            taskDescriptionTextView.textColor = .placeholderText
        }
    }
}
