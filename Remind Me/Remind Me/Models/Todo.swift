//
//  Todo.swift
//  Remind Me
//
//  Created by huy.dang on 9/25/24.
//

import Foundation
import FirebaseFirestore

struct Todo: Codable, Identifiable {
    @DocumentID var id: String?
    var title: String
    var note: String?
    var date: TimeInterval?
    var time: TimeInterval?
    var priority: Int
    var completed: Bool = false
}

enum Priority: Int, CaseIterable {
    case None = 0
    case Low = 1
    case Medium = 2
    case High = 3
}
