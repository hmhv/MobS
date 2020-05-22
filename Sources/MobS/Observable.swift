//
//  State.swift
//  MobS
//
//  Created by MYUNGHOON HONG on 2020/04/24.
//

import Foundation

protocol ActiveObserverChecker {
    func checkActiveObserver()
}

extension MobS {

    @propertyWrapper
    public final class Observable<T> {

        private var value: T
        private lazy var notifier = Notifier()

        public var wrappedValue: T {
            get {
                runOnMainThread {
                    checkActiveObserver()
                    return value
                }
            }
            set {
                runOnMainThread {
                    guard MobS.activeObservers.last == nil else {
                        fatalError("You can not change observable in observer's action. Use MobS.Computed instead.")
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
                runOnMainThread {
                    MobS.numberOfObservable -= 1
                }
            }
        }

        @discardableResult
        public func addObserver<O: RemoverOwner>(with owner: O,
                                                 useRemover: Bool = true,
                                                 skipFirst: Bool = false,
                                                 runIf: @escaping (O) -> Bool = { _ in true },
                                                 action: @escaping (O, T) -> Void) -> Removable {

            let wrappedAction = { [weak owner, weak self] in
                guard let owner = owner, let self = self else { return }
                if runIf(owner) {
                    action(owner, self.wrappedValue)
                }
            }

            let observer = MobS.addObserver(isForComputed: false,
                                            observables: [self],
                                            action: wrappedAction)
            if !skipFirst {
                wrappedAction()
            }

            if useRemover {
                observer.removed(by: owner.remover)
            }

            return observer
        }

        public func bind<O: RemoverOwner>(to owner: O,
                                          keyPath: ReferenceWritableKeyPath<O, T>) {
            MobS.addObserver { [weak owner, weak self] in
                guard let owner = owner, let self = self else { return }
                owner[keyPath: keyPath] = self.wrappedValue
            }.removed(by: owner.remover)
        }

        public func bind<O: RemoverOwner, R>(to owner: O,
                                             keyPath: ReferenceWritableKeyPath<O, R>,
                                             transform: @escaping (T) -> R) {
            MobS.addObserver { [weak owner, weak self] in
                guard let owner = owner, let self = self else { return }
                owner[keyPath: keyPath] = transform(self.wrappedValue)
            }.removed(by: owner.remover)
        }

    }

}

extension MobS.Observable: ActiveObserverChecker {

    func checkActiveObserver() {
        if let activeObserver = MobS.activeObservers.last {
            activeObserver.add(notifier: notifier)
            notifier.add(observer: activeObserver)
        }
    }

}
