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
    private let primaryPath = "users/\(String(describing: Auth.auth().currentUser?.email))/"
    static let shared: CloudFirestoreService = CloudFirestoreService()
    init() {}
    
    func fetchAllTaskList(completion: @escaping (Result<[TaskList], Error>) -> Void) {
        let path = primaryPath + "TaskList"
        db.collection(path).getDocuments { snapshot, error in
            guard let snapshot = snapshot, error == nil else {
                return
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
