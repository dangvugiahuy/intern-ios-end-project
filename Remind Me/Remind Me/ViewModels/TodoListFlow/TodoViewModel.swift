//
//  TodoViewModel.swift
//  Remind Me
//
//  Created by Huy Gia on 30/9/24.
//

import Foundation
import FirebaseAuth

protocol TodoViewModelDelegate: AnyObject {
    func getTaskListSuccessHandle(list: [TaskList])
}

final class TodoViewModel {
    
    private var user: User?
    private var service: CloudFirestoreService?
    weak var delegate: TodoViewModelDelegate?
    
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
