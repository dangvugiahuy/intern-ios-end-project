//
//  ProfileViewController.swift
//  Remind Me
//
//  Created by Huy Gia on 14/9/24.
//

import UIKit
import SwiftUI

class ProfileViewController: BaseViewController {
    
    let vm: ProfileViewModel = ProfileViewModel()
    
    @IBOutlet weak var userDisplayNameLabel: UILabel!
    @IBOutlet weak var userEmailLabel: UILabel!
    @IBOutlet weak var userAvatarImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupFirstLoadVC()
        setupUIWithUserData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = false
    }
    
    private func setupFirstLoadVC() {
        self.title = "Profile"
        userAvatarImageView.setupAvtImage()
        self.setupLeftNavigationBarItem()
        vm.delegate = self
    }
    
    private func setupUIWithUserData() {
        userDisplayNameLabel.text = vm.user?.displayName?.isEmpty != nil ? vm.user?.displayName : vm.user?.email
        userEmailLabel.text = vm.user?.email
        userAvatarImageView.loadImageFromURL((vm.user?.photoURL?.absoluteString) ?? "")
    }
    
    @IBSegueAction func goToAboutUsView(_ coder: NSCoder) -> UIViewController? {
        let view = AboutUsSwiftUIView()
        return UIHostingController(coder: coder, rootView: view)
    }
    
    @IBAction func changeUserImageSelector(_ sender: Any) {
        let actionSheet = UIAlertController(title: "Remind Me", message: "Change account image", preferredStyle: .actionSheet)
        actionSheet.setTitleAtt(font: UIFont(name: "Poppins-SemiBold", size: 18), color: UIColor(named: "Greyscale800"))
        actionSheet.setMessageAtt(font: UIFont(name: "Poppins-Light", size: 14), color: UIColor(named: "Greyscale800"))
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { _ in
            actionSheet.dismiss(animated: true)
        }))
        actionSheet.addAction(UIAlertAction(title: "Take picture", style: .default, handler: { _ in
            
        }))
        actionSheet.addAction(UIAlertAction(title: "Import from gallery", style: .default, handler: { _ in
            
        }))
        actionSheet.view.tintColor = UIColor(named: "Greyscale800")
        self.present(actionSheet, animated: true)
    }
    
    @IBAction func signOutButtonClicked(_ sender: Any) {
        let alert = UIAlertController(title: "Remind Me", message: "Are you sure to log out", preferredStyle: .alert)
        alert.setTitleAtt(font: UIFont(name: "Poppins-SemiBold", size: 18), color: UIColor(named: "Primary900"))
        alert.setMessageAtt(font: UIFont(name: "Poppins-Light", size: 14), color: UIColor(named: "Greyscale800"))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { _ in
            alert.dismiss(animated: true)
        }))
        alert.addAction(UIAlertAction(title: "Yes", style: .destructive, handler: { [self] _ in
            vm.signOut()
        }))
        present(alert, animated: true)
    }
}

extension ProfileViewController: ProfileViewModelDelegate {
    func signOutSuccessHandle() {
        let vc = self.storyboard?.instantiateViewController(identifier: "LoginUserVC") as! LoginUserViewController
        self.tabBarController?.tabBar.isHidden = true
        self.navigationController?.navigationBar.isHidden = true
        self.next(vc: vc)
    }
}
