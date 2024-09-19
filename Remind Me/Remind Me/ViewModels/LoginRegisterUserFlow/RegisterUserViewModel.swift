//
//  RegisterUserViewModel.swift
//  Remind Me
//
//  Created by huy.dang on 9/18/24.
//

import Foundation

protocol RegisterUserViewModelDelegate: AnyObject {
    func showErrorAlert(message: String)
}

final class RegisterUserViewModel {
    
    var email: String = ""
    var password: String = ""
    var error: RegisterUserErrorType = .None
    weak var delegate: RegisterUserViewModelDelegate?
    
    func register() {
        EmailPasswordAuthService.shared.createUser(email: email, password: password) { [self] result in
            switch result {
            case .success(let success):
                break
            case .failure(let failure):
                if failure == .invalidEmail {
                    error = .InvalidEmail
                } else if failure == .emailAlreadyInUse {
                    error = .EmailAlreadyInUse
                } else if failure == .weakPassword {
                    error = .WeakPassword
                }
                delegate?.showErrorAlert(message: error.errorDescription())
            }
        }
    }
}
