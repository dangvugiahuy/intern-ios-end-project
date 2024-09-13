//
//  LoginViewController.swift
//  Remind Me
//
//  Created by huy.dang on 9/12/24.
//

import UIKit

class RegisterUserViewController: UIViewController {

    @IBOutlet weak var emailTextFieldView: UIView!
    @IBOutlet weak var passwordTextFieldView: UIView!
    @IBOutlet weak var comfirmPassTextFieldView: UIView!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var googleButton: UIButton!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var comfirmPassTextField: UITextField!
    @IBOutlet weak var hideShowPassButton: UIButton!
    @IBOutlet weak var hideShowComfirmPassButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupFirstLoadVC()
    }
    
    private func setupFirstLoadVC() {
        emailTextFieldView.textFieldViewConfig()
        passwordTextFieldView.textFieldViewConfig()
        comfirmPassTextFieldView.textFieldViewConfig()
        signUpButton.setupFilledButton()
        hideShowPassButton.hideShowPasswordButtonConfig()
        hideShowComfirmPassButton.hideShowPasswordButtonConfig()
    }
    
    @IBAction func hideShowPassButtonClicked(_ sender: Any) {
        hideShowPassButton.isSelected.toggle()
        passwordTextField.isSecureTextEntry = !hideShowPassButton.isSelected
    }
    
    @IBAction func hideShowComfirmPassButtonClicked(_ sender: Any) {
        hideShowComfirmPassButton.isSelected.toggle()
        comfirmPassTextField.isSecureTextEntry = !hideShowComfirmPassButton.isSelected
    }
    
}

extension RegisterUserViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case emailTextField:
            passwordTextField.becomeFirstResponder()
        case passwordTextField:
            comfirmPassTextField.becomeFirstResponder()
        default:
            textField.endEditing(true)
        }
    }
}
