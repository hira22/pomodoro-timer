//
//  ContentView.swift
//  pomodoro-timer
//
//  Created by private on 2020/02/16.
//  Copyright © 2020 moca. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @State var timer: Timer?
    @State var count: TimeInterval = 0.0 {
        didSet {
            self.isRestTime = {
                if case 0...5 = Int(count) / 60 % 60 % 25 {
                    // TODO: for Debug
                    // if case 0...5 = Int(count) % 60 % 25 {
                    return true
                }
                return false
            }()
        }
    }
    
    var timeCount: String {
        let formatter = DateComponentsFormatter()
        formatter.unitsStyle = .positional
        formatter.allowedUnits = [ .hour, .minute, .second ]
        formatter.zeroFormattingBehavior = [ .pad ]
        return formatter.string(from: count)!
    }
    
    @State var isRestTime: Bool = false
    
    var body: some View {
        ZStack {
            if $isRestTime.wrappedValue {
                Color.yellow.edgesIgnoringSafeArea(.all)
            } else {
                Color.green.edgesIgnoringSafeArea(.all)
            }
            VStack {
                Text(timeCount)
                // TODO: for Debug
                // Text("\(Int(count) % 60 % 5)")
                HStack {
                    Button("start") {
                        self.timer?.invalidate()
                        self.timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { timer in
                            self.count += timer.timeInterval
                        })
                    }
                    Button("reset") {
                        self.timer?.invalidate()
                        self.$count.wrappedValue = 0.0
                        self.timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { timer in
                            self.count += timer.timeInterval
                        })
                    }
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
