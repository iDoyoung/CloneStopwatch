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

enum TimerStatus {
    case initialized
    case counting
    case stoped
}

class StopwatchViewModel: StopwatchViewModelInput {
    
    var timerStatus = PublishSubject<TimerStatus>()
    
    var timer = DispatchSource.makeTimerSource(flags: [], queue: .main)
    //TODO: Add Lab timer
    
    //TODO: Add Oberservable timer
    
    func startTimer() {
        timerStatus.onNext(.counting)
        timer.schedule(deadline: .now(), repeating: 0.01)
        timer.resume()
    }
    
    func stopTimer() {
        timerStatus.onNext(.stoped)
        timer.suspend()
    }
    
    func restartTimer() {
        timerStatus.onNext(.counting)
        timer.resume()
    }
    
    func resetTimer() {
    }
    
    func lapTime() {
    }
    
    //TODO: Output
}
