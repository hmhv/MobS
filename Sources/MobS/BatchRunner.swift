//
//  BatchRunner.swift
//  MobS
//
//  Created by MYUNGHOON HONG on 2020/04/24.
//

import Foundation

extension MobS {

    final class BatchRunner {

        private var pendingObserversForObservable = Set<Observer>()

        deinit {
            pendingObserversForObservable.forEach { $0() }
        }

        func add(observersForObservable: Set<Observer>) {
            pendingObserversForObservable = pendingObserversForObservable.union(observersForObservable)
        }

    }

}
