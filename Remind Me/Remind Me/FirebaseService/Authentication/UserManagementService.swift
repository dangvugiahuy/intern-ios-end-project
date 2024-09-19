//
//  UserManagementService.swift
//  Remind Me
//
//  Created by huy.dang on 9/19/24.
//

import Foundation
import FirebaseAuth

final class UserManagementService {
    static let shared: UserManagementService = UserManagementService()
    init() {}
    
    func isUserSignedIn() -> Bool {
        if Auth.auth().currentUser != nil {
            return true
        } else {
            return false
        }
    }
}
