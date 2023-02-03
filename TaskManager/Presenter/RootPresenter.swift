//
//  RootPresenter.swift
//  TaskManager
//
//  Created by grandmaster on 1.2.23..
//

import Foundation

protocol RootPresenterProtocol: AnyObject {
    var model: ModelProtocol! { get set }
    var view: RootViewControllerProtocol! { get set }
    
    var isEmptyList: Bool { get }
    var currentListName: String? { get }
    func renameList(_ name: String)
    func removeList()
    func removeTask(for indexPath: IndexPath)
    
    var tableViewNumberOfRow: Int { get }
    func tableViewDataSource(_ indexPath: IndexPath) -> Task
    func selectList(_ indexPath: IndexPath)
    
    func collectionViewDataSource(_ indexPath: IndexPath) -> List
    var collectionViewNumberOfRow: Int { get }
    
    func addNewListWith(_ name: String)
    func isCurrentList(for indexPath: IndexPath) -> Bool
    func addTask()
    func getEditTaskViewController(presentetionType: EditTaskVCType, for indexPath: IndexPath?) -> EditTaskViewController
}

final class RootPresenter: RootPresenterProtocol {
    
    var model: ModelProtocol!
    let builder = Builder()
    weak var view: RootViewControllerProtocol!
    
    var isEmptyList: Bool {
        return model.lists.isEmpty
    }
    
    func isCurrentList(for indexPath: IndexPath) -> Bool {
        model.selectedList == indexPath.item
    }
    
    var currentListName: String? {
        isEmptyList ? nil : model.lists[model.selectedList].name
    }
    
    func tableViewDataSource(_ indexPath: IndexPath) -> Task {
        model.lists[model.selectedList].tasks[indexPath.row]
    }
    
    var tableViewNumberOfRow: Int {
        isEmptyList ? 0 : model.lists[model.selectedList].tasksCount
    }
    
    var collectionViewNumberOfRow: Int {
        model.listCount
    }
    
    func collectionViewDataSource(_ indexPath: IndexPath) -> List {
        model.lists[indexPath.item]
    }
    
    func selectList(_ indexPath: IndexPath) {
        model.selectedList = indexPath.item
        view.reloadView()
    }
    
    func addNewListWith(_ name: String) {
        model.lists.append(.init(name: name, tasks: []))
        view.reloadView()
    }
    
    func renameList(_ name: String) {
        model.lists[model.selectedList].name = name
        view.reloadView()
    }
    
    func removeList() {
        model.lists.remove(at: model.selectedList)
        if model.selectedList == model.listCount && model.selectedList > 0 {
            model.selectedList -= 1
        }
        view.reloadView()
    }
    
    func addTask() {
        model.lists[model.selectedList].tasks.append(.mock)
        view.reloadView()
    }
    
    func removeTask(for indexPath: IndexPath) {
        model.lists[model.selectedList].tasks.remove(at: indexPath.row)
        view.reloadView()
    }
    
    func getEditTaskViewController(presentetionType: EditTaskVCType, for indexPath: IndexPath? = nil) -> EditTaskViewController {
        if let indexPath = indexPath {
            let task = model.lists[model.selectedList].tasks[indexPath.row]
            return builder.createEditTaskVC(presentetionType: presentetionType,
                                            indexPath: indexPath,
                                            model: EditTaskModel(task: task),
                                            delegate: self)
        } else {
            return builder.createEditTaskVC(presentetionType: presentetionType,
                                            model: EditTaskModel(),
                                            delegate: self)
        }
    }
    
}

//MARK: - EditTaskPresenterDelegate

extension RootPresenter: EditTaskPresenterDelegate {
    func taskCreated(_ task: Task, indexPath: IndexPath?) {
        if let indexPath = indexPath {
            model.lists[model.selectedList].tasks[indexPath.row].title = task.title
            model.lists[model.selectedList].tasks[indexPath.row].body = task.body
        } else {
            model.lists[model.selectedList].tasks.append(task)
        }
        view.reloadView()
    }
    
}

//MARK: - TaskCellDelegate

extension RootPresenter: TaskCellDelegate {
    
    func checkboxDidTap(_ cell: TaskCell) {
        guard let indexPath = cell.indexPath else { return }
        model.lists[model.selectedList].tasks[indexPath.row].isDone = cell.isDone
    }
    
}
