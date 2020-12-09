//
//  TaskStorageManager.swift
//  Task Tracker
//
//  Created by Tatiana Podlesnykh on 9.12.2020.
//

import Foundation

class DataManager {
    
    var items = [TaskListItem]()
    
    func documentsDirectory() -> URL {
      let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
      return paths[0]
    }
    
    func dataFilePath() -> URL {
      return documentsDirectory().appendingPathComponent("TaskListItem.plist")
    }
}
