//
//  StopwatchViewModel.swift
//  StopWatch
//
//  Created by Doyoung on 2022/07/27.
//

import RxSwift
import RxRelay

protocol StopwatchViewModelInput {
    func startTimer()
    func stopTimer()
    func resetTimer()
    func restartTimer()
    func lapTime()
}

protocol StopwatchViewModelOutput {
    var timerStatus: BehaviorSubject<TimerStatus> { get }
    var laps: BehaviorRelay<[Lap]> { get }
    var mainTimerText: Observable<String> { get }
    var lapTimerText: Observable<String> { get }
}

enum TimerStatus {
    case initialized
    case counting
    case stoped
}

class StopwatchViewModel: StopwatchViewModelInput, StopwatchViewModelOutput {
    
    private var disposeBag = DisposeBag()
    
    var countingMainTimes = PublishSubject<Double>()
    var countingLapTimes = BehaviorRelay<Double>(value: 0)
    
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
            guard let self = self else { return }
            self.countingLapTimes.accept(self.countingLapTimes.value + 0.01)
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
        let times = countingLapTimes.value
        var value = laps.value
        value.insert(Lap(index: (laps.value.count+1), times: times), at: 0)//FIXME: - Reversed로 가능한지 고려
        laps.accept(value)
        countingLapTimes.accept(0)
        
        lapTimer = DispatchSource.makeTimerSource(flags: [], queue: .main)
        lapTimer?.setEventHandler { [weak self] in
            guard let self = self else { return }
            self.countingLapTimes.accept(self.countingLapTimes.value + 0.01)
        }
        lapTimer?.schedule(deadline: .now(), repeating: 0.01)
        lapTimer?.resume()
    }
    
    //MARK: - Output
    var timerStatus = BehaviorSubject<TimerStatus>(value: .initialized)
    var laps = BehaviorRelay(value: [Lap]())
    
    lazy var mainTimerText = countingMainTimes
        .scan(0) { $0 + $1 }
        .map { $0.toCountingTime() }
    
    lazy var lapTimerText = countingLapTimes
        .scan(0) { $0 + $1 }
        .map { $0.toCountingTime() }
    
}
