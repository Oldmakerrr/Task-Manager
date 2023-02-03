//
//  Lablel++.swift
//  TaskManager
//
//  Created by grandmaster on 2.2.23..
//

import UIKit

extension UILabel {
    
    static func boldLabel(_ fontSize: CGFloat = 22) -> UILabel {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: fontSize)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }
}
