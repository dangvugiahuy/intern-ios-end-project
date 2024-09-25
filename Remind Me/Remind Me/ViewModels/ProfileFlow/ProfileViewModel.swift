//
//  ProfileViewModel.swift
//  Remind Me
//
//  Created by huy.dang on 9/20/24.
//

import Foundation
import FirebaseAuth

protocol ProfileViewModelDelegate: AnyObject {
    func signOutSuccessHandle()
}

final class ProfileViewModel {
    
    private var user: User?
    weak var delegate: ProfileViewModelDelegate?
    
    init() {
        user = Auth.auth().currentUser
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
        UserManagementService.shared.reload(from: user!) { result in
            switch result {
            case .success(let user):
                self.user = user
            case .failure(_):
                break
            }
        }
    }
    
    func getUserEmail() -> String {
        guard let user = user else { return "" }
        guard let email = user.email else { return "" }
        return email
    }
    
    func getUserDisplayName() -> String {
        guard let user = user else { return "No name" }
        guard let displayName = user.displayName else { return "No name" }
        return displayName
    }
    
    func getUserPhotoURL() -> String {
        guard let user = user else { return "" }
        guard let photoURL = user.photoURL?.absoluteString else { return "" }
        return photoURL
    }
}
