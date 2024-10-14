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
    
    func sortFeedDate(feeds: [Feed], option: FilterType) -> [Feed] {
        let result = feeds.sorted { feed1, feed2 in
            switch option {
            case .low:
                return feed1.createDate < feed2.createDate
            case .high:
                return feed1.createDate > feed2.createDate
            }
        }
        return result
    }
    
    func deleteFeed(feed: Feed) {
        cloudFireStoreService?.deleteFeed(feed: feed, completion: { [self] result in
            switch result {
            case .success(let feed):
                storageService?.deleteFeedImages(feed: feed, completion: { result in
                    switch result {
                    case .success(_):
                        break
                    case .failure(let failure):
                        print("Delete image error: \(failure.localizedDescription)")
                    }
                })
            case .failure(let failure):
                print("Delete Feed Error: \(failure.localizedDescription)")
            }
        })
    }
}
