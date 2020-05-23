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
        private lazy var notifier = Notifier()

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
                    if let activeObserver = MobS.activeObservers.last {
                        activeObserver.add(toNotifier: notifier)
                    }
                    value = newValue
                    notifier()
                }
            }
        }

        public var projectedValue: Observable<T> {
            self
        }

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
                notifier.removeAll()
                runOnMainThread {
                    MobS.numberOfObservable -= 1
                }
            }
        }

        @discardableResult
        public func addObserver<O: RemoverOwner>(with owner: O,
                                                 useRemover: Bool = true,
                                                 action: @escaping (O, T) -> Void) -> Removable {
            owner.addObserver(useRemover: useRemover) { [weak self] (owner) in
                guard let self = self else { return }
                action(owner, self.wrappedValue)
            }
        }

        @discardableResult
        public func addObserver<O: RemoverOwner>(with owner: O,
                                                 useRemover: Bool = true,
                                                 action: @escaping (O, T, Bool) -> Void) -> Removable {
            var isFirstCall = true
            return owner.addObserver(useRemover: useRemover) { [weak self] (owner) in
                guard let self = self else { return }
                action(owner, self.wrappedValue, isFirstCall)
                isFirstCall = false
            }
        }

        @discardableResult
        public func bind<O: RemoverOwner>(to owner: O,
                                          keyPath: ReferenceWritableKeyPath<O, T>,
                                          useRemover: Bool = true) -> Removable {
            owner.addObserver(useRemover: useRemover) { [weak self] (owner) in
                guard let self = self else { return }
                owner[keyPath: keyPath] = self.wrappedValue
            }
        }

        @discardableResult
        public func bind<O: RemoverOwner, R>(to owner: O,
                                             keyPath: ReferenceWritableKeyPath<O, R>,
                                             transform: @escaping (T) -> R,
                                             useRemover: Bool = true) -> Removable {
            owner.addObserver(useRemover: useRemover) { [weak self] (owner) in
                guard let self = self else { return }
                owner[keyPath: keyPath] = transform(self.wrappedValue)
            }
        }

    }

}
