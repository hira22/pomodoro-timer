//
//  ContentView.swift
//  Shared
//
//  Created by Masayuki Hiraoka on 2020/09/10.
//  Copyright © 2020 moca. All rights reserved.
//

import SwiftUI
import Combine

struct ContentView: View {
    
    @ObservedObject var timer: PomodoroTimer = .init()
    
    var body: some View {
        ZStack {
            
            BackView(workTime: $timer.isInWorkTime)
            
            VStack(alignment: .center, spacing: 200.0) {
                Counter(count: $timer.count, working: $timer.isInWorkTime)
                    .padding(.vertical, 8.0)
                    .padding(.horizontal, 32.0)
                
                Button(action: { timer.start() }) {
                    Text(timer.starting ? "RESTART": "START")
                        .frame(width: 200, height: 80)
                        .foregroundColor(.white)
                        .background(timer.starting ? Color.red : Color.green)
                        .cornerRadius(40)
                }
                
            }
            
        }
    }
}

struct BackView: View {
    @Binding var workTime: Bool
    
    var body: some View {
        workTime ? Color.black.edgesIgnoringSafeArea(.all) : Color.white.edgesIgnoringSafeArea(.all)
    }
}

struct Counter: View {
    let formatter: DateComponentsFormatter = {
        let f = DateComponentsFormatter()
        f.unitsStyle = .positional
        f.allowedUnits = [ .hour, .minute, .second ]
        f.zeroFormattingBehavior = [ .pad ]
        return f
    }()
    
    @Binding var count: TimeInterval
    @Binding var working: Bool
    
    var body: some View {
        Text(formatter.string(from: count)!)
            .foregroundColor(working ? .white : .gray)
            .font(.title)
            .fontWeight(.medium)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

