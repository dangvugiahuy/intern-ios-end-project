//
//  DateShowType.swift
//  Remind Me
//
//  Created by huy.dang on 9/27/24.
//

import Foundation

enum DateShowType {
    case Today
    case Yesterday
    case Tomorrow
    case Other(String)
    
    func dateStringFormat() -> String {
        switch self {
        case .Today:
            return "Today"
        case .Yesterday:
            return "Yesterday"
        case .Tomorrow:
            return "Tomorrow"
        case .Other(let string):
            return string
        }
    }
}
