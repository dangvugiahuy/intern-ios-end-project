//
//  Feed.swift
//  Remind Me
//
//  Created by huy.dang on 10/9/24.
//

import Foundation
import FirebaseFirestore

struct Feed: Codable, Identifiable {
    var id: String?
    var content: String
    var imageURL: String?
    var createDate: TimeInterval
}
