//
//  ChangePasswordViewController.swift
//  Remind Me
//
//  Created by huy.dang on 9/17/24.
//

import UIKit

class ChangePasswordViewController: UIViewController {
    
    @IBOutlet weak var oldPasswordTextFieldView: UIView!
    @IBOutlet weak var newPasswordTextFieldView: UIView!
    @IBOutlet weak var comfirmPasswordTextFieldView: UIView!
    @IBOutlet weak var oldPasswordTextField: UITextField!
    @IBOutlet weak var newPasswordTextField: UITextField!
    @IBOutlet weak var comfirmPasswordTextField: UITextField!
    @IBOutlet weak var saveChangeButton: UIButton!
    @IBOutlet weak var hideShowOldPassButton: UIButton!
    @IBOutlet weak var hideShowNewPassButton: UIButton!
    @IBOutlet weak var hideShowComfirmPassButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupFirstLoadVC()
    }
    
    private func setupFirstLoadVC() {
        self.title = "Change account password"
        self.tabBarController?.tabBar.isHidden = true
        oldPasswordTextFieldView.textFieldViewConfig()
        newPasswordTextFieldView.textFieldViewConfig()
        comfirmPasswordTextFieldView.textFieldViewConfig()
        saveChangeButton.setupFilledButton()
        hideShowOldPassButton.hideShowPasswordButtonConfig()
        hideShowNewPassButton.hideShowPasswordButtonConfig()
        hideShowComfirmPassButton.hideShowPasswordButtonConfig()
    }
    
    @IBAction func hideShowOldPassButtonClicked(_ sender: Any) {
        hideShowOldPassButton.isSelected.toggle()
        oldPasswordTextField.isSecureTextEntry = !hideShowOldPassButton.isSelected
    }
    
    @IBAction func hideShowNewPassButtonClicked(_ sender: Any) {
        hideShowNewPassButton.isSelected.toggle()
        newPasswordTextField.isSecureTextEntry = !hideShowNewPassButton.isSelected
    }
    
    @IBAction func hideShowComfirmPassButtonClicked(_ sender: Any) {
        hideShowComfirmPassButton.isSelected.toggle()
        comfirmPasswordTextField.isSecureTextEntry = !hideShowComfirmPassButton.isSelected
    }
    
    @IBAction func saveChangeButtonClicked(_ sender: Any) {
        
    }
}

extension ChangePasswordViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case oldPasswordTextField:
            newPasswordTextField.becomeFirstResponder()
        case newPasswordTextField:
            comfirmPasswordTextField.becomeFirstResponder()
        default:
            textField.endEditing(true)
        }
    }
}
