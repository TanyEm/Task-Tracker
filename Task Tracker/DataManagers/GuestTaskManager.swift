//
//  GuestTaskManager.swift
//  Task Tracker
//
//  Created by Tatiana Podlesnykh on 22.12.2020.
//

import Foundation

class GuestTaskManager: AbstractTaskManager {
    
    override func isPrivateAccess() -> Bool {
        return false
    }
    
    override func getTasks() -> [TaskListItem] {
        return items.filter({!$0.isPrivate})
    }
}
