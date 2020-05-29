//
//  MobS.swift
//  MobS
//
//  Created by MYUNGHOON HONG on 2020/04/24.
//

import Foundation

public final class MobS {

    public static func updateState(action: () -> Void) {
        runOnMainThread {
            if MobS.batchRunner == nil {
                let batchRunner = BatchRunner()
                MobS.batchRunner = batchRunner

                action()

                batchRunner()
                MobS.batchRunner = nil
            } else {
                action()
            }
        }
    }

}

extension MobS {

    static var activeObservers: [Observer] = []
    static var batchRunner: BatchRunner?

    static func addObserver(observables: [MobSObserverCheckable], skipInitialCall: Bool, action: @escaping () -> Void) -> MobSRemovable {
        runOnMainThread {
            MobS.activeObservers.append(Observer(action: action))
            observables.forEach { $0.checkObserver() }
            if !skipInitialCall {
                action()
            }
            return MobS.activeObservers.removeLast()
        }
    }

}

extension MobS {

    public static var isTraceEnabled = false {
        didSet {
            numberOfObservable = 0
            numberOfObserver = 0
        }
    }

    static var numberOfObservable = 0 {
        didSet { printTraceInfo() }
    }

    static var numberOfObserver = 0 {
        didSet { printTraceInfo() }
    }

    static func printTraceInfo() {
        debugPrint("Observable (\(numberOfObservable)), Observer (\(numberOfObserver))")
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
