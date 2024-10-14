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
                    let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as! SceneDelegate
                    sceneDelegate.window?.rootViewController = tabBarVC
                } else {
                    let rootVc = self.storyboard?.instantiateViewController(withIdentifier: "LoginUserVC") as! LoginUserViewController
                    rootVc.isroot = true
                    let navigateVC = UINavigationController(rootViewController: rootVc)
                    navigateVC.modalPresentationStyle = .fullScreen
                    present(navigateVC, animated: true)
                }
            }
        } else {
            let vc = InternetUnavailableViewController()
            vc.modalPresentationStyle = .fullScreen
            present(vc, animated: false)
        }
    }
}
