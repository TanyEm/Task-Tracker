//
//  Task_TrackerDataManagerTests.swift
//  Task TrackerTests
//
//  Created by Tatiana Podlesnykh on 7.12.2020.
//

import XCTest
@testable import Task_Tracker

class Task_TrackerDataManagerTests: XCTestCase {
    
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

    func testCreateTask() throws {
        let dataManager = DataManager()

        let expectedTask = TaskListItem()
        expectedTask.text = "test text"

        dataManager.createTask(taskItem: expectedTask)
        
        let gotTask = try dataManager.getTask(id: expectedTask.taskID!.uuidString)
        
        XCTAssertEqual(expectedTask.taskID!.uuidString, gotTask.taskID!.uuidString)
        XCTAssertEqual(expectedTask.text, gotTask.text)
    }
    
    func testGetTasks() throws {
        let dataManager = DataManager()

        let taskPrivate = TaskListItem()
        taskPrivate.text = "private text"
        taskPrivate.isPrivate = true
        
        let taskPublic = TaskListItem()
        taskPublic.text = "public text"
        taskPublic.isPrivate = false

        dataManager.createTask(taskItem: taskPrivate)
        dataManager.createTask(taskItem: taskPublic)
        
        var gotTasks = dataManager.getTasks(isGuest: false)
        
        XCTAssertEqual(gotTasks.count, 2)
        XCTAssertEqual(gotTasks[0].taskID!.uuidString, taskPrivate.taskID!.uuidString)
        XCTAssertEqual(gotTasks[0].text, taskPrivate.text)
        XCTAssertEqual(gotTasks[1].taskID!.uuidString, taskPublic.taskID!.uuidString)
        XCTAssertEqual(gotTasks[1].text, taskPublic.text)
        
        gotTasks = dataManager.getTasks(isGuest: true)
        
        XCTAssertEqual(gotTasks.count, 1)
        XCTAssertEqual(gotTasks[0].taskID!.uuidString, taskPublic.taskID!.uuidString)
        XCTAssertEqual(gotTasks[0].text, taskPublic.text)
    }
    
    func testEditTask() throws {
        let dataManager = DataManager()

        let taskOriginal = TaskListItem()
        taskOriginal.text = "task text #1"
        
        let taskEdited = TaskListItem()
        taskEdited.text = "Edited text here"

        dataManager.createTask(taskItem: taskOriginal)
        
        try dataManager.editTask(id: taskOriginal.taskID!.uuidString, taskItem: taskEdited)
        
        let gotTask = try dataManager.getTask(id: taskEdited.taskID!.uuidString)
        
        XCTAssertEqual(gotTask.taskID!.uuidString, taskEdited.taskID!.uuidString)
        XCTAssertEqual(gotTask.text, taskEdited.text)
    }
    
    func testRemoveTask() throws {
        let dataManager = DataManager()

        let task1 = TaskListItem()
        task1.text = "task text #1"
        
        let task2 = TaskListItem()
        task2.text = "task text #2"

        dataManager.createTask(taskItem: task1)
        dataManager.createTask(taskItem: task2)
        
        try dataManager.removeTask(id: task1.taskID!.uuidString)
        
        let remainingTasks = dataManager.getTasks(isGuest: false)
        
        XCTAssertEqual(remainingTasks.count, 1)
        XCTAssertEqual(remainingTasks[0].taskID!.uuidString, task2.taskID!.uuidString)
        XCTAssertEqual(remainingTasks[0].text, task2.text)
    }
}
