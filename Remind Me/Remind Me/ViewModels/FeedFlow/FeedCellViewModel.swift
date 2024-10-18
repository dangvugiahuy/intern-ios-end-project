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
    func returnImages(images: [UIImage])
    func returnImage(image: UIImage)
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
    
    func getImages(from feed: Feed) {
        if let imagesURL = feed.imagesURL {
            var images: [UIImage] = [UIImage]()
            for url in imagesURL {
                storageService?.fetchImage(path: "\(feed.id!)/\(url).jpg", completion: { [self] result in
                    switch result {
                    case .success(let image):
                        images.append(image)
                        if images.count == feed.imagesURL?.count {
                            delegate?.returnImages(images: images)
                        }
                    case .failure(let failure):
                        print("fetch Image Fail: \(failure.localizedDescription)")
                    }
                })
            }
        }
    }
    
    func getImage(from feed: Feed) {
        if let url = feed.imagesURL?[0] {
            storageService?.fetchImage(path: "\(feed.id!)/\(url).jpg", completion: { [self] result in
                switch result {
                case .success(let image):
                    delegate?.returnImage(image: image)
                case .failure(let failure):
                    print("fetch Image Fail: \(failure.localizedDescription)")
                }
            })
        }
    }
}
