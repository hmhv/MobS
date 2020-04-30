//
//  Computed.swift
//  MobS
//
//  Created by MYUNGHOON HONG on 2020/04/29.
//

import Foundation

extension MobS {

    public final class Computed<T>: RemoverOwner {

        public var result: T { callAsFunction() }

        private var value: T! { didSet { notifier() } }
        private var transform: () -> T
        private var notifier = Notifier()

        public init(transform: @escaping () -> T) {
            self.transform = transform
            
            MobS.addObserver(isForComputed: true) { [weak self] in
                guard let self = self else { return }
                self.value = self.transform()
            }.removed(by: remover)

            if MobS.isTraceEnabled {
                runOnMainThread {
                    MobS.numberOfComputed += 1
                }
            }
        }

        deinit {
            if MobS.isTraceEnabled {
                runOnMainThread {
                    MobS.numberOfComputed -= 1
                }
            }
        }

        public func callAsFunction() -> T {
            runOnMainThread {
                if let activeObserver = MobS.activeObservers.last {
                    activeObserver.add(notifier: notifier)
                    notifier.add(observer: activeObserver)
                }
                return value
            }
        }

        public func addObserver<O: RemoverOwner>(with owner: O, action: @escaping (O, T) -> Void) {
            MobS.addObserver { [weak owner, weak self] in
                guard let owner = owner, let self = self else { return }
                action(owner, self.result)
            }.removed(by: owner.remover)
        }

        public func bind<O: RemoverOwner>(to owner: O, keyPath: ReferenceWritableKeyPath<O, T>) {
            MobS.addObserver { [weak owner, weak self] in
                guard let owner = owner, let self = self else { return }
                owner[keyPath: keyPath] = self.result
            }.removed(by: owner.remover)
        }

        public func bind<O: RemoverOwner, R>(to owner: O, keyPath: ReferenceWritableKeyPath<O, R>, transform: @escaping (T) -> R) {
            MobS.addObserver { [weak owner, weak self] in
                guard let owner = owner, let self = self else { return }
                owner[keyPath: keyPath] = transform(self.result)
            }.removed(by: owner.remover)
        }

    }

}
