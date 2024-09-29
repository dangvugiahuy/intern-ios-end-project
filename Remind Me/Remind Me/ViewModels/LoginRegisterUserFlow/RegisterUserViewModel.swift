//
//  RegisterUserViewModel.swift
//  Remind Me
//
//  Created by huy.dang on 9/18/24.
//

import Foundation
import FirebaseAuth
import UIKit

protocol RegisterUserViewModelDelegate: AnyObject {
    func showErrorAlert(message: String)
    func registerSuccessHandle()
}

final class RegisterUserViewModel {
    
    var email: String = ""
    var password: String = ""
    var vc: UIViewController?
    private var error: RegisterUserErrorType = .None
    weak var delegate: RegisterUserViewModelDelegate?
    
    func register() {
        EmailPasswordAuthService.shared.createUser(email: email, password: password) { [self] result in
            switch result {
            case .success(let userAuthData):
                UserDefaults.standard.set(SignInMethod.EmailPassword.rawValue, forKey: "SignInMethod")
                UserManagementService.shared.createUserDataInCloudFireStore(user: userAuthData.user)
                delegate?.registerSuccessHandle()
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
    
    func registerWithGoogle() {
        GoogleAuthService.shared.signIn(vc: vc!) { [self] result in
            switch result {
            case .success(let userAuthData):
                UserDefaults.standard.set(SignInMethod.Google.rawValue, forKey: "SignInMethod")
                UserManagementService.shared.createUserDataInCloudFireStore(user: userAuthData.user)
                delegate?.registerSuccessHandle()
            case .failure(let failure):
                if failure == .emailAlreadyInUse {
                    error = .EmailAlreadyInUse
                }
                delegate?.showErrorAlert(message: error.errorDescription())
            }
        }
    }
}
