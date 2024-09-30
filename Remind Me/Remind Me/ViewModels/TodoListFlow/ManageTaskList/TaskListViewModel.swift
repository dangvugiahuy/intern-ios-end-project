//
//  TaskListViewModel.swift
//  Remind Me
//
//  Created by huy.dang on 9/30/24.
//

import Foundation
import FirebaseAuth

protocol TaskListViewModelDelegate: AnyObject {
    func getTaskListSuccessHandle(list: [TaskList])
}

final class TaskListViewModel {
    
    private var user: User?
    private var service: CloudFirestoreService?
    weak var delegate: TaskListViewModelDelegate?
    
    init() {
        user = Auth.auth().currentUser
        if let user = self.user {
            service = CloudFirestoreService(user: user)
        }
    }
    
    func getAllTaskList() {
        service?.fetchAllTaskList(completion: { [self] result in
            switch result {
            case .success(let model):
                delegate?.getTaskListSuccessHandle(list: model)
            case .failure(let failure):
                print("Read Data Error: \(failure.localizedDescription)")
            }
        })
    }
}
