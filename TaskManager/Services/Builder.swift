//
//  Builder.swift
//  TaskManager
//
//  Created by grandmaster on 1.2.23..
//

import Foundation

protocol BuilderProtocol {
    func createRootVC(viewController: RootViewControllerProtocol,
                      presenter: RootPresenterProtocol,
                      model: ModelProtocol) -> RootViewController
    
    func createEditTaskVC(presentetionType: EditTaskVCType,
                          indexPath: IndexPath?,
                          viewController: EditTaskViewControllerProtocol,
                          presenter: EditTaskPresenterProtocol,
                          model: TaskModelEditable,
                          delegate: EditTaskPresenterDelegate) -> EditTaskViewController
}

final class Builder: BuilderProtocol {
    
    func createRootVC(viewController: RootViewControllerProtocol = RootViewController(),
                      presenter: RootPresenterProtocol = RootPresenter(),
                      model: ModelProtocol = Model()
    ) -> RootViewController {
        let vc = viewController
        presenter.model = model
        presenter.view = vc
        vc.presenter = presenter
        return vc as! RootViewController
    }
    
    func createEditTaskVC(presentetionType: EditTaskVCType,
                          indexPath: IndexPath? = nil,
                          viewController: EditTaskViewControllerProtocol = EditTaskViewController(),
                          presenter: EditTaskPresenterProtocol = EditTaskPresenter(),
                          model: TaskModelEditable,
                          delegate: EditTaskPresenterDelegate
    ) -> EditTaskViewController {
        let vc = viewController
        presenter.model = model
        model.indexPath = indexPath
        presenter.view = vc
        presenter.delegate = delegate
        vc.presentetionType = presentetionType
        vc.presenter = presenter
        return vc as! EditTaskViewController
    }
    
}
