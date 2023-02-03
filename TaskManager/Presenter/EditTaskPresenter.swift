//
//  EditTaskPresenter.swift
//  TaskManager
//
//  Created by grandmaster on 1.2.23..
//

import Foundation

protocol EditTaskPresenterProtocol: AnyObject {
    var view: EditTaskViewControllerProtocol! { get set }
    var model: TaskModelEditable! { get set }
    var delegate: EditTaskPresenterDelegate? { get set }
    
    func getTaskName() -> String?
    func getTaskBody() -> String?
    func createTask(_ task: Task)
}

protocol EditTaskPresenterDelegate: AnyObject {
    func taskCreated(_ task: Task, indexPath: IndexPath?)
}

final class EditTaskPresenter: EditTaskPresenterProtocol {
    
    weak var delegate: EditTaskPresenterDelegate?
    
    weak var view: EditTaskViewControllerProtocol!
    
    var model: TaskModelEditable!
    
    func getTaskName() -> String? {
        model.task?.title
    }
    
    func getTaskBody() -> String? {
        model.task?.body
    }
    
    func createTask(_ task: Task) {
        delegate?.taskCreated(task, indexPath: model.indexPath)
    }
}
