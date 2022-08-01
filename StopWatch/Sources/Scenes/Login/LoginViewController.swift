//
//  LoginViewController.swift
//  StopWatch
//
//  Created by Doyoung on 2022/07/26.
//

import UIKit
import RxSwift
import RxCocoa

final class LoginViewController: UIViewController {

    var viewModel: LoginViewModelInput?
    var router: LoginRouterLogic?
    private var disposeBag = DisposeBag()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Stop Watch"
        label.font = UIFont.systemFont(ofSize: 30, weight: .black)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let loginButton: UIButton = {
        let button = UIButton()
        button.setTitle("Google Login", for: .normal)
        button.setTitleColor(UIColor.label, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    //MARK: - Life cycle
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        setupViewController()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupViewController()
    }
    
    override func loadView() {
        super.loadView()
        view.backgroundColor = .systemBackground
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUIComponents()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        viewModel?.autoLogin { [weak self] in
            self?.router?.showLoginSuccess()
        }
    }
    
    private func setupViewController() {
        let viewController = self
        let viewModel = LoginViewModel()
        let router = LoginRouter()
        router.viewController = viewController
        viewController.viewModel = viewModel
        viewController.router = router
    }
    
    private func setupUIComponents() {
        view.addSubview(titleLabel)
        view.addSubview(loginButton)
        setupLayoutConstraint()
        setupBinding()
    }
    
    private func setupLayoutConstraint() {
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: view.centerYAnchor),
            loginButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loginButton.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 30)
        ])
    }
    
    private func setupBinding() {
        loginButton.rx.tap
            .bind { [weak self] in
                guard let self = self else { return }
                self.viewModel?.loginToGoogle(source: self) {
                    self.router?.showLoginSuccess()
                }
            }
            .disposed(by: disposeBag)
    }
    
}
