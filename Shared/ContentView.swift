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
    
    @ObservedObject private var timer: PomodoroTimer = .init()
    
    var body: some View {
        ZStack {
            BackView(workTime: $timer.isInWorkTime)
            
            VStack(alignment: .center, spacing: 200.0) {
                CounterView(count: $timer.count, working: $timer.isInWorkTime)
                    .padding(.vertical, 8.0)
                    .padding(.horizontal, 32.0)
                
                Button(action: { timer.start() }) {
                    ButtonText(starting: $timer.starting)
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

struct CounterView: View {
    @Binding var count: TimeInterval
    @Binding var working: Bool
    
    var body: some View {
        Text(Timer.formatter.string(from: count) ?? "00:00:00")
            .foregroundColor(working ? .white : .gray)
            .font(.title)
            .fontWeight(.medium)
    }
}

struct ButtonText: View {
    @Binding var starting: Bool
    
    var body: some View {
        Text( starting ? "RESTART": "START")
            .frame(width: 200, height: 80)
            .foregroundColor(.white)
            .background( starting ? Color.red : Color.green)
            .cornerRadius(40)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
