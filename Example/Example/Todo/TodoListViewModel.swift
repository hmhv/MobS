//
//  TodoListViewModel.swift
//  Example
//
//  Created by MYUNGHOON HONG on 2020/04/24.
//  Copyright © 2020 hmhv. All rights reserved.
//

import Foundation
import MobS

class TodoListViewModel: MobSRemoverOwner {

    @MobS.Observable(value: [])
    private var allTodoCellModels: [TodoCellModel]

    @MobS.Observable(value: .all)
    var todoFilter: TodoFilter

    @MobS.Observable(value: [])
    private(set) var todoCellModels: [TodoCellModel]

    @MobS.Observable(value: "")
    private(set) var title: String

    init() {
        defer { addTestTodos() }

        [$todoFilter, $allTodoCellModels].addObserver(with: self) { (self) in
            self.updateTodoCellModels()
        }
    }

    func addNewTodo() -> TodoCellModel {
        let cm = TodoCellModel(todo: Todo()) { [weak self] in self?.updateTodoCellModels() }
        allTodoCellModels.append(cm)
        return cm
    }

    func delete(cellModel: TodoCellModel) {
        allTodoCellModels.removeAll { $0.todo == cellModel.todo }
    }


}

extension TodoListViewModel {

    private func updateTodoCellModels() {
        todoCellModels = allTodoCellModels.filter(todoFilter.filter)
        title = "\(todoFilter.listViewTitle) :: \(todoCellModels.count)"
    }

    private func addTestTodos() {
        allTodoCellModels = (1 ..< 10).map {
            let randomTodo = [String](repeating: "Todo", count: Int.random(in: 1 ..< 15)).joined(separator: " ")
            let todo = Todo(title: "\(randomTodo) \($0)", done: $0 % 2 == 0)
            return TodoCellModel(todo: todo) { [weak self] in self?.updateTodoCellModels() }
        }
    }

}
