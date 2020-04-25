//
//  Removable.swift
//  MobS
//
//  Created by MYUNGHOON HONG on 2020/04/24.
//

import Foundation

public protocol Removable {
    func remove()
}

extension Removable {

    public func removed(by remover: MobS.Remover) {
        remover.add(removable: self)
    }
    
}
