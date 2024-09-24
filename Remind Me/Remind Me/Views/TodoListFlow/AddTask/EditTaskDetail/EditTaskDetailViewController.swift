//
//  EditTaskDetailViewController.swift
//  Remind Me
//
//  Created by huy.dang on 9/24/24.
//

import UIKit

class EditTaskDetailViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setupFirstLoadVC()
    }
    
    private func setupFirstLoadVC() {
        self.title = "Details"
    }
}
