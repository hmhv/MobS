//
//  MobSObserverCheckable.swift
//  MobS
//
//  Created by MYUNGHOON HONG on 2020/05/28.
//

import Foundation

public protocol MobSObserverCheckable {
    func checkObserver()
}

public extension Array where Element == MobSObserverCheckable {

    @discardableResult
    func addObserver<O: MobSRemoverOwner>(with owner: O,
                                      skipInitialCall: Bool = false,
                                      useRemover: Bool = true,
                                      action: @escaping (O) -> Void) -> MobSRemovable {
        let observer = MobS.addObserver(observables: self, skipInitialCall: skipInitialCall) { [weak owner] in
            guard let owner = owner else { return }
            action(owner)
        }
        if useRemover {
            observer.removed(by: owner.remover)
        }
        return observer
    }

}
