//
//  ProfileViewController.swift
//  Remind Me
//
//  Created by Huy Gia on 14/9/24.
//

import UIKit
import FirebaseAuth
import SwiftUI
import SkeletonView

class ProfileViewController: BaseViewController {
    
    private let vm: ProfileViewModel = ProfileViewModel()
    
    @IBOutlet weak var userDisplayNameLabel: UILabel!
    @IBOutlet weak var userEmailLabel: UILabel!
    @IBOutlet weak var userAvatarImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        userAvatarImageView.showAnimatedGradientSkeleton()
        vm.reloadUserProfile()
        setupUIWithUserData()
        self.tabBarController?.tabBar.isHidden = false
    }
    
    override func setupFirstLoadVC() {
        self.title = "Profile"
        userAvatarImageView.setupAvtImage()
        self.setupLeftNavigationBarItem()
        vm.delegate = self
    }
    
    private func setupUIWithUserData() {
        userDisplayNameLabel.text = vm.getUserDisplayName()
        userEmailLabel.text = vm.getUserEmail()
        DispatchQueue.main.async { [self] in
            userAvatarImageView.loadImageFromURL(vm.getUserPhotoURL())
            userAvatarImageView.hideSkeleton()
        }
    }
    
    @IBSegueAction func goToAboutUsView(_ coder: NSCoder) -> UIViewController? {
        let view = AboutUsSwiftUIView()
        return UIHostingController(coder: coder, rootView: view)
    }
    
    @IBAction func changeUserImageSelector(_ sender: Any) {
        let actionSheet = UIAlertController.createSimpleAlert(with: "Remind Me", and: "Change account image", style: .actionSheet)
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
        let alert = UIAlertController.createSimpleAlert(with: "Remind Me", and: "Are you sure to log out", style: .alert)
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
        let vc = self.storyboard?.instantiateViewController(identifier: "RootVC") as! RootViewController
        let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as! SceneDelegate
        sceneDelegate.window?.rootViewController = vc
        self.backToRoot()
    }
}
