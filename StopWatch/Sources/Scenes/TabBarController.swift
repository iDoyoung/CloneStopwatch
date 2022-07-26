//
//  TabBarController.swift
//  StopWatch
//
//  Created by Doyoung on 2022/07/26.
//

import UIKit

final class TabBarController: UITabBarController {
    
    private let firstTabViewController: UIViewController = {
        let viewController = StopWatchViewController()
        let image = UIImage(systemName: "stopwatch.fill")
        viewController.tabBarItem = UITabBarItem(title: "Stopwatch", image: image, selectedImage: image)
        return viewController
    }()
    
    private let secondTabViewController: UIViewController = {
        let viewController = SettingViewController()
        let image = UIImage(systemName: "gear")
        viewController.tabBarItem = UITabBarItem(title: "Setting", image: image, selectedImage: image)
        return viewController
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewControllers = [firstTabViewController, secondTabViewController]
    }
}
