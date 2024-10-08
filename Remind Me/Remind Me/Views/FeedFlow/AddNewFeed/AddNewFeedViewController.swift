//
//  AddNewFeedViewController.swift
//  Remind Me
//
//  Created by huy.dang on 10/8/24.
//

import UIKit

class AddNewFeedViewController: BaseViewController {
    
    private let profileVm: ProfileViewModel = ProfileViewModel()

    @IBOutlet weak var feedContentTextView: UITextView!
    @IBOutlet weak var userDisplayNameLabel: UILabel!
    @IBOutlet weak var userAvatarImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        userDisplayNameLabel.text = profileVm.getUserDisplayName()
        userAvatarImageView.loadImageFromURL(profileVm.getUserPhotoURL())
    }
    
    override func setupFirstLoadVC() {
        userAvatarImageView.setupAvtImage()
    }
    
}
