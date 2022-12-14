//
//  LapTableViewCell.swift
//  StopWatch
//
//  Created by Doyoung on 2022/07/27.
//

import UIKit
import RxSwift

final class LapTableViewCell: UITableViewCell {
    
    static let resueIdentifier = "LapTableViewCellReuseIdentifier"
    var disposeBag = DisposeBag()
    
    let lapLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let timeLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .right
        label.font = .monospacedDigitSystemFont(ofSize: 17, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupCellUIComponents()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupCellUIComponents()
    }
    
    private func setupCellUIComponents() {
        contentView.backgroundColor = .systemBackground
        contentView.addSubview(lapLabel)
        contentView.addSubview(timeLabel)
        setUpLayoutConstraint()
    }
    
    private func setUpLayoutConstraint() {
        NSLayoutConstraint.activate([
            lapLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 14),
            lapLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            timeLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -14),
            timeLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
        lapLabel.textColor = .label
        timeLabel.textColor = .label
        timeLabel.text = ""
    }
    
}
