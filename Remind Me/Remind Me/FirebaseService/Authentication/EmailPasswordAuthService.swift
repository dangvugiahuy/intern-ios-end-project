//
//  EmailPasswordAuthService.swift
//  Remind Me
//
//  Created by huy.dang on 9/18/24.
//

import Foundation
import FirebaseAuth

final class EmailPasswordAuthService {
    
    static let shared: EmailPasswordAuthService =  EmailPasswordAuthService()
    init() {}
    
    func createUser(email: String, password: String, completion: @escaping (Result<AuthDataResult, AuthErrorCode>) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password) { userData, error in
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
    
    func signIn(email: String, password: String, completion: @escaping (Result<AuthDataResult, AuthErrorCode>) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] userData, error in
            guard let strongSelf = self else { return }
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
    
}
