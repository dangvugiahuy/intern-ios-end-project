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
    
    @IBOutlet weak var sortButton: UIBarButtonItem!
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
        sortButton.menu = sortMenu()
    }
    
    private func sortMenu() -> UIMenu {
        let dateSortMenu = UIMenu(title: "Sort By: Due date", image: UIImage(systemName: "calendar"), options: .singleSelection, children: [
            UIAction(title: "Oldest First", image: UIImage(systemName: "arrow.up"), handler: { [self] _ in
                feeds = vm.sortFeedDate(feeds: feeds, option: .low)
                feedTableView.reloadData()
            }),
            UIAction(title: "Newest First", image: UIImage(systemName: "arrow.down"), handler: { [self] _ in
                feeds = vm.sortFeedDate(feeds: feeds, option: .high)
                feedTableView.reloadData()
            })
        ])
        return UIMenu(options: [], children: [dateSortMenu])
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
    
    func deletePostHandle(cell: UITableViewCell) {
        let actionSheet = UIAlertController.createSimpleAlert(with: "Remind Me", and: "Are you sure to delete this post? This action can't be undone", style: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { [self] _ in
            let indexPath = feedTableView.indexPath(for: cell)
            let feed = feeds[indexPath!.row]
            feeds.remove(at: indexPath!.row)
            feedTableView.beginUpdates()
            feedTableView.deleteRows(at: [indexPath!], with: .automatic)
            feedTableView.endUpdates()
            vm.deleteFeed(feed: feed)
        }))
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        self.present(actionSheet, animated: true)
    }
    
    func update() {
        feedTableView.beginUpdates()
        feedTableView.endUpdates()
    }
    
    func addnewFeedSuccess() {
        vm.getAllFeed()
    }
    
    func getAllFeedSuccess(feeds: [Feed]) {
        self.feeds = feeds
        sortButton.isEnabled = self.feeds.isEmpty ? false : true
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
