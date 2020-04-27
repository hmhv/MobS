//
//  AssociatedObjectOwner.swift
//  MobS
//
//  Created by MYUNGHOON HONG on 2020/04/27.
//

import Foundation

public protocol AssociatedObjectOwner: AnyObject {
    func getAssociatedObject<T>(key: UnsafeRawPointer, initialObject: @autoclosure () -> T) -> T
    func setAssociatedObject<T>(key: UnsafeRawPointer, object: T?)
}

extension AssociatedObjectOwner {

    public func getAssociatedObject<T>(key: UnsafeRawPointer, initialObject: @autoclosure () -> T) -> T {
        if let object = objc_getAssociatedObject(self, key) as? T {
            return object
        }
        let object = initialObject()
        objc_setAssociatedObject(self, key, object, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        return object
    }

    public func setAssociatedObject<T>(key: UnsafeRawPointer, object: T?) {
        objc_setAssociatedObject(self, key, object, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }

}
