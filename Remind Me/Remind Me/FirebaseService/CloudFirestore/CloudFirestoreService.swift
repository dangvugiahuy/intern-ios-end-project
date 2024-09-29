//
//  CloudFirestoreService.swift
//  Remind Me
//
//  Created by huy.dang on 9/25/24.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth

final class CloudFirestoreService {
    
    private let db = Firestore.firestore()
    private let user: User
    private var primaryPath: String = ""
    
    init(user: User) {
        self.user = user
        self.primaryPath = "users/" + user.uid
    }
    
//    func fetchAllTaskList(completion: @escaping (Result<[TaskList], Error>) -> Void) {
//        let path = primaryPath + "TaskList"
//        db.collection(path).getDocuments { snapshot, error in
//            guard let snapshot = snapshot, error == nil else {
//                return
//            }
//        }
//    }
    
    func createTaskList(list: TaskList, completion: @escaping (Result<Any, Error>) -> Void) {
        let path = primaryPath + "/TaskList"
        do  {
            try db.collection(path).addDocument(from: list)
            completion(.success(list))
        } catch {
            completion(.failure(error))
        }
    }
    
    func checkUserExistInDB(completion: @escaping (Result<Bool, Error>) -> Void) {
        db.document(primaryPath).getDocument { snapshot, error in
            guard error == nil else {
                completion(.failure(error!))
                return
            }
            if let snapshot, snapshot.exists {
                completion(.success(true))
            } else {
                completion(.success(false))
            }
        }
    }
    
//    func fetchAllTodoData() {
//        let path = primaryPath + "TaskList"
//    }
//    
//    func fetchTodoData(from taskList: TaskList) -> [Todo] {
//        
//    }
}
