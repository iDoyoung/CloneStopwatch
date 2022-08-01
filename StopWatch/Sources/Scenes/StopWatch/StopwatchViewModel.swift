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
    func fetchStopwatchTimer()
    func saveStopwatchTimer()
}

protocol StopwatchViewModelOutput {
    var timerStatus: BehaviorSubject<TimerStatus> { get set }
    var laps: BehaviorRelay<[Lap]> { get set }
    var mainTimerText: Observable<String> { get set }
    var lapTimerText: Observable<String> { get set }
}

enum TimerStatus {
    case initialized
    case counting
    case stoped
}

class StopwatchViewModel: StopwatchViewModelInput, StopwatchViewModelOutput {
    
    private var disposeBag = DisposeBag()
    var firestore: StopwatchFirestoreProtocol = StopwatchFirestore()
    var timerManager: TimerManager = TimerManager()
    
    //MARK: - Input
    func startTimer() {
        timerManager.startTimer()
    }
    
    func stopTimer() {
        timerManager.stopTimer()
    }
    
    func resetTimer() {
        timerManager.resetTimer()
    }
    
    func restartTimer() {
        timerManager.restartTimer()
    }
    
    func lapTime() {
        timerManager.lapTime()
    }
    
    //TODO: - Refactor method
    func fetchStopwatchTimer() {
        firestore.getStopwatchData { [weak self] timer in
            guard let self = self,
                  let mainStartedTimes = timer.mainStartedTime,
                  let lapStartedTimes = timer.lapStartedTime else { return }
            
            self.timerManager.mainStartedTime = timer.mainStartedTime
            self.timerManager.lapStartedTime = timer.lapStartedTime

            self.timerManager.laps.accept(timer.laps)

            self.timerManager.mainTimer = self.timerManager.configureTimer { [weak self] in
                guard let self = self else { return }
                self.timerManager.countingMainTimes.accept(self.timerManager.countingMainTimes.value + 0.01)
            }
            self.timerManager.lapTimer = self.timerManager.configureTimer { [weak self] in
                guard let self = self else { return }
                self.timerManager.countingLapTimes.accept(self.timerManager.countingLapTimes.value + 0.01)
            }

            if timer.isStop {
                self.timerManager.countingMainTimes.accept(timer.mainTime)
                self.timerManager.countingLapTimes.accept(timer.lapTime)
                self.timerStatus.onNext(.stoped)
            } else {
                self.timerManager.countingMainTimes.accept(self.timerManager.currentTimeToDouble() - mainStartedTimes)
                self.timerManager.countingLapTimes.accept(self.timerManager.currentTimeToDouble() - lapStartedTimes)
                self.timerStatus.onNext(.counting)
                self.timerManager.mainTimer?.resume()
                self.timerManager.lapTimer?.resume()
            }
        }
    }
    
    func saveStopwatchTimer() {
        guard let user = UserDefaults.standard.string(forKey: "userID") else { return }
        guard let currentTimer = timerManager.getCurrentTimerData(by: user) else { return }
        firestore.saveStopwatchData(timer: currentTimer)
    }
    
    var timerStatus: BehaviorSubject<TimerStatus>
    var laps: BehaviorRelay<[Lap]>
    var mainTimerText: Observable<String>
    var lapTimerText: Observable<String>
    
    init() {
        timerStatus = timerManager.timerStatus
        laps = timerManager.laps
        mainTimerText = timerManager.countingMainTimes.map { $0.toCountingTime() }
        lapTimerText = timerManager.countingLapTimes.map { $0.toCountingTime() }
    }
    
}
