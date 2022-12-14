//
//  StopWatchViewController.swift
//  StopWatch
//
//  Created by Doyoung on 2022/07/26.
//

import UIKit
import RxSwift
import RxCocoa

final class StopwatchViewController: UIViewController {

    var viewModel: (StopwatchViewModelInput&StopwatchViewModelOutput)?
    
    private var disposeBag = DisposeBag()
    
    private let timeLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.sizeToFit()
        label.font = .monospacedDigitSystemFont(ofSize: 90, weight: .thin)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var leftButton: ControlButton = {
        let button = ControlButton(type: .system)
        button.addTarget(self, action: #selector(leftButtonAction), for: .touchUpInside)
        button.tintColor = .systemGray
        button.setTitleColor(UIColor.white, for: .normal)
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
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.backgroundColor = .clear
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 14, bottom: 0, right: 14)
        tableView.register(LapTableViewCell.self, forCellReuseIdentifier: LapTableViewCell.resueIdentifier)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    //MARK: - Life cycle
    override func loadView() {
        super.loadView()
        view.backgroundColor = .systemBackground
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUIComponents()
        observeTimerStatus()
        setupTimerTextBinding()
        setupLapsTableViewBinding()
        viewModel?.fetchStopwatchTimer()
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
            leftButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 14),
            rightButton.heightAnchor.constraint(equalToConstant: 84),
            rightButton.widthAnchor.constraint(equalToConstant: 84),
            rightButton.topAnchor.constraint(equalTo: timeLabel.bottomAnchor, constant: 2),
            rightButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -14),
            lapTableView.topAnchor.constraint(equalTo: leftButton.bottomAnchor, constant: 16),
            lapTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            lapTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            lapTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
   
    func observeTimerStatus() {
        viewModel?.timerStatus
            .observe(on: MainScheduler.instance)
            .subscribe { [weak self] event in
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
    
    func setupTimerTextBinding() {
        viewModel?.mainTimerText
            .observe(on: MainScheduler.instance)
            .bind(to: timeLabel.rx.text)
            .disposed(by: disposeBag)
    }
    
    func setupLapsTableViewBinding() {
        viewModel?.laps
            .observe(on: MainScheduler.instance)
            .bind(to: lapTableView.rx.items(cellIdentifier: LapTableViewCell.resueIdentifier, cellType: LapTableViewCell.self)) { [weak self] row, lap, cell in
                guard let self = self,
                      let viewModel = self.viewModel else { return }
                cell.timeLabel.text = lap.times.toCountingTime()
                
                cell.lapLabel.text = "??? \(lap.index)"
                if row == 0 {
                    viewModel.lapTimerText
                        .bind(to: cell.timeLabel.rx.text)
                        .disposed(by: cell.disposeBag)
                } else if viewModel.laps.value.count > 2 {
                    let max = viewModel.laps.value.max(by: { $0.times < $1.times })
                    let min = viewModel.laps.value[1...].min(by: { $0.times < $1.times })
                    if lap == min {
                        cell.timeLabel.textColor = .systemRed
                        cell.lapLabel.textColor = .systemRed
                    }
                    if lap == max {
                        cell.timeLabel.textColor = .systemGreen
                        cell.lapLabel.textColor = .systemGreen
                    }
                }
            }
            .disposed(by: disposeBag)
    }
    
    private func updateRightButton(to status: TimerStatus) {
        rightButton.timerStatus = status
        switch status {
        case .initialized:
            rightButton.setTitle("??????", for: .normal)
            rightButton.tintColor = .systemGreen
        case .counting:
            rightButton.setTitle("??????", for: .normal)
            rightButton.tintColor = .systemRed
        case .stoped:
            rightButton.setTitle("??????", for: .normal)
            rightButton.tintColor = .systemGreen
        }
    }
    
    private func updateLeftButton(to status: TimerStatus) {
        leftButton.timerStatus = status
        switch status {
        case .initialized:
            leftButton.setTitle("???", for: .normal)
            leftButton.isEnabled = false
        case .counting:
            leftButton.setTitle("???", for: .normal)
            leftButton.isEnabled = true
        case .stoped:
            leftButton.setTitle("?????????", for: .normal)
            leftButton.isEnabled = true
        }
    }
    
    //MARK: - Control Action
    @objc
    func rightButtonAction(_ sender: ControlButton) {
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

extension StopwatchViewController {
    static let factory: ((StopwatchViewModelInput&StopwatchViewModelOutput) -> StopwatchViewController) = { viewModel in
        let stopwatchViewController = StopwatchViewController()
        stopwatchViewController.viewModel = viewModel
        return stopwatchViewController
    }
}
