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
                let beforePendingObservers = pendingObservers

                let computeds = pendingObservers.filter { $0.isComputed }
                pendingObservers = pendingObservers.filter { !$0.isComputed }

                if computeds.count > 0 {
                    computeds.forEach { $0() }
                } else {
                    let observers = pendingObservers
                    pendingObservers.removeAll()
                    observers.forEach { $0() }
                }

                if beforePendingObservers == pendingObservers {
                    fatalError("You have a circular reference. check observables in addObserver() action block.")
                }
            }
        }

    }

}
