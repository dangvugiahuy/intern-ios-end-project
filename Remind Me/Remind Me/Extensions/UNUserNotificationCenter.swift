//
//  UNUserNotificationCenter.swift
//  Remind Me
//
//  Created by Huy Gia on 7/10/24.
//

import Foundation
import UIKit

extension UNUserNotificationCenter {
    
    static func checkRequestInNotificationCenter(id: String) -> Bool {
        var result: Bool = false
        UNUserNotificationCenter.current().getPendingNotificationRequests { requests in
            for request in requests {
                if request.identifier == id {
                    result = true
                    break
                }
            }
        }
        return result
    }
    
    static func addNewScheduleTaskToNotification(task: Todo) {
        let enableNotification = UserDefaults.standard.bool(forKey: "enableNotification")
        if let date = task.date, let time = task.time {
            if enableNotification {
                let content = UNMutableNotificationContent()
                content.title = "Remind Me"
                content.body = task.title
                content.sound = UNNotificationSound.default
                let trigger = UNCalendarNotificationTrigger(dateMatching: Date.merge(from: date, and: time), repeats: false)
                let request = UNNotificationRequest(identifier: task.id!, content: content, trigger: trigger)
                UNUserNotificationCenter.current().add(request)
            }
        }
    }
    
    static func removeScheduleTaskFromNotification(id: String) {
        let enableNotification = UserDefaults.standard.bool(forKey: "enableNotification")
        if enableNotification {
            UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [id])
        }
    }
}
