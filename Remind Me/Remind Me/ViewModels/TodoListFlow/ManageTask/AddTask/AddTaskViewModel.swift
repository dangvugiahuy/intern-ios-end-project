//
//  AddTaskViewModel.swift
//  Remind Me
//
//  Created by huy.dang on 9/30/24.
//

import Foundation
import FirebaseAuth

protocol AddTaskViewModelDelegate: AnyObject {
    func addTaskSuccessHandle(task: Todo)
}

final class AddTaskViewModel {
    
    private var user: User?
    private var service: CloudFirestoreService?
    weak var delegate: AddTaskViewModelDelegate?
    var taskListChoosen: TaskList?
    var task: Todo?
    
    init() {
        user = Auth.auth().currentUser
        if let user = self.user {
            service = CloudFirestoreService(user: user)
        }
    }
    
    func addTask() {
        guard let taskListChoosen = self.taskListChoosen, let task = self.task else { return }
        service?.createTask(from: taskListChoosen, with: task, completion: { [self] result in
            switch result {
            case .success(let model):
                delegate?.addTaskSuccessHandle(task: model)
            case .failure(let failure):
                print("Add Task List Error: \(failure.localizedDescription)")
            }
        })
    }
}
