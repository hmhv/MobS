//
//  Notifier.swift
//  MobS
//
//  Created by MYUNGHOON HONG on 2020/04/24.
//

import Foundation

extension MobS {

    class Notifier: HashableClass {

        private(set) var observersForObservable = Set<Observer>()
        private(set) var observersForComputed = Set<Observer>()

        deinit {
            runOnMainThread {
                observersForObservable.forEach { $0.remove(notifier: self) }
                observersForComputed.forEach { $0.remove(notifier: self) }
                observersForObservable.removeAll()
                observersForComputed.removeAll()
            }
        }

        func add(observer: Observer) {
            if observer.isForComputed {
                observersForComputed.insert(observer)
            } else {
                observersForObservable.insert(observer)
            }
        }

        func remove(observer: Observer) {
            if observer.isForComputed {
                observersForComputed.remove(observer)
            } else {
                observersForObservable.remove(observer)
            }
        }

        func callAsFunction() {
            if let batchRunner = MobS.batchRunner {
                batchRunner.add(observersForObservable: observersForObservable)
                observersForComputed.forEach { $0() }
            } else {
                MobS.batchRunner = BatchRunner()
                MobS.batchRunner?.add(observersForObservable: observersForObservable)
                observersForComputed.forEach { $0() }
                MobS.batchRunner = nil
            }

        }

    }

}
