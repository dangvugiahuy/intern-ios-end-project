//
//  ProfileViewController.swift
//  Remind Me
//
//  Created by Huy Gia on 14/9/24.
//

import UIKit
import SwiftUI

class ProfileViewController: BaseViewController {
    
    @IBOutlet weak var userAvatarImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupFirstLoadVC()
    }
    
    private func setupFirstLoadVC() {
        self.title = "Profile"
        userAvatarImageView.setupAvtImage()
        self.setupLeftNavigationBarItem()
    }
    
    @IBSegueAction func goToAboutUsView(_ coder: NSCoder) -> UIViewController? {
        let view = AboutUsSwiftUIView()
        return UIHostingController(coder: coder, rootView: view)
    }
    
    @IBAction func changeUserImageSelector(_ sender: Any) {
        
    }
}
