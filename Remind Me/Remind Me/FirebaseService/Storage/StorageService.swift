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
    
    func uploadImage(from image: UIImage, with imageName: String, completion: @escaping (Result<Float, Error>) -> Void) {
        let ref = storage.reference(withPath: primaryPath + imageName)
        guard let imgData = image.jpegData(compressionQuality: 0.75) else { return }
        let uploadMetaData = StorageMetadata.init()
        uploadMetaData.contentType = "image/jpeg"
        
        let taskRef = ref.putData(imgData, metadata: uploadMetaData) { metaData, error in
            guard error == nil else {
                completion(.failure(error!))
                return
            }
        }
        
        taskRef.observe(.progress) { snapShot in
            guard let snapProgress = snapShot.progress?.fractionCompleted else { return }
            completion(.success(Float(snapProgress)))
        }
    }
}
