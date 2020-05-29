//
//  Observer.swift
//  MobS
//
//  Created by MYUNGHOON HONG on 2020/04/24.
//

import Foundation

extension MobS {

    final class Observer: HashableClass {

        private let action: () -> Void
        private var fromNotifiers = Set<Notifier>()
        private var toNotifiers = Set<Notifier>()

        init(action: @escaping () -> Void) {
            self.action = action

            super.init()

            if MobS.isTraceEnabled {
                runOnMainThread {
                    MobS.numberOfObserver += 1
                }
            }
        }

        deinit {
            remove()
            if MobS.isTraceEnabled {
                runOnMainThread {
                    MobS.numberOfObserver -= 1
                }
            }
        }

        func add(notifier: Notifier) {
            fromNotifiers.insert(notifier)
        }

        func remove(notifier: Notifier) {
            fromNotifiers.remove(notifier)
        }

        func callAsFunction() {
            action()
        }

        func add(toNotifier: Notifier) {
            toNotifiers.insert(toNotifier)
        }

        var isComputed: Bool {
            return toNotifiers.count > 0
        }

    }

}

extension MobS.Observer: MobSRemovable {

    func remove() {
        runOnMainThread {
            fromNotifiers.forEach { $0.remove(observer: self) }
            fromNotifiers.removeAll()
            toNotifiers.removeAll()
        }
    }

}
