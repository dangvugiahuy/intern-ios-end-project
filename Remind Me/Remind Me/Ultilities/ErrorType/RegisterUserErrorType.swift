//
//  RegisterUserErrorType.swift
//  Remind Me
//
//  Created by huy.dang on 9/19/24.
//

import Foundation

enum RegisterUserErrorType: Error {
    
    case InvalidEmail
    case EmailAlreadyInUse
    case WeakPassword
    case None
    
    func errorDescription() -> String {
        switch self {
        case .InvalidEmail:
            return "Invalid email address. Please try again!"
        case .EmailAlreadyInUse:
            return "Email address is already in use. Please use another email"
        case .WeakPassword:
            return """
Your password must:
- At least 8 character
- At least 1 lowercase letter
- At least 1 uppercase letter
- At least 1 special character
"""
        case .None:
            return ""
        }
    }
    
}
