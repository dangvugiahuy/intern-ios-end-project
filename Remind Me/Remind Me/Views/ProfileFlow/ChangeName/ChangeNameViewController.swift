//
//  ChangeNameViewController.swift
//  Remind Me
//
//  Created by huy.dang on 9/17/24.
//

import UIKit

class ChangeNameViewController: UIViewController {

    @IBOutlet weak var fullNameTextFieldView: UIView!
    @IBOutlet weak var fullNameTextField: UITextField!
    @IBOutlet weak var saveChangeButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupFirstLoadVC()
    }
    
    private func setupFirstLoadVC() {
        self.title = "Change account name"
        self.tabBarController?.tabBar.isHidden = true
        fullNameTextFieldView.textFieldViewConfig()
        saveChangeButton.setupFilledButton()
    }
    
}

extension ChangeNameViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.endEditing(true)
    }
}
