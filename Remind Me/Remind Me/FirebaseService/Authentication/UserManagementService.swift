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
    
    func changeName(from user: User, with name: String, completion: @escaping (Result<User, AuthErrorCode>) -> Void) {
        let changeRequest = user.createProfileChangeRequest()
        changeRequest.displayName = name
        changeRequest.commitChanges { error in
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
    
    func reload(from user: User, completion: @escaping (Result<User, AuthErrorCode>) -> Void) {
        user.reload { error in
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
    
    func createUserDataInCloudFireStore(user: User) {
        let fireStoreService =  CloudFirestoreService(user: user)
        fireStoreService.checkUserExistInDB { result in
            switch result {
            case .success(let isUserExists):
                switch isUserExists {
                case true:
                    break
                case false:
                    fireStoreService.createUserInitData { result in
                        switch result {
                        case .success(_):
                            fireStoreService.createTaskList(list: TaskList(id: UUID().uuidString, name: "Remind Me", tintColor: TaskListTintColor(tint: "#55847A", backgroundTint: "#CCDAD7"))) { result in
                                switch result {
                                case .success(_):
                                    print("Success")
                                    break
                                case .failure(let failure):
                                    print( "Write Data Error: " + failure.localizedDescription)
                                }
                            }
                        case .failure(let failure):
                            print( "Write User Data Error: " + failure.localizedDescription)
                        }
                    }
                }
            case .failure(let fail):
                print("Get Document Error: " + fail.localizedDescription)
            }
        }
    }
}
