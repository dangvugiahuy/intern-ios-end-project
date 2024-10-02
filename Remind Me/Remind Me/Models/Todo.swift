//
//  Todo.swift
//  Remind Me
//
//  Created by huy.dang on 9/25/24.
//

import Foundation
import FirebaseFirestore
import UIKit

struct Todo: Codable, Identifiable {
    var id: String?
    var title: String
    var note: String?
    var date: TimeInterval?
    var time: TimeInterval?
    var priority: Int
    var completed: Bool = false
    var taskList: TaskList?
}

enum Priority: Int, CaseIterable {
    case None = 0
    case Low = 1
    case Medium = 2
    case High = 3
    
    static func toString(prior: Int) -> String {
        switch prior {
        case 1:
            return "Low"
        case 2:
            return "Medium"
        case 3:
            return "High"
        default:
            return "None"
        }
    }
    
    static func setColor(prior: Int) -> UIColor {
        switch prior {
        case 1:
            return .primary900
        case 2:
            return .bluescale900
        case 3:
            return .redscale900
        default:
            return .greyscale800
        }
    }
}
