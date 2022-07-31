//
//  Timer.swift
//  StopWatch
//
//  Created by Doyoung on 2022/07/31.
//

import Foundation

struct StopwatchTimer: Codable {
    
    let userID: String
    let mainStartedTime: Double?
    let lapStartedTime: Double?
    let mainTime: Double
    let lapTime: Double
    let laps: [Lap]
    let isStop: Bool
    
    enum CodingKeys: String, CodingKey {
        case userID = "user_id"
        case mainStartedTime = "main_started_time"
        case lapStartedTime = "lap_started_time"
        case mainTime = "main_time"
        case lapTime = "lap_time"
        case laps
        case isStop = "is_stop"
    }
    
}
