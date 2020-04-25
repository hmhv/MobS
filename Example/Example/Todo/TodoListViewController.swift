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

    override func viewDidLoad() {
        super .viewDidLoad()
        setupUI()
    }

    private func setupUI() {
        let filterItem = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(changeFilter))
        let addItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNewTodo))
        navigationItem.rightBarButtonItems = [addItem, filterItem]

        viewModel.$todoCellModels.addUpdater(with: self) { (vc, todos) in
            vc.navigationItem.title = "Todo List :: \(vc.viewModel.todoFilterType)"
            vc.tableView.reloadData()
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

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.todoCellModels.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        tableView.dequeueReusableCell(withIdentifier: "TodoCell", for: indexPath) as! TodoCell
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
