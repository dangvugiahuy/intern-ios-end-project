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
import Photos
import PhotosUI

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
        self.tabBarController?.tabBar.isHidden = false
    }
    
    override func setupFirstLoadVC() {
        self.title = "Profile"
        userAvatarImageView.setupAvtImage()
        self.setupLeftNavigationBarItem()
        vm.delegate = self
        setupUIWithUserData()
    }
    
    private func setupUIWithUserData() {
        userDisplayNameLabel.text = vm.getUserDisplayName()
        userEmailLabel.text = vm.getUserEmail()
        userAvatarImageView.loadImageFromURL(vm.getUserPhotoURL())
    }
    
    @IBSegueAction func goToAboutUsView(_ coder: NSCoder) -> UIViewController? {
        let view = AboutUsSwiftUIView()
        return UIHostingController(coder: coder, rootView: view)
    }
    
    @IBAction func changeUserImageSelector(_ sender: Any) {
        if SignInMethod.getCurrentSignInMethodValue() != "Google" {
            let actionSheet = UIAlertController.createSimpleAlert(with: "Remind Me", and: "Change account image", style: .actionSheet)
            actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { _ in
                actionSheet.dismiss(animated: true)
            }))
            actionSheet.addAction(UIAlertAction(title: "Take picture", style: .default, handler: { _ in
                let vc = UIImagePickerController()
                vc.sourceType = .camera
                vc.allowsEditing = true
                vc.delegate = self
                self.present(vc, animated: true)
            }))
            actionSheet.addAction(UIAlertAction(title: "Import from gallery", style: .default, handler: { _ in
                var config: PHPickerConfiguration = PHPickerConfiguration(photoLibrary: .shared())
                config.filter = .images
                config.selectionLimit = 1
                let picker: PHPickerViewController = PHPickerViewController(configuration: config)
                picker.delegate = self
                self.present(picker, animated: true)
            }))
            actionSheet.view.tintColor = UIColor(named: "Greyscale800")
            self.present(actionSheet, animated: true)
        } else {
            UIAlertController.showSimpleAlertWithOKButton(on: self, message: "This feature can't be used, because you are sign in with Google")
        }
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
    
    @IBAction func changeAccountNameClicked(_ sender: UITapGestureRecognizer) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ChangeAccountNameVC") as! ChangeNameViewController
        vc.delegate = self
        self.next(vc: vc)
    }
}

extension ProfileViewController: ProfileViewModelDelegate, PHPickerViewControllerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, ChangeNameViewControllerDelegate {
    
    func changeNameSuccessHandle() {
        vm.reloadUserProfile()
        userDisplayNameLabel.text = vm.getUserDisplayName()
    }
    
    func changeUserPhotoSuccessHandle() {
        DispatchQueue.main.async { [self] in
            vm.reloadUserProfile()
            userAvatarImageView.loadImageFromURL(vm.getUserPhotoURL())
            userAvatarImageView.hideSkeleton()
            UserDefaults.standard.set(true, forKey: "UserChangeAvt")
        }
    }
    
    func uploadImageSuccessHandle() {
        vm.changeUserImage()
    }
    
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true, completion: nil)
        let itemProvider = results.first?.itemProvider
        if let itemProvider = itemProvider, itemProvider.canLoadObject(ofClass: UIImage.self) {
            itemProvider.loadObject(ofClass: UIImage.self) { image, error in
                DispatchQueue.main.async { [self] in
                    if let image = image as? UIImage {
                        userAvatarImageView.showAnimatedGradientSkeleton()
                        vm.uploadUserImage(image: image)
                    }
                }
            }
        }
    }
    
    func signOutSuccessHandle() {
        let vc = self.storyboard?.instantiateViewController(identifier: "RootVC") as! RootViewController
        let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as! SceneDelegate
        sceneDelegate.window?.rootViewController = vc
        self.backToRoot()
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true)
        guard let image = info[.originalImage] as? UIImage else {
            return
        }
        userAvatarImageView.showAnimatedGradientSkeleton()
        vm.uploadUserImage(image: image)
    }
}
