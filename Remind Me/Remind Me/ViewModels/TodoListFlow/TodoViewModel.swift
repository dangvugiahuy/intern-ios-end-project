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
    func getAllTaskSuccessHandle(tasks: [Todo])
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
    
    func getAllTask(list: [TaskList]) {
        var todos: [Todo] = [Todo]()
        var last: Int = 0
        for i in 0..<list.count {
            service?.fetchTask(from: list[i], completion: { [self] result in
                switch result {
                case .success(let model):
                    last += 1
                    todos.append(contentsOf: model)
                    if last == list.count {
                        delegate?.getAllTaskSuccessHandle(tasks: todos)
                    }
                case .failure(let failure):
                    print("Read Data Error: \(failure.localizedDescription)")
                }
            })
        }
    }
    
    func getTodayTasks(todos: [Todo]) -> [Todo] {
        let result = todos.compactMap {
            switch $0.date != nil {
            case true:
                return Calendar.current.isDateInToday(Date(timeIntervalSinceNow: $0.date!)) ? $0 : nil
            case false:
                return nil
            }
        }
        return result
    }
    
    func getTaskCompleted(todos: [Todo]) -> [Todo] {
        let result = todos.compactMap {
            return $0.completed ? $0 : nil
        }
        return result
    }
}
