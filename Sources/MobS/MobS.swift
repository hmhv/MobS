//
//  MobS.swift
//  MobS
//
//  Created by MYUNGHOON HONG on 2020/04/24.
//

import Foundation

public final class MobS {

    public static func combine2<T1, T2>(o1: Observable<T1>,
                                        o2: Observable<T2>,
                                        skipInitialCall: Bool = false,
                                        action: @escaping (T1, T2) -> Void) -> MobSRemovable {
        addObserver(observables: [o1, o2], skipInitialCall: skipInitialCall) {
            action(o1.wrappedValue, o2.wrappedValue)
        }
    }

    public static func combine2<O: MobSRemoverOwner, T1, T2>(o1: Observable<T1>,
                                                             o2: Observable<T2>,
                                                             with owner: O,
                                                             skipInitialCall: Bool = false,
                                                             action: @escaping (O, T1, T2) -> Void) {
        MobS.addObserver(observables: [o1, o2], skipInitialCall: skipInitialCall) { [weak owner] in
            guard let owner = owner else { return }
            action(owner, o1.wrappedValue, o2.wrappedValue)
        }.removed(by: owner.remover)
    }

    public static func combine3<T1, T2, T3>(o1: Observable<T1>,
                                            o2: Observable<T2>,
                                            o3: Observable<T3>,
                                            skipInitialCall: Bool = false,
                                            action: @escaping (T1, T2, T3) -> Void) -> MobSRemovable {
        addObserver(observables: [o1, o2, o3], skipInitialCall: skipInitialCall) {
            action(o1.wrappedValue, o2.wrappedValue, o3.wrappedValue)
        }
    }

    public static func combine3<O: MobSRemoverOwner, T1, T2, T3>(o1: Observable<T1>,
                                                                 o2: Observable<T2>,
                                                                 o3: Observable<T3>,
                                                                 with owner: O,
                                                                 skipInitialCall: Bool = false,
                                                                 action: @escaping (O, T1, T2, T3) -> Void) {
        MobS.addObserver(observables: [o1, o2, o3], skipInitialCall: skipInitialCall) { [weak owner] in
            guard let owner = owner else { return }
            action(owner, o1.wrappedValue, o2.wrappedValue, o3.wrappedValue)
        }.removed(by: owner.remover)
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

    static func addObserver(observables: [ObserverCheckable], skipInitialCall: Bool, action: @escaping () -> Void) -> MobSRemovable {
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
