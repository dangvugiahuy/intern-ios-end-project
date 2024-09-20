//
//  GoogleAuthService.swift
//  Remind Me
//
//  Created by huy.dang on 9/18/24.
//

import Foundation
import FirebaseCore
import FirebaseAuth
import GoogleSignIn

final class GoogleAuthService {
    
    static let shared: GoogleAuthService = GoogleAuthService()
    init() {}
    
    func signIn(vc: UIViewController, completion: @escaping (Result<AuthDataResult, AuthErrorCode>) -> Void) {
        guard let clientID = FirebaseApp.app()?.options.clientID else { return }
        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config
        GIDSignIn.sharedInstance.signIn(withPresenting: vc) { result, error in
            guard error == nil else { return }
            guard let user = result?.user, let idToken = user.idToken?.tokenString else { return }
            let credential = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: user.accessToken.tokenString)
            Auth.auth().signIn(with: credential) { userData, error in
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
}
