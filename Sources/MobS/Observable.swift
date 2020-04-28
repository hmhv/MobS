//
//  State.swift
//  MobS
//
//  Created by MYUNGHOON HONG on 2020/04/24.
//

import Foundation

extension MobS {

    @propertyWrapper
    public final class Observable<T> {

        private var value: T
        private var notifier = Notifier()

        public init(value: T) {
            self.value = value
            if MobS.isTraceEnabled {
                runOnMainThread {
                    MobS.numberOfObservable += 1
                }
            }
        }

        deinit {
            if MobS.isTraceEnabled {
                runOnMainThread {
                    MobS.numberOfObservable -= 1
                }
            }
        }

        public var wrappedValue: T {
            get {
                runOnMainThread {
                    if let activeObserver = MobS.activeObservers.last {
                        activeObserver.add(notifier: notifier)
                        notifier.add(observer: activeObserver)
                    }
                    return value
                }
            }
            set {
                runOnMainThread {
                    value = newValue
                    if let batchRunner = MobS.batchRunner {
                        batchRunner.add(observer: notifier.observers)
                    } else {
                        notifier()
                    }
                }
            }
        }

        public var projectedValue: Observable<T> {
            self
        }

        public func addObserver<O: RemoverOwner>(with owner: O, action: @escaping (O, T) -> Void) {
            MobS.addObserver { [weak owner, weak self] in
                guard let owner = owner, let self = self else { return }
                action(owner, self.wrappedValue)
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

extension MobS.Observable: Hashable {

    public static func == (lhs: MobS.Observable<T>, rhs: MobS.Observable<T>) -> Bool {
        lhs.notifier == rhs.notifier
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(notifier)
    }

}
