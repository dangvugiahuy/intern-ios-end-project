//
//  ChangeNameViewController.swift
//  Remind Me
//
//  Created by huy.dang on 9/17/24.
//

import UIKit
import FirebaseAuth

protocol ChangeNameViewControllerDelegate: AnyObject {
    func changeNameSuccessHandle()
}

class ChangeNameViewController: BaseViewController {
 
    private let vm: ChangeNameViewModel =  ChangeNameViewModel()
    weak var delegate: ChangeNameViewControllerDelegate?

    @IBOutlet var viewTapGesture: UITapGestureRecognizer!
    @IBOutlet weak var fullNameTextFieldView: UIView!
    @IBOutlet weak var fullNameTextField: UITextField!
    @IBOutlet weak var warningGoogleSignInStackView: UIStackView!
    @IBOutlet weak var saveChangeButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func setupFirstLoadVC() {
        self.title = "Change account name"
        self.tabBarController?.tabBar.isHidden = true
        fullNameTextFieldView.textFieldViewConfig()
        saveChangeButton.setupFilledButton()
        viewTapGesture.isEnabled = false
        vm.delegate = self
        fullNameTextField.text = vm.getUserDisplayName()
        warningGoogleSignInStackView.isHidden = SignInMethod.getCurrentSignInMethodValue() != "Google" ? true : false
        fullNameTextField.isEnabled = SignInMethod.getCurrentSignInMethodValue() != "Google" ? true : false
        saveChangeButton.isEnabled = SignInMethod.getCurrentSignInMethodValue() != "Google" ? true : false
    }
    
    private func foundEmptyField() -> Bool {
        if fullNameTextField.text == "" {
            return true
        }
        return false
    }
    
    @IBAction func saveChangeButtonClicked(_ sender: Any) {
        guard foundEmptyField() == false else {
            UIAlertController.showSimpleAlertWithOKButton(on: self, message: "Display name is require, please try again")
            fullNameTextField.text = vm.getUserDisplayName()
            return
        }
        vm.name = fullNameTextField.text!
        vm.changeName()
    }
    
    @IBAction func hideKeyboard(_ sender: Any) {
        view.endEditing(true)
        viewTapGesture.isEnabled = false
    }
    
}

extension ChangeNameViewController: UITextFieldDelegate, ChangNameViewModelDelegate {
    
    func changeNameSuccessHandle() {
        let alert = UIAlertController.createSimpleAlert(with: "Remind Me", and: "Change Display name successfully", style: .alert)
        alert.view.tintColor = UIColor(named: "Greyscale800")
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: { [self] _ in
            self.back()
            delegate?.changeNameSuccessHandle()
        }))
        present(alert, animated: true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.endEditing(true)
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        viewTapGesture.isEnabled = true
    }
}
