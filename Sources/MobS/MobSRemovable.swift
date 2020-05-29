//
//  MobSRemovable.swift
//  MobS
//
//  Created by MYUNGHOON HONG on 2020/04/24.
//

import Foundation

public protocol MobSRemovable {
    func remove()
}

extension MobSRemovable {

    public func removed(by remover: MobS.Remover) {
        remover.add(removable: self)
    }
    
}
