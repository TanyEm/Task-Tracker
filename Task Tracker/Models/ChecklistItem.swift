//
//  TaskStorageManager.swift
//  Task Tracker
//
//  Created by Tatiana Podlesnykh on 9.12.2020.
//

import Foundation


class ChecklistItem {
    var text = ""
    var checked = false
    
    func toggleChecked() {
      checked = !checked
    }
}
