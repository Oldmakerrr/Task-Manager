//
//  TaskCell.swift
//  TaskManager
//
//  Created by grandmaster on 1.2.23..
//

import UIKit

protocol ReusableView {
    static var identifier: String { get }
}

protocol TaskCellDelegate: AnyObject {
    func checkboxDidTap(_ cell: TaskCell)
}

final class TaskCell: UITableViewCell, ReusableView {
    
    static let identifier: String = "TaskCell"
    weak var delegate: TaskCellDelegate?
    var indexPath: IndexPath?
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = Constants.Font.bold18
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let bodyLabel = UILabel()
    
    private let checkboxButton = UIButton()
    
    private lazy var stackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [titleLabel, checkboxButton])
        stack.axis = .horizontal
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private let separatorView = UIView()
    
    private(set) var isDone: Bool = false {
        didSet {
            checkboxButton.setBackgroundImage(UIImage(systemName: isDone ? Constants.Image.imageCheckmarkDone : Constants.Image.imageCheckmarkEmpty),
                                             for: .normal)
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        addConstraints()
    }
    
    func populateCell(_ task: Task) {
        titleLabel.text = task.title
        bodyLabel.text = task.body
        isDone = task.isDone
    }
    
    private func setupUI() {
        contentView.addSubview(stackView)
        contentView.addSubview(bodyLabel)
        contentView.addSubview(separatorView)
        separatorView.backgroundColor = .systemGray5
        checkboxButton.addTarget(self, action: #selector(checkBoxTapHandler), for: .touchUpInside)
        bodyLabel.translatesAutoresizingMaskIntoConstraints = false
        checkboxButton.translatesAutoresizingMaskIntoConstraints = false
        separatorView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func addConstraints() {
        NSLayoutConstraint.activate([
            separatorView.topAnchor.constraint(equalTo: contentView.topAnchor),
            separatorView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            separatorView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            separatorView.heightAnchor.constraint(equalToConstant: 1),
            
            stackView.topAnchor.constraint(equalTo: separatorView.bottomAnchor, constant: Constants.Size.viewPadding),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constants.Size.viewPadding),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Constants.Size.viewPadding),
            
            checkboxButton.widthAnchor.constraint(equalToConstant: 24),
            checkboxButton.heightAnchor.constraint(equalToConstant: 24),

            bodyLabel.topAnchor.constraint(equalTo: stackView.bottomAnchor),
            bodyLabel.leadingAnchor.constraint(equalTo: stackView.leadingAnchor),
            bodyLabel.trailingAnchor.constraint(equalTo: stackView.trailingAnchor),
            bodyLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: Constants.Size.viewPadding)
        ])
    }
    
    @objc private func checkBoxTapHandler() {
        isDone.toggle()
        delegate?.checkboxDidTap(self)
    }
}
