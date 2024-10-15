//
//  ProfileViewModel.swift
//  Remind Me
//
//  Created by huy.dang on 9/20/24.
//

import Foundation
import FirebaseAuth
import UIKit

protocol ProfileViewModelDelegate: AnyObject {
    func signOutSuccessHandle()
    func uploadImageSuccessHandle()
    func changeUserPhotoSuccessHandle()
}

final class ProfileViewModel {
    
    private var user: User?
    private var storageService: StorageService?
    weak var delegate: ProfileViewModelDelegate?
    
    init() {
        self.user = Auth.auth().currentUser
        if let user = self.user {
            storageService = StorageService(user: user)
        }
    }
    
    func signOut() {
        switch UserManagementService.shared.signOutSuccess() {
        case true:
            delegate?.signOutSuccessHandle()
        case false:
            break
        }
    }
    
    func reloadUserProfile() {
        guard let user = self.user else { return }
        UserManagementService.shared.reload(from: user) { result in
            switch result {
            case .success(let user):
                self.user = user
            case .failure(_):
                break
            }
        }
    }
    
    func getUserEmail() -> String {
        guard let user = self.user else { return "" }
        guard let email = user.email else { return "" }
        return email
    }
    
    func getUserDisplayName() -> String {
        guard let user = self.user else { return "No name" }
        guard let displayName = user.displayName else { return "No name" }
        return displayName
    }
    
    func getUserPhotoURL() -> String {
        guard let user = self.user else { return "" }
        guard let photoURL = user.photoURL?.absoluteString else { return "" }
        return photoURL
    }
    
    func uploadUserImage(image: UIImage) {
        storageService?.uploadImage(from: image, with: "Profile/avt.jpg", completion: { [self] result in
            switch result {
            case .success(_):
                delegate?.uploadImageSuccessHandle()
            case .failure(let failure):
                print("Upload Error: \(failure.localizedDescription)")
            }
        })
    }
    
    func changeUserImage() {
        storageService?.getImageURL(path: "Profile/avt.jpg", completion: { [self] result in
            switch result {
            case .success(let url):
                UserManagementService.shared.changePhotoURL(from: user!, with: url) { [self] result in
                    switch result {
                    case .success(_):
                        delegate?.changeUserPhotoSuccessHandle()
                    case .failure(let failure):
                        print("change User photo fail: \(failure.localizedDescription)")
                    }
                }
            case .failure(let failure):
                print("get URL Fail: \(failure.localizedDescription)")
            }
        })
    }
}
