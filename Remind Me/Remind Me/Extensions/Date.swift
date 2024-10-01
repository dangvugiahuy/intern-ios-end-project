//
//  Date.swift
//  Remind Me
//
//  Created by Huy Gia on 1/10/24.
//

import Foundation

extension Date {
    static func dateToString(date: TimeInterval) -> String {
        var dateShowType: DateShowType = .Other("")
        let dateFromInterval = Date(timeIntervalSinceNow: date)
        if Calendar.current.isDateInToday(dateFromInterval) {
            dateShowType = .Today
        } else if Calendar.current.isDateInYesterday(dateFromInterval) {
            dateShowType = .Yesterday
        } else if Calendar.current.isDateInTomorrow(dateFromInterval) {
            dateShowType = .Tomorrow
        } else {
            dateShowType = .Other(DateFormatter().formated(from: dateFromInterval, with: "EEEE, MMMM d, yyyy"))
        }
        return dateShowType.dateStringFormat()
    }
}
