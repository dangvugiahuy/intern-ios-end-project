//
//  FeedCellViewModel.swift
//  Remind Me
//
//  Created by huy.dang on 10/10/24.
//

import Foundation
import FirebaseAuth
import UIKit

protocol FeedCellViewModelDelegate: AnyObject {
    func setImage(image: UIImage)
}

final class FeedCellViewModel {
    
    private var user: User?
    private var storageService: StorageService?
    weak var delegate: FeedCellViewModelDelegate?
    
    init() {
        user = Auth.auth().currentUser
        if let user = self.user {
            storageService = StorageService(user: user)
        }
    }
    
    func getImage(imageURL: String) {
        storageService?.fetchImage(imageName: imageURL, completion: { [self] result in
            switch result {
            case .success(let image):
                delegate?.setImage(image: image)
            case .failure(let failure):
                print("fetch Image Fail")
            }
        })
    }
}
