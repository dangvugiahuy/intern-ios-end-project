//
//  ChangePasswordViewController.swift
//  Remind Me
//
//  Created by huy.dang on 9/17/24.
//

import UIKit
import FirebaseAuth

class ChangePasswordViewController: BaseViewController {
    
    private let vm: ChangePasswordViewModel =  ChangePasswordViewModel()
    
    @IBOutlet var viewTapGesture: UITapGestureRecognizer!
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
    @IBOutlet weak var warningStackView: UIStackView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupFirstLoadVC()
    }
    
    private func setupFirstLoadVC() {
        self.title = "Change account password"
        self.tabBarController?.tabBar.isHidden = true
        vm.delegate = self
        oldPasswordTextFieldView.textFieldViewConfig()
        newPasswordTextFieldView.textFieldViewConfig()
        comfirmPasswordTextFieldView.textFieldViewConfig()
        saveChangeButton.setupFilledButton()
        hideShowOldPassButton.hideShowPasswordButtonConfig()
        hideShowNewPassButton.hideShowPasswordButtonConfig()
        hideShowComfirmPassButton.hideShowPasswordButtonConfig()
        viewTapGesture.isEnabled = false
        warningStackView.isHidden = SignInMethod.getCurrentSignInMethodValue() != "Google" ? true : false
        saveChangeButton.isEnabled = SignInMethod.getCurrentSignInMethodValue() != "Google" ? true : false
        oldPasswordTextField.isEnabled = SignInMethod.getCurrentSignInMethodValue() != "Google" ? true : false
        newPasswordTextField.isEnabled = SignInMethod.getCurrentSignInMethodValue() != "Google" ? true : false
        comfirmPasswordTextField.isEnabled = SignInMethod.getCurrentSignInMethodValue() != "Google" ? true : false
    }
    
    private func foundEmptyField() -> Bool {
        if oldPasswordTextField.text == "" || newPasswordTextField.text == "" || comfirmPasswordTextField.text == "" {
            return true
        }
        return false
    }
    
    private func comfirmPassMatched() -> Bool {
        return newPasswordTextField.text == comfirmPasswordTextField.text
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
        guard foundEmptyField() == false else {
            UIAlertController.showSimpleAlert(on: self, message: "All field is require, please try again")
            return
        }
        guard comfirmPassMatched() == true else {
            UIAlertController.showSimpleAlert(on: self, message: "Comfirm password doesn't match, please try again")
            return
        }
        vm.password = oldPasswordTextField.text!
        vm.newPassword = newPasswordTextField.text!
        vm.changePassword()
    }
    
    @IBAction func hideKeyboard(_ sender: Any) {
        view.endEditing(true)
        viewTapGesture.isEnabled = false
    }
}

extension ChangePasswordViewController: UITextFieldDelegate, ChangPasswordViewModelDelegate {
    
    func showErrorAlert(message: String) {
        UIAlertController.showSimpleAlert(on: self, message: message)
    }
    
    func changePassSuccessHandle() {
        let vc = ChangePasswordSuccessViewController()
        self.tabBarController?.tabBar.isHidden = true
        self.navigationController?.navigationBar.isHidden = true
        self.next(vc: vc)
    }
    
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
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        viewTapGesture.isEnabled = true
    }
}
