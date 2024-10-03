//
//  TaskListDetailViewModel.swift
//  Remind Me
//
//  Created by huy.dang on 10/3/24.
//

import Foundation
import FirebaseAuth

protocol TaskListDetailViewModelDelegate: AnyObject {
    func getAllTaskSuccess(todos: [Todo])
    func setCompleteTaskSuccess()
    func deleteTaskSuccess()
}

final class TaskListDetailViewModel {
    
    private var user: User?
    private var service: CloudFirestoreService?
    weak var delegate: TaskListDetailViewModelDelegate?
    
    init() {
        user = Auth.auth().currentUser
        if let user = self.user {
            service = CloudFirestoreService(user: user)
        }
    }
    
    func getAllTask(from list: TaskList) {
        service?.fetchTask(from: list, completion: { [self] result in
            switch result {
            case .success(let model):
                delegate?.getAllTaskSuccess(todos: model)
            case .failure(let failure):
                print("Read Data Fail: \(failure.localizedDescription)")
            }
        })
    }
    
    func getTaskinComplete(todos: [Todo]) -> [Todo] {
        let result = todos.compactMap {
            return !$0.completed ? $0 : nil
        }
        return result
    }
    
    func setCompleteTask(task: Todo) {
        service?.setTaskComplete(from: task, completion: { [self] result in
            switch result {
            case .success(_):
                delegate?.setCompleteTaskSuccess()
            case .failure(let failure):
                print("Write Data Error: \(failure.localizedDescription)")
            }
        })
    }
    
    func deleteTask(task: Todo) {
        service?.deleteDocument(from: task, completion: { [self] result in
            switch result {
            case .success(_):
                delegate?.deleteTaskSuccess()
            case .failure(let failure):
                print("Write Data Error: \(failure.localizedDescription)")
            }
        })
    }
}
