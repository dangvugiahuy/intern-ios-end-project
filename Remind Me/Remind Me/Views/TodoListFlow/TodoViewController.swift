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
    private var isScreenBack =  false
    private let enableNotification = UserDefaults.standard.bool(forKey: "enableNotification")
        
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
        self.isScreenBack.toggle()
        self.tabBarController?.tabBar.isHidden = false
        self.disableLargeTitle()
        loadingIndicator.startAnimating()
        loadingIndicator.isHidden = false
        vm.getAllTaskList()
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
        filterButton.primaryAction = nil
        filterButton.menu = filterMenu()
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
    }
    
    private func filterMenu() -> UIMenu {
        let dueDateSortMenu = UIMenu(title: "Sort By: Due date", image: UIImage(systemName: "calendar"), options: .singleSelection, children: [
            UIAction(title: "Oldest First", image: UIImage(systemName: "arrow.up"), handler: { [self] _ in
                todos = vm.filterDueDate(todos: todos, option: .low)
                todosTableView.reloadData()
            }),
            UIAction(title: "Newest First", image: UIImage(systemName: "arrow.down"), handler: { [self] _ in
                todos = vm.filterDueDate(todos: todos, option: .high)
                todosTableView.reloadData()
            })
        ])
        let prioritySortMenu = UIMenu(title: "Sort By: Priority", image: UIImage(systemName: "flag"), options: .singleSelection, children: [
            UIAction(title: "Highest First", image: UIImage(systemName: "arrow.up"), handler: { [self] _ in
                todos = vm.filterPriority(todos: todos, option: .high)
                todosTableView.reloadData()
            }),
            UIAction(title: "Lowest First", image: UIImage(systemName: "arrow.down"), handler: { [self] _ in
                todos = vm.filterPriority(todos: todos, option: .low)
                todosTableView.reloadData()
            })
        ])
        return UIMenu(options: [], children: [dueDateSortMenu, prioritySortMenu])
    }
    
    private func setupClearTaskCompleted() {
        taskClearButton.isHidden = switchTaskSegmentControl.selectedSegmentIndex == 2 ? false : true
        taskCompletedCountLabel.isHidden = switchTaskSegmentControl.selectedSegmentIndex == 2 ? false : true
    }
    
    private func handleEmptyList() {
        if todos.isEmpty {
            todosTableView.createViewWhenEmptyData(title: "No Todo")
        } else {
            todosTableView.backgroundView = nil
        }
    }
    
    @IBAction func switchTaskSegmentControlValueChange(_ sender: Any) {
        loadingIndicator.startAnimating()
        loadingIndicator.isHidden = false
        refreshTableView()
        setupClearTaskCompleted()
        loadingIndicator.stopAnimating()
        handleEmptyList()
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
    
    @IBAction func taskClearButtonClicked(_ sender: Any) {
        let actionSheet = UIAlertController.createSimpleAlert(with: "Remind Me", and: "\(todos.count) completed todo will be deleted from this list. This cannot be undone.", style: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "Delete All", style: .destructive, handler: { [self] _ in
            let temptodos = todos
            todos.removeAll()
            let indexPaths: [IndexPath] = todosTableView.indexPathsForVisibleRows.map {
                return $0
            }!
            todosTableView.deleteRows(at: indexPaths, with: .fade)
            taskCompletedCountLabel.text = "0 Completed •"
            taskClearButton.isEnabled = false
            vm.clearAllCompleteTask(todos: temptodos)
        }))
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(actionSheet, animated: true)
    }
}

extension TodoViewController: UIViewControllerTransitioningDelegate, AddTaskTableViewControllerDelegate, AddTaskListTableViewControllerDelegate, TodoViewModelDelegate, UITableViewDelegate, UITableViewDataSource, TaskTableViewCellDelegate, TaskDetailViewControllerDelegate {
    
    func editTaskFromDetailSuccessHandle(cell: UITableViewCell, task: Todo) {
        self.isScreenBack.toggle()
        vm.getAllTask(list: self.list)
    }
    
    func deleteTaskFromDetailSuccessHandle(cell: UITableViewCell) {
        self.isScreenBack.toggle()
        vm.getAllTask(list: self.list)
    }
    
    func editTaskHandle(cell: UITableViewCell, task: Todo) {
        let vc = TaskDetailViewController()
        vc.task = task
        vc.cell = cell
        vc.delegate = self
        vc.modalPresentationStyle = .custom
        vc.transitioningDelegate = self
        self.present(vc, animated: true)
    }
    
    func editTaskListSuccessHandle(list: TaskList) {}
    
    func deleteTaskSuccess(task: Todo) {
        if task.date != nil && task.time != nil {
            UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [task.id!])
        }
        vm.getAllTask(list: self.list)
    }
    
    func deleteTaskHandle(cell: UITableViewCell, task: Todo) {
        let actionSheet = UIAlertController.createSimpleAlert(with: "Remind Me", and: "This todo will be deleted from this list. This cannot be undone.", style: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { [self] _ in
            let indexPath = todosTableView.indexPath(for: cell)
            todos.remove(at: indexPath!.row)
            todosTableView.beginUpdates()
            todosTableView.deleteRows(at: [indexPath!], with: .left)
            todosTableView.endUpdates()
            if switchTaskSegmentControl.selectedSegmentIndex == 2 {
                taskCompletedCountLabel.text = todos.isEmpty ? "0 Completed •" : "\(todos.count) Completed •"
                taskClearButton.isEnabled = todos.isEmpty ? false : true
            }
            vm.deleteTask(task: task)
        }))
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(actionSheet, animated: true)
    }
    
    func clearAllTaskCompletedSuccess() {
        vm.getAllTask(list: self.list)
    }
    
    func setTaskComplete(cell: UITableViewCell, task: Todo) {
        let indexPath = todosTableView.indexPath(for: cell)
        todos.remove(at: indexPath!.row)
        todosTableView.beginUpdates()
        todosTableView.deleteRows(at: [indexPath!], with: .left)
        todosTableView.endUpdates()
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
        cell.delegate = self
        return cell
    }
    
    func getAllTaskSuccessHandle(tasks: [Todo]) {
        self.allTodos = tasks
        filterButton.isEnabled = allTodos.isEmpty ? false : true
        switch self.isScreenBack {
        case true:
            refreshTableView()
            loadingIndicator.stopAnimating()
            handleEmptyList()
            self.isScreenBack.toggle()
            break
        case false:
            handleEmptyList()
            break
        }
    }
    
    func addNewTaskSuccessHandle(task: Todo) {
        self.isScreenBack.toggle()
        if let date = task.date, let time = task.time {
            if enableNotification {
                let content = UNMutableNotificationContent()
                content.title = "Remind Me"
                content.body = task.title
                content.sound = UNNotificationSound.default
                let trigger = UNCalendarNotificationTrigger(dateMatching: Date.merge(from: date, and: time), repeats: false)
                let request = UNNotificationRequest(identifier: task.id!, content: content, trigger: trigger)
                UNUserNotificationCenter.current().add(request)
            }
        }
        vm.getAllTask(list: self.list)
    }
    
    func getTaskListSuccessHandle(list: [TaskList]) {
        self.list = list
        addButton.isEnabled = self.list.isEmpty ? false : true
        if !self.list.isEmpty {
            vm.getAllTask(list: self.list)
        } else {
            todosTableView.createViewWhenEmptyData(title: "Please create new list to add your new todo")
            loadingIndicator.stopAnimating()
        }
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
