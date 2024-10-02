//
//  TodoViewController.swift
//  Remind Me
//
//  Created by huy.dang on 9/13/24.
//

import UIKit

class TodoViewController: BaseViewController {
    
    private let vm: TodoViewModel = TodoViewModel()
    private var list: [TaskList] = [TaskList]()
    private var allTodos: [Todo] = [Todo]()
    private var todos: [Todo] = [Todo]()
        
    @IBOutlet weak var taskClearButton: UIButton!
    @IBOutlet weak var taskCompletedCountLabel: UILabel!
    @IBOutlet weak var todosTableView: UITableView!
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    @IBOutlet weak var addButton: UIBarButtonItem!
    @IBOutlet weak var manageTaskListButton: UIBarButtonItem!
    @IBOutlet weak var switchTaskSegmentControl: UISegmentedControl!
    @IBOutlet weak var filterButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = false
        self.disableLargeTitle()
        if allTodos.isEmpty {
            loadingIndicator.startAnimating()
            vm.getAllTaskList()
        }
        setupClearTaskCompleted()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.enableLargeTitle()
    }
    
    override func setupFirstLoadVC() {
        self.title = "Todo"
        todosTableView.delegate = self
        todosTableView.dataSource = self
        switchTaskSegmentControl.setupSegment()
        loadingIndicator.hidesWhenStopped = true
        manageTaskListButton.primaryAction = nil
        manageTaskListButton.menu = setupMenu()
        self.setupLeftNavigationBarItem()
        vm.delegate = self
    }
    
    private func setupMenu() -> UIMenu {
        let menu = UIMenu(title: "Manage Task List", options: [], children: [
            UIAction(title: "My List", image: UIImage(systemName: "list.bullet.indent"), handler: { _ in
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "TaskListTableVC") as! TaskListTableViewController
                vc.list = self.list
                self.next(vc: vc)
            }),
            UIAction(title: "Add New List", image: UIImage(systemName: "text.badge.plus"), handler: { _ in
                let rootview = self.storyboard?.instantiateViewController(withIdentifier: "AddTaskListVC") as! AddTaskListTableViewController
                rootview.delegate = self
                let navigateVC = UINavigationController(rootViewController: rootview)
                navigateVC.modalPresentationStyle = .custom
                navigateVC.transitioningDelegate = self
                self.present(navigateVC, animated: true)
            })
        ])
        return menu
    }
    
    private func refreshTableView() {
        switch switchTaskSegmentControl.selectedSegmentIndex {
        case 1:
            todos = vm.getTaskIsCompleted(todos: allTodos, with: false)
            break
        case 2:
            todos = vm.getTaskIsCompleted(todos: allTodos, with: true)
            taskCompletedCountLabel.text = todos.isEmpty ? "0 Completed •" : "\(todos.count) Completed •"
            taskClearButton.isEnabled = todos.isEmpty ? false : true
            break
        default:
            todos = vm.getTodayTasks(todos: allTodos)
            break
        }
        todosTableView.reloadData()
        loadingIndicator.stopAnimating()
    }
    
    private func setupClearTaskCompleted() {
        taskClearButton.isHidden = switchTaskSegmentControl.selectedSegmentIndex == 2 ? false : true
        taskCompletedCountLabel.isHidden = switchTaskSegmentControl.selectedSegmentIndex == 2 ? false : true
    }
    
    @IBAction func switchTaskSegmentControlValueChange(_ sender: Any) {
        loadingIndicator.startAnimating()
        refreshTableView()
        setupClearTaskCompleted()
        if todos.isEmpty {
            todosTableView.createViewWhenEmptyData(title: "No Todo")
        } else {
            todosTableView.backgroundView = nil
        }
    }
    
    @IBAction func filterButtonClicked(_ sender: UIBarButtonItem) {
        
    }
    
    @IBAction func addTaskClicked(_ sender: UIBarButtonItem) {
        let rootview = self.storyboard?.instantiateViewController(withIdentifier: "AddNewTaskVC") as! AddTaskTableViewController
        rootview.list = self.list
        rootview.delegate = self
        let navigateVC = UINavigationController(rootViewController: rootview)
        navigateVC.modalPresentationStyle = .custom
        navigateVC.transitioningDelegate = self
        self.present(navigateVC, animated: true)
    }
}

extension TodoViewController: UIViewControllerTransitioningDelegate, AddTaskTableViewControllerDelegate, AddTaskListTableViewControllerDelegate, TodoViewModelDelegate, UITableViewDelegate, UITableViewDataSource, TaskTableViewCellDelegate {
    
    func setTaskComplete(indexPath: IndexPath, task: Todo) {
        todos.remove(at: indexPath.row)
        todosTableView.deleteRows(at: [indexPath], with: .left)
        taskCompletedCountLabel.text = todos.isEmpty ? "0 Completed •" : "\(todos.count) Completed •"
        taskClearButton.isEnabled = todos.isEmpty ? false : true
        vm.setCompleteTask(task: task)
    }
    
    func setCompleteTaskSuccess() {
        vm.getAllTask(list: self.list)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = todosTableView.dequeueReusableCell(withIdentifier: "TaskTableViewCell", for: indexPath) as! TaskTableViewCell
        cell.task = todos[indexPath.row]
        cell.indexPath = indexPath
        cell.delegate = self
        return cell
    }
    
    func getAllTaskSuccessHandle(tasks: [Todo]) {
        self.allTodos = tasks
        refreshTableView()
        if todos.isEmpty {
            todosTableView.createViewWhenEmptyData(title: "No Todo")
        } else {
            todosTableView.backgroundView = nil
        }
    }
    
    func addNewTaskSuccessHandle(task: Todo) {
        vm.getAllTask(list: self.list)
    }
    
    func getTaskListSuccessHandle(list: [TaskList]) {
        self.list = list
        addButton.isEnabled = self.list.isEmpty ? false : true
        vm.getAllTask(list: self.list)
    }
    
    func addTaskListSuccessHandle(list: TaskList) {
        vm.getAllTaskList()
        let vc = TaskListDetailViewController()
        vc.list = list
        self.next(vc: vc)
    }
    
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        let presentController = PresentationController(presentedViewController: presented, presenting: presenting)
        presentController.heightValue = 0.8
        presentController.yValue = (1 - presentController.heightValue!)
        return presentController
    }
}
