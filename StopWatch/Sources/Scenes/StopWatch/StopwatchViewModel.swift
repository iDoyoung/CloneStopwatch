//
//  StopwatchViewModel.swift
//  StopWatch
//
//  Created by Doyoung on 2022/07/27.
//

import RxSwift

protocol StopwatchViewModelInput {
    func startTimer()
    func stopTimer()
    func resetTimer()
    func lapTime()
}

class StopwatchViewModel: StopwatchViewModelInput {
    
    var timer = DispatchSource.makeTimerSource(flags: [], queue: .main)
    //TODO: Add Lab timer
    
    //TODO: Add Oberservable timer
    
    func startTimer() {
        timer.schedule(deadline: .now(), repeating: 0.01)
        timer.resume()
    }
    
    func stopTimer() {
        timer.cancel()
    }
    
    func resetTimer() {
    }
    
    func lapTime() {
    }
    
    //TODO: Output
}
