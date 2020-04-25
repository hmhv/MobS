//
//  MobS.swift
//  MobS
//
//  Created by MYUNGHOON HONG on 2020/04/24.
//

import Foundation

public final class MobS {

    private(set) static var activeUpdaters: [Updater] = []
    private(set) static var batchUpdater: BatchUpdater?

    public static func addUpdater(action: @escaping () -> Void) -> Removable {
        runOnMainThread {
            MobS.activeUpdaters.append(Updater(action: action))
            action()
            return MobS.activeUpdaters.removeLast()
        }
    }

    public static func updateState(action: () -> Void) {
        runOnMainThread {
            if MobS.batchUpdater == nil {
                MobS.batchUpdater = BatchUpdater()
                action()
                MobS.batchUpdater?()
                MobS.batchUpdater = nil
            } else {
                action()
            }
        }
    }

}

extension MobS {

    public static var isTraceEnabled = false {
        didSet {
            numberOfUpdater = 0
            numberOfState = 0
            numberOfNotifier = 0
        }
    }

    static var numberOfUpdater = 0 {
        didSet { debugPrint("Updater = \(numberOfUpdater), State = \(numberOfState), Notifier = \(numberOfNotifier)") }
    }
    static var numberOfState = 0 {
        didSet { debugPrint("Updater = \(numberOfUpdater), State = \(numberOfState), Notifier = \(numberOfNotifier)") }
    }
    static var numberOfNotifier = 0 {
        didSet { debugPrint("Updater = \(numberOfUpdater), State = \(numberOfState), Notifier = \(numberOfNotifier)") }
    }

}

func runOnMainThread<T>(action: () -> T) -> T {
    if Thread.isMainThread {
        return action()
    } else {
        return DispatchQueue.main.sync {
            action()
        }
    }
}
