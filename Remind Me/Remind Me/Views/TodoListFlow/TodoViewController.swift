//
//  TodoViewController.swift
//  Remind Me
//
//  Created by huy.dang on 9/13/24.
//

import UIKit

class TodoViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if NetworkMonitor.shared.isConnected {
            
        } else {
            let vc = InternetUnavailableViewController()
            vc.modalPresentationStyle = .fullScreen
            present(vc, animated: false)
        }
    }
    
}
