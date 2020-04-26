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

    @MobS.Observable(value: [])
    private(set) var todoCellModels: [TodoCellModel]

    @MobS.Observable(value: TodoFilterType.all.listViewTitle)
    private(set) var title: String

    private var allTodoCellModels: [TodoCellModel] = [] {
        didSet {
            todoCellModels = allTodoCellModels.filter(todoFilterType.todoFilter)
        }
    }

    var todoFilterType: TodoFilterType = .all {
        didSet {
            todoCellModels = allTodoCellModels.filter(todoFilterType.todoFilter)
            title = todoFilterType.listViewTitle
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

    @MobS.Observable
    var todo: Todo

    init(todo: Todo) {
        _todo = MobS.Observable(value: todo)
    }

    func toggle() {
        todo.done.toggle()
    }

}


enum TodoFilterType {

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

    var listViewTitle: String {
        switch self {
        case .all:
            return "Todo List :: All"
        case .wip:
            return "Todo List :: WIP"
        case .done:
            return "Todo List :: Done"
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
