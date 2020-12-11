//
//  TaskListModel.swift
//  Task Tracker
//
//  Created by Tatiana Podlesnykh on 8.12.2020.
//

import Foundation

class TaskListItem: NSObject, Codable {
    var text = ""
    var checked = false
    var isPrivate = false
    var dueDate = Date()
    var shouldRemind = false
    var taskID: UUID?
    
    override init() {
        taskID = UUID()
    }
    
    func toggleChecked() {
        checked = !checked
    }
}
