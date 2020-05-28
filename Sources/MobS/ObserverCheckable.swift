//
//  ObserverCheckable.swift
//  MobS
//
//  Created by MYUNGHOON HONG on 2020/05/28.
//

import Foundation

public protocol ObserverCheckable {
    func checkObserver()
}

public extension Array where Element == ObserverCheckable {

    @discardableResult
    func addObserver<O: RemoverOwner>(with owner: O,
                                      skipInitialCall: Bool = false,
                                      useRemover: Bool = true,
                                      action: @escaping (O) -> Void) -> Removable {
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
