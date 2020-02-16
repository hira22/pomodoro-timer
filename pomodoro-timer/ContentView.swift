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
    
    @State var isWorkTime: Bool = true
    
    var body: some View {
        ZStack {
            if $isWorkTime.wrappedValue {
                Color.black.edgesIgnoringSafeArea(.all)
            } else {
                Color.white.edgesIgnoringSafeArea(.all)
            }
            VStack(alignment: .center, spacing: 150.0) {
                Spacer()
                // COUNTER
                ZStack {
                    Rectangle()
                        .frame(height: 48.0)
                        .foregroundColor(.white)
                        .cornerRadius(12, antialiased:  true)
                    Text(timeCount)
                        .foregroundColor(.gray)
                        .font(.title)
                        .fontWeight(.medium)
                        .padding(.vertical, 8.0)
                        .padding(.horizontal, 32.0)
                }
                // TODO: for Debug
                // Text("\(Int(count) % 60 % 30)")
                
                Spacer()
//                HStack(alignment: .center, spacing: 100.0) {
                    
                if count < 1 {
                        
                        // START
                        Button(
                            action: { self.timer?.invalidate()
                                self.timer = Timer.scheduledTimer(withTimeInterval: 1.0,
                                                                  repeats: true) { timer in
                                                                    self.count += timer.timeInterval } },
                            label: { Text("START").foregroundColor(.white).padding(.vertical, 8.0) }
                        ).background(
                            Rectangle()
                                .frame(width: 100.0, height: 100.0)
                                .foregroundColor(.green)
                                .cornerRadius(50, antialiased:  true)
                        )
                    } else {
                        
                        //RE-START
                        Button(
                            action: {
                                self.timer?.invalidate()
                                self.$count.wrappedValue = 0.0
                                self.timer = Timer.scheduledTimer(withTimeInterval: 1.0,
                                                                  repeats: true) { timer in
                                                                    self.count += timer.timeInterval } },
                            label: { Text("RESTART").foregroundColor(.white).padding(.vertical, 8.0)}
                        ).background(
                            Rectangle()
                                .frame(width: 100.0, height: 100.0)
                                .foregroundColor(.red)
                                .cornerRadius(50, antialiased:  true)
                        )
                    }
                    
//                }
                Spacer()
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
