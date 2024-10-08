//
//  AddNewFeedViewController.swift
//  Remind Me
//
//  Created by huy.dang on 10/8/24.
//

import UIKit

class AddNewFeedViewController: BaseViewController {
    
    private let profileVm: ProfileViewModel = ProfileViewModel()
    @IBOutlet weak var addNewFeedContentTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

    }
    
    override func setupFirstLoadVC() {
        
    }
}

extension AddNewFeedViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = UITableViewCell()
        switch indexPath.row {
        case 0:
            cell = addNewFeedContentTableView.dequeueReusableCell(withIdentifier: "AddFeedUserInfoCell", for: indexPath)
        case 1:
            cell = addNewFeedContentTableView.dequeueReusableCell(withIdentifier: "AddFeedContentCell", for: indexPath)
        case 2:
            cell = addNewFeedContentTableView.dequeueReusableCell(withIdentifier: "AddFeedImageCell", for: indexPath)
        default:
            break
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
