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
        setupFirstLoadVC()
    }
    
    func setupFirstLoadVC() {}
    
    func enableLargeTitle() {
        self.navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    func disableLargeTitle() {
        self.navigationController?.navigationBar.prefersLargeTitles = false
    }
    
    func back(to vc: UIViewController) {
        self.navigationController?.popToViewController(vc, animated: true)
    }
    
    func back() {
        self.navigationController?.popViewController(animated: true)
    }
    
    func backToRoot() {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    func next(vc: UIViewController) {
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func setupLeftNavigationBarItem() {
        self.navigationController?.navigationBar.backIndicatorImage = UIImage(systemName: "chevron.left")
        self.navigationController?.navigationBar.backIndicatorTransitionMaskImage = UIImage(systemName: "chevron.left")
        self.navigationItem.backButtonTitle = ""
    }
}
