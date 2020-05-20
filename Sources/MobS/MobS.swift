//
//  MobS.swift
//  MobS
//
//  Created by MYUNGHOON HONG on 2020/04/24.
//

import Foundation

public final class MobS {

    public static func addObserver<O: RemoverOwner>(with owner: O, action: @escaping (O) -> Void) -> Removable {
        MobS.addObserver { [weak owner] in
            guard let owner = owner else { return }
            action(owner)
        }
    }

    public static func addObserver(action: @escaping () -> Void) -> Removable {
        addObserver(isForComputed: false, action: action)
    }

    public static func updateState(action: () -> Void) {
        runOnMainThread {
            if MobS.batchRunner == nil {
                MobS.batchRunner = BatchRunner()
                action()
                MobS.batchRunner = nil
            } else {
                action()
            }
        }
    }

}

extension MobS {

    private(set) static var activeObservers: [Observer] = []
    static var batchRunner: BatchRunner?

    static func addObserver(isForComputed: Bool, action: @escaping () -> Void) -> Observer {
        runOnMainThread {
            MobS.activeObservers.append(Observer(action: action, isForComputed: isForComputed))
            action()
            return MobS.activeObservers.removeLast()
        }
    }

}

extension MobS {

    public static var isTraceEnabled = false {
        didSet {
            numberOfObservable = 0
            numberOfComputed = 0
            numberOfObserver = 0
        }
    }

    static var numberOfObservable = 0 {
        didSet { printTraceInfo() }
    }
    static var numberOfComputed = 0 {
        didSet { printTraceInfo() }
    }
    static var numberOfObserver = 0 {
        didSet { printTraceInfo() }
    }
    static func printTraceInfo() {
        debugPrint("Observable (\(numberOfObservable)), Computed (\(numberOfComputed)), Observer (\(numberOfObserver))")
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
