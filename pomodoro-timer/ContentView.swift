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
            self.isWorkTime = {
                if case 0...24 = Int(count) / 60 % 60 % 30 {
                    // TODO: for Debug
                    // if case 0...24 = Int(count) % 60 % 30 {
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
    
    @State var isWorkTime: Bool = false
    
    var body: some View {
        ZStack {
            if $isWorkTime.wrappedValue {
                Color.green.edgesIgnoringSafeArea(.all)
            } else {
                Color.white.edgesIgnoringSafeArea(.all)
            }
            VStack {
                Text(timeCount)
                // TODO: for Debug
                // Text("\(Int(count) % 60 % 30)")
                 Text("\(Int(count) / 60 % 60 % 30)")
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
