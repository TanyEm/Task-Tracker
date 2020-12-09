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
    
    func toggleChecked() {
      checked = !checked
    }
}
