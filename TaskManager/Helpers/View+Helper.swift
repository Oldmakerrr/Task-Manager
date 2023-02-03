//
//  View++.swift
//  TaskManager
//
//  Created by grandmaster on 1.2.23..
//

import UIKit

extension UIView {
    
    enum Padding {
        case all(CGFloat)
        case padding(top: CGFloat? = nil, right: CGFloat? = nil, bottom: CGFloat? = nil, left: CGFloat? = nil)
    }
    
    func embed(in view: UIView, with padding: Padding? = nil) {
        
        var top: CGFloat {
            switch padding {
            case .all(let value):
                return value
            case .padding(let top, _, _, _):
                return top ?? 0
            case .none:
                return 0
            }
        }
        
        var bottom: CGFloat {
            switch padding {
            case .all(let value):
                return value
            case .padding(_, _, let bottom, _):
                return bottom ?? 0
            case .none:
                return 0
            }
        }
        
        var left: CGFloat {
            switch padding {
            case .all(let value):
                return value
            case .padding(_, _, _, let left):
                return left ?? 0
            case .none:
                return 0
            }
        }
        var right: CGFloat {
            switch padding {
            case .all(let value):
                return value
            case .padding(_, let right, _, _):
                return right ?? 0
            case .none:
                return 0
            }
        }
        
        translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(self)
        NSLayoutConstraint.activate([
            topAnchor.constraint(equalTo: view.topAnchor, constant: top),
            leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: left),
            trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -right),
            bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -bottom),
            widthAnchor.constraint(equalTo: view.widthAnchor, constant: -(left + right)),
            heightAnchor.constraint(equalTo: view.heightAnchor, constant: -(top + bottom))
        ])
    }
    
    func embedViewInBorder(_ padding: CGFloat = Constants.Size.borderPadding,
                           borderWidth: CGFloat = 2,
                           borderColor: UIColor = .gray,
                           cornerRadius: CGFloat = 4) -> UIView {
        let backgroundView = UIView()
        backgroundView.backgroundColor = .clear
        backgroundView.layer.borderWidth = borderWidth
        backgroundView.layer.borderColor = borderColor.cgColor
        backgroundView.layer.cornerRadius = cornerRadius
        self.embed(in: backgroundView, with: .all(padding))
        return backgroundView
    }
}
