//
//  BaseViewController.swift
//  Remind Me
//
//  Created by Huy Gia on 11/9/24.
//

import UIKit

class BaseViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    func back() {
        self.navigationController?.popViewController(animated: true)
    }
    
    func next(vc: UIViewController) {
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
