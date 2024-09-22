//
//  ChangePasswordViewModel.swift
//  Remind Me
//
//  Created by Huy Gia on 21/9/24.
//

import Foundation
import FirebaseAuth

protocol ChangPasswordViewModelDelegate: AnyObject {
    func changePassSuccessHandle()
}

final class ChangePasswordViewModel {
    
    let signInMethod: SignInMethod = UserDefaults.standard.value(forKey: "SignInMethod") as! SignInMethod
    var email: String = ""
    var password: String = ""
    var newPassword: String = ""
    weak var delegate: ChangPasswordViewModelDelegate?
    
    func changePassword() {
        UserManagementService.shared.reAuthenTicate(email: email, password: password) { [self] result in
            switch result {
            case .success(let userData):
                UserManagementService.shared.changePassword(from: userData.user, with: newPassword) { [self] result in
                    switch result {
                    case .success(_):
                        delegate?.changePassSuccessHandle()
                    case .failure(let failure):
                        break
                    }
                }
            case .failure(let failure):
                break
            }
        }
    }
}
