//
//  LoginUserViewController.swift
//  Remind Me
//
//  Created by huy.dang on 9/13/24.
//

import UIKit

class LoginUserViewController: BaseViewController {
    
    private let vm: LoginUserViewModel = LoginUserViewModel()
    var isroot: Bool = false

    @IBOutlet weak var emailTextFieldView: UIView!
    @IBOutlet var viewTapGesture: UITapGestureRecognizer!
    @IBOutlet weak var passwordTextFieldView: UIView!
    @IBOutlet weak var signInButton: UIButton!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var hideShowPasswordButton: UIButton!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
    }
    
    override func setupFirstLoadVC() {
        emailTextFieldView.textFieldViewConfig()
        passwordTextFieldView.textFieldViewConfig()
        signInButton.setupFilledButton()
        hideShowPasswordButton.hideShowPasswordButtonConfig()
        viewTapGesture.isEnabled = false
        vm.delegate = self
        vm.vc = self
        self.navigationController?.navigationBar.tintColor = .primary900
        self.setupLeftNavigationBarItem()
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
            UIAlertController.showSimpleAlertWithOKButton(on: self, message: "All field is require, please try again")
            return
        }
        vm.email = emailTextField.text!
        vm.password = passwordTextField.text!
        vm.signIn()
    }
    
    @IBAction func hideKeyboard(_ sender: Any) {
        view.endEditing(true)
        viewTapGesture.isEnabled = false
    }
    
    @IBAction func signInWithGoogleButtonClicked(_ sender: Any) {
        vm.signInWithGoogle()
    }
    
    @IBAction func signUpButtonClicked(_ sender: Any) {
        switch isroot {
        case true:
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "RegisterUserVC") as! RegisterUserViewController
            vc.modalPresentationStyle = .fullScreen
            vc.modalTransitionStyle = .flipHorizontal
            self.present(vc, animated: true)
        case false:
            self.dismiss(animated: true)
        }
        
    }
}

extension LoginUserViewController: UITextFieldDelegate, LoginUserViewModelDelegate {
    
    func logInSuccessHandle() {
        let tabBarVC = self.storyboard?.instantiateViewController(withIdentifier: "HomeTabBarController") as! HomeTabBarController
        let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as! SceneDelegate
        sceneDelegate.window?.rootViewController = tabBarVC
    }
    
    func showErrorAlert(message: String) {
        UIAlertController.showSimpleAlertWithOKButton(on: self, message: message)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case emailTextField:
            passwordTextField.becomeFirstResponder()
        default:
            textField.endEditing(true)
        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        viewTapGesture.isEnabled = true
    }
}
