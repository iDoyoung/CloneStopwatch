//
//  Double+ToTime.swift
//  StopWatch
//
//  Created by Doyoung on 2022/07/29.
//

import Foundation

extension Double {
    
    func toCountingTime() -> String {
        let hours = Int(self)/3600
        let minutes = Int(self)%3600/60
        let seconds = Int(self)%3600%60
        let centisecond = Int((self.truncatingRemainder(dividingBy: 1) * 100).rounded())
        
        return hours == 0 ? String(format: "%02d:%02d.%02d", minutes, seconds, centisecond):
                            String(format: "%02d:%02d:%02d.%02d", hours, minutes, seconds, centisecond)
    }
}
