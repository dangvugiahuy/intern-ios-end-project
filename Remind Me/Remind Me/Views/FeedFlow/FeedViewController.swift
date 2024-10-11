//
//  FeedViewController.swift
//  Remind Me
//
//  Created by huy.dang on 9/13/24.
//

import UIKit
import SkeletonView

class FeedViewController: BaseViewController {
    
    private let profileVm: ProfileViewModel = ProfileViewModel()
    private let vm: FeedViewModel = FeedViewModel()
    private var feeds: [Feed] = [Feed]()
    
    @IBOutlet weak var feedTableView: UITableView!
    @IBOutlet weak var userAvtImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        userAvtImageView.showAnimatedGradientSkeleton()
        DispatchQueue.main.async { [self] in
            userAvtImageView.loadImageFromURL(profileVm.getUserPhotoURL())
            userAvtImageView.hideSkeleton()
        }
        if feeds.isEmpty {
            vm.getAllFeed()
        }
    }
    
    override func setupFirstLoadVC() {
        self.title = "Feed"
        userAvtImageView.setupAvtImage()
        vm.delegate = self
    }
    
    @IBAction func addNewFeedButton(_ sender: Any) {
        let rootview = self.storyboard?.instantiateViewController(withIdentifier: "AddNewFeedVC") as! AddNewFeedViewController
        rootview.delegate = self
        let navigateVC = UINavigationController(rootViewController: rootview)
        navigateVC.modalPresentationStyle = .fullScreen
        self.present(navigateVC, animated: true)
    }
}

extension FeedViewController: UITableViewDelegate, UITableViewDataSource, FeedViewModelDelegate, AddNewFeedViewControllerDelegate, FeedTableViewCellDelegate {
    
    func update(at cell: UITableViewCell) {
        let indexPath = feedTableView.indexPath(for: cell)
        feedTableView.reloadRows(at: [indexPath!], with: .automatic)
    }
    
    func addnewFeedSuccess() {
        vm.getAllFeed()
    }
    
    func getAllFeedSuccess(feeds: [Feed]) {
        self.feeds = feeds
        feedTableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return feeds.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = feedTableView.dequeueReusableCell(withIdentifier: "FeedTableCell", for: indexPath) as! FeedTableViewCell
        cell.feed = feeds[indexPath.row]
        cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
