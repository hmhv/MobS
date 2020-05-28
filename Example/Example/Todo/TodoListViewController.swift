//
//  TodoListViewController.swift
//  Example
//
//  Created by MYUNGHOON HONG on 2020/04/24.
//  Copyright © 2020 hmhv. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {

    private let viewModel = TodoListViewModel()
    private lazy var dataSource: UITableViewDiffableDataSource<TodoSection, TodoCellModel> = {
        let dataSource = UITableViewDiffableDataSource<TodoSection, TodoCellModel>(tableView: tableView) { (tableView, indexPath, item) -> UITableViewCell? in
            tableView.dequeueReusableCell(withIdentifier: "TodoCell", for: indexPath)
        }
        dataSource.defaultRowAnimation = .fade
        return dataSource
    }()

    override func viewDidLoad() {
        super .viewDidLoad()
        setupUI()
        setupViewModel()
    }

    private func setupUI() {
        let filterItem = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(changeFilter))
        let addItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNewTodo))
        navigationItem.rightBarButtonItems = [addItem, filterItem]

        tableView.dataSource = dataSource
    }

    private func setupViewModel() {
        viewModel.$title.addObserver(with: self) { (self) in
            self.navigationItem.title = self.title
        }
        viewModel.$todoCellModels.addObserver(with: self) { (self) in
            self.updateTableView(with: self.viewModel.todoCellModels)
        }
    }

    @objc func addNewTodo() {
        showTodoDetailVC(todoCellModel: viewModel.addNewTodo())
    }

    @objc func changeFilter() {
        viewModel.todoFilterType.toggle()
    }

    func showTodoDetailVC(todoCellModel: TodoCellModel) {
        if let vc =  TodoDetailViewController.newVC() as? TodoDetailViewController {
            vc.viewModel = viewModel
            vc.todoCellModel = todoCellModel
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}

extension TodoListViewController {

    func updateTableView(with cellModels: [TodoCellModel]) {
        var snapshot = NSDiffableDataSourceSnapshot<TodoSection, TodoCellModel>()
        snapshot.appendSections(TodoSection.allCases)
        snapshot.appendItems(cellModels, toSection: .todo)
        dataSource.apply(snapshot)
    }

    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        (cell as? TodoCell).map { $0.cellModel = viewModel.todoCellModels[indexPath.row] }
    }

    override func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        (cell as? TodoCell).map { $0.cellModel = nil }
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        showTodoDetailVC(todoCellModel: viewModel.todoCellModels[indexPath.row])
    }

}
