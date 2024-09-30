//
//  TaskList.swift
//  Remind Me
//
//  Created by huy.dang on 9/25/24.
//

import Foundation
import FirebaseFirestore

struct TaskList: Codable, Identifiable {
    var id: String?
    var name: String
    var tintColor: String
}
