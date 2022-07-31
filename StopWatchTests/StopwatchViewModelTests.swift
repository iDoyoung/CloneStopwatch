//
//  StopwatchViewModelTests.swift
//  StopWatchTests
//
//  Created by Doyoung on 2022/07/27.
//

import XCTest
import RxSwift
import RxTest
import RxBlocking

@testable import StopWatch

class StopwatchViewModelTests: XCTestCase {

    //MARK: - System under test
    var sut: StopwatchViewModel!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        sut = StopwatchViewModel()
    }

    override func tearDownWithError() throws {
        sut = nil
        UserDefaults.standard.removeObject(forKey: "userID")
        try super.tearDownWithError()
    }
    
    //MARK: - Test doubles
    class StopwatchFirestoreSpy: StopwatchFirestoreProtocol {
        
        var saveStopwatchDataCalled = false
        var getStopwatchDataCalled = false
        
        func getStopwatchData(completion: @escaping (StopwatchTimer) -> Void) {
            getStopwatchDataCalled = true
        }
        
        func saveStopwatchData(timer: StopwatchTimer) {
            guard UserDefaults.standard.string(forKey: "userID") != nil else { return }
            saveStopwatchDataCalled = true
        }
    }
    
    //MARK: - Tests
    func test_startTimer_mainTimerAndLaptimerShouldBeNotCancelled() {
        //given
        //when
        sut.startTimer()
        //then
        guard let mainTimer = sut.mainTimer,
              let lapTimer = sut.lapTimer else {
            XCTFail()
            return
        }
        XCTAssert(!mainTimer.isCancelled)
        XCTAssert(!lapTimer.isCancelled)
    }
    
    func test_stopTimer_timerShouldBeCancelld() {
        //given
//        let expectation = TimerStatus.stoped
//        sut.startTimer()
//        //when
//        sut.stopTimer()
//        //then
//        let result = try? sut.timerStatus.toBlocking(timeout: 1).first()
//        XCTAssertEqual(result, expectation)
//        sut.mainTimer.resume()
    }
    
    func test_restartTimer_timerShouldBeNotCanncelled() {
        //given
        sut.startTimer()
        sut.stopTimer()
        //when
        sut.restartTimer()
        //then
        guard let mainTimer = sut.mainTimer,
              let lapTimer = sut.lapTimer else {
            XCTFail()
            return
        }
        XCTAssert(!mainTimer.isCancelled)
        XCTAssert(!lapTimer.isCancelled)
    }
    
    func test_lapTime_lapTimerShouldBeNotCancelled() {
        //given
        sut.startTimer()
        //when
        sut.lapTime()
        //then
        guard let lapTimer = sut.lapTimer else { return }
        XCTAssert(!lapTimer.isCancelled)
    }
    
    func test_resetTimer_mainAndLaptimerShouldBeNil() {
        //given
        //when
        sut.resetTimer()
        //then
        XCTAssertNil(sut.mainTimer)
        XCTAssertNil(sut.lapTimer)
    }
    
    func test_saveTimer_whenUserIDIsNotNil_shouldCallStopwatchFirestore() {
        //given
        let stopwatchFirestoreSpy = StopwatchFirestoreSpy()
        sut.firestore = stopwatchFirestoreSpy
        UserDefaults.standard.set("test", forKey: "userID")
        //when
        sut.saveStopwatchTimer(isStop: true)
        //then
        XCTAssert(stopwatchFirestoreSpy.saveStopwatchDataCalled)
    }
    
    func test_saveTimer_whenUserIDIsNil_shouldNotCallStopwatchFirestore() {
        //given
        let stopwatchFirestoreSpy = StopwatchFirestoreSpy()
        sut.firestore = stopwatchFirestoreSpy
        UserDefaults.standard.removeObject(forKey: "userID")
        //when
        sut.saveStopwatchTimer(isStop: true)
        //then
        XCTAssert(!stopwatchFirestoreSpy.saveStopwatchDataCalled)
    }
    
    func test_fetchStopwatchTimer_shouldCallGetStopwatchData() {
        //given
        let stopwatchFirestoreSpy = StopwatchFirestoreSpy()
        sut.firestore = stopwatchFirestoreSpy
        //when
        sut.fetchStopwatchTimer()
        //then
        XCTAssert(stopwatchFirestoreSpy.getStopwatchDataCalled)
    }
    
}
