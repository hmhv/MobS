//
//  TodoListViewController.swift
//  Example
//
//  Created by MYUNGHOON HONG on 2020/04/24.
//  Copyright © 2020 hmhv. All rights reserved.
//

import UIKit

enum TodoSection: CaseIterable {
    case todo
}

class TodoListViewController: UITableViewController {

    private let viewModel = TodoListViewModel()
    private lazy var diffableDataSource: UITableViewDiffableDataSource<TodoSection, TodoCellModel> = {
        let dataSource = UITableViewDiffableDataSource<TodoSection, TodoCellModel>(tableView: tableView) { [weak self] (tableView, indexPath, item) in
            guard let self = self else { return nil }
            let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: TodoCell.self), for: indexPath) as! TodoCell
            cell.cellModel = item
            return cell
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

        // UITableViewDiffableDataSource is slow.
        // Comment out the line of code below, if you test many TodoCellModels.
        tableView.dataSource = diffableDataSource
    }

    private func setupViewModel() {
        viewModel.$title.addObserver(with: self) { (self, title) in
            self.navigationItem.title = title
        }
        viewModel.$todoCellModels.addObserver(with: self) { (self, todoCellModels) in
            self.updateTableView(with: todoCellModels)
        }
    }

    @objc func addNewTodo() {
        showTodoDetailVC(todoCellModel: viewModel.addNewTodo())
    }

    @objc func changeFilter() {
        viewModel.todoFilter.toggle()
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
        if tableView.dataSource is UITableViewDiffableDataSource<TodoSection, TodoCellModel> {
            var snapshot = NSDiffableDataSourceSnapshot<TodoSection, TodoCellModel>()
            snapshot.appendSections(TodoSection.allCases)
            snapshot.appendItems(cellModels, toSection: .todo)
            diffableDataSource.apply(snapshot)
        } else {
            tableView.reloadData()
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.todoCellModels.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: TodoCell.self), for: indexPath) as! TodoCell
        cell.cellModel = viewModel.todoCellModels[indexPath.row]
        return cell
    }

    override func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        (cell as? TodoCell).map { $0.cellModel = nil }
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        showTodoDetailVC(todoCellModel: viewModel.todoCellModels[indexPath.row])
    }

}
