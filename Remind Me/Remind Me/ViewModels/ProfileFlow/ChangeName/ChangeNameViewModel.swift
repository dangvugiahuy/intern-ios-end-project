//
//  ChangeNameViewModel.swift
//  Remind Me
//
//  Created by huy.dang on 9/23/24.
//

import Foundation
import FirebaseAuth

protocol ChangNameViewModelDelegate: AnyObject {
    func changeNameSuccessHandle()
}

final class ChangeNameViewModel {
    
    private let user: User?
    var name: String = ""
    weak var delegate: ChangNameViewModelDelegate?
    
    init() {
        user = Auth.auth().currentUser
    }
    
    func changeName() {
        guard let user = user else { return }
        UserManagementService.shared.changeName(from: user, with: name) { [self] result in
            switch result {
            case .success(_):
                delegate?.changeNameSuccessHandle()
            case .failure(_):
                break
            }
        }
    }
    
    func getUserDisplayName() -> String {
        guard let user = user else { return "No name" }
        guard let displayName = user.displayName else { return "No name" }
        return displayName
    }
}
