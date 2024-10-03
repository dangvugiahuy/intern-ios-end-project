//
//  TaskListDetailViewController.swift
//  Remind Me
//
//  Created by Huy Gia on 29/9/24.
//

import UIKit

class TaskListDetailViewController: BaseViewController {
    
    private let vm: TaskListDetailViewModel = TaskListDetailViewModel()
    var list: TaskList?
    var todos: [Todo] = [Todo]()
    @IBOutlet weak var todoTableView: UITableView!
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    @IBOutlet weak var addNewTaskButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func setupFirstLoadVC() {
        loadingIndicator.hidesWhenStopped = true
        self.tabBarController?.tabBar.isHidden = true
        let nib = UINib(nibName: "TaskListTodoTableViewCell", bundle: .main)
        todoTableView.register(nib, forCellReuseIdentifier: "TaskListTodoTableViewCell")
        vm.delegate = self
        if let list = self.list {
            loadingIndicator.startAnimating()
            self.title = list.name
            self.navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor().colorFrom(hex: list.tintColor)]
            addNewTaskButton.tintColor = UIColor().colorFrom(hex: list.tintColor)
            vm.getAllTask(from: list)
        }
        todoTableView.delegate = self
        todoTableView.dataSource = self
    }
    
    @IBAction func addNewTodoClicked(_ sender: Any) {
        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: .main)
        let rootview = storyboard.instantiateViewController(withIdentifier: "AddNewTaskVC") as! AddTaskTableViewController
        rootview.taskListChoosen = self.list
        rootview.delegate = self
        let navigateVC = UINavigationController(rootViewController: rootview)
        navigateVC.modalPresentationStyle = .custom
        navigateVC.transitioningDelegate = self
        self.present(navigateVC, animated: true)
    }
}

extension TaskListDetailViewController: UITableViewDelegate, UITableViewDataSource, TaskListDetailViewModelDelegate, TaskListTodoTableViewCellDelegate, AddTaskTableViewControllerDelegate, UIViewControllerTransitioningDelegate {
    
    func deleteTaskSuccess() {
        if self.todos.isEmpty {
            todoTableView.createViewWhenEmptyData(title: "No Todo in \(list!.name)")
        } else {
            todoTableView.backgroundView = nil
        }
    }
    
    func deleteTaskHandle(indexPath: IndexPath, task: Todo) {
        let actionSheet = UIAlertController.createSimpleAlert(with: "Remind Me", and: "This todo will be deleted from this list. This cannot be undone.", style: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { [self] _ in
            todoTableView.beginUpdates()
            todos.remove(at: indexPath.row)
            todoTableView.deleteRows(at: [indexPath], with: .left)
            todoTableView.reloadData()
            todoTableView.endUpdates()
            vm.deleteTask(task: task)
        }))
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(actionSheet, animated: true)
    }
    
    func addNewTaskSuccessHandle(task: Todo) {
        todoTableView.beginUpdates()
        todos.insert(task, at: 0)
        let indexPath = IndexPath(row: 0, section: 0)
        todoTableView.insertRows(at: [indexPath], with: .right)
        todoTableView.endUpdates()
        if todoTableView.backgroundView != nil {
            todoTableView.backgroundView = nil
        }
    }
    
    func setCompleteTaskSuccess() {
        if self.todos.isEmpty {
            todoTableView.createViewWhenEmptyData(title: "No Todo in \(list!.name)")
        } else {
            todoTableView.backgroundView = nil
        }
    }
    
    func setTaskComplete(indexPath: IndexPath, task: Todo) {
        todoTableView.beginUpdates()
        todos.remove(at: indexPath.row)
        todoTableView.deleteRows(at: [indexPath], with: .left)
        todoTableView.reloadData()
        todoTableView.endUpdates()
        vm.setCompleteTask(task: task)
    }

    func getAllTaskSuccess(todos: [Todo]) {
        self.todos = vm.getTaskinComplete(todos: todos)
        todoTableView.reloadData()
        loadingIndicator.stopAnimating()
        if self.todos.isEmpty {
            todoTableView.createViewWhenEmptyData(title: "No Todo in \(list!.name)")
        } else {
            todoTableView.backgroundView = nil
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = todoTableView.dequeueReusableCell(withIdentifier: "TaskListTodoTableViewCell", for: indexPath) as! TaskListTodoTableViewCell
        cell.todo = todos[indexPath.row]
        cell.indexPath = indexPath
        cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        let presentController = PresentationController(presentedViewController: presented, presenting: presenting)
        presentController.heightValue = 0.7
        presentController.yValue = (1 - presentController.heightValue!)
        return presentController
    }
}
