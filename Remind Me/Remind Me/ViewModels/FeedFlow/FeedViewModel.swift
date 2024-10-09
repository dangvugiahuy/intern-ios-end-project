//
//  FeedViewModel.swift
//  Remind Me
//
//  Created by huy.dang on 10/9/24.
//

import Foundation
import FirebaseAuth
import UIKit

final class FeedViewModel {
    
    private var user: User?
    private var cloudFireStoreService: CloudFirestoreService?
    private var storageService: StorageService?
    
    init() {
        user = Auth.auth().currentUser
        if let user = self.user {
            cloudFireStoreService = CloudFirestoreService(user: user)
            storageService = StorageService(user: user)
        }
    }
}
