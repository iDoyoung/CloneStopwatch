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
    var countingMainTimes = PublishSubject<Double>()
    var countingLapTimes = PublishSubject<Double>()
    
    var mainTimer: DispatchSourceTimer?
    var lapTimer: DispatchSourceTimer?
    
    func startTimer() {
        timerStatus.onNext(.counting)
        mainTimer = DispatchSource.makeTimerSource(flags: [], queue: .main)
        lapTimer = DispatchSource.makeTimerSource(flags: [], queue: .main)
        
        mainTimer?.schedule(deadline: .now(), repeating: 0.01)
        lapTimer?.schedule(deadline: .now(), repeating: 0.01)
        
        mainTimer?.setEventHandler { [weak self] in
            self?.countingMainTimes.onNext(0.01)
        }
        
        lapTimer?.setEventHandler { [weak self] in
            self?.countingLapTimes.onNext(0.01)
        }
        
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
        mainTimer?.cancel()
        lapTimer?.cancel()
        mainTimer = nil
        lapTimer = nil
    }
    
    func lapTime() {
        lapTimer?.cancel()
        lapTimer = DispatchSource.makeTimerSource(flags: [], queue: .main)
        lapTimer?.schedule(deadline: .now(), repeating: 0.01)
        lapTimer?.resume()
    }
    
    //TODO: Output
    lazy var mainTimerText = countingMainTimes.map {
        //Int to Time 00:00:00
        //let time = Int($0)
        //밀리초 .00
        "\($0)"
    }
    
    lazy var lapTimerText = countingLapTimes.map {
        "\($0)"
    }
    
}
