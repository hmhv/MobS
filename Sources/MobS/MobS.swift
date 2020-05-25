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

    public static func addObserver<O: RemoverOwner>(with owner: O, action: @escaping (O, Bool) -> Void) -> Removable {
        var isFirstCall = true
        return MobS.addObserver { [weak owner] in
            guard let owner = owner else { return }
            action(owner, isFirstCall)
            isFirstCall = false
        }
    }

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
