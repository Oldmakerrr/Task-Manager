//
//  TaskManagerTests.swift
//  TaskManagerTests
//
//  Created by grandmaster on 3.2.23..
//

import XCTest
@testable import TaskManager

final class TaskManagerTests: XCTestCase {
    
    var presenter: RootPresenterProtocol!
    var model: ModelProtocol!
    var view: RootViewControllerProtocol!
    
    let numberOfList = 5
    let numberOfTask = 6
    let indexPath = IndexPath(row: 3, section: 1)
    
    override func setUpWithError() throws {
        presenter = RootPresenter()
        model = MockModel(numberOfList: numberOfList, numberOfTask: numberOfTask)
        presenter.model = model
        view = RootViewController()
        view.presenter = presenter
        presenter.view = view
    }

    override func tearDownWithError() throws {
        presenter = nil
        model = nil
        view = nil
    }

    func testRemoveList() throws {
        presenter.removeList()
        XCTAssertEqual(model.listCount, numberOfList - 1)
    }
    
    func testRenameList() throws {
        let newName = "MockListName"
        presenter.renameList(newName)
        let renamedList = model.lists[model.selectedList]
        XCTAssertEqual(renamedList.name, newName)
    }
    
    func testTaskCountAfterRemove() {
        presenter.removeTask(for: indexPath)
        XCTAssertEqual(model.lists[model.selectedList].tasksCount, numberOfTask-1)
    }
    
    func testRemoveParticularTask() {
        let taskWillRemove = model.lists[model.selectedList].tasks[indexPath.row]
        presenter.removeTask(for: indexPath)
        XCTAssertFalse(model.lists[model.selectedList].tasks.contains(where: { $0.title == taskWillRemove.title }))
    }

    func testCountAfterAddNewList() {
        let name = "MockName"
        presenter.addNewListWith(name)
        XCTAssertEqual(model.listCount, numberOfList + 1)
    }
    
    func testNameAfterAddNewList() {
        let name = "MockName"
        presenter.addNewListWith(name)
        XCTAssertEqual(model.lists.last?.name, name)
    }

}
