//
//  Task_TrackerDataManagerTests.swift
//  Task TrackerTests
//
//  Created by Tatiana Podlesnykh on 7.12.2020.
//

import XCTest
@testable import Task_Tracker

class Task_TrackerAbstractTaskManagerTests: XCTestCase {

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
        let taskManager = AbstractTaskManager()


        let expectedTask = TaskListItem()
        expectedTask.text = "test text"

        taskManager.createTask(taskItem: expectedTask)
        
        let gotTask = try taskManager.getTask(id: expectedTask.taskID!.uuidString)
        
        XCTAssertEqual(expectedTask.taskID!.uuidString, gotTask.taskID!.uuidString)
        XCTAssertEqual(expectedTask.text, gotTask.text)
    }
    
    func testGetTasks() throws {
        let taskManager = AbstractTaskManager()


        let taskPrivate = TaskListItem()
        taskPrivate.text = "private text"
        taskPrivate.isPrivate = true
        
        let taskPublic = TaskListItem()
        taskPublic.text = "public text"
        taskPublic.isPrivate = false

        taskManager.createTask(taskItem: taskPrivate)
        taskManager.createTask(taskItem: taskPublic)
        
        let gotTasks = taskManager.getTasks()
        
        XCTAssertEqual(gotTasks.count, 2)
        XCTAssertEqual(gotTasks[0].taskID!.uuidString, taskPrivate.taskID!.uuidString)
        XCTAssertEqual(gotTasks[0].text, taskPrivate.text)
        XCTAssertEqual(gotTasks[1].taskID!.uuidString, taskPublic.taskID!.uuidString)
        XCTAssertEqual(gotTasks[1].text, taskPublic.text)
    }
    
    func testEditTask() throws {
        let taskManager = AbstractTaskManager()

        let taskOriginal = TaskListItem()
        taskOriginal.text = "task text #1"
        
        let taskEdited = TaskListItem()
        taskEdited.text = "Edited text here"

        taskManager.createTask(taskItem: taskOriginal)
        
        try taskManager.editTask(id: taskOriginal.taskID!.uuidString, taskItem: taskEdited)
        
        let gotTask = try taskManager.getTask(id: taskEdited.taskID!.uuidString)
        
        XCTAssertEqual(gotTask.taskID!.uuidString, taskEdited.taskID!.uuidString)
        XCTAssertEqual(gotTask.text, taskEdited.text)
    }
    
    func testRemoveTask() throws {
        let taskManager = AbstractTaskManager()

        let task1 = TaskListItem()
        task1.text = "task text #1"
        
        let task2 = TaskListItem()
        task2.text = "task text #2"

        taskManager.createTask(taskItem: task1)
        taskManager.createTask(taskItem: task2)
        
        try taskManager.removeTask(id: task1.taskID!.uuidString)
        
        let remainingTasks = taskManager.getTasks()
        
        XCTAssertEqual(remainingTasks.count, 1)
        XCTAssertEqual(remainingTasks[0].taskID!.uuidString, task2.taskID!.uuidString)
        XCTAssertEqual(remainingTasks[0].text, task2.text)
    }
}
