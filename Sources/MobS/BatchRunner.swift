//
//  BatchRunner.swift
//  MobS
//
//  Created by MYUNGHOON HONG on 2020/04/24.
//

import Foundation

final class BatchRunner {

    private var pendingObservers = Set<Observer>()

    deinit {
        pendingObservers.forEach { $0() }
    }

    func add(observer: Set<Observer>) {
        pendingObservers = pendingObservers.union(observer)
    }

}
