//
//  ChangePasswordErrorType.swift
//  Remind Me
//
//  Created by huy.dang on 9/23/24.
//

import Foundation

enum ChangePasswordErrorType: Error {
    case WrongPassword
    case WeakPassword
    case None
    
    func errorDescription() -> String {
        switch self {
        case .WrongPassword:
            return "The current password is incorrect, please try again"
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
