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
    private var isUserChangeAvt: Bool?
    private var feeds: [Feed] = [Feed]()
    
    @IBOutlet weak var sortButton: UIBarButtonItem!
    @IBOutlet weak var feedTableView: UITableView!
    @IBOutlet weak var userAvtImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        isUserChangeAvt = UserDefaults.standard.bool(forKey: "UserChangeAvt")
        if let isUserChangeAvt = self.isUserChangeAvt {
            if isUserChangeAvt {
                userAvtImageView.loadImageFromURL(profileVm.getUserPhotoURL())
                UserDefaults.standard.set(false, forKey: "UserChangeAvt")
            }
        }
    }
    
    override func setupFirstLoadVC() {
        self.title = "Feed"
        userAvtImageView.setupAvtImage()
        vm.delegate = self
        vm.getAllFeed()
        sortButton.menu = sortMenu()
        userAvtImageView.loadImageFromURL(profileVm.getUserPhotoURL())
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
    
    func addnewFeedSuccess(feed: Feed) {
        feeds.insert(feed, at: 0)
        feedTableView.beginUpdates()
        let indexPath = IndexPath(row: 0, section: 0)
        feedTableView.insertRows(at: [indexPath], with: .automatic)
        feedTableView.endUpdates()
    }
    
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
