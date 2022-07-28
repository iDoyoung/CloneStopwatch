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
    
    var mainTimer: DispatchSourceTimer?
    var lapTimer: DispatchSourceTimer?
    
    //TODO: Add Oberservable timer
    
    func startTimer() {
        timerStatus.onNext(.counting)
        mainTimer = DispatchSource.makeTimerSource(flags: [], queue: .main)
        lapTimer = DispatchSource.makeTimerSource(flags: [], queue: .main)
        mainTimer?.schedule(deadline: .now(), repeating: 0.01)
        lapTimer?.schedule(deadline: .now(), repeating: 0.01)
        mainTimer?.resume()
        lapTimer?.resume()
    }
    
    func stopTimer() {
        timerStatus.onNext(.stoped)
        mainTimer?.suspend()
        lapTimer?.suspend()
    }
    
    func restartTimer() {
        timerStatus.onNext(.counting)
        mainTimer?.resume()
        lapTimer?.resume()
    }
    
    func resetTimer() {
    }
    
    func lapTime() {
        lapTimer?.cancel()
        lapTimer = DispatchSource.makeTimerSource(flags: [], queue: .main)
        lapTimer?.schedule(deadline: .now(), repeating: 0.01)
        lapTimer?.resume()
    }
    
    //TODO: Output
}
