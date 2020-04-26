//
//  MobS.swift
//  MobS
//
//  Created by MYUNGHOON HONG on 2020/04/24.
//

import Foundation

public final class MobS {

    private(set) static var activeObservers: [Observer] = []
    private(set) static var batchRunner: BatchRunner?

    public static func addObserver(action: @escaping () -> Void) -> Removable {
        runOnMainThread {
            MobS.activeObservers.append(Observer(action: action))
            action()
            return MobS.activeObservers.removeLast()
        }
    }

    public static func updateState(action: () -> Void) {
        runOnMainThread {
            if MobS.batchRunner == nil {
                MobS.batchRunner = BatchRunner()
                action()
                MobS.batchRunner?()
                MobS.batchRunner = nil
            } else {
                action()
            }
        }
    }

}

extension MobS {

    public static var isTraceEnabled = false {
        didSet {
            numberOfObserver = 0
            numberOfState = 0
            numberOfNotifier = 0
        }
    }

    static var numberOfObserver = 0 {
        didSet { debugPrint("Observer (\(numberOfObserver)), State (\(numberOfState)), Notifier (\(numberOfNotifier))") }
    }
    static var numberOfState = 0 {
        didSet { debugPrint("Observer (\(numberOfObserver)), State (\(numberOfState)), Notifier (\(numberOfNotifier))") }
    }
    static var numberOfNotifier = 0 {
        didSet { debugPrint("Observer (\(numberOfObserver)), State (\(numberOfState)), Notifier (\(numberOfNotifier))") }
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
