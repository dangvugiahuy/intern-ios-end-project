//
//  LoginUserViewController.swift
//  Remind Me
//
//  Created by huy.dang on 9/13/24.
//

import UIKit

class LoginUserViewController: UIViewController {

    @IBOutlet weak var emailTextFieldView: UIView!
    @IBOutlet weak var passwordTextFieldView: UIView!
    @IBOutlet weak var signInButton: UIButton!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var hideShowPasswordButton: UIButton!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupFirstLoadVC()
    }
    
    private func setupFirstLoadVC() {
        emailTextFieldView.textFieldViewConfig()
        passwordTextFieldView.textFieldViewConfig()
        signInButton.setupFilledButton()
        hideShowPasswordButton.hideShowPasswordButtonConfig()
    }
    
    @IBAction func hideShowPasswordClicked(_ sender: Any) {
        hideShowPasswordButton.isSelected.toggle()
        passwordTextField.isSecureTextEntry = !hideShowPasswordButton.isSelected
    }
    
}

extension LoginUserViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case emailTextField:
            passwordTextField.becomeFirstResponder()
        default:
            textField.endEditing(true)
        }
    }
}
