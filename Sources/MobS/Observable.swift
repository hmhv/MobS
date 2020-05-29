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

        private var activeObserversBackup: [Observer] = []

        public var wrappedValue: T {
            get {
                runOnMainThread {
                    value
                }
            }
            set {
                runOnMainThread {
                    if activeObserversBackup.count > 0 {
                        fatalError("You have a circular reference. check observables in addObserver() action block.")
                    }
                    if let activeObserver = MobS.activeObservers.last {
                        activeObserver.add(toNotifier: notifier)
                        activeObserversBackup = MobS.activeObservers
                        MobS.activeObservers = []
                        value = newValue
                        notifier()
                        MobS.activeObservers = activeObserversBackup
                        activeObserversBackup = []
                    } else {
                        value = newValue
                        notifier()
                    }
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
        public func addObserver<O: MobSRemoverOwner>(with owner: O,
                                                 skipInitialCall: Bool = false,
                                                 useRemover: Bool = true,
                                                 action: @escaping (O) -> Void) -> MobSRemovable {
            let observer = MobS.addObserver(observables: [self], skipInitialCall: skipInitialCall) { [weak owner] in
                guard let owner = owner else { return }
                action(owner)
            }
            if useRemover {
                observer.removed(by: owner.remover)
            }
            return observer
        }

        public func bind<O: MobSRemoverOwner>(to owner: O,
                                          keyPath: ReferenceWritableKeyPath<O, T>) {
            MobS.addObserver(observables: [self], skipInitialCall: false) { [weak self, weak owner] in
                guard let self = self, let owner = owner else { return }
                owner[keyPath: keyPath] = self.wrappedValue
            }.removed(by: owner.remover)
        }

        public func bind<O: MobSRemoverOwner, R>(to owner: O,
                                             keyPath: ReferenceWritableKeyPath<O, R>,
                                             transform: @escaping (T) -> R) {
            MobS.addObserver(observables: [self], skipInitialCall: false) { [weak self, weak owner] in
                guard let self = self, let owner = owner else { return }
                owner[keyPath: keyPath] = transform(self.wrappedValue)
            }.removed(by: owner.remover)
        }

    }

}

extension MobS.Observable: MobSObserverCheckable {

    /// Don't call this method directly. For internal use only.
    public func checkObserver() {
        if let activeObserver = MobS.activeObservers.last {
            activeObserver.add(notifier: notifier)
            notifier.add(observer: activeObserver)
        }
    }

}
