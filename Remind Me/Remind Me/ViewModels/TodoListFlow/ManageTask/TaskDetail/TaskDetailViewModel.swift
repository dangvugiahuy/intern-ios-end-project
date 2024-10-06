//
//  TaskDetailViewModel.swift
//  Remind Me
//
//  Created by Huy Gia on 6/10/24.
//

import Foundation
import FirebaseAuth

protocol TaskDetailViewModelDelegate: AnyObject {
    func deleteTaskHandle()
    func editTaskHandle()
}

final class TaskDetailViewModel {
    
    private var user: User?
    private var service: CloudFirestoreService?
    weak var delegate: TaskDetailViewModelDelegate?
    
    init() {
        user = Auth.auth().currentUser
        if let user = self.user {
            service = CloudFirestoreService(user: user)
        }
    }
    
    func deleteTask(task: Todo) {
        service?.deleteDocument(from: task, completion: { [self] result in
            switch result {
            case .success(_):
                delegate?.deleteTaskHandle()
            case .failure(let failure):
                print("Write Data Error: \(failure.localizedDescription)")
            }
        })
    }
    
    func updateTask(task: Todo) {
        service?.editTask(task: task, completion: { [self] result in
            switch result {
            case .success(_):
                delegate?.editTaskHandle()
            case .failure(let failure):
                print("Write Data Error: \(failure.localizedDescription)")
            }
        })
    }
}
