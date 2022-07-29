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
    
    private lazy var firstTabViewController: UIViewController = {
        let viewController = StopwatchViewController()
        let image = UIImage(systemName: "stopwatch.fill")
        viewController.tabBarItem = UITabBarItem(title: "Stopwatch", image: image, selectedImage: image)
        return viewController
    }()
    
    private lazy var secondTabViewController: UIViewController = {
        let viewController = SettingViewController()
        let image = UIImage(systemName: "gear")
        viewController.tabBarItem = UITabBarItem(title: "Setting", image: image, selectedImage: image)
        return viewController
    }()
    
    func showLoginSuccess() {
        let destinationViewController = UITabBarController()
        destinationViewController.tabBar.tintColor = UIColor(red: 149/255, green: 189/255, blue: 250/255, alpha: 1)
        destinationViewController.viewControllers = [firstTabViewController, secondTabViewController]
        destinationViewController.modalPresentationStyle = .fullScreen
        viewController?.present(destinationViewController, animated: true)
    }
    
    func showLoginFailure() {
    }
    
}
