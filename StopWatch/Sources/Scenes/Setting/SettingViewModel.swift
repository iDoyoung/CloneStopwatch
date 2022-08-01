//
//  SettingViewModel.swift
//  StopWatch
//
//  Created by Doyoung on 2022/08/01.
//

import Foundation

enum UserInterfaceStyle: String, CaseIterable {
    case device
    case light
    case dark
}

protocol SettingViewModelInput {
    func logout(completion: @escaping () -> Void)
    func setUserInterfaceStyle(_ style: UserInterfaceStyle)
}

final class SettingViewModel: SettingViewModelInput {
    
    var loginService: SocialLoginProtocol
    var timerManager: TimerManager
    var firestore: StopwatchFirestoreProtocol
    
    init(loginService: SocialLoginProtocol, timerManager: TimerManager, firestore: StopwatchFirestoreProtocol) {
        self.loginService = loginService
        self.timerManager = timerManager
        self.firestore = firestore
    }
    func logout(completion: @escaping () -> Void) {
        loginService.signOut { [weak self] in
            guard let user = UserDefaults.standard.string(forKey: "userID") else { return }
            guard let timer = self?.timerManager.getCurrentTimerData(by: user) else { return }
            self?.firestore.saveStopwatchData(timer: timer)
            completion()
        }
    }
    
    func setUserInterfaceStyle(_ style: UserInterfaceStyle) {
        UserDefaults.standard.set(style.rawValue, forKey: "UserInterfaceStyle")
    }
    
}
