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
    func setCompleteTaskSuccess()
    func clearAllTaskCompletedSuccess()
    func deleteTaskSuccess(task: Todo)
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
            switch $0.date != nil && $0.completed == false {
            case true:
                return Calendar.current.isDateInToday(Date(timeIntervalSince1970: $0.date!)) ? $0 : nil
            case false:
                return nil
            }
        }
        return result
    }
    
    func getTaskIsCompleted(todos: [Todo], with completed: Bool) -> [Todo] {
        let result = todos.compactMap {
            return $0.completed == completed ? $0 : nil
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
    
    func clearAllCompleteTask(todos: [Todo]) {
        service?.clearAllDocument(from: todos, completion: { [self] result in
            switch result {
            case .success(_):
                delegate?.clearAllTaskCompletedSuccess()
            case .failure(let failure):
                print("Write Data Error: \(failure.localizedDescription)")
            }
        })
    }
    
    func deleteTask(task: Todo) {
        service?.deleteDocument(from: task, completion: { [self] result in
            switch result {
            case .success(_):
                delegate?.deleteTaskSuccess(task: task)
            case .failure(let failure):
                print("Write Data Error: \(failure.localizedDescription)")
            }
        })
    }
    
    func filterDueDate(todos: [Todo], option: filterType) -> [Todo] {
        let taskWithDate = todos.compactMap {
            return $0.date != nil ? $0 : nil
        }
        let taskWithOutDate = todos.compactMap {
            return $0.date == nil ? $0 : nil
        }
        var result: [Todo] = [Todo]()
        result = taskWithDate.sorted { todo1, todo2 in
            switch option {
            case .low:
                return todo1.date! < todo2.date!
            case .high:
                return todo1.date! > todo2.date!
            }
        }
        result.append(contentsOf: taskWithOutDate)
        return result
    }
    
    func filterPriority(todos: [Todo], option: filterType) -> [Todo] {
        let result = todos.sorted { todo1, todo2 in
            switch option {
            case .low:
                return todo1.priority < todo2.priority
            case .high:
                return todo1.priority > todo2.priority
            }
        }
        return result
    }
}

enum filterType {
    case high
    case low
}
