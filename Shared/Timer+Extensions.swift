//
//  Timer+Extensions.swift
//  pomodoro-timer
//
//  Created by Masayuki Hiraoka on 2020/09/11.
//  Copyright © 2020 moca. All rights reserved.
//

import Foundation

extension Timer {
    /// `HH:mm:ss`へのフォーマッター
    static let formatter: DateComponentsFormatter = {
        let f = DateComponentsFormatter()
        f.unitsStyle = .positional
        f.allowedUnits = [ .hour, .minute, .second ]
        f.zeroFormattingBehavior = [ .pad ]
        return f
    }()
}
