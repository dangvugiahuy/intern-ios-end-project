//
//  ResetPasswordViewModel.swift
//  Remind Me
//
//  Created by huy.dang on 10/15/24.
//

import Foundation
import UIKit

protocol ResetPasswordViewModelDelegate: AnyObject {
    func sendResetPassSuccessHandle()
    func sendResetPassErrorHandle(message: String)
}

final class ResetPasswordViewModel {
    
    var email: String = ""
    weak var delegate: ResetPasswordViewModelDelegate?
    
    func resetPassword() {
        EmailPasswordAuthService.shared.resetPassword(email: self.email) { [self] result in
            switch result {
            case .success(_):
                delegate?.sendResetPassSuccessHandle()
            case .failure(let failure):
                if failure == .invalidEmail {
                    delegate?.sendResetPassErrorHandle(message: "Invalid email address. Please try again!")
                } else if failure == .userDisabled {
                    delegate?.sendResetPassErrorHandle(message: "Your account has been disabled. Please contact us for more details")
                } else if failure == .userNotFound {
                    delegate?.sendResetPassErrorHandle(message: "This email hasn't been registered. Please try again!")
                } else {
                    delegate?.sendResetPassErrorHandle(message: failure.localizedDescription)
                }
            }
        }
    }
}
