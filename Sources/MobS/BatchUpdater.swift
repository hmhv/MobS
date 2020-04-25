//
//  BatchUpdater.swift
//  MobS
//
//  Created by MYUNGHOON HONG on 2020/04/24.
//

import Foundation

final class BatchUpdater {

    private var pendingUpdaters = Set<Updater>()

    func add(updater: Set<Updater>) {
        pendingUpdaters = pendingUpdaters.union(updater)
    }

    func callAsFunction() {
        pendingUpdaters.forEach { $0() }
    }

}
