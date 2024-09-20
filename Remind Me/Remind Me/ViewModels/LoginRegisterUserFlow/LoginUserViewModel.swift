//
//  LoginUserViewModel.swift
//  Remind Me
//
//  Created by huy.dang on 9/18/24.
//

import Foundation

protocol LoginUserViewModelDelegate: AnyObject {
    func showErrorAlert(message: String)
    func logInSuccessHandle()
}

final class LoginUserViewModel {
    
    var email: String = ""
    var password: String = ""
    var error: LoginUserErrorType = .Default
    weak var delegate: LoginUserViewModelDelegate?
    
    func signIn() {
        EmailPasswordAuthService.shared.signIn(email: email, password: password) { [self] result in
            switch result {
            case .success(_):
                delegate?.logInSuccessHandle()
            case .failure(let failure):
                if failure == .invalidEmail {
                    error = .InvalidEmail
                } else if failure == .userDisabled {
                    error = .UserDisabled
                }
                delegate?.showErrorAlert(message: error.errorDescription())
            }
        }
    }
}
