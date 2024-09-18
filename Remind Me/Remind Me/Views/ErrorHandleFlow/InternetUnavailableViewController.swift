//
//  InternetUnavailableViewController.swift
//  Remind Me
//
//  Created by huy.dang on 9/18/24.
//

import UIKit

class InternetUnavailableViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func retryButtonClicked(_ sender: Any) {
        if NetworkMonitor.shared.isConnected {
            self.dismiss(animated: false)
        }
    }
    
}
