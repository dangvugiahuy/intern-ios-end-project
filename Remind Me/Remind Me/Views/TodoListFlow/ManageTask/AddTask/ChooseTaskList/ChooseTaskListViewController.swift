//
//  ChooseTaskListViewController.swift
//  Remind Me
//
//  Created by huy.dang on 9/25/24.
//

import UIKit

protocol ChooseTaskListViewControllerDelegate: AnyObject {
    func chooseTaskListCallBack(list: [TaskList], taskListChoosen: TaskList)
}

class ChooseTaskListViewController: BaseViewController {
    
    public var list: [TaskList]
    public var taskListChoosen: TaskList
    weak var delegate: ChooseTaskListViewControllerDelegate?
    
    @IBOutlet weak var noticeTaskListChoosenLabel: UILabel!
    @IBOutlet weak var taskListTableView: UITableView!
    
    init?(coder: NSCoder, list: [TaskList], taskListChoosen: TaskList) {
        self.list = list
        self.taskListChoosen = taskListChoosen
        super.init(coder: coder)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        for i in 0..<list.count {
            if taskListChoosen.id == list[i].id {
                taskListTableView.selectRow(at: IndexPath(row: i, section: 0), animated: true, scrollPosition: .middle)
                break
            }
        }
    }
    
    override func setupFirstLoadVC() {
        self.title = "Lists"
        taskListTableView.delegate = self
        taskListTableView.dataSource = self
        noticeTaskListChoosenLabel.text = "Todo will be created in " + "\"\(taskListChoosen.name)\""
    }
}

extension ChooseTaskListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = taskListTableView.dequeueReusableCell(withIdentifier: "ChooseTaskListCell", for: indexPath) as! ChooseTaskListTableViewCell
        cell.taskList = list[indexPath.row]
        cell.taskListChoosen = taskListChoosen
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        taskListChoosen = list[indexPath.row]
        delegate?.chooseTaskListCallBack(list: list, taskListChoosen: taskListChoosen)
        self.back()
    }
}
