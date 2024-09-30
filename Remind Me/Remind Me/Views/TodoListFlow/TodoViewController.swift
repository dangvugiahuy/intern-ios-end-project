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
        vm.getAllTaskList()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.enableLargeTitle()
    }
    
    override func setupFirstLoadVC() {
        self.title = "Todo"
        switchTaskSegmentControl.setupSegment()
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

extension TodoViewController: UIViewControllerTransitioningDelegate, AddTaskTableViewControllerDelegate, AddTaskListTableViewControllerDelegate, TodoViewModelDelegate {
    
    func addNewTaskSuccessHandle(task: Todo) {
        print("success")
    }
    
    func getTaskListSuccessHandle(list: [TaskList]) {
        self.list = list
        addButton.isEnabled = self.list.isEmpty ? false : true
    }
    
    func addTaskListSuccessHandle(list: TaskList) {
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
