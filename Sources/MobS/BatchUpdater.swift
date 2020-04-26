//
//  BatchUpdater.swift
//  MobS
//
//  Created by MYUNGHOON HONG on 2020/04/24.
//

import Foundation

final class BatchUpdater {

    private var pendingUpdaters = Set<Observer>()

    func add(updater: Set<Observer>) {
        pendingUpdaters = pendingUpdaters.union(updater)
    }

    func callAsFunction() {
        pendingUpdaters.forEach { $0() }
    }

}
