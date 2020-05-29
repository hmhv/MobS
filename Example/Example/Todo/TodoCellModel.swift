//
//  TodoCellModel.swift
//  Example
//
//  Created by MYUNGHOON HONG on 2020/05/30.
//  Copyright © 2020 hmhv. All rights reserved.
//

import Foundation
import MobS

struct TodoCellModel {

    @MobS.Observable
    var todo: Todo

    private let viewModelUpdater: () -> Void

    init(todo: Todo, viewModelUpdater: @escaping () -> Void) {
        _todo = MobS.Observable(value: todo)
        self.viewModelUpdater = viewModelUpdater
    }

    func toggle() {
        todo.done.toggle()
        viewModelUpdater()
    }

    func update(title: String, done: Bool) {
        MobS.updateState {
            todo.title = title
            todo.done = done
            viewModelUpdater()
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
