//
//  Throttler.swift
//  telegram-charts
//
//  Created by Roman Aliyev on 3/21/19.
//  Copyright © 2019 Roman Aliyev. All rights reserved.
//

import Foundation

class Throttler {
    private var workItem: DispatchWorkItem = DispatchWorkItem(block: {})
    private var previousRun: Date = Date.distantPast
    private let queue: DispatchQueue
    private let minimumDelay: TimeInterval
    
    init(minimumDelay: TimeInterval, queue: DispatchQueue = DispatchQueue.main) {
        self.minimumDelay = minimumDelay
        self.queue = queue
    }
    
    func execute(_ block: @escaping () -> Void) {
        self.workItem.cancel()
        
        self.workItem = DispatchWorkItem() {
            [weak self] in
            self?.previousRun = Date()
            block()
        }

        let delay = abs(self.previousRun.timeIntervalSinceNow) > self.minimumDelay ? 0 : self.minimumDelay
        self.queue.asyncAfter(deadline: .now() + Double(delay), execute: self.workItem)
    }
}
