//
//  CustomDispatchGroup.swift
//  Task
//
//  Created by Alberto Martínez Fernández on 01/03/2020.
//  Copyright © 2020 Alberto Martínez Fernández. All rights reserved.
//

import UIKit

class CustomDispatchGroup {
    private var internalCount: Int = 0
    private let internalQueue: DispatchQueue = DispatchQueue(label: "LockingQueue")
    private let dispatchGroup: DispatchGroup = DispatchGroup()

    var count: Int {
        get {
            return internalQueue.sync { internalCount }
        }

        set (newState) {
            internalQueue.sync { internalCount = newState }
        }
    }

    public func notify(qos: DispatchQoS = .unspecified, flags: DispatchWorkItemFlags = [], queue: DispatchQueue, execute work: @escaping @convention(block) () -> Void) {
        dispatchGroup.notify(qos: qos, flags: flags, queue: queue, execute: work)
    }

    func enter() {
        count += 1
        dispatchGroup.enter()
    }

    func leave() {
        guard count > 0 else {
            return
        }
        count -= 1
        dispatchGroup.leave()
    }
}
