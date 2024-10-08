//
//  UNUserNotificationCenter.swift
//  Remind Me
//
//  Created by Huy Gia on 7/10/24.
//

import Foundation
import UIKit

extension UNUserNotificationCenter {
    
    static func checkRequestInNotificationCenter(task: Todo, completion: @escaping (Result<[UNNotificationRequest?], Error>) -> Void) {
        UNUserNotificationCenter.current().getPendingNotificationRequests { requests in
            let request = requests.compactMap {
                return $0.identifier == task.id! ? $0 : nil
            }
            completion(.success(request))
        }
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
