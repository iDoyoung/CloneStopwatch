//
//  Lap.swift
//  StopWatch
//
//  Created by Doyoung on 2022/07/29.
//

import Foundation

struct Lap: Equatable {
    var index: Int
    var times: Double
    
    static func == (lhs: Lap, rhs: Lap) -> Bool {
        lhs.index == rhs.index
    }
    
}
