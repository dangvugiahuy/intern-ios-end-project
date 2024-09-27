//
//  DateFormatter.swift
//  Remind Me
//
//  Created by huy.dang on 9/27/24.
//

import Foundation

extension DateFormatter {
    func formated(from date: Date, with format: String) -> String {
        self.dateFormat = format
        return self.string(from: date)
    }
}
