//
//  RootViewController+Extensions.swift
//  TaskManager
//
//  Created by Vladimir Berezin on 03.02.23.
//

import UIKit

extension RootViewController {

    internal func addConstraints() {
        addConstraintsToListCV()
        addConstraintsToTaskTV()
        addConstraintsToButton()
    }

    private func addConstraintsToListCV() {
        NSLayoutConstraint.activate([
            listCollectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            listCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.Size.viewPadding),
            listCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constants.Size.viewPadding),
            listCollectionView.heightAnchor.constraint(equalToConstant: Constants.Size.listCellSize.height + Constants.Size.viewPadding * 2)
        ])
    }

    private func addConstraintsToTaskTV() {
        taskTableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            taskTableView.topAnchor.constraint(equalTo: listCollectionView.bottomAnchor),
            taskTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            taskTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            taskTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }

    private func addConstraintsToButton() {
        NSLayoutConstraint.activate([
            addTaskButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
            addTaskButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -40)
        ])
    }
    
}
