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
        private var notifiers = Set<Notifier>()

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
            notifiers.insert(notifier)
        }

        func remove(notifier: Notifier) {
            notifiers.remove(notifier)
        }

        func callAsFunction() {
            action()
        }

    }

}

extension MobS.Observer: Removable {

    func remove() {
        runOnMainThread {
            notifiers.forEach { $0.remove(observer: self) }
            notifiers.removeAll()
        }
    }

}
