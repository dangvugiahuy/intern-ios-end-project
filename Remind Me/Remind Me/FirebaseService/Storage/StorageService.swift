//
//  StorageService.swift
//  Remind Me
//
//  Created by huy.dang on 10/9/24.
//

import Foundation
import FirebaseAuth
import FirebaseStorage
import UIKit

final class StorageService {
    
    private let storage = Storage.storage()
    private let user: User
    private var primaryPath: String = ""
    
    init(user: User) {
        self.user = user
        self.primaryPath = "users/\(user.uid)/"
    }
    
    func uploadImage(from image: UIImage, with path: String, completion: @escaping (Result<Any, Error>) -> Void) {
        let ref = storage.reference(withPath: primaryPath + path)
        guard let imgData = image.jpegData(compressionQuality: 0.75) else { return }
        let uploadMetaData = StorageMetadata.init()
        uploadMetaData.contentType = "image/jpeg"
        
        ref.putData(imgData, metadata: uploadMetaData) { metaData, error in
            guard error == nil else {
                completion(.failure(error!))
                return
            }
            completion(.success("Upload Success!!"))
        }
    }
    
    func fetchImage(path: String, completion: @escaping (Result<UIImage, Error>) -> Void) {
        let ref = storage.reference(withPath: primaryPath + path)
        ref.getData(maxSize: 4 * 1024 * 1024) { result in
            switch result {
            case .success(let data):
                completion(.success(UIImage(data: data)!))
            case .failure(let failure):
                completion(.failure(failure))
            }
        }
    }
    
    func deleteFeedImages(feed: Feed, completion: @escaping (Result<Any, Error>) -> Void) {
        let ref = storage.reference(withPath: primaryPath + "\(feed.id!)")
        ref.listAll { result in
            switch result {
            case .success(let storeResult):
                for item in storeResult.items {
                    item.delete { error in
                        guard error == nil else {
                            completion(.failure(error!))
                            return
                        }
                    }
                }
                completion(.success("Delete Successs"))
            case .failure( let failure):
                completion(.failure(failure))
            }
        }
    }
}
