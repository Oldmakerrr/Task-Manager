//
//  RootViewController.swift
//  TaskManager
//
//  Created by grandmaster on 1.2.23..
//

import UIKit

protocol RootViewControllerProtocol: AnyObject {
    var presenter: RootPresenterProtocol! { get set }
    func reloadView()
}

enum TextFieldType {
    case rename(String), addNew(String)
}

final class RootViewController: UIViewController, RootViewControllerProtocol {
    
    var presenter: RootPresenterProtocol!
    
    private var textFieldType: TextFieldType?
    
    private var doneAlertAction: UIAlertAction?
    
    internal lazy var editListButton = UIBarButtonItem(
        image: UIImage(systemName: Constants.Image.imageEditList),
        style: .done,
        target: self,
        action: #selector(editListHandler))
    
    internal lazy var listCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(ListCell.self, forCellWithReuseIdentifier: ListCell.identifier)
        return collectionView
    }()
    
    internal lazy var taskTableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(TaskCell.self, forCellReuseIdentifier: TaskCell.identifier)
        tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        return tableView
    }()
    
    internal lazy var addTaskButton: UIButton = {
        let button = UIButton()
        let size: CGFloat = Constants.Size.addTaskButtomSize
        button.backgroundColor = .blue
        button.translatesAutoresizingMaskIntoConstraints = false
        button.widthAnchor.constraint(equalToConstant: size).isActive = true
        button.heightAnchor.constraint(equalToConstant: size).isActive = true
        button.layer.cornerRadius = size/2
        button.addTarget(self, action: #selector(addTaskHandler), for: .touchUpInside)
        let image = UIImage(named: Constants.Image.imagePlus)?.withRenderingMode(.alwaysTemplate)
        button.setImage(image, for: .normal)
        button.tintColor = .white
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        addConstraints()
    }
    
    private func setupUI() {
        view.backgroundColor = .white
        title = presenter.currentListName
        view.addSubview(listCollectionView)
        view.addSubview(taskTableView)
        view.addSubview(addTaskButton)
        configureNavigationBar()
    }
    
    private func configureNavigationBar() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: Constants.Image.imageAddList),
            style: .done,
            target: self,
            action: #selector(addListHandler))
        
        navigationItem.leftBarButtonItem = editListButton
        if presenter.isEmptyList {
            editListButton.isEnabled = false
        }
    }
    
    func reloadView() {
        taskTableView.reloadData()
        listCollectionView.reloadData()
        title = presenter.currentListName
    }
    
    private func showEditAlert(alertTitle: String? = nil,
                               actionTitle: String? = nil,
                               placeholder: String? = nil,
                               textFieldText: String? = nil,
                               handler: @escaping (String)-> Void) {
        let alert = UIAlertController(title: alertTitle, message: nil, preferredStyle: .alert)
        let done = UIAlertAction(title: actionTitle, style: .default) { action in
            let textField = alert.textFields?.first as? UITextField
            if let name = textField?.text {
                handler(name)
            }
        }
        done.isEnabled = false
        doneAlertAction = done
        let cancel = UIAlertAction(title: "Cancel", style: .cancel)
        alert.addTextField { textField in
            textField.placeholder = placeholder
            textField.text = textFieldText
            textField.delegate = self
            textField.addTarget(self,
                                action: #selector(self.textFieldDidChange),
                                for: .editingChanged)
        }
        alert.addAction(done)
        alert.addAction(cancel)
        present(alert, animated: true)
    }
    
    private func removeTaskSwipeAction(indexPath: IndexPath) -> UIContextualAction {
        let removeSwipe = UIContextualAction(style: .destructive, title: "Remove") { _, _, completion in
            self.presenter.removeTask(for: indexPath)
            completion(true)
        }
        removeSwipe.backgroundColor = .red
        removeSwipe.image = UIImage(systemName: Constants.Image.imageBin)
        return removeSwipe
    }
    
    @objc private func editListHandler() {
        let alert = UIAlertController(title: "Edit list",
                                      message: nil,
                                      preferredStyle: .actionSheet)
        
        let editName = UIAlertAction(title: "Rename list", style: .default) { [weak self] _ in
            self?.showEditAlert(alertTitle: "Input new list name",
                                actionTitle: "Rename",
                                placeholder: "Name",
                                textFieldText: self?.presenter.currentListName) { [weak self] name in
                self?.presenter.renameList(name)
                self?.textFieldType = .rename(name)
            }
        }
        
        let removeList = UIAlertAction(title: "Remove", style: .destructive) { [weak self] _ in
            self?.presenter.removeList()
            if let presenter = self?.presenter {
                if presenter.isEmptyList {
                    self?.editListButton.isEnabled = false
                }
            }
        }
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel)
        alert.addAction(editName)
        alert.addAction(removeList)
        alert.addAction(cancel)
        present(alert, animated: true)
    }
    
    @objc private func addListHandler() {
        showEditAlert(alertTitle: "Add new List",
                      actionTitle: "Add",
                      placeholder: "Input list name") { [weak self] name in
            guard let self = self else { return }
            if self.presenter.isEmptyList {
                self.editListButton.isEnabled = true
            }
            self.presenter.addNewListWith(name)
            self.textFieldType = .addNew(name)
        }
    }
    
    @objc private func addTaskHandler() {
        if presenter.isEmptyList {
            addListHandler()
        } else {
            let editTaskViewController = presenter.getEditTaskViewController(presentetionType: .new, for: nil)
            if let presentationController = editTaskViewController.presentationController as? UISheetPresentationController {
                presentationController.detents = [.medium()]
            }
            present(editTaskViewController, animated: true)
        }
    }
    
    @objc private func textFieldDidChange(_ textField: UITextField) {
        guard let text = textField.text else {
            doneAlertAction?.isEnabled = false
            return }
        doneAlertAction?.isEnabled = !text.isEmpty
    }
    
}

//MARK: - UITableViewDataSource

extension RootViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        presenter.tableViewNumberOfRow
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TaskCell.identifier, for: indexPath) as! TaskCell
        cell.populateCell(presenter.tableViewDataSource(indexPath))
        cell.indexPath = indexPath
        cell.delegate = presenter as? TaskCellDelegate
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        Constants.Size.tableViewCellHeight
    }
    
}

//MARK: - UITableViewDelegate

extension RootViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let editTaskViewController = presenter.getEditTaskViewController(presentetionType: .edit, for: indexPath)
        if let presentationController = editTaskViewController.presentationController as? UISheetPresentationController {
            presentationController.detents = [.medium()]
        }
        present(editTaskViewController, animated: true)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        UISwipeActionsConfiguration(actions: [removeTaskSwipeAction(indexPath: indexPath)])
    }
    
}

//MARK: - UICollectionViewDataSource

extension RootViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        presenter.collectionViewNumberOfRow
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ListCell.identifier, for: indexPath) as! ListCell
        cell.populateCell(presenter.collectionViewDataSource(indexPath), isSelected: presenter.isCurrentList(for: indexPath))
        return cell
    }
    
}

//MARK: - UICollectionViewDelegate

extension RootViewController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        presenter.selectList(indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        Constants.Size.listCellSize
    }
    
}

//MARK: - UITextFieldDelegate

extension RootViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard let textFieldType = textFieldType else { return false }
        switch textFieldType {
        case .rename (let name):
            presenter.addNewListWith(name)
        case .addNew (let name):
            presenter.renameList(name)
        }
        return true
    }
    
}


