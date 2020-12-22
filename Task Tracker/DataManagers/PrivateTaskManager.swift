//
//  PrivateTaskManager.swift
//  Task Tracker
//
//  Created by Tatiana Podlesnykh on 22.12.2020.
//

import Foundation

class PrivateTaskManager: AbstractTaskManager {
    
    override func isPrivateAccess() -> Bool {
        return true
    }
}
