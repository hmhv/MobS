//
//  TodoListViewModel.swift
//  Example
//
//  Created by MYUNGHOON HONG on 2020/04/24.
//  Copyright © 2020 hmhv. All rights reserved.
//

import Foundation
import MobS

class TodoListViewModel: RemoverOwner {

    @MobS.Observable(value: [])
    private var allTodoCellModels: [TodoCellModel]

    @MobS.Observable(value: .all)
    var todoFilterType: TodoFilterType

    @MobS.Observable(value: [])
    private(set) var todoCellModels: [TodoCellModel]

    @MobS.Observable(value: "")
    private(set) var title: String

    init() {
        defer {
            allTodoCellModels = (1 ..< 10).map { TodoCellModel(todo: Todo(title: "Todo \($0)", done: $0 % 2 == 0)) }
        }

        [$todoFilterType, $allTodoCellModels].addObserver(with: self) { (self) in
            self.todoCellModels = self.allTodoCellModels.filter(self.todoFilterType.todoFilter)
            self.title = "\(self.todoFilterType.listViewTitle) :: \(self.todoCellModels.count)"
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

enum TodoSection: CaseIterable {
    case todo
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

    func update(title: String, done: Bool) {
        MobS.updateState {
            todo.title = title
            todo.done = done
        }
    }

}

extension TodoCellModel: Hashable {

    static func == (lhs: TodoCellModel, rhs: TodoCellModel) -> Bool {
        return lhs.todo.id == rhs.todo.id
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(todo.id)
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
