//
//  LoginUserViewController.swift
//  Remind Me
//
//  Created by huy.dang on 9/13/24.
//

import UIKit

class LoginUserViewController: BaseViewController {
    
    private let vm: LoginUserViewModel = LoginUserViewModel()

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
        vm.delegate = self
        vm.vc = self
    }
    
    private func foundEmptyField() -> Bool {
        if emailTextField.text == "" || passwordTextField.text == "" {
            return true
        }
        return false
    }
    
    @IBAction func hideShowPasswordClicked(_ sender: Any) {
        hideShowPasswordButton.isSelected.toggle()
        passwordTextField.isSecureTextEntry = !hideShowPasswordButton.isSelected
    }
    
    @IBAction func signInButtonClicked(_ sender: Any) {
        guard foundEmptyField() == false else {
            UIAlertController.showErrorAlert(on: self, message: "All field is require, please try again")
            return
        }
        vm.email = emailTextField.text!
        vm.password = passwordTextField.text!
        vm.signIn()
    }
    
    @IBAction func signInWithGoogleButtonClicked(_ sender: Any) {
        vm.signInWithGoogle()
    }
}

extension LoginUserViewController: UITextFieldDelegate, LoginUserViewModelDelegate {
    
    func logInSuccessHandle() {
        let tabBarVC = self.storyboard?.instantiateViewController(withIdentifier: "HomeTabBarController") as! HomeTabBarController
        tabBarVC.modalPresentationStyle = .fullScreen
        present(tabBarVC, animated: true)
    }
    
    func showErrorAlert(message: String) {
        UIAlertController.showErrorAlert(on: self, message: message)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case emailTextField:
            passwordTextField.becomeFirstResponder()
        default:
            textField.endEditing(true)
        }
    }
}
