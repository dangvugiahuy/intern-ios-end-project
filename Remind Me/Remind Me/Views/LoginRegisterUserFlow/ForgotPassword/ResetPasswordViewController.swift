//
//  ResetPasswordViewController.swift
//  Remind Me
//
//  Created by huy.dang on 9/17/24.
//

import UIKit

class ResetPasswordViewController: BaseViewController {
    
    private let vm: ResetPasswordViewModel = ResetPasswordViewModel()

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var emailTextFieldView: UIView!
    @IBOutlet weak var sendResetPassButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        emailTextField.becomeFirstResponder()
    }
    
    override func setupFirstLoadVC() {
        self.navigationController?.navigationBar.isHidden = false
        sendResetPassButton.setupFilledButton()
        emailTextFieldView.textFieldViewConfig()
        sendResetPassButton.isEnabled = false
        vm.delegate = self
    }
    
    @IBAction func emailTextFieldValueChange(_ sender: UITextField) {
        sendResetPassButton.isEnabled = emailTextField.text != "" ? true : false
    }
    
    @IBAction func sendResetPassButtonClicked(_ sender: Any) {
        vm.email = emailTextField.text!
        vm.resetPassword()
    }
}

extension ResetPasswordViewController: ResetPasswordViewModelDelegate, UITextFieldDelegate {
    
    func sendResetPassSuccessHandle() {
        let alert = UIAlertController.createSimpleAlert(with: "Remind Me", and: "We are send you an email, please check your email to reset your password", style: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
            self.back()
        }))
        self.present(alert, animated: true)
    }
    
    func sendResetPassErrorHandle(message: String) {
        UIAlertController.showSimpleAlertWithOKButton(on: self, message: message)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
    }
}
