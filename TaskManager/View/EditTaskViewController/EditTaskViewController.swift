//
//  EditTaskViewController.swift
//  TaskManager
//
//  Created by grandmaster on 1.2.23..
//

import UIKit

protocol EditTaskViewControllerProtocol: AnyObject {
    var presenter: EditTaskPresenterProtocol! { get set }
    var presentetionType: EditTaskVCType! { get set }
}

enum EditTaskVCType {
    case new, edit
}

enum KeybordState {
    case isShow(CGFloat), notShow
}

final class EditTaskViewController: UIViewController, EditTaskViewControllerProtocol {
    
    var presenter: EditTaskPresenterProtocol!
    
    var presentetionType: EditTaskVCType!
    
    var keyboardState: KeybordState = .notShow {
        didSet {
            switch keyboardState {
            case .isShow(let keyboardHeight):
                addTaskButton.frame.origin.y -= keyboardHeight - Constants.Size.viewPadding * 2
                addTaskButton.transform = CGAffineTransformMakeScale(0.8, 1)
            case .notShow:
                addTaskButton.frame.origin.y += 200
                addTaskButton.transform = CGAffineTransformMakeScale(1, 1)
            }
        }
    }
    
    private var buttonTitle: String {
        switch presentetionType {
        case .new:
            return "Add task"
        case .edit:
            return "Edit task"
        case .none:
            return ""
        }
    }
    
    private let titleTextField = UITextField()
    
    private let bodyTextView = UITextView()
    
    private let titleLabel: UILabel = .boldLabel()
    
    private let bodyLabel: UILabel = .boldLabel()
    
    internal lazy var stackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [titleLabel,
                                                   titleTextField.embedViewInBorder(),
                                                   bodyLabel,
                                                   bodyTextView.embedViewInBorder(),
                                                   addTaskButton])
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.spacing = Constants.Size.stackSpacing
        return stack
    }()
    
    private lazy var addTaskButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .blue
        button.titleLabel?.font = Constants.Font.bold22
        button.widthAnchor.constraint(equalToConstant: view.bounds.width/2).isActive = true
        button.heightAnchor.constraint(equalToConstant: Constants.Size.rectangleButtonSize).isActive = true
        button.setTitle(buttonTitle, for: .normal)
        button.isEnabled = titleTextField.text?.isEmpty ?? true ? false : true
        button.layer.cornerRadius = Constants.Size.cornerRadius
        button.addTarget(self, action: #selector(addTaskButtonHandler), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        configureUI()
        addConstraints()
    }
    
    private func setupUI() {
        view.addSubview(stackView)
    }
    
    private func configureUI() {
        view.backgroundColor = .white
        titleTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        titleTextField.translatesAutoresizingMaskIntoConstraints = false
        titleTextField.delegate = self
        bodyTextView.translatesAutoresizingMaskIntoConstraints = false
        bodyTextView.text = presenter.getTaskBody()
        titleTextField.text = presenter.getTaskName()
        titleLabel.text = "Task name"
        bodyLabel.text = "Description"
    }
    
    @objc private func addTaskButtonHandler() {
        guard let title = titleTextField.text, let body = bodyTextView.text else { return }
        let task = Task(title: title, body: body, isDone: false)
        presenter.createTask(task)
        dismiss(animated: true)
    }
    
    @objc private func textFieldDidChange(_ textField: UITextField) {
        guard let text = textField.text else {
            addTaskButton.isEnabled = false
            return }
        addTaskButton.isEnabled = !text.isEmpty
    }
    
}

//MARK: - UITextFieldDelegate

extension EditTaskViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard let title = textField.text, !title.isEmpty else { return false }
        let task = Task(title: title, body: bodyTextView.text, isDone: false)
        presenter.createTask(task)
        dismiss(animated: true)
        return true
    }
    
}
