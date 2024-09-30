//
//  TaskListTableViewController.swift
//  Remind Me
//
//  Created by huy.dang on 9/30/24.
//

import UIKit

class TaskListTableViewController: UITableViewController {
    
    private let vm: TaskListViewModel = TaskListViewModel()
    private var list: [TaskList] = [TaskList]()
    private let viewIndicator = UIActivityIndicatorView(style: .medium)

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "My List"
        self.navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.greyscale800]
        self.tabBarController?.tabBar.isHidden = true
        viewIndicator.tintColor = .primary900
        viewIndicator.hidesWhenStopped = true
        viewIndicator.translatesAutoresizingMaskIntoConstraints = false
        self.tableView.addSubview(viewIndicator)
        viewIndicator.centerXAnchor.constraint(equalTo: self.tableView.centerXAnchor).isActive = true
        viewIndicator.centerYAnchor.constraint(equalTo: self.tableView.centerYAnchor).isActive = true
        vm.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        viewIndicator.startAnimating()
        vm.getAllTaskList()
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TaskListCell", for: indexPath) as! TaskListTableViewCell
        cell.taskListItem = list[indexPath.row]
        return cell
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension TaskListTableViewController: TaskListViewModelDelegate {
    func getTaskListSuccessHandle(list: [TaskList]) {
        self.list = list
        if self.list.isEmpty {
            viewIndicator.stopAnimating()
            self.tableView.createViewWhenEmptyData(title: "No Todo List, please create new list to add new todo")
        } else {
            self.tableView.backgroundView = nil
            viewIndicator.stopAnimating()
            self.tableView.reloadData()
        }
    }
}
