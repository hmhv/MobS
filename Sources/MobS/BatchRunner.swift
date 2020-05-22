//
//  BatchRunner.swift
//  MobS
//
//  Created by MYUNGHOON HONG on 2020/04/24.
//

import Foundation

extension MobS {

    final class BatchRunner {

        private var pendingObservers = Set<Observer>()

        private var first = false

        func add(observers: Set<Observer>) {
            pendingObservers = pendingObservers.union(observers)
        }

        func callAsFunction() {
            while pendingObservers.count > 0 {
                let observers = pendingObservers
                pendingObservers.removeAll()
                observers.forEach { $0() }

                if observers == pendingObservers {
                    fatalError("You have a circular reference. check observables in addObserver() action block.")
                }
            }
        }

    }

}
