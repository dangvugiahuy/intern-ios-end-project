//
//  FeedViewController.swift
//  Remind Me
//
//  Created by huy.dang on 9/13/24.
//

import UIKit

class FeedViewController: BaseViewController {
    
    private let profileVm: ProfileViewModel = ProfileViewModel()
    
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
