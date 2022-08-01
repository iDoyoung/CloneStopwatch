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
    
    var service: SocialLoginProtocol?
    
    func logout(completion: @escaping () -> Void) {
        service?.signOut {
            completion()
        }
    }
    
    func setUserInterfaceStyle(_ style: UserInterfaceStyle) {
        UserDefaults.standard.set(style.rawValue, forKey: "UserInterfaceStyle")
    }
    
}
