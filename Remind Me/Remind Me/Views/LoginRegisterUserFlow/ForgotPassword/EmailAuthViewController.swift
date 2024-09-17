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
        setupFirstLoadVC()
    }
    
    private func setupFirstLoadVC() {
        self.setupLeftNavigationBarItem()
        self.title = "Forgot Password"
    }
}
