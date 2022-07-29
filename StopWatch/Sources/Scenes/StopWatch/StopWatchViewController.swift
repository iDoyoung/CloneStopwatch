//
//  StopWatchViewController.swift
//  StopWatch
//
//  Created by Doyoung on 2022/07/26.
//

import UIKit
import RxSwift
import RxCocoa

class StopwatchViewController: UIViewController {

    var viewModel: (StopwatchViewModelInput&StopwatchViewModelOutput)?
    
    private var disposeBag = DisposeBag()
    
    private let timeLabel: UILabel = {
        let label = UILabel()
        label.text = "00:00.00"
        label.textAlignment = .center
        label.font = .monospacedDigitSystemFont(ofSize: 90, weight: .thin)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var leftButton: UIButton = {
        let button = ControlButton(type: .system)
        button.setTitle("랩", for: .normal)
        button.setTitle("재설정", for: .selected)
        button.addTarget(self, action: #selector(leftButtonAction), for: .touchUpInside)
        button.tintColor = .systemGray
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var rightButton: UIButton = {
        let button = ControlButton(type: .system)
        button.setTitle("시작", for: .normal)
        button.setTitle("중단", for: .selected)
        button.addTarget(self, action: #selector(rightButtonAction), for: .touchUpInside)
        button.tintColor = .systemGreen
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let lapTableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.backgroundColor = .systemRed
        tableView.register(LapTableViewCell.self, forCellReuseIdentifier: LapTableViewCell.resueIdentifier)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    //MARK: - Life cycle
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        viewModel = StopwatchViewModel()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        viewModel = StopwatchViewModel()
    }
    
    override func loadView() {
        super.loadView()
        view.backgroundColor = .systemBackground
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUIComponents()
        observeTimerStatus()
    }

    //MARK: - Setup UI
    private func setupUIComponents() {
        view.addSubview(timeLabel)
        view.addSubview(leftButton)
        view.addSubview(rightButton)
        view.addSubview(lapTableView)
        setupLayoutConstraint()
    }
    
    private func setupLayoutConstraint() {
        NSLayoutConstraint.activate([
            timeLabel.heightAnchor.constraint(equalToConstant: 340),
            timeLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            timeLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            timeLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            leftButton.heightAnchor.constraint(equalToConstant: 84),
            leftButton.widthAnchor.constraint(equalToConstant: 84),
            leftButton.topAnchor.constraint(equalTo: timeLabel.bottomAnchor, constant: 2),
            leftButton.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            rightButton.heightAnchor.constraint(equalToConstant: 84),
            rightButton.widthAnchor.constraint(equalToConstant: 84),
            rightButton.topAnchor.constraint(equalTo: timeLabel.bottomAnchor, constant: 2),
            rightButton.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            lapTableView.topAnchor.constraint(equalTo: leftButton.bottomAnchor, constant: 16),
            lapTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            lapTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            lapTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
   
    func observeTimerStatus() {
        viewModel?.timerStatus.subscribe { [weak self] event in
            switch event {
            case .next(let status):
                self?.updateLeftButton(to: status)
                self?.updateRightButton(to: status)
            case .error(let error):
                #if DEBUG
                print("Error: \(error)")
                #endif
            case .completed:
                #if DEBUG
                print("Complete")
                #endif
            }
        }.disposed(by: disposeBag)
    }
    
    private func updateRightButton(to status: TimerStatus) {
        switch status {
        case .initialized:
            rightButton.tintColor = .systemGreen
            rightButton.isSelected = false
        case .counting:
            rightButton.tintColor = .systemRed
            rightButton.isSelected = false
        case .stoped:
            rightButton.tintColor = .systemGreen
            rightButton.isSelected = false
        }
    }
    
    private func updateLeftButton(to status: TimerStatus) {
        switch status {
        case .initialized:
            leftButton.isEnabled = false
            leftButton.isSelected = false
        case .counting:
            leftButton.isEnabled = true
            leftButton.isSelected = false
        case .stoped:
            leftButton.isSelected = true
        }
    }
    
    //MARK: - Control Action
    @objc
    private func rightButtonAction(_ sender: UIButton) {
        sender.isSelected ? startTimer() : stopTimer()
    }
    
    @objc
    private func leftButtonAction(_ sender: UIButton) {
        sender.isSelected ? resetTimer() : lapTime()
    }
    
    func startTimer() {
        viewModel?.startTimer()
    }
    
    func stopTimer() {
        viewModel?.stopTimer()
    }
    
    func lapTime() {
        viewModel?.lapTime()
    }
    
    func resetTimer() {
        viewModel?.resetTimer()
    }
    
}
