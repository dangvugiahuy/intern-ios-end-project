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
    
    func signOutSuccess() -> Bool {
        do {
            try Auth.auth().signOut()
            return true
        } catch let signOutError as NSError {
            print(signOutError.localizedDescription)
            return false
        }
    }
    
    func reAuthenTicate(email: String, password: String, completion: @escaping (Result<AuthDataResult, AuthErrorCode>) -> Void) {
        guard let user = Auth.auth().currentUser else { return }
        let credential = EmailAuthProvider.credential(withEmail: email, password: password)
        user.reauthenticate(with: credential) { userData, error in
            guard error == nil else {
                if let error = error as NSError? {
                    guard let errorCode = AuthErrorCode(rawValue: error.code) else { return }
                    completion(.failure(errorCode))
                }
                return
            }
            completion(.success(userData!))
        }
    }
    
    func changePassword(from user: User, with newPassword: String, completion: @escaping (Result<User, AuthErrorCode>) -> Void) {
        user.updatePassword(to: newPassword) { error in
            guard error == nil else {
                if let error = error as NSError? {
                    guard let errorCode = AuthErrorCode(rawValue: error.code) else { return }
                    completion(.failure(errorCode))
                }
                return
            }
            completion(.success(user))
        }
    }
}
