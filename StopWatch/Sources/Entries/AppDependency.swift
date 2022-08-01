//
//  AppDependency.swift
//  StopWatch
//
//  Created by Doyoung on 2022/08/01.
//

import Foundation

struct AppDependency {
    
    let loginService: SocialLoginProtocol
    let timerManager: TimerManager
    let stopwatchFirestore: StopwatchFirestoreProtocol
    let loginViewController: LoginViewController
    static func resolve() -> AppDependency {
        let loginService = SocialLoginService()
        let timerManager = TimerManager()
        let stopwatchFirestore = StopwatchFirestore()
        let loginViewController = LoginViewController()
        let loginViewModel = LoginViewModel()
        let loginRouter = LoginRouter()
        loginViewController.viewModel = loginViewModel
        loginViewModel.loginService = loginService
        let stopwatchViewModel = StopwatchViewModel(timerManager: timerManager, firestore: stopwatchFirestore)
        let settingViewModel = SettingViewModel(loginService: loginService, timerManager: timerManager, firestore: stopwatchFirestore)
        loginViewController.router = loginRouter
        loginRouter.stopwatchViewController = StopwatchViewController.factory(stopwatchViewModel)
        loginRouter.settingViewController = SettingViewController.factory(settingViewModel)
        loginRouter.viewController = loginViewController
        
        return AppDependency(loginService: loginService, timerManager: timerManager, stopwatchFirestore: stopwatchFirestore, loginViewController: loginViewController)
    }
    
}
