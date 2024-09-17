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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = false
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
        let actionSheet = UIAlertController(title: "Change account image", message: nil, preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { _ in
            actionSheet.dismiss(animated: true)
        }))
        actionSheet.addAction(UIAlertAction(title: "Take picture", style: .default, handler: { _ in
            
        }))
        actionSheet.addAction(UIAlertAction(title: "Import from gallery", style: .default, handler: { _ in
            
        }))
        actionSheet.view.tintColor = UIColor(named: "Greyscale800")
        self.present(actionSheet, animated: true)
    }
}
