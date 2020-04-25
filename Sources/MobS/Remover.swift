//
//  Remover.swift
//  MobS
//
//  Created by MYUNGHOON HONG on 2020/04/24.
//

import Foundation

extension MobS {
    
    public final class Remover {

        deinit {
            removeAll()
        }

        public func add(removable: Removable) {
            runOnMainThread {
                removables.append(removable)
            }
        }

        public func removeAll() {
            runOnMainThread {
                removables.forEach { $0.remove() }
                removables.removeAll()
            }
        }

        private var removables: [Removable] = []

    }

}
