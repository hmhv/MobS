//
//  TodoFilter.swift
//  Example
//
//  Created by MYUNGHOON HONG on 2020/05/30.
//  Copyright © 2020 hmhv. All rights reserved.
//

import Foundation

enum TodoFilter {

    typealias Filter = (TodoCellModel) -> Bool

    case all
    case done
    case wip

    var filter: Filter {
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
