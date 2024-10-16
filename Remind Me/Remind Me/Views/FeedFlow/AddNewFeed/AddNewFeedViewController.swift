//
//  AddNewFeedViewController.swift
//  Remind Me
//
//  Created by huy.dang on 10/8/24.
//

import UIKit
import Photos
import PhotosUI

protocol AddNewFeedViewControllerDelegate: AnyObject {
    func addnewFeedSuccess(feed: Feed)
}

class AddNewFeedViewController: BaseViewController {
    
    private let profileVm: ProfileViewModel = ProfileViewModel()
    private let vm: AddNewFeedViewModel = AddNewFeedViewModel()
    weak var delegate: AddNewFeedViewControllerDelegate?
    private var content: String = ""
    private var images: [UIImage] = [UIImage]()
    private var date: TimeInterval?
    private var feed: Feed?
    @IBOutlet weak var postFeedButton: UIBarButtonItem!
    @IBOutlet weak var loadingView: UIView!
    @IBOutlet weak var backButton: UIBarButtonItem!
    @IBOutlet weak var uploadFeedProgress: UIProgressView!
    @IBOutlet weak var feedCreateDatePicker: UIDatePicker!
    @IBOutlet weak var addNewFeedContentTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        postFeedButton.isEnabled = true
        backButton.isEnabled = true
    }
    
    override func setupFirstLoadVC() {
        postFeedButton.isEnabled = false
        vm.delegate = self
        date = feedCreateDatePicker.date.dateToTimeInterVal()
        loadingView.isHidden = true
    }
    
    @IBAction func postFeedButtonClicked(_ sender: UIBarButtonItem) {
        let id = UUID().uuidString
        let imagesURL: [String] = images.map {_ in
            return UUID().uuidString
        }
        let feed = self.images.isEmpty == false ? Feed(id: id, content: self.content, imagesURL: imagesURL, createDate: self.date!) : Feed(id: id, content: self.content, createDate: self.date!)
        self.feed = feed
        vm.addNewFeed(from: feed, with: images)
        postFeedButton.isEnabled = false
        backButton.isEnabled = false
        UIView.animate(withDuration: 0.35) { [self] in
            loadingView.isHidden = false
            loadingView.alpha = 1
        }
    }
    
    @IBAction func chooseImageButtonClicked(_ sender: Any) {
        var config: PHPickerConfiguration = PHPickerConfiguration(photoLibrary: .shared())
        config.filter = .images
        config.selectionLimit = 5
        let picker: PHPickerViewController = PHPickerViewController(configuration: config)
        picker.delegate = self
        self.present(picker, animated: true)
    }
    
    @IBAction func backButtonClicked(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func createDatePickerValueChange(_ sender: Any) {
        date = feedCreateDatePicker.date.dateToTimeInterVal()
    }
}

extension AddNewFeedViewController: UITableViewDelegate, UITableViewDataSource, AddFeedContentTableViewCellDelegate, PHPickerViewControllerDelegate, AddNewFeedViewModelDelegate, AddFeedImageTableViewCellDelegate {
    
    func uploadImageProgressHandle(progress: Float) {
        let tempProgress = uploadFeedProgress.progress + progress
        uploadFeedProgress.setProgress(tempProgress, animated: true)
        if uploadFeedProgress.progress >= 1 {
            self.dismiss(animated: true)
            delegate?.addnewFeedSuccess(feed: self.feed!)
        }
    }
    
    func discardImage() {
        self.images = []
        addNewFeedContentTableView.reloadData()
    }
    
    func addFeedWithoutImageHandle() {
        uploadFeedProgress.setProgress(1, animated: true)
        if uploadFeedProgress.progress == 1 {
            self.dismiss(animated: true)
            delegate?.addnewFeedSuccess(feed: self.feed!)
        }
    }
    
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true, completion: nil)
        if self.images.isEmpty == false {
            self.images.removeAll()
        }
        results.forEach { result in
            result.itemProvider.loadObject(ofClass: UIImage.self) { reading, error in
                guard let image = reading as? UIImage, error == nil else { return }
                self.images.append(image)
                DispatchQueue.main.async { [self] in
                    if self.images.count == results.count {
                        addNewFeedContentTableView.reloadData()
                    }
                }
            }
        }
    }
    
    func updateCellHeight(_ cell: AddFeedContentTableViewCell, _ textView: UITextView) {
        content = textView.text
        postFeedButton.isEnabled = content != "" ? true : false
        let size = textView.bounds.size
        let newSize = addNewFeedContentTableView.sizeThatFits(CGSize(width: cell.bounds.size.width, height: CGFloat.greatestFiniteMagnitude))
        if size.height != newSize.height {
            UIView.setAnimationsEnabled(false)
            addNewFeedContentTableView?.beginUpdates()
            addNewFeedContentTableView?.endUpdates()
            UIView.setAnimationsEnabled(true)
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = UITableViewCell()
        switch indexPath.row {
        case 0:
            let cellUserInfo = addNewFeedContentTableView.dequeueReusableCell(withIdentifier: "AddFeedUserInfoCell", for: indexPath) as! AddFeedUserInfoTableViewCell
            cellUserInfo.userDisplayNameLabel.text = profileVm.getUserDisplayName()
            cellUserInfo.userAvtImageView.loadImageFromURL(profileVm.getUserPhotoURL())
            cell = cellUserInfo
        case 1:
            let cellFeedContent = addNewFeedContentTableView.dequeueReusableCell(withIdentifier: "AddFeedContentCell", for: indexPath) as! AddFeedContentTableViewCell
            cellFeedContent.delegate = self
            cell = cellFeedContent
        case 2:
            let cellFeedImage = addNewFeedContentTableView.dequeueReusableCell(withIdentifier: "AddFeedImageCell", for: indexPath) as! AddFeedImageTableViewCell
            cellFeedImage.images = self.images
            cellFeedImage.delegate = self
            cell = cellFeedImage
        default:
            break
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
