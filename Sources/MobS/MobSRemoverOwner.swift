//
//  MobSRemoverOwner.swift
//  MobS
//
//  Created by MYUNGHOON HONG on 2020/04/24.
//

import Foundation

private var removerContext = 0

public protocol MobSRemoverOwner: AnyObject {
    var remover: MobS.Remover { get set }
}

extension MobSRemoverOwner {

    public var remover: MobS.Remover {
        get {
            runOnMainThread {
                if let remover = objc_getAssociatedObject(self, &removerContext) as? MobS.Remover {
                    return remover
                }
                let remover = MobS.Remover()
                objc_setAssociatedObject(self, &removerContext, remover, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
                return remover
            }
        }
        set {
            runOnMainThread {
                objc_setAssociatedObject(self, &removerContext, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            }
        }
    }

}

extension NSObject: MobSRemoverOwner {}
