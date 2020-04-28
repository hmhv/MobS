//
//  Notifier.swift
//  MobS
//
//  Created by MYUNGHOON HONG on 2020/04/24.
//

import Foundation

final class Notifier {

    private lazy var id = Unmanaged.passUnretained(self).toOpaque().hashValue
    private(set) var observers = Set<Observer>()

    deinit {
        runOnMainThread {
            observers.forEach { $0.remove(notifier: self) }
            observers.removeAll()
        }
    }

    func add(observer: Observer) {
        observers.insert(observer)
    }

    func remove(observer: Observer) {
        observers.remove(observer)
    }

    func callAsFunction() {
        observers.forEach { $0() }
    }

}

extension Notifier: Hashable {

    static func == (lhs: Notifier, rhs: Notifier) -> Bool {
        lhs.id == rhs.id
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

}
