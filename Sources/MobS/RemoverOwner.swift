//
//  RemoverOwner.swift
//  MobS
//
//  Created by MYUNGHOON HONG on 2020/04/24.
//

import Foundation

private var removerContext = 0

public protocol RemoverOwner: AssociatedObjectOwner {
    var remover: MobS.Remover { get set }
}

extension RemoverOwner {

    public var remover: MobS.Remover {
        get {
            runOnMainThread {
                getAssociatedObject(key: &removerContext, initialObject: MobS.Remover())
            }
        }
        set {
            runOnMainThread {
                setAssociatedObject(key: &removerContext, object: newValue)
            }
        }
    }

}

extension RemoverOwner {

    public func addObserver(action: @escaping (Self) -> Void) {
        MobS.addObserver { [weak self] in
            guard let self = self else { return }
            action(self)
        }.removed(by: remover)
    }

}

extension NSObject: RemoverOwner {}
