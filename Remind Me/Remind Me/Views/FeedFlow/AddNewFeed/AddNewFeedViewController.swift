//
//  AddNewFeedViewController.swift
//  Remind Me
//
//  Created by huy.dang on 10/8/24.
//

import UIKit
import PhotosUI

class AddNewFeedViewController: BaseViewController {
    
    private let profileVm: ProfileViewModel = ProfileViewModel()
    private let vm: AddNewFeedViewModel = AddNewFeedViewModel()
    private var content: String = ""
    private var image: UIImage?
    private var date: TimeInterval?
    @IBOutlet weak var postFeedButton: UIBarButtonItem!
    @IBOutlet weak var uploadFeedProgress: UIProgressView!
    @IBOutlet weak var feedCreateDatePicker: UIDatePicker!
    @IBOutlet weak var addNewFeedContentTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        addNewFeedContentTableView.reloadData()
    }
    
    override func setupFirstLoadVC() {
        postFeedButton.isEnabled = false
        vm.delegate = self
        date = feedCreateDatePicker.date.dateToTimeInterVal()
    }
    
    @IBAction func postFeedButtonClicked(_ sender: UIBarButtonItem) {
        let id = UUID().uuidString
        let feed = self.image != nil ? Feed(id: id, content: self.content, imageURL: "\(id).jpg", createDate: self.date!) : Feed(id: id, content: self.content, createDate: self.date!)
        vm.addNewFeed(from: feed, with: image)
    }
    
    @IBAction func chooseImageButtonClicked(_ sender: Any) {
        var config: PHPickerConfiguration = PHPickerConfiguration(photoLibrary: .shared())
        config.filter = .images
        config.selectionLimit = 1
        let picker: PHPickerViewController = PHPickerViewController(configuration: config)
        picker.delegate = self
        self.present(picker, animated: true)
    }
    
    @IBAction func backButtonClicked(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}

extension AddNewFeedViewController: UITableViewDelegate, UITableViewDataSource, AddFeedContentTableViewCellDelegate, PHPickerViewControllerDelegate, AddNewFeedViewModelDelegate {
    
    func uploadImageProgressHandle(progress: Float) {
        uploadFeedProgress.progress = progress
        if uploadFeedProgress.progress == 1 {
            print("upload success!")
        }
    }
    
    func addFeedWithoutImageHandle() {
        uploadFeedProgress.progress = 1
        self.dismiss(animated: true)
    }
    
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true, completion: nil)
        results.forEach { result in
            result.itemProvider.loadObject(ofClass: UIImage.self) { reading, error in
                guard let image = reading as? UIImage, error == nil else { return }
                self.image = image
                DispatchQueue.main.async { [self] in
                    if self.image != nil {
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
            cellFeedImage.image = self.image
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
