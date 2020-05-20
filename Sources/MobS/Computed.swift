//
//  Computed.swift
//  MobS
//
//  Created by MYUNGHOON HONG on 2020/04/29.
//

import Foundation

extension MobS {

    @propertyWrapper
    public final class Computed<T> {

        private var value: T? { didSet { notifier() } }
        private var notifier = Notifier()
        private var observer: Observer?

        public var wrappedValue: T {
            get {
                runOnMainThread {
                    guard let value = value else {
                        fatalError("You must call initComputed before use.")
                    }
                    checkActiveObserver()
                    return value
                }
            }
        }

        public var projectedValue: Computed<T> {
            self
        }

        public init() {
            if MobS.isTraceEnabled {
                runOnMainThread {
                    MobS.numberOfComputed += 1
                }
            }
        }

        deinit {
            runOnMainThread {
                observer?.remove()
                if MobS.isTraceEnabled {
                    MobS.numberOfComputed -= 1
                }
            }
        }
        
        public func initComputed<O: AnyObject>(with owner: O,_ transform: @escaping (O) -> T) {
            guard observer == nil else {
                fatalError("initComputed was already called.")
            }

            observer = MobS.addObserver(isForComputed: true) { [weak owner, weak self] in
                guard let owner = owner, let self = self else { return }
                self.value = transform(owner)
            }
        }

        public func initComputed(_ transform: @escaping () -> T) {
            guard observer == nil else {
                fatalError("initComputed was already called.")
            }

            observer = MobS.addObserver(isForComputed: true) { [weak self] in
                guard let self = self else { return }
                self.value = transform()
            }
        }

        public func addObserver<O: RemoverOwner>(with owner: O, action: @escaping (O, T) -> Void) {
            MobS.addObserver(isForComputed: false) { [weak owner, weak self] in
                guard let owner = owner, let self = self else { return }
                action(owner, self.wrappedValue)
            }.removed(by: owner.remover)
        }

        public func addObserver<O: RemoverOwner>(with owner: O, runIf: @escaping (O) -> Bool, action: @escaping (O, T) -> Void) {
            MobS.addObserver(isForComputed: false, observables: [self]) { [weak owner, weak self] in
                guard let owner = owner, let self = self else { return }
                if runIf(owner) {
                    action(owner, self.wrappedValue)
                }
            }.removed(by: owner.remover)
        }

        public func bind<O: RemoverOwner>(to owner: O, keyPath: ReferenceWritableKeyPath<O, T>) {
            MobS.addObserver { [weak owner, weak self] in
                guard let owner = owner, let self = self else { return }
                owner[keyPath: keyPath] = self.wrappedValue
            }.removed(by: owner.remover)
        }

        public func bind<O: RemoverOwner, R>(to owner: O, keyPath: ReferenceWritableKeyPath<O, R>, transform: @escaping (T) -> R) {
            MobS.addObserver { [weak owner, weak self] in
                guard let owner = owner, let self = self else { return }
                owner[keyPath: keyPath] = transform(self.wrappedValue)
            }.removed(by: owner.remover)
        }

    }

}

extension MobS.Computed: ActiveObserverChecker {

    func checkActiveObserver() {
        if let activeObserver = MobS.activeObservers.last {
            activeObserver.add(notifier: notifier)
            notifier.add(observer: activeObserver)
        }

    }

}
