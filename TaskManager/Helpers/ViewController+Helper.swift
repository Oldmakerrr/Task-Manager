//
//  ViewController++.swift
//  TaskManager
//
//  Created by grandmaster on 1.2.23..
//

import UIKit

extension UIViewController {
    
    func showErrorAlert() {
        let alert = UIAlertController(title: "Oops", message: "Something went wrong", preferredStyle: .alert)
        let ok = UIAlertAction(title: "Ok", style: .default)
        alert.addAction(ok)
        self.present(alert, animated: true)
    }
}
