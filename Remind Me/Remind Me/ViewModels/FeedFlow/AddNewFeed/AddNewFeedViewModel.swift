//
//  AddNewFeedViewModel.swift
//  Remind Me
//
//  Created by huy.dang on 10/9/24.
//

import Foundation
import FirebaseAuth
import UIKit

protocol AddNewFeedViewModelDelegate: AnyObject {
    func uploadImageProgressHandle(progress: Float)
    func addFeedWithoutImageHandle()
}

final class AddNewFeedViewModel {
    
    private var user: User?
    private var cloudFireStoreService: CloudFirestoreService?
    private var storageService: StorageService?
    weak var delegate: AddNewFeedViewModelDelegate?
    
    init() {
        user = Auth.auth().currentUser
        if let user = self.user {
            cloudFireStoreService = CloudFirestoreService(user: user)
            storageService = StorageService(user: user)
        }
    }
    
    func addNewFeed(from feed: Feed, with image: UIImage?) {
        cloudFireStoreService?.addNewFeed(from: feed, completion: { [self] result in
            switch result {
            case .success(let imagePath):
                if imagePath != "" {
                    if let image = image {
                        storageService?.uploadImage(from: image, with: imagePath, completion: { [self] result in
                            switch result {
                            case .success(let progress):
                                delegate?.uploadImageProgressHandle(progress: progress)
                            case .failure(let failure):
                                print("Upload Image Error: \(failure.localizedDescription)")
                            }
                        })
                    }
                } else {
                    delegate?.addFeedWithoutImageHandle()
                }
            case .failure(let failure):
                print("Write data Error: \(failure.localizedDescription)")
            }
        })
    }
}
