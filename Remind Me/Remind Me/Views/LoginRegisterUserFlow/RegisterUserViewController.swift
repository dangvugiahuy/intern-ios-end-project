//
//  LoginViewController.swift
//  Remind Me
//
//  Created by huy.dang on 9/12/24.
//

import UIKit

class RegisterUserViewController: BaseViewController {
    
    private let vm: RegisterUserViewModel = RegisterUserViewModel()

    @IBOutlet weak var emailTextFieldView: UIView!
    @IBOutlet weak var passwordTextFieldView: UIView!
    @IBOutlet weak var comfirmPassTextFieldView: UIView!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var googleButton: UIButton!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet var viewTapGesture: UITapGestureRecognizer!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var comfirmPassTextField: UITextField!
    @IBOutlet weak var hideShowPassButton: UIButton!
    @IBOutlet weak var hideShowComfirmPassButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func setupFirstLoadVC() {
        emailTextFieldView.textFieldViewConfig()
        passwordTextFieldView.textFieldViewConfig()
        comfirmPassTextFieldView.textFieldViewConfig()
        signUpButton.setupFilledButton()
        hideShowPassButton.hideShowPasswordButtonConfig()
        hideShowComfirmPassButton.hideShowPasswordButtonConfig()
        viewTapGesture.isEnabled = false
        vm.delegate = self
        vm.vc = self
    }
    
    private func comfirmPassMatched() -> Bool {
        return passwordTextField.text == comfirmPassTextField.text
    }
    
    private func foundEmptyField() -> Bool {
        if emailTextField.text == "" || passwordTextField.text == "" || comfirmPassTextField.text == "" {
            return true
        }
        return false
    }
    
    @IBAction func hideShowPassButtonClicked(_ sender: Any) {
        hideShowPassButton.isSelected.toggle()
        passwordTextField.isSecureTextEntry = !hideShowPassButton.isSelected
    }
    
    @IBAction func hideShowComfirmPassButtonClicked(_ sender: Any) {
        hideShowComfirmPassButton.isSelected.toggle()
        comfirmPassTextField.isSecureTextEntry = !hideShowComfirmPassButton.isSelected
    }
    
    @IBAction func signUpButtonClicked(_ sender: Any) {
        guard foundEmptyField() == false else {
            UIAlertController.showSimpleAlertWithOKButton(on: self, message: "All field is require, please try again")
            return
        }
        guard comfirmPassMatched() == true else {
            UIAlertController.showSimpleAlertWithOKButton(on: self, message: "Comfirm password doesn't match, please try again")
            return
        }
        vm.email = emailTextField.text!
        vm.password = passwordTextField.text!
        vm.register()
    }
    
    @IBAction func signUpWithGoogleButtonClicked(_ sender: Any) {
        vm.registerWithGoogle()
    }
    
    @IBAction func hideKeyboard(_ sender: Any) {
        view.endEditing(true)
        viewTapGesture.isEnabled = false
    }
    
}

extension RegisterUserViewController: UITextFieldDelegate, RegisterUserViewModelDelegate {
    
    func registerSuccessHandle() {
        let alert = UIAlertController.createSimpleAlert(with: "Remind Me", and: "You’re all set", style: .alert)
        let okButton = UIAlertAction(title: "Let's GO!", style: .default) { _ in
            let tabBarVC = self.storyboard?.instantiateViewController(withIdentifier: "HomeTabBarController") as! HomeTabBarController
            tabBarVC.modalPresentationStyle = .fullScreen
            self.present(tabBarVC, animated: true)
        }
        alert.addAction(okButton)
        alert.view.tintColor = UIColor(named: "Primary900")
        present(alert, animated: true)
    }
    
    func showErrorAlert(message: String) {
        UIAlertController.showSimpleAlertWithOKButton(on: self, message: message)
    }
    
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
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        viewTapGesture.isEnabled = true
    }
    
}
