//
//  TaskListTintColor.swift
//  Remind Me
//
//  Created by huy.dang on 10/1/24.
//

import Foundation

struct TaskListTintColor: Codable {
    let tint: String
    let backgroundTint: String
    
    static func getTaskListTintColor() -> [TaskListTintColor] {
        return [
            TaskListTintColor(tint: "#D22B2B", backgroundTint: "#F1BFBF"),
            TaskListTintColor(tint: "#F28C28", backgroundTint: "#FBDCBE"),
            TaskListTintColor(tint: "#FDDA0D", backgroundTint: "#FEF3B6"),
            TaskListTintColor(tint: "#55847A", backgroundTint: "#CCDAD7"),
            TaskListTintColor(tint: "#4169E1", backgroundTint: "#C6D2F6"),
            TaskListTintColor(tint: "#CF9FFF", backgroundTint: "#F0E2FF"),
            TaskListTintColor(tint: "#6F4E37", backgroundTint: "#D3C9C3")
        ]
    }
}
