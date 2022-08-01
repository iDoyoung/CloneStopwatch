//
//  LoginViewControllerTests.swift
//  StopWatchTests
//
//  Created by Doyoung on 2022/07/31.
//

import XCTest

@testable import StopWatch

class LoginViewControllerTests: XCTestCase {
    
    //MARK: System under test
    var sut: LoginViewController!
    var window: UIWindow!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        window = UIWindow()
        sut = LoginViewController()
    }

    override func tearDownWithError() throws {
        sut = nil
        window = nil
        try super.tearDownWithError()
    }

    
    //MARK: Test doubles
    class LoginViewModelSpy: LoginViewModelInput {
        
        var autoLoginCalled = false
        var logintoGoogleCalled = false
        
        func autoLogin(completion: @escaping () -> Void) {
            autoLoginCalled = true
        }
        
        func loginToGoogle(source: UIViewController, completion: @escaping () -> Void) {
            logintoGoogleCalled = true
        }
        
        
    }
    
    //MARK: Tests
    func test_viewDidLoad_shouldCallAutoLogin() {
        //given
        let viewModel = LoginViewModelSpy()
        sut.viewModel = viewModel
        //when
        sut.viewDidAppear(false)
        //then
        XCTAssert(viewModel.autoLoginCalled)
    }
    
}
