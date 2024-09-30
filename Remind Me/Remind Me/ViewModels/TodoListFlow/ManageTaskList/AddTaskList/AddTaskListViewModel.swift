//
//  AddTaskListViewModel.swift
//  Remind Me
//
//  Created by Huy Gia on 29/9/24.
//

import Foundation
import FirebaseAuth

protocol AddTaskListViewModelDelegate: AnyObject {
    func addTaskListSuccessHandle(list: TaskList)
}

final class AddTaskListViewModel {
    
    private var user: User?
    private var service: CloudFirestoreService?
    weak var delegate: AddTaskListViewModelDelegate?
    var name: String = ""
    var tintColor: String = ""
    
    init() {
        user = Auth.auth().currentUser
    }
    
    func addNewTaskList() {
        guard let user = self.user else { return }
        let service = CloudFirestoreService(user: user)
        service.createTaskList(list: TaskList(id: UUID().uuidString, name: self.name, tintColor: self.tintColor)) { [self] result in
            switch result {
            case .success(let model):
                delegate?.addTaskListSuccessHandle(list: model)
            case .failure(let failure):
                print( "Write Data Error: " + failure.localizedDescription)
            }
        }
    }
}
