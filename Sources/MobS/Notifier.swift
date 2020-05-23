//
//  Notifier.swift
//  MobS
//
//  Created by MYUNGHOON HONG on 2020/04/24.
//

import Foundation

extension MobS {

    class Notifier: HashableClass {

        private(set) var observers = Set<Observer>()

        func add(observer: Observer) {
            observers.insert(observer)
        }

        func remove(observer: Observer) {
            observers.remove(observer)
        }

        func removeAll() {
            observers.forEach { $0.remove(notifier: self) }
            observers.removeAll()
        }

        func callAsFunction() {
            if let batchRunner = MobS.batchRunner {
                batchRunner.add(observers: observers)
            } else {
                let batchRunner = BatchRunner()
                MobS.batchRunner = batchRunner

                batchRunner.add(observers: observers)

                batchRunner()
                MobS.batchRunner = nil
            }
        }

    }

}
