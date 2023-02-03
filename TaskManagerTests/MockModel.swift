//
//  MockModel.swift
//  TaskManagerTests
//
//  Created by grandmaster on 3.2.23..
//

import Foundation
@testable import TaskManager

class MockModel: ModelProtocol {
    
    var lists = [List]()
    
    var selectedList: Int
    
    var listCount: Int {
        lists.count
    }
    
    init(numberOfList: Int, numberOfTask: Int) {
        selectedList = 1
        for index in 0..<numberOfList {
            var tasks = [Task]()
            for index in (0..<numberOfTask) {
                let task: Task = .init(title: "MockName:\(index)", body: "Description:\(index)", isDone: false)
                tasks.append(task)
            }
            lists.append(.init(name: "MockName: \(index)", tasks: tasks))
        }
    }
}
