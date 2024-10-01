//
//  TaskListDetailViewController.swift
//  Remind Me
//
//  Created by Huy Gia on 29/9/24.
//

import UIKit

class TaskListDetailViewController: BaseViewController {
    
    var list: TaskList?
    @IBOutlet weak var addNewTaskButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func setupFirstLoadVC() {
        if let list = self.list {
            self.title = list.name
            self.navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor().colorFrom(hex: list.tintColor.tint)]
            addNewTaskButton.tintColor = UIColor().colorFrom(hex: list.tintColor.tint)
            self.tabBarController?.tabBar.isHidden = true
            self.disableLargeTitle()
        }
    }
}
