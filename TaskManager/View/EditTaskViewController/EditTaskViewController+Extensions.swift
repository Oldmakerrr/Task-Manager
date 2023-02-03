//
//  EditTaskViewController+Extensions.swift
//  TaskManager
//
//  Created by Vladimir Berezin on 03.02.23.
//

import UIKit

extension EditTaskViewController {

    internal func addConstraints() {
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: Constants.Size.viewPadding),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.Size.viewPadding),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constants.Size.viewPadding),
            stackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -Constants.Size.viewPadding)
        ])
    }
    
}
