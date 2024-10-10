//
//  FeedViewModel.swift
//  Remind Me
//
//  Created by huy.dang on 10/9/24.
//

import Foundation
import FirebaseAuth
import UIKit

protocol FeedViewModelDelegate: AnyObject {
    func getAllFeedSuccess(feeds: [Feed])
}

final class FeedViewModel {
    
    private var user: User?
    private var cloudFireStoreService: CloudFirestoreService?
    private var storageService: StorageService?
    weak var delegate: FeedViewModelDelegate?
    
    init() {
        user = Auth.auth().currentUser
        if let user = self.user {
            cloudFireStoreService = CloudFirestoreService(user: user)
            storageService = StorageService(user: user)
        }
    }
    
    func getAllFeed() {
        cloudFireStoreService?.fetchFeeds(completion: { [self] result in
            switch result {
            case .success(let model):
                delegate?.getAllFeedSuccess(feeds: model)
            case .failure(let failure):
                print("Read Data Error: \(failure.localizedDescription)")
            }
        })
    }
}
