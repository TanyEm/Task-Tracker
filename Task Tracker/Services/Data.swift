//
//  Data.swift
//  Task Tracker
//
//  Created by Tatiana Podlesnykh on 22.12.2020.
//

import Foundation

protocol DataManager {
    func setTask(taskItem: TaskListItem)
    func getTask(id: String) throws -> TaskListItem
    func editTask(id: String, taskItem: TaskListItem) throws
    func removeTask(id: String) throws
    func getTasks() -> [TaskListItem]
}

class PrivateTaskManager: DataManager {
    
    var items = [TaskListItem]()
    
    init() {
        loadChecklistItems()
        print("Documents folder is \(documentsDirectory())")
        print("Data file path is \(dataFilePath())")
    }
    
    func setTask(taskItem: TaskListItem) {
        items.append(taskItem)
        saveTasks()
    }
    
    func getTask(id: String) throws -> TaskListItem {
        for item in items {
            if item.taskID?.uuidString == id {
                return item
            }
        }
        throw DataError.taskNotFound(id: id)
    }
    
    func editTask(id: String, taskItem: TaskListItem) throws {
        var idxToChange = -1
        for (idx, el) in items.enumerated() {
            if el.taskID?.uuidString == id {
                idxToChange = idx
                break
            }
        }
        
        if idxToChange < 0 {
            throw DataError.taskNotFound(id: id)
        }
        
        items[idxToChange] = taskItem
        saveTasks()
    }
    
    func removeTask(id: String) throws {
        var idxToRemove = -1
        for (idx, el) in items.enumerated() {
            if el.taskID?.uuidString == id {
                idxToRemove = idx
                break
            }
        }
        
        if idxToRemove < 0 {
            throw DataError.taskNotFound(id: id)
        }
        
        items.remove(at: idxToRemove)
        saveTasks()
    }
    
    func getTasks() -> [TaskListItem] {
        return items
    }
    
    private func documentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    private func dataFilePath() -> URL {
        return documentsDirectory().appendingPathComponent("TaskListItem.plist")
    }
    
    private func saveTasks() {
        let encoder = PropertyListEncoder()
        do {
            let data = try encoder.encode(items)
            try data.write(to: dataFilePath(), options: Data.WritingOptions.atomic)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    private func loadChecklistItems() {
        let path = dataFilePath()
        if let data = try? Data(contentsOf: path) {
            let decoder = PropertyListDecoder()
            do {
                items = try decoder.decode([TaskListItem].self,from: data)
            } catch {
                print(error.localizedDescription)
            }
        }
    }
}

class GuestTaskManager: PrivateTaskManager {
    
    override func getTasks() -> [TaskListItem] {
        return items.filter({!$0.isPrivate})
    }
}
