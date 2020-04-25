//
//  Updater.swift
//  MobS
//
//  Created by MYUNGHOON HONG on 2020/04/24.
//

import Foundation

final class Updater {

    private lazy var id = Unmanaged.passUnretained(self).toOpaque().hashValue
    private let action: () -> Void
    private var notifiers = Set<Notifier>()

    init(action: @escaping () -> Void) {
        self.action = action
        if MobS.isTraceEnabled {
            MobS.numberOfUpdater += 1
        }
    }

    deinit {
        if MobS.isTraceEnabled {
            MobS.numberOfUpdater -= 1
        }
    }

    func add(notifier: Notifier) {
        notifiers.insert(notifier)
    }

    func remove(notifier: Notifier) {
        notifiers.remove(notifier)
    }

    func callAsFunction() {
        action()
    }

}

extension Updater: Removable {

    func remove() {
        runOnMainThread {
            notifiers.forEach { $0.remove(updater: self) }
            notifiers.removeAll()
        }
    }

}

extension Updater: Hashable {

    static func == (lhs: Updater, rhs: Updater) -> Bool {
        lhs.id == rhs.id
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

}
