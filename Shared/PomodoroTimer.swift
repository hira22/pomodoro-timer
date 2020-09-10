//
//  PomodoroTimer.swift
//  pomodoro-timer
//
//  Created by Masayuki Hiraoka on 2020/09/10.
//  Copyright © 2020 moca. All rights reserved.
//

import Foundation
import Combine

class PomodoroTimer: ObservableObject {
    @Published var count: TimeInterval = 0.0
    @Published var starting: Bool = false
    @Published var isInWorkTime: Bool = false
    
    private var timerCancellable: AnyCancellable?
    private var workTimeCancellable: AnyCancellable?
    
    private var startAt: Date!
    
    private var timerPublisher: Timer.TimerPublisher!
    
    init() {
        workTimeCancellable = $count
            .map { (timeInterval: TimeInterval) -> Bool in
                0...24 ~= Int(timeInterval) / 60 % 60 % 30
                // MARK: DEBUG
//                 0...24 ~= Int(timeInterval) % 60 % 30
            }
            .assign(to: \.isInWorkTime, on: self)
    }
    
    func start() {
        timerCancellable?.cancel()
        startAt = Date()
        starting = true
        timerPublisher = Timer.publish(every: 1, on: .main, in: .common)
        timerCancellable = timerPublisher
            .autoconnect()
            .map { (output: Timer.TimerPublisher.Output) -> TimeInterval in
                output.timeIntervalSince(self.startAt)
            }
            .handleEvents(receiveSubscription: { (subscription: Subscription) in
                print("subscription: \(subscription)")
            }, receiveOutput: { (double: Double) in
                print("output: \(double)")
            }, receiveCompletion: { (completion: Subscribers.Completion<Publishers.Autoconnect<Timer.TimerPublisher>.Failure>) in
                print("completion: \(completion)")
            }, receiveCancel: {
                print("cancel")
            }, receiveRequest: { (demand: Subscribers.Demand) in
                print("request: \(demand)")
            })
            .assign(to: \.count, on: self)
    }
    
}
