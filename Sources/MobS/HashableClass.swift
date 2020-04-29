//
//  HashableClass.swift
//  MobS
//
//  Created by MYUNGHOON HONG on 2020/04/30.
//

import Foundation

extension MobS {

    public class HashableClass {

        private(set) lazy var hashableID = ObjectIdentifier(self).hashValue

    }

}

extension MobS.HashableClass: Hashable {

    public static func == (lhs: MobS.HashableClass, rhs: MobS.HashableClass) -> Bool {
        lhs.hashableID == rhs.hashableID
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(hashableID)
    }

}
