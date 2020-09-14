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
    @Published var isInWorkTime: Bool = true
    
    private var timerPublisher: Timer.TimerPublisher = Timer.publish(every: 1, on: .main, in: .common)
    
    private var timerSubscription: AnyCancellable?
    private var subscriptions: Set<AnyCancellable> = []
    
    init() {
        $count
            .map { (timeInterval: TimeInterval) -> Bool in
                0...24 ~= Int(timeInterval) / 60 % 60 % 30
                // MARK: DEBUG
                // 0...24 ~= Int(timeInterval) % 60 % 30
            }
            .assign(to: \.isInWorkTime, on: self)
            .store(in: &subscriptions)
        
        $count.map { (timeInterval: TimeInterval) -> Bool in
            !timeInterval.isZero
        }
        .assign(to: \.starting, on: self)
        .store(in: &subscriptions)
    }
    
    func start() {
        timerSubscription?.cancel()
        let startAt: Date = .init()
        
        timerSubscription = timerPublisher
            .map { (output: Timer.TimerPublisher.Output) -> TimeInterval in
                output.timeIntervalSince(startAt)
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
        
        _ = timerPublisher.connect()
    }
    
}
