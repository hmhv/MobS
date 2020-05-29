//
//  Todo.swift
//  Example
//
//  Created by MYUNGHOON HONG on 2020/04/24.
//  Copyright © 2020 hmhv. All rights reserved.
//

import Foundation

struct Todo: Hashable {

    let id: Int
    var title: String
    var done: Bool

    init(title: String = "new Todo", done: Bool = false) {
        id = IDGenerator.newId()
        self.title = title
        self.done = done
    }

}

fileprivate enum IDGenerator {

    static var id = 0

    static func newId() -> Int {
        defer { id += 1 }
        return id
    }

}
