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
    
    func fetchAllTaskList(completion: @escaping (Result<[TaskList], Error>) -> Void) {
        let path = primaryPath + "/TaskList"
        var list: [TaskList] = [TaskList]()
        db.collection(path).getDocuments { snapshot, error in
            guard let snapshot = snapshot, error == nil else {
                completion(.failure(error!))
                return
            }
            if !snapshot.isEmpty {
                list = snapshot.documents.map({ document in
                    return TaskList(id: document["id"] as? String, name: document["name"] as! String, tintColor: document["tintColor"] as! String)
                })
            }
            completion(.success(list))
        }
    }
    
    func createUserInitData(completion: @escaping (Result<Bool, Error>) -> Void) {
        db.document(primaryPath).setData([
            "email" : user.email ?? "",
            "name" : user.displayName ?? ""
        ]) { error in
            guard error != nil else { return }
            completion(.failure(error!))
            return
        }
        completion(.success(true))
    }
    
    func createTaskList(list: TaskList, completion: @escaping (Result<TaskList, Error>) -> Void) {
        let path = primaryPath + "/TaskList"
        do  {
            try db.collection(path).document(list.id!).setData(from: list)
            completion(.success(list))
        } catch {
            completion(.failure(error))
        }
    }
    
    func createTask(from list: TaskList, with task: Todo, completion: @escaping (Result<Todo, Error>) -> Void) {
        let path = primaryPath + "/TaskList/\(list.id!)/Todos"
        do  {
            try db.collection(path).document(task.id!).setData(from: task)
            completion(.success(task))
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
