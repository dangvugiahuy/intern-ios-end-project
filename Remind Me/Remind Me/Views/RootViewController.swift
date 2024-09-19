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
            let firstLaunch = !UserDefaults.standard.bool(forKey: "LaunchBefore")
            if firstLaunch {
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "OnBoardingVC") as! OnBoardingViewController
                vc.modalPresentationStyle = .fullScreen
                present(vc, animated: false)
            } else {
                let userSignedIn = UserManagementService.shared.isUserSignedIn()
                if userSignedIn {
                    let tabBarVC = self.storyboard?.instantiateViewController(withIdentifier: "HomeTabBarController") as! HomeTabBarController
                    tabBarVC.modalPresentationStyle = .fullScreen
                    present(tabBarVC, animated: true)
                } else {
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "LoginUserVC") as! LoginUserViewController
                    vc.modalPresentationStyle = .fullScreen
                    present(vc, animated: true)
                }
            }
        } else {
            let vc = InternetUnavailableViewController()
            vc.modalPresentationStyle = .fullScreen
            present(vc, animated: false)
        }
    }
}
