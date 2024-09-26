//
//  AddTaskTableViewController.swift
//  Remind Me
//
//  Created by huy.dang on 9/26/24.
//

import UIKit

class AddTaskTableViewController: UITableViewController {

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
        
    }
}

extension AddTaskTableViewController: UITextFieldDelegate, UITextViewDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
    }
    
    func textViewDidChange(_ textView: UITextView) {
        taskNotesTextViewPlaceholderLabel.isHidden = taskNotesTextView.text != "" ? true : false
    }
}
