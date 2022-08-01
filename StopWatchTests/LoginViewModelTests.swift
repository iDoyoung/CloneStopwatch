//
//  LoginViewModelTests.swift
//  StopWatchTests
//
//  Created by Doyoung on 2022/07/31.
//

import XCTest

@testable import StopWatch

class LoginViewModelTests: XCTestCase {

    //MARK: - System under test
    var sut: LoginViewModel!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        sut = LoginViewModel()
    }

    override func tearDownWithError() throws {
        sut = nil
        try super.tearDownWithError()
    }
    
    //MARK: - Test doubles
    class LoginServiceSpy: SocialLoginProtocol {
        
        var autoLoginCalled = false
        var googleLoginCalled = false
        var signOutCalled = false
        
        func autoLogin(completion: @escaping () -> Void) {
            autoLoginCalled = true
        }
        
        func googleLogin(source: UIViewController, completion: @escaping () -> Void) {
            googleLoginCalled = true
        }
        
        func signOut(completion: @escaping () -> Void) {
            signOutCalled = true
        }
    }
    
    //MARK: - Tests
    func test_autoLogin_shouldCallAutoLoginInLoginService() {
        //given
        let loginService = LoginServiceSpy()
        sut.loginService = loginService
        //when
        sut.autoLogin(completion: { })
        //then
        XCTAssert(loginService.autoLoginCalled)
    }

}
