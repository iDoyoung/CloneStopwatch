//
//  StopWatchViewController.swift
//  StopWatch
//
//  Created by Doyoung on 2022/07/26.
//

import UIKit
import RxSwift
import RxCocoa

class StopWatchViewController: UIViewController {

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
        button.tintColor = .systemGray
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let rightButton: UIButton = {
        let button = ControlButton(type: .system)
        button.setTitle("시작", for: .normal)
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
    override func loadView() {
        super.loadView()
        view.backgroundColor = .systemBackground
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUIComponents()
    }

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
   
}
