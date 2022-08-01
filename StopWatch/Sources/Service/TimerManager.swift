//
//  TimerManager.swift
//  StopWatch
//
//  Created by Doyoung on 2022/08/01.
//

import RxSwift
import RxRelay

final class TimerManager {
    
    private var disposeBag = DisposeBag()
    
    //타이머 진행 중에 타이머 시작시간 저장
    var mainStartedTime: Double?
    var lapStartedTime: Double?
    
    var countingMainTimes = BehaviorRelay<Double>(value: 0)
    var countingLapTimes = BehaviorRelay<Double>(value: 0)
    
    var mainTimer: DispatchSourceTimer?
    var lapTimer: DispatchSourceTimer?
    
    var timerStatus = BehaviorSubject<TimerStatus>(value: .initialized)
    var laps = BehaviorRelay(value: [Lap]())
    
    func configureTimer(event: @escaping() -> Void) -> DispatchSourceTimer {
        let timer = DispatchSource.makeTimerSource(flags: [], queue: .global())
        timer.schedule(deadline: .now(), repeating: 0.01)
        timer.setEventHandler(handler: event)
        return timer
    }
    
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
        
        mainStartedTime = currentTimeToDouble()
        lapStartedTime = currentTimeToDouble()
        
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
        mainStartedTime = nil
        lapStartedTime = nil
        countingMainTimes.accept(0)
        countingLapTimes.accept(0)
        laps.accept([])
    }
    
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
        lapStartedTime = currentTimeToDouble()
    }
    
    func getCurrentTimerData(by user: String) -> StopwatchTimer? {
        guard let status = try? timerStatus.value() else { return nil}
        var isStop: Bool
        switch status {
        case .counting:
            isStop = false
        case .initialized, .stoped:
            isStop = true
        }
        return StopwatchTimer(userID: user,
                              mainStartedTime: mainStartedTime,
                              lapStartedTime: lapStartedTime,
                              mainTime: countingMainTimes.value,
                              lapTime: countingLapTimes.value,
                              laps: laps.value,
                              isStop: isStop)
    }
    
    ///현재시간 밀리세컨즈 구하기
    func currentTimeToDouble() -> Double {
        return Double(Int64(Date().timeIntervalSince1970 * 1000)) / 1000
    }
    
}
