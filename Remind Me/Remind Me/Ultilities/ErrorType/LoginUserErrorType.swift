//
//  LoginUserErrorType.swift
//  Remind Me
//
//  Created by huy.dang on 9/20/24.
//

import Foundation

enum LoginUserErrorType: Error {
    
    case InvalidEmail
    case UserDisabled
    case EmailAlreadyInUse
    case Default
    
    func errorDescription() -> String {
        switch self {
        case .InvalidEmail:
            return "Invalid email address. Please try again!"
        case .UserDisabled:
            return "Your account has been disabled. Please contact us for more details"
        case .EmailAlreadyInUse:
            return "Email address is available with another Sign In Mehtod. Please use another email"
        case .Default:
            return "Your email or password is incorrect. Please try again"
        }
    }
    
}
