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
    private lazy var dataSource: UITableViewDiffableDataSource<TodoSection, TodoCellModel> = {
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

        tableView.dataSource = dataSource
    }

    private func setupViewModel() {
        viewModel.$title.addObserver(with: self) { (self) in
            self.navigationItem.title = self.viewModel.title
        }
        viewModel.$todoCellModels.addObserver(with: self) { (self) in
            self.updateTableView(with: self.viewModel.todoCellModels)
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
        var snapshot = NSDiffableDataSourceSnapshot<TodoSection, TodoCellModel>()
        snapshot.appendSections(TodoSection.allCases)
        snapshot.appendItems(cellModels, toSection: .todo)
        dataSource.apply(snapshot)
    }

    override func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        (cell as? TodoCell).map { $0.cellModel = nil }
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        showTodoDetailVC(todoCellModel: viewModel.todoCellModels[indexPath.row])
    }

}
