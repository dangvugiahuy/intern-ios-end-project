//
//  EmailAuthViewController.swift
//  Remind Me
//
//  Created by huy.dang on 9/17/24.
//

import UIKit

class EmailAuthViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func setupFirstLoadVC() {
        self.navigationController?.navigationBar.isHidden = false
        self.setupLeftNavigationBarItem()
        self.title = "Forgot Password"
    }
}
