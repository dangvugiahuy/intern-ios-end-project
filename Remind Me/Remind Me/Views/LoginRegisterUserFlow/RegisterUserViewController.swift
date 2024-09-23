//
//  LoginViewController.swift
//  Remind Me
//
//  Created by huy.dang on 9/12/24.
//

import UIKit

class RegisterUserViewController: UIViewController {
    
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
        setupFirstLoadVC()
    }
    
    private func setupFirstLoadVC() {
        emailTextFieldView.textFieldViewConfig()
        passwordTextFieldView.textFieldViewConfig()
        comfirmPassTextFieldView.textFieldViewConfig()
        signUpButton.setupFilledButton()
        hideShowPassButton.hideShowPasswordButtonConfig()
        hideShowComfirmPassButton.hideShowPasswordButtonConfig()
        viewTapGesture.cancelsTouchesInView = false
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
            UIAlertController.showSimpleAlert(on: self, message: "All field is require, please try again")
            return
        }
        guard comfirmPassMatched() == true else {
            UIAlertController.showSimpleAlert(on: self, message: "Comfirm password doesn't match, please try again")
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
        viewTapGesture.cancelsTouchesInView = false
    }
    
}

extension RegisterUserViewController: UITextFieldDelegate, RegisterUserViewModelDelegate {
    
    func registerSuccessHandle() {
        let alert = UIAlertController(title: "Remind Me", message: "You’re all set", preferredStyle: .alert)
        alert.setTitleAtt(font: UIFont(name: "Poppins-SemiBold", size: 18), color: UIColor(named: "Primary900"))
        alert.setMessageAtt(font: UIFont(name: "Poppins-Light", size: 14), color: UIColor(named: "Greyscale800"))
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
        UIAlertController.showSimpleAlert(on: self, message: message)
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
        viewTapGesture.cancelsTouchesInView = true
    }
    
}
