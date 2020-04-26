//
//  Observer.swift
//  MobS
//
//  Created by MYUNGHOON HONG on 2020/04/24.
//

import Foundation

final class Observer {

    private lazy var id = Unmanaged.passUnretained(self).toOpaque().hashValue
    private let action: () -> Void
    private var notifiers = Set<Notifier>()

    init(action: @escaping () -> Void) {
        self.action = action
        if MobS.isTraceEnabled {
            MobS.numberOfObserver += 1
        }
    }

    deinit {
        if MobS.isTraceEnabled {
            MobS.numberOfObserver -= 1
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

extension Observer: Removable {

    func remove() {
        runOnMainThread {
            notifiers.forEach { $0.remove(observer: self) }
            notifiers.removeAll()
        }
    }

}

extension Observer: Hashable {

    static func == (lhs: Observer, rhs: Observer) -> Bool {
        lhs.id == rhs.id
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

}
