//
//  ChangePasswordSuccessViewController.swift
//  Remind Me
//
//  Created by huy.dang on 9/23/24.
//

import UIKit

class ChangePasswordSuccessViewController: BaseViewController {

    @IBOutlet weak var backToLoginButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        backToLoginButton.setupFilledButton()
    }

    @IBAction func backToLoginButtonClicked(_ sender: Any) {
        self.tabBarController?.tabBar.isHidden = true
        self.navigationController?.navigationBar.isHidden = true
        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: .main)
        let vc = storyboard.instantiateViewController(withIdentifier: "LoginUserVC") as! LoginUserViewController
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true)
    }
}
