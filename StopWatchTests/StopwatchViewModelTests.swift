//
//  StopwatchViewModelTests.swift
//  StopWatchTests
//
//  Created by Doyoung on 2022/07/27.
//

import XCTest
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
    func test_startTimer_TimerShouldBeNotCancelled() {
        //given
        //when
        sut.startTimer()
        //then
        XCTAssert(!sut.timer.isCancelled)
    }
}
