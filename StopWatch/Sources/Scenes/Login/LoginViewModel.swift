//
//  LoginViewModel.swift
//  StopWatch
//
//  Created by Doyoung on 2022/07/31.
//

//FIXME: - Try unimport UIKit
import UIKit

protocol LoginViewModelInput {
    func autoLogin(completion: @escaping() -> Void)
    func loginToGoogle(source: UIViewController, completion: @escaping () -> Void)
}

final class LoginViewModel: LoginViewModelInput {
    
    var loginService: SocialLoginProtocol? = SocialLoginService()
    
    func autoLogin(completion: @escaping() -> Void) {
        loginService?.autoLogin(completion: completion)
    }
    
    func loginToGoogle(source: UIViewController, completion: @escaping () -> Void) {
        loginService?.googleLogin(source: source, completion: completion)
    }
    
}
