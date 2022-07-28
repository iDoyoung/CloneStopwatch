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
        try super.tearDownWithError()
    }
    
    //MARK: - Test doubles

    //MARK: - Tests
    func test_startTimer_timerShouldBeNotCancelled() {
        //given
        //when
        sut.startTimer()
        //then
        XCTAssert(!sut.timer.isCancelled)
    }
    
    func test_stopTimer_timerShouldBeCancelld() {
        //given
        let expectation = TimerStatus.stoped
        sut.startTimer()
        //when
        sut.stopTimer()
        //then
        let result = try? sut.timerStatus.toBlocking(timeout: 1).first()
        XCTAssertEqual(result, expectation)
        sut.timer.resume()
    }
    
    func test_restart_Timer_timerShouldBeNotCanncelled() {
        //given
        sut.startTimer()
        sut.stopTimer()
        //when
        sut.restartTimer()
        //then
        XCTAssert(!sut.timer.isCancelled)
    }
    
}
