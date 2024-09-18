//
//  RootViewController.swift
//  Remind Me
//
//  Created by huy.dang on 9/18/24.
//

import UIKit

class RootViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if NetworkMonitor.shared.isConnected {
            let tabBarVC = self.storyboard?.instantiateViewController(withIdentifier: "HomeTabBarController") as! HomeTabBarController
            tabBarVC.modalPresentationStyle = .fullScreen
            present(tabBarVC, animated: true)
        } else {
            let vc = InternetUnavailableViewController()
            vc.modalPresentationStyle = .fullScreen
            present(vc, animated: false)
        }
    }
}
