//
//  StopwatchViewControllerTests.swift
//  StopWatchTests
//
//  Created by Doyoung on 2022/07/29.
//

import XCTest
import RxSwift
import RxRelay

@testable import StopWatch

class StopwatchViewControllerTests: XCTestCase {

    //MARK: - System under test
    var sut: StopwatchViewController!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        sut = StopwatchViewController()
    }

    override func tearDownWithError() throws {
        try super.tearDownWithError()
        sut = StopwatchViewController()
    }

    //MARK: - Test doubles
    final class StopwatchViewModelSpy: StopwatchViewModelInput&StopwatchViewModelOutput {

        var startTimerCalled = false
        var stopTimerCalled = false
        var restartTimerCalled = false
        var resetTimerCalled = false
        var lapTimeCalled = false
        
        func startTimer() {
            startTimerCalled = true
        }
        
        func stopTimer() {
            stopTimerCalled = true
        }
        
        func restartTimer() {
            restartTimerCalled = true
        }
        
        func resetTimer() {
            resetTimerCalled = true
        }
        
        func lapTime() {
            lapTimeCalled = true
        }
        
        func saveTimer(isStop: Bool) {
            
        }
        
        var timerStatus = BehaviorSubject<TimerStatus>(value: .initialized)
        var mainTimerText: Observable<String> = Observable.just("Test main time")
        var lapTimerText: Observable<String> = Observable.just("Test Lap time")
        var laps = BehaviorRelay<[Lap]>(value: [])
    }
    
    //MARK: - Tests
    func test_startTimer_shouldInteractViewModelToCallStartTimer() {
        //given
        let stopwatchViewModelSpy = StopwatchViewModelSpy()
        sut.viewModel = stopwatchViewModelSpy
        //when
        sut.startTimer()
        //then
        XCTAssert(stopwatchViewModelSpy.startTimerCalled)
    }
    
    func test_stopTimer_shouldInteractViewModelToCallStopTimer() {
        //given
        let stopwatchViewModelSpy = StopwatchViewModelSpy()
        sut.viewModel = stopwatchViewModelSpy
        //when
        sut.stopTimer()
        //then
        XCTAssert(stopwatchViewModelSpy.stopTimerCalled)
    }
    
    func test_restartTimer_shouldInteractViewModelToCallRestartTimer() {
        //given
        let stopwatchViewModelSpy = StopwatchViewModelSpy()
        sut.viewModel = stopwatchViewModelSpy
        //when
        sut.restartTimer()
        //then
        XCTAssert(stopwatchViewModelSpy.restartTimerCalled)
    }
    
    func test_lapTime_shouldInteractViewModelToCallLapTimer() {
        //given
        let stopwatchViewModelSpy = StopwatchViewModelSpy()
        sut.viewModel = stopwatchViewModelSpy
        //when
        sut.lapTime()
        //then
        XCTAssert(stopwatchViewModelSpy.lapTimeCalled)
    }
    
    func test_restTimer_shouldInteractViewModelToCallRestTimer() {
        //given
        let stopwatchViewModelSpy = StopwatchViewModelSpy()
        sut.viewModel = stopwatchViewModelSpy
        //when
        sut.resetTimer()
        //then
        XCTAssert(stopwatchViewModelSpy.resetTimerCalled)
    }

}
