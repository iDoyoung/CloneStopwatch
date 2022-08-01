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

final class SettingViewModel {
    
    var service = SocialLoginService()
    
    func logout(completion: @escaping () -> Void) {
        service.signOut {
            completion()
        }
    }
    
    func setUserInterfaceStyle(_ style: UserInterfaceStyle) {
        UserDefaults.standard.set(style.rawValue, forKey: "UserInterfaceStyle")
    }
    
}
