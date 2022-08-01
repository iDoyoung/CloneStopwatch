//
//  SettingViewController.swift
//  StopWatch
//
//  Created by Doyoung on 2022/07/26.
//

import UIKit

final class SettingViewController: UIViewController {

    var viewModel: SettingViewModelInput?
    private let userInterfaceStyle = UserDefaults.standard.string(forKey: "UserInterfaceStyle")
    
    private lazy var logoutButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("로그아웃", for: .normal)
        button.setTitleColor(UIColor.label, for: .normal)
        button.addTarget(self, action: #selector(logout), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var interfaceStackView: UIStackView = {
       let stackView = UIStackView(arrangedSubviews: [interfaceStyleTitleLabel, interfaceStyleSegmentedControl])
        stackView.axis = .horizontal
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private let interfaceStyleTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "UserInterfaceStyle"
        return label
    }()
    
    private lazy var interfaceStyleSegmentedControl : UISegmentedControl = {
        let segmentedControl = UISegmentedControl(items: ["Device", "Light", "Dark"])
        segmentedControl.addTarget(self, action: #selector(setInterfaceStyle), for: .valueChanged)

        if let userInterfaceStyle = userInterfaceStyle {
            switch UserInterfaceStyle.init(rawValue: userInterfaceStyle) {
            case .device:
                segmentedControl.selectedSegmentIndex = 0
            case .light:
                segmentedControl.selectedSegmentIndex = 1
            case .dark:
                segmentedControl.selectedSegmentIndex = 2
            case .none:
                segmentedControl.selectedSegmentIndex = 0
            }
        }
        
        return segmentedControl
    }()
    
    //MARK: - Life Cycle
    override func loadView() {
        super.loadView()
        view.backgroundColor = .systemBackground
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUIComponents()
    }
    
    //AMRK: - Setup UI
    private func setupUIComponents() {
        view.addSubview(logoutButton)
        view.addSubview(interfaceStackView)
        setupLayoutConstraint()
    }
    
    private func setupLayoutConstraint() {
        NSLayoutConstraint.activate([
            logoutButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            logoutButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            interfaceStackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            interfaceStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            interfaceStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    
    @objc
    private func logout() {
        viewModel?.logout { [weak self] in
            self?.dismiss(animated: true)
        }
    }
    
    @objc
    private func setInterfaceStyle(_ sender: UISegmentedControl) {
        let interfaceStyle = UserInterfaceStyle.allCases[sender.selectedSegmentIndex]
        viewModel?.setUserInterfaceStyle(interfaceStyle)
        switch interfaceStyle {
        case .device:
            view.window?.overrideUserInterfaceStyle = .unspecified
        case .dark:
            view.window?.overrideUserInterfaceStyle = .dark
        case .light:
            view.window?.overrideUserInterfaceStyle = .light
        }
    }
    
}

extension SettingViewController {
    static let factory: (SettingViewModelInput) -> SettingViewController = { viewModel in
        let settingViewController = SettingViewController()
        settingViewController.viewModel = viewModel
        return settingViewController
    }
}
