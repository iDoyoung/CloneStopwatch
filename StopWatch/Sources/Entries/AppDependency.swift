//
//  AppDependency.swift
//  StopWatch
//
//  Created by Doyoung on 2022/08/01.
//

import Foundation

struct AppDependency {
    let loginService: SocialLoginProtocol
    let loginViewController: LoginViewController

    static func resolve() -> AppDependency {
        let loginService = SocialLoginService()
        let loginViewController = LoginViewController()
        let loginViewModel = LoginViewModel()
        let loginRouter = LoginRouter()
        loginViewController.viewModel = loginViewModel
        loginViewModel.loginService = loginService
        let stopwatchViewModel = StopwatchViewModel()
        let settingViewModel = SettingViewModel()
        settingViewModel.service = loginService
        loginViewController.router = loginRouter
        loginRouter.stopwatchViewController = StopwatchViewController.factory(stopwatchViewModel)
        loginRouter.settingViewController = SettingViewController.factory(settingViewModel)
        loginRouter.viewController = loginViewController
        
        return AppDependency(loginService: loginService, loginViewController: loginViewController)
    }
    
    
}
