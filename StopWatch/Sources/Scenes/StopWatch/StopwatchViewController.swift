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
    
    private lazy var leftButton: ControlButton = {
        let button = ControlButton(type: .system)
        button.addTarget(self, action: #selector(leftButtonAction), for: .touchUpInside)
        button.tintColor = .systemGray
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var rightButton: ControlButton = {
        let button = ControlButton(type: .system)
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
        rightButton.timerStatus = status
        switch status {
        case .initialized:
            rightButton.setTitle("시작", for: .normal)
            rightButton.tintColor = .systemGreen
        case .counting:
            rightButton.setTitle("중단", for: .normal)
            rightButton.tintColor = .systemRed
        case .stoped:
            rightButton.setTitle("시작", for: .normal)
            rightButton.tintColor = .systemGreen
        }
    }
    
    private func updateLeftButton(to status: TimerStatus) {
        leftButton.timerStatus = status
        switch status {
        case .initialized:
            leftButton.setTitle("랩", for: .normal)
            leftButton.isEnabled = false
        case .counting:
            leftButton.setTitle("랩", for: .normal)
            leftButton.isEnabled = true
        case .stoped:
            leftButton.setTitle("재설정", for: .normal)
        }
    }
    
    //MARK: - Control Action
    @objc
    func rightButtonAction(_ sender: ControlButton) {
        print(sender.timerStatus)
        switch sender.timerStatus {
        case .initialized:
            startTimer()
        case .counting:
            stopTimer()
        case .stoped:
            restartTimer()
        }
    }
    
    @objc
    func leftButtonAction(_ sender: ControlButton) {
        switch sender.timerStatus {
        case .initialized:
            lapTime()
        case .counting:
            lapTime()
        case .stoped:
            resetTimer()
        }
    }
    
    func startTimer() {
        #if DEBUG
        print("Start Timer")
        #endif
        viewModel?.startTimer()
    }
    
    func stopTimer() {
        #if DEBUG
        print("Start Timer")
        #endif
        viewModel?.stopTimer()
    }
    
    func restartTimer() {
        #if DEBUG
        print("Restart timer")
        #endif
        viewModel?.restartTimer()
    }
    
    func lapTime() {
        #if DEBUG
        print("Lap Time")
        #endif
        viewModel?.lapTime()
    }
    
    func resetTimer() {
        #if DEBUG
        print("Reset timer")
        #endif
        viewModel?.resetTimer()
    }
    
}
