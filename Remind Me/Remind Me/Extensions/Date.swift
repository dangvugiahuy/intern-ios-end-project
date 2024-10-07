//
//  Date.swift
//  Remind Me
//
//  Created by Huy Gia on 1/10/24.
//

import Foundation

extension Date {
    
    static func dateToString(date: TimeInterval, format: String) -> String {
        var dateShowType: DateShowType = .Other("")
        let dateFromInterval = Date(timeIntervalSince1970: date)
        if Calendar.current.isDateInToday(dateFromInterval) {
            dateShowType = .Today
        } else if Calendar.current.isDateInYesterday(dateFromInterval) {
            dateShowType = .Yesterday
        } else if Calendar.current.isDateInTomorrow(dateFromInterval) {
            dateShowType = .Tomorrow
        } else {
            dateShowType = .Other(DateFormatter().formated(from: dateFromInterval, with: format))
        }
        return dateShowType.dateStringFormat()
    }
    
    func dateToTimeInterVal() -> TimeInterval {
        let dateComp = Calendar.current.dateComponents([.day, .month, .year], from: self)
        let result = Calendar.current.date(from: dateComp)
        return result!.timeIntervalSince1970
    }
    
    func timeToTimeInterVal() -> TimeInterval {
        let timeComp = Calendar.current.dateComponents([.hour, .minute], from: self)
        let result = Calendar.current.date(from: timeComp)
        return result!.timeIntervalSince1970
    }
    
    static func merge(from date: TimeInterval, and time: TimeInterval) -> DateComponents {
        var dmyComp = Calendar.current.dateComponents([.day, .month, .year], from: Date(timeIntervalSince1970: date))
        let hmComp = Calendar.current.dateComponents([.hour, .minute], from: Date(timeIntervalSince1970: time))
        dmyComp.hour = hmComp.hour
        dmyComp.minute = hmComp.minute
        return dmyComp
    }
}
