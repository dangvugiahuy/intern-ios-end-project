//
//  SignInMethod.swift
//  Remind Me
//
//  Created by Huy Gia on 22/9/24.
//

import Foundation

enum SignInMethod: String {
    case EmailPassword = "EmailPassword"
    case Google = "Google"
    
    static func getCurrentSignInMethodValue() -> String {
        return UserDefaults.standard.string(forKey: "SignInMethod") ?? ""
    }
}
