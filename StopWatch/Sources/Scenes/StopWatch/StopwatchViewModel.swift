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
    func restartTimer()
    func lapTime()
}

protocol StopwatchViewModelOutput {
    var timerStatus: BehaviorSubject<TimerStatus> { get }
    var mainTimerText: Observable<String> { get }
    var lapTimerText: Observable<String> { get }
}

enum TimerStatus {
    case initialized
    case counting
    case stoped
}

class StopwatchViewModel: StopwatchViewModelInput, StopwatchViewModelOutput {
    
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
        timerStatus.onNext(.initialized)
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
    
    //MARK: - Output
    var timerStatus = BehaviorSubject<TimerStatus>(value: .initialized)
    
    lazy var mainTimerText = countingMainTimes
        .scan(0) { $0 + $1 }
        .map { $0.toCountingTime() }
    
    lazy var lapTimerText = countingLapTimes.map {
        "\($0)"
    }
    
}
