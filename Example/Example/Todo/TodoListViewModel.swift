//
//  TodoListViewModel.swift
//  Example
//
//  Created by MYUNGHOON HONG on 2020/04/24.
//  Copyright © 2020 hmhv. All rights reserved.
//

import Foundation
import MobS

class TodoListViewModel {

    @MobS.State(initialState: [])
    var todoCellModels: [TodoCellModel]

    private var allTodoCellModels: [TodoCellModel] = [] {
        didSet {
            todoCellModels = allTodoCellModels.filter(todoFilterType.todoFilter)
        }
    }

    var todoFilterType: TodoFilterType = .all {
        didSet {
            todoCellModels = allTodoCellModels.filter(todoFilterType.todoFilter)
        }
    }
    
    init() {
        defer {
            allTodoCellModels = (1 ..< 10).map { TodoCellModel(todo: Todo(title: "Todo \($0)", done: $0 % 2 == 0)) }
        }
    }

    func addNewTodo() -> TodoCellModel {
        let cm = TodoCellModel(todo: Todo())
        allTodoCellModels.append(cm)
        return cm
    }

    func delete(cellModel: TodoCellModel) {
        allTodoCellModels.removeAll { $0.todo == cellModel.todo }
    }
    
}

class TodoCellModel {

    @MobS.State
    var todo: Todo

    init(todo: Todo) {
        _todo = MobS.State(initialState: todo)
    }

    func toggle() {
        todo.done.toggle()
    }

}


enum TodoFilterType: CustomStringConvertible {

    typealias Filter = (TodoCellModel) -> Bool

    case all
    case done
    case wip

    var todoFilter: Filter {
        switch self {
        case .all:
            return { _ in true }
        case .wip:
            return { !$0.todo.done }
        case .done:
            return { $0.todo.done }
        }
    }

    var description: String {
        switch self {
        case .all:
            return "All"
        case .wip:
            return "WIP"
        case .done:
            return "Done"
        }
    }

    mutating func toggle() {
        switch self {
        case .all:
            self = .wip
        case .wip:
            self = .done
        case .done:
            self = .all
        }
    }

}
