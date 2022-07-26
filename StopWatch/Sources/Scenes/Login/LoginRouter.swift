//
//  LoginRouter.swift
//  StopWatch
//
//  Created by Doyoung on 2022/07/26.
//

import UIKit

protocol LoginRouterLogic {
    func showLoginSuccess()
    func showLoginFailure()
}

final class LoginRouter: LoginRouterLogic {
    
    weak var viewController: UIViewController?
    
    func showLoginSuccess() {
        let destinationViewController = TabBarController()
        viewController?.present(destinationViewController, animated: true)
    }
    
    func showLoginFailure() {
    }
    
}
