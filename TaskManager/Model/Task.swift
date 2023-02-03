//
//  Task.swift
//  TaskManager
//
//  Created by grandmaster on 1.2.23..
//

import Foundation

struct Task: Codable {
    var title: String?
    var body: String?
    var isDone: Bool = false
}

extension Task {
    static var mock: Self {
        .init(title: "Test Task", body: "some description", isDone: true)
    }
}
