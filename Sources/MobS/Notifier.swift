//
//  Notifier.swift
//  MobS
//
//  Created by MYUNGHOON HONG on 2020/04/24.
//

import Foundation

final class Notifier {

    private lazy var id = Unmanaged.passUnretained(self).toOpaque().hashValue
    private(set) var updaters = Set<Updater>()

    func add(updater: Updater) {
        updaters.insert(updater)
    }

    func remove(updater: Updater) {
        updaters.remove(updater)
    }

    func callAsFunction() {
        updaters.forEach { $0() }
    }

}

extension Notifier: Removable {

    func remove() {
        runOnMainThread {
            updaters.forEach { $0.remove(notifier: self) }
            updaters.removeAll()
        }
    }

}

extension Notifier: Hashable {

    static func == (lhs: Notifier, rhs: Notifier) -> Bool {
        lhs.id == rhs.id
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

}
