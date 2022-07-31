//
//  Timer.swift
//  StopWatch
//
//  Created by Doyoung on 2022/07/31.
//

import Foundation

struct StopwatchTimer: Codable {
    
    let userID: String
    let mainTimer: Double
    let lapTimer: Double
    let laps: [Lap]
    let isStop: Bool
    
    enum CodingKeys: String, CodingKey {
        case userID = "user_id"
        case mainTimer = "main_timer"
        case lapTimer = "lap_timer"
        case laps
        case isStop = "is_stop"
    }
    
}
