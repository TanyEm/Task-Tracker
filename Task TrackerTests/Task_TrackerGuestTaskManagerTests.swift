//
//  Task_TrackerGuestTaskManagerTests.swift
//  Task TrackerTests
//
//  Created by Tatiana Podlesnykh on 23.12.2020.
//

import XCTest
@testable import Task_Tracker

class Task_TrackerGuestTaskManagerTests: XCTestCase {

    private func documentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    // Rewrite data document with an empty array
    private func EraseDataDocument() throws {
        let path = documentsDirectory().appendingPathComponent("TaskListItem.plist")
        let encoder = PropertyListEncoder()
        do {
            let data = try encoder.encode([TaskListItem]())
            try data.write(to: path, options: Data.WritingOptions.atomic)
        } catch {
            throw error
        }
    }

    override func setUpWithError() throws {
        // erase data document before each test
        try EraseDataDocument()
    }

    override func tearDownWithError() throws {
        // erase data document after each test
        try EraseDataDocument()
    }
    
    func testGetTasks() throws {
        let taskManager = GuestTaskManager()

        let taskPrivate = TaskListItem()
        taskPrivate.text = "private text"
        taskPrivate.isPrivate = true
        
        let taskPublic = TaskListItem()
        taskPublic.text = "public text"
        taskPublic.isPrivate = false

        taskManager.createTask(taskItem: taskPrivate)
        taskManager.createTask(taskItem: taskPublic)
        
        let gotTasks = taskManager.getTasks()
        
        XCTAssertEqual(gotTasks.count, 1)
        XCTAssertEqual(gotTasks[0].taskID!.uuidString, taskPublic.taskID!.uuidString)
        XCTAssertEqual(gotTasks[0].text, taskPublic.text)
    }
    
    func testIsPrivateAccess() throws {
        let taskManager = GuestTaskManager()
        
        XCTAssertFalse(taskManager.isPrivateAccess())
    }
}
