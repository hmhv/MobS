//
//  State.swift
//  MobS
//
//  Created by MYUNGHOON HONG on 2020/04/24.
//

import Foundation

extension MobS {

    @propertyWrapper
    public final class State<T> {

        private var state: T
        private var notifier = Notifier()

        public init(initialState: T) {
            self.state = initialState
            if MobS.isTraceEnabled {
                MobS.numberOfState += 1
            }
        }

        deinit {
            notifier.remove()
            if MobS.isTraceEnabled {
                MobS.numberOfState -= 1
            }
        }

        public var wrappedValue: T {
            get {
                runOnMainThread {
                    if let activeUpdater = MobS.activeUpdaters.last {
                        activeUpdater.add(notifier: notifier)
                        notifier.add(updater: activeUpdater)
                    }
                    return state
                }
            }
            set {
                runOnMainThread {
                    state = newValue
                    if let batchUpdater = MobS.batchUpdater {
                        batchUpdater.add(updater: notifier.updaters)
                    } else {
                        notifier()
                    }
                }
            }
        }

        public var projectedValue: State<T> {
            self
        }

        public func addUpdater<O: RemoverOwner>(with owner: O, action: @escaping (O, T) -> Void) {
            MobS.addUpdater { [weak owner, weak self] in
                guard let owner = owner, let self = self else { return }
                action(owner, self.wrappedValue)
            }.removed(by: owner.remover)
        }

        public func bind<O: RemoverOwner>(to owner: O, keyPath: ReferenceWritableKeyPath<O, T>) {
            MobS.addUpdater { [weak owner, weak self] in
                guard let owner = owner, let self = self else { return }
                owner[keyPath: keyPath] = self.wrappedValue
            }.removed(by: owner.remover)
        }

        public func bind<O: RemoverOwner, R>(to owner: O, keyPath: ReferenceWritableKeyPath<O, R>, transform: @escaping (T) -> R) {
            MobS.addUpdater { [weak owner, weak self] in
                guard let owner = owner, let self = self else { return }
                owner[keyPath: keyPath] = transform(self.wrappedValue)
            }.removed(by: owner.remover)
        }

    }

}

extension MobS.State: Hashable {

    public static func == (lhs: MobS.State<T>, rhs: MobS.State<T>) -> Bool {
        lhs.notifier == rhs.notifier
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(notifier)
    }

}
