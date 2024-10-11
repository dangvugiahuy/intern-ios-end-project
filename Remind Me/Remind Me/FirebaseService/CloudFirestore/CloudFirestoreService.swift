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
    
    func editTaskList(list: TaskList, completion: @escaping (Result<TaskList, Error>) -> Void) {
        let path = primaryPath + "/TaskList"
        db.collection(path).document(list.id!).setData(["name" : list.name, "tintColor": list.tintColor], merge: true) { error in
            guard error == nil else {
                completion(.failure(error!))
                return
            }
            completion(.success(list))
        }
    }
    
    func editTask(task: Todo, completion: @escaping (Result<Any, Error>) -> Void) {
        let path = primaryPath + "/TaskList/\(task.taskList!.id!)/Todos"
        do {
            try db.collection(path).document(task.id!).setData(from: task)
            completion(.success("Edit Success!"))
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
    
    func fetchTask(from list: TaskList, completion: @escaping (Result<[Todo], Error>) -> Void) {
        var todos: [Todo] = [Todo]()
        let path = primaryPath + "/TaskList/\(list.id!)/Todos"
        db.collection(path).getDocuments { snapshot, error in
            guard let snapshot = snapshot, error == nil else {
                completion(.failure(error!))
                return
            }
            if !snapshot.isEmpty {
                todos = snapshot.documents.map({ document in
                    return Todo(id: document["id"] as? String, title: document["title"] as! String, note: document["note"] as? String, date: document["date"] as? TimeInterval, time: document["time"] as? TimeInterval, priority: document["priority"] as! Int, completed: document["completed"] as! Bool, taskList: list)
                })
            }
            completion(.success(todos))
        }
    }
    
    func setTaskComplete(from task: Todo, completion: @escaping (Result<Any, Error>) -> Void) {
        let path = primaryPath + "/TaskList/\(task.taskList!.id!)/Todos"
        db.collection(path).document(task.id!).setData(["completed" : task.completed], merge: true) { error in
            guard error == nil else {
                completion(.failure(error!))
                return
            }
            completion(.success("Success!"))
        }
    }
    
    func clearAllDocument(from todos: [Todo], completion: @escaping (Result<Any, Error>) -> Void) {
        for todo in todos {
            let path = primaryPath + "/TaskList/\(todo.taskList!.id!)/Todos"
            db.collection(path).document(todo.id!).delete { error in
                guard error == nil else {
                    completion(.failure(error!))
                    return
                }
            }
        }
        completion(.success("Clear Success!"))
    }
    
    func deleteDocument(from todo: Todo, completion: @escaping (Result<Any, Error>) -> Void) {
        let path = primaryPath + "/TaskList/\(todo.taskList!.id!)/Todos"
        db.collection(path).document(todo.id!).delete { error in
            guard error == nil else {
                completion(.failure(error!))
                return
            }
            completion(.success("Clear Success!"))
        }
    }
    
    func deleteTaskList(from todos: [Todo], of list: TaskList, completion: @escaping (Result<Any, Error>) -> Void) {
        if !todos.isEmpty {
            let todosPath = primaryPath + "/TaskList/\(list.id!)/Todos"
            for todo in todos {
                db.collection(todosPath).document(todo.id!).delete { error in
                    guard error == nil else {
                        completion(.failure(error!))
                        return
                    }
                }
            }
        }
        let path = primaryPath + "/TaskList"
        db.collection(path).document(list.id!).delete { error in
            guard error == nil else {
                completion(.failure(error!))
                return
            }
        }
        completion(.success("Delete Success!"))
    }
    
    func addNewFeed(from feed: Feed, completion: @escaping (Result<[String]?, Error>) -> Void) {
        let path = primaryPath + "/Feed"
        do  {
            try db.collection(path).document(feed.id!).setData(from: feed)
            completion(.success(feed.imagesURL))
        } catch {
            completion(.failure(error))
        }
    }
    
    func fetchFeeds(completion: @escaping (Result<[Feed], Error>) -> Void) {
        var feeds: [Feed] = [Feed]()
        let path = primaryPath + "/Feed"
        db.collection(path).getDocuments { snapshot, error in
            guard let snapshot = snapshot, error == nil else {
                completion(.failure(error!))
                return
            }
            if !snapshot.isEmpty {
                feeds = snapshot.documents.map({ document in
                    return Feed(id: document["id"] as? String, content: document["content"] as! String, imagesURL: document["imagesURL"] as? [String], createDate: document["createDate"] as! TimeInterval)
                })
            }
            completion(.success(feeds))
        }
    }
}
