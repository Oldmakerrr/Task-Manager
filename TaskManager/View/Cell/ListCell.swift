//
//  ListCell.swift
//  TaskManager
//
//  Created by grandmaster on 1.2.23..
//

import UIKit

final class ListCell: UICollectionViewCell, ReusableView {
    
    static var identifier: String = "ListCell"
    
    private let title = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func populateCell(_ list: List, isSelected: Bool) {
        title.text = list.name
        backgroundColor = isSelected ? .blue : .systemGray5
        title.textColor = isSelected ? .white : .black
        title.font = isSelected ? Constants.Font.bold18 : Constants.Font.system16
    }

    private func configureUI() {
        contentView.addSubview(title)
        layer.cornerRadius = Constants.Size.cornerRadius
        title.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            title.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            title.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
    
}
