//
//  TodoViewController.swift
//  Remind Me
//
//  Created by huy.dang on 9/13/24.
//

import UIKit

class TodoViewController: BaseViewController {
        
    @IBOutlet weak var manageTaskListButton: UIBarButtonItem!
    @IBOutlet weak var switchTaskSegmentControl: UISegmentedControl!
    @IBOutlet weak var filterButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func setupFirstLoadVC() {
        self.title = "Todo"
        switchTaskSegmentControl.setupSegment()
        manageTaskListButton.primaryAction = nil
        manageTaskListButton.menu = setupMenu()
    }
    
    private func setupMenu() -> UIMenu {
        let menu = UIMenu(title: "Manage Task List", options: [], children: [
            UIAction(title: "My List", image: UIImage(systemName: "list.bullet.indent"), handler: { _ in
                
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
        rootview.delegate = self
        let navigateVC = UINavigationController(rootViewController: rootview)
        navigateVC.modalPresentationStyle = .custom
        navigateVC.transitioningDelegate = self
        self.present(navigateVC, animated: true)
    }
}

extension TodoViewController: UIViewControllerTransitioningDelegate, AddTaskTableViewControllerDelegate, AddTaskListTableViewControllerDelegate {
    
    func addTaskListSuccessHandle() {
        print("Success")
    }
    
    func addNewTaskSuccessHandle() {
        print("Success")
    }
    
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        let presentController = PresentationController(presentedViewController: presented, presenting: presenting)
        presentController.heightValue = 0.8
        presentController.yValue = (1 - presentController.heightValue!)
        return presentController
    }
}
