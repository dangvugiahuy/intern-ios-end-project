//
//  FeedViewController.swift
//  Remind Me
//
//  Created by huy.dang on 9/13/24.
//

import UIKit

class FeedViewController: BaseViewController {
    
    private let profileVm: ProfileViewModel = ProfileViewModel()
    private var feeds: [Feed] = [Feed]()
    
    @IBOutlet weak var feedTableView: UITableView!
    @IBOutlet weak var userAvtImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        userAvtImageView.loadImageFromURL(profileVm.getUserPhotoURL())
    }
    
    override func setupFirstLoadVC() {
        self.title = "Feed"
        userAvtImageView.setupAvtImage()
    }
}

extension FeedViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return feeds.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = feedTableView.dequeueReusableCell(withIdentifier: "FeedTableCell", for: indexPath) as! FeedTableViewCell
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
