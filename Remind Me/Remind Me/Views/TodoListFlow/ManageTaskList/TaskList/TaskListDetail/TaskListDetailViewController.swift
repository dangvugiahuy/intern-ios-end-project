//
//  TaskListDetailViewController.swift
//  Remind Me
//
//  Created by Huy Gia on 29/9/24.
//

import UIKit

protocol TaskListDetailViewControllerDelegate: AnyObject {
    func delete(at indexPath: IndexPath)
    func update(at indexPath: IndexPath, with list: TaskList)
}

class TaskListDetailViewController: BaseViewController {
    
    private let vm: TaskListDetailViewModel = TaskListDetailViewModel()
    private var isEdit: Bool = false
    private let enableNotification = UserDefaults.standard.bool(forKey: "enableNotification")
    var indexPath: IndexPath?
    var list: TaskList?
    var todos: [Todo] = [Todo]()
    weak var delegate: TaskListDetailViewControllerDelegate?
    @IBOutlet weak var todoTableView: UITableView!
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    @IBOutlet weak var addNewTaskButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if isEdit {
            delegate?.update(at: indexPath!, with: list!)
            isEdit.toggle()
        }
    }
    
    override func setupFirstLoadVC() {
        let detailButton = UIBarButtonItem(image: UIImage(systemName: "ellipsis.circle"), primaryAction: nil, menu: detailMenu())
        self.navigationItem.rightBarButtonItem = detailButton
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
    
    private func handleEmptyList() {
        if self.todos.isEmpty {
            todoTableView.createViewWhenEmptyData(title: "No Todo in \(list!.name)")
        } else {
            todoTableView.backgroundView = nil
        }
    }
    
    private func detailMenu() -> UIMenu {
        let menuItems: [UIAction] = [
            UIAction(title: "Detail", image: UIImage(systemName: "info.circle"), handler: { [self] _ in
                let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: .main)
                let rootview = storyboard.instantiateViewController(withIdentifier: "AddTaskListVC") as! AddTaskListTableViewController
                rootview.taskList = list
                rootview.delegate = self
                let navigateVC = UINavigationController(rootViewController: rootview)
                navigateVC.modalPresentationStyle = .custom
                navigateVC.transitioningDelegate = self
                self.present(navigateVC, animated: true)
            }),
            UIAction(title: "Delete", image: UIImage(systemName: "trash"), attributes: .destructive, handler: { [self] _ in
                let alert = UIAlertController.createSimpleAlert(with: "Delete list \"\(list!.name)\"?", and: "This will delete all todo in list", style: .alert)
                alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
                alert.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { [self] _ in
                    vm.deleteThisTaskList(list: list!, todos: todos)
                }))
                self.present(alert, animated: true)
            }),
        ]
        return UIMenu(children: menuItems)
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

extension TaskListDetailViewController: UITableViewDelegate, UITableViewDataSource, TaskListDetailViewModelDelegate, TaskListTodoTableViewCellDelegate, AddTaskTableViewControllerDelegate, UIViewControllerTransitioningDelegate, AddTaskListTableViewControllerDelegate, TaskDetailViewControllerDelegate {
    
    func editTaskFromDetailSuccessHandle(cell: UITableViewCell, task: Todo) {
        let indexPath = todoTableView.indexPath(for: cell)
        todos[indexPath!.row] = task
        todoTableView.reloadData()
    }
    
    func deleteTaskFromDetailSuccessHandle(cell: UITableViewCell) {
        let indexPath = todoTableView.indexPath(for: cell)
        todos.remove(at: indexPath!.row)
        todoTableView.beginUpdates()
        todoTableView.deleteRows(at: [indexPath!], with: .left)
        todoTableView.endUpdates()
        handleEmptyList()
        switch UNUserNotificationCenter.checkRequestInNotificationCenter(id: todos[indexPath!.row].id!) {
        case true:
            UNUserNotificationCenter.removeScheduleTaskFromNotification(id: todos[indexPath!.row].id!)
        case false:
            break
        }
    }
    
    func editTaskHandle(cell: UITableViewCell, task: Todo) {
        let vc = TaskDetailViewController()
        vc.task = task
        vc.delegate = self
        vc.cell = cell
        vc.modalPresentationStyle = .custom
        vc.transitioningDelegate = self
        self.present(vc, animated: true)
    }
    
    func editTaskListSuccessHandle(list: TaskList) {
        self.list = list
        self.title = list.name
        self.navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor().colorFrom(hex: list.tintColor)]
        addNewTaskButton.tintColor = UIColor().colorFrom(hex: list.tintColor)
        handleEmptyList()
        isEdit.toggle()
    }
    
    func addTaskListSuccessHandle(list: TaskList) {}
    
    func deleteThisListSuccess() {
        delegate?.delete(at: indexPath!)
        self.navigationController?.popViewController(animated: true)
    }
    
    func deleteTaskSuccess(task: Todo) {
        switch UNUserNotificationCenter.checkRequestInNotificationCenter(id: task.id!) {
        case true:
            UNUserNotificationCenter.removeScheduleTaskFromNotification(id: task.id!)
        case false:
            break
        }
        handleEmptyList()
    }
    
    func deleteTaskHandle(cell: UITableViewCell, task: Todo) {
        let actionSheet = UIAlertController.createSimpleAlert(with: "Remind Me", and: "This todo will be deleted from this list. This cannot be undone.", style: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { [self] _ in
            let indexPath = todoTableView.indexPath(for: cell)
            todos.remove(at: indexPath!.row)
            todoTableView.beginUpdates()
            todoTableView.deleteRows(at: [indexPath!], with: .left)
            todoTableView.endUpdates()
            vm.deleteTask(task: task)
        }))
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(actionSheet, animated: true)
    }
    
    func addNewTaskSuccessHandle(task: Todo) {
        todos.insert(task, at: 0)
        todoTableView.beginUpdates()
        let indexPath = IndexPath(row: 0, section: 0)
        todoTableView.insertRows(at: [indexPath], with: .automatic)
        todoTableView.endUpdates()
        handleEmptyList()
        UNUserNotificationCenter.addNewScheduleTaskToNotification(task: task)
    }
    
    func setCompleteTaskSuccess() {
        handleEmptyList()
    }
    
    func setTaskComplete(cell: UITableViewCell, task: Todo) {
        let indexPath = todoTableView.indexPath(for: cell)
        todos.remove(at: indexPath!.row)
        todoTableView.beginUpdates()
        todoTableView.deleteRows(at: [indexPath!], with: .left)
        todoTableView.endUpdates()
        vm.setCompleteTask(task: task)
    }

    func getAllTaskSuccess(todos: [Todo]) {
        self.todos = vm.getTaskinComplete(todos: todos)
        todoTableView.reloadData()
        loadingIndicator.stopAnimating()
        handleEmptyList()
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
        presentController.heightValue = 0.8
        presentController.yValue = (1 - presentController.heightValue!)
        return presentController
    }
}
