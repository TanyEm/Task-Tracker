//
//  Task_TrackerPrivateTaskManagerTests.swift
//  Task TrackerTests
//
//  Created by Tatiana Podlesnykh on 23.12.2020.
//

import XCTest
@testable import Task_Tracker

class Task_TrackerPrivateTaskManagerTests: XCTestCase {

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
    
    func testIsPrivateAccess() throws {
        let taskManager = PrivateTaskManager()
        
        XCTAssertTrue(taskManager.isPrivateAccess())
    }
}
