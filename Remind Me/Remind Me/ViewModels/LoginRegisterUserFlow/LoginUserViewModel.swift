//
//  LoginUserViewModel.swift
//  Remind Me
//
//  Created by huy.dang on 9/18/24.
//

import Foundation
import UIKit

protocol LoginUserViewModelDelegate: AnyObject {
    func showErrorAlert(message: String)
    func logInSuccessHandle()
}

final class LoginUserViewModel {
    
    var email: String = ""
    var password: String = ""
    var error: LoginUserErrorType = .Default
    var vc: UIViewController?
    weak var delegate: LoginUserViewModelDelegate?
    
    func signIn() {
        EmailPasswordAuthService.shared.signIn(email: email, password: password) { [self] result in
            switch result {
            case .success(_):
                UserDefaults.standard.set(SignInMethod.EmailPassword, forKey: "SignInMethod")
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
    
    func signInWithGoogle() {
        GoogleAuthService.shared.signIn(vc: vc!) { [self] result in
            switch result {
            case .success(_):
                UserDefaults.standard.set(SignInMethod.Google, forKey: "SignInMethod")
                delegate?.logInSuccessHandle()
            case .failure(let failure):
                if failure == .emailAlreadyInUse {
                    error = .EmailAlreadyInUse
                }
                delegate?.showErrorAlert(message: error.errorDescription())
            }
        }
    }
}
