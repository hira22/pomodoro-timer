//
//  ContentView.swift
//  pomodoro-timer
//
//  Created by private on 2020/02/16.
//  Copyright © 2020 moca. All rights reserved.
//

import SwiftUI
import Combine

struct ContentView: View {
    @State private var timer: Timer.TimerPublisher = Timer.publish(every: 1, on: .main, in: .common)
    @State private var count: TimeInterval = 0.0
    @State private var cancellable: Cancellable?
    @State private var isTimerStarting: Bool = false
    
    var body: some View {
        ZStack {
            backgroundView
            VStack(alignment: .center, spacing: 200.0) {
                pomodoroCounterView
                    .padding(.vertical, 8.0)
                    .padding(.horizontal, 32.0)
                startButton
            }
            
        // Is this correct? 🤔
        }.onReceive(timer) { _ in
            self.count += 1.0
        }
    }
}

private extension ContentView {
    
    var isInWorkTime: Bool {
        if case 0...24 = Int(count) / 60 % 60 % 30 {
        // for Debug
//        if case 0...24 = Int(count) % 60 % 30 {
            return true
        }
        return false
    }
    
    var backgroundView: some View {
        isInWorkTime ? Color.black.edgesIgnoringSafeArea(.all) : Color.white.edgesIgnoringSafeArea(.all)
    }
    
    var pomodoroCounterView: some View {
        
        let formatter = DateComponentsFormatter()
        formatter.unitsStyle = .positional
        formatter.allowedUnits = [ .hour, .minute, .second ]
        formatter.zeroFormattingBehavior = [ .pad ]
        
        return Text(formatter.string(from: count)!)
            .foregroundColor(isInWorkTime ? .white : .gray)
            .font(.title)
            .fontWeight(.medium)
    }
    
    var startButton: some View {
        let text: String = isTimerStarting ? "RESTART": "START"
        let color: Color = isTimerStarting ? .red : .green
        return Button(
            action: {
                // Is this correct? 🤔
                self.cancellable?.cancel()
                self.count = 0.0
                self.timer = Timer.publish(every: 1, on: .main, in: .common)
                self.cancellable = self.timer.connect()
                self.isTimerStarting = true },
            label: {
                Text(text)
                    .frame(width: 200, height: 80)
                    .foregroundColor(.white)
                    .background(color)
                    .cornerRadius(40) }
        )
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
