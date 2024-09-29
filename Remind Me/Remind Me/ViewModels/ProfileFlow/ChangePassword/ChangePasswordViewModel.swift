//
//  ChangePasswordViewModel.swift
//  Remind Me
//
//  Created by Huy Gia on 21/9/24.
//

import Foundation
import FirebaseAuth

protocol ChangPasswordViewModelDelegate: AnyObject {
    func showErrorAlert(message: String)
    func changePassSuccessHandle()
}

final class ChangePasswordViewModel {
    
    private let user: User?
    var password: String = ""
    var newPassword: String = ""
    private var error: ChangePasswordErrorType = .None
    weak var delegate: ChangPasswordViewModelDelegate?
    
    init() {
        user = Auth.auth().currentUser
    }
    
    private func signOut() {
        switch UserManagementService.shared.signOutSuccess() {
        case true:
            break
        case false:
            break
        }
    }
    
    func changePassword() {
        guard let user = self.user else { return }
        UserManagementService.shared.reAuthenTicate(email: user.email!, password: password) { [self] result in
            switch result {
            case .success(let userData):
                UserManagementService.shared.changePassword(from: userData.user, with: newPassword) { [self] result in
                    switch result {
                    case .success(_):
                        signOut()
                        delegate?.changePassSuccessHandle()
                    case .failure(let failure):
                        if failure == .weakPassword {
                            error = .WeakPassword
                        }
                        delegate?.showErrorAlert(message: error.errorDescription())
                    }
                }
            case .failure(_):
                error = .WrongPassword
                delegate?.showErrorAlert(message: error.errorDescription())
            }
        }
    }
}
