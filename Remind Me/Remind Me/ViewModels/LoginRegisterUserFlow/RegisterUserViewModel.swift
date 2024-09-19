//
//  RegisterUserViewModel.swift
//  Remind Me
//
//  Created by huy.dang on 9/18/24.
//

import Foundation

protocol RegisterUserViewModelDelegate {
    func showErrorAlert(message: String)
}

final class RegisterUserViewModel {
    
    var email: String = ""
    var password: String = ""
    var error: RegisterUserErrorType = .None
    
    func register() {
//        EmailPasswordAuthService.shared.createUser(email: email, password: password) { [self] result in
//            switch result {
//            case .success(let success):
//                
//            case .failure(let failure):
//                switch failure {
//                case .invalidEmail:
//                    error = .InvalidEmail
//                case .emailAlreadyInUse:
//                    error = .EmailAlreadyInUse
//                }
//            }
//        }
    }
}
