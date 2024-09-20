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
    
    var user: User?
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
}
