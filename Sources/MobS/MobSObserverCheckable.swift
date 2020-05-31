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

    func addObserver(skipInitialCall: Bool = false,
                     action: @escaping () -> Void) -> MobSRemovable {
        MobS.addObserver(observables: self, skipInitialCall: skipInitialCall) {
            action()
        }
    }

    func addObserver<O: MobSRemoverOwner>(with owner: O,
                                          skipInitialCall: Bool = false,
                                          action: @escaping (O) -> Void) {
        MobS.addObserver(observables: self, skipInitialCall: skipInitialCall) { [weak owner] in
            guard let owner = owner else { return }
            action(owner)
        }.removed(by: owner.remover)
    }

}
