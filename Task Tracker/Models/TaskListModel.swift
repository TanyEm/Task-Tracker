//
//  TaskListModel.swift
//  Task Tracker
//
//  Created by Tatiana Podlesnykh on 8.12.2020.
//

import Foundation
import UserNotifications

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
    
    func scheduleNotification() {
      removeNotification()
      if shouldRemind && dueDate > Date() {
        let content = UNMutableNotificationContent()
        content.title = "Reminder:"
        content.body = text
        content.sound = UNNotificationSound.default
        
        let calendar = Calendar(identifier: .gregorian)
        let components = calendar.dateComponents([.month, .day, .hour, .minute], from: dueDate)
        let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: false)
        let request = UNNotificationRequest(identifier: "\(String(describing: taskID))", content: content, trigger: trigger)
        let center = UNUserNotificationCenter.current()
        center.add(request)
      }
    }
    
    func removeNotification() {
        let center = UNUserNotificationCenter.current()
        center.removePendingNotificationRequests(withIdentifiers: ["\(String(describing: taskID))"])
    }
}
