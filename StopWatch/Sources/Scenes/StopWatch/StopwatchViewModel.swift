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
    func saveTimer(isStop: Bool)
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
    var firestore = StopwatchFirestore()
    
    var countingMainTimes = BehaviorRelay<Double>(value: 0)
    var countingLapTimes = BehaviorRelay<Double>(value: 0)
    
    var mainTimer: DispatchSourceTimer?
    var lapTimer: DispatchSourceTimer?
    
    private func configureTimer(event: @escaping() -> Void) -> DispatchSourceTimer {
        let timer = DispatchSource.makeTimerSource(flags: [], queue: .global())
        timer.schedule(deadline: .now(), repeating: 0.01)
        timer.setEventHandler(handler: event)
        return timer
    }
    
    //MARK: - Input
    func startTimer() {
        timerStatus.onNext(.counting)
        mainTimer = configureTimer { [weak self] in
            guard let self = self else { return }
            self.countingMainTimes.accept(self.countingMainTimes.value + 0.01)
        }
        lapTimer = configureTimer { [weak self] in
            guard let self = self else { return }
            self.countingLapTimes.accept(self.countingLapTimes.value + 0.01)
        }
        mainTimer?.resume()
        lapTimer?.resume()
        lapTime()
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
        mainTimer?.resume()
        lapTimer?.resume()
        mainTimer?.cancel()
        lapTimer?.cancel()
        countingMainTimes.accept(0)
        countingLapTimes.accept(0)
        laps.accept([])
    }
    
    func saveTimer(isStop: Bool) {
        guard let user = UserDefaults.standard.string(forKey: "userID") else { return }
        let currentTimer = Timer(userID: user,
                                 mainTimer: countingMainTimes.value,
                                 lapTimer: countingLapTimes.value,
                                 laps: laps.value,
                                 isStop: isStop)
        firestore.saveStopwatchData(timer: currentTimer)
    }
    
    //TODO: - Refactor method
    func lapTime() {
        let times = countingLapTimes.value
        var value = laps.value
        if !value.isEmpty {
            value[0].times = times
        }
        value.insert(Lap(index: (laps.value.count+1), times: 0), at: 0)//FIXME: - Reversed로 가능한지 고려
        laps.accept(value)
        lapTimer?.cancel()
        countingLapTimes.accept(0)
        lapTimer = configureTimer { [weak self] in
            guard let self = self else { return }
            self.countingLapTimes.accept(self.countingLapTimes.value + 0.01)
        }
        lapTimer?.resume()
    }
    
    //MARK: - Output
    var timerStatus = BehaviorSubject<TimerStatus>(value: .initialized)
    var laps = BehaviorRelay(value: [Lap]())
    
    lazy var mainTimerText = countingMainTimes
        .map { $0.toCountingTime() }
    
    lazy var lapTimerText = countingLapTimes
        .map { $0.toCountingTime() }
    
}
