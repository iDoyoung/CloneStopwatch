//
//  ControlButton.swift
//  StopWatch
//
//  Created by Doyoung on 2022/07/26.
//

import UIKit

@IBDesignable
final class ControlButton: UIButton {
    
    var timerStatus: TimerStatus = .initialized
    
    override func tintColorDidChange() {
        setTitleColor(tintColor, for: .normal)
        titleLabel?.backgroundColor = tintColor.withAlphaComponent(0.2)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        resetTitleLabel()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        resetTitleLabel()
    }
    
    private let strokeLayer: CAShapeLayer = {
        let layer = CAShapeLayer()
        let path = UIBezierPath(ovalIn: CGRect(x: 3, y: 3, width: 78, height: 78))
        layer.path = path.cgPath
        layer.fillColor = UIColor.clear.cgColor
        layer.lineWidth = 2
        layer.strokeColor = UIColor.systemBackground.cgColor
        return layer
    }()
    
    private func resetTitleLabel() {
        guard let view = titleLabel?.superview,
              let titleLabel = titleLabel else { return }
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.backgroundColor = tintColor.withAlphaComponent(0.2)
        titleLabel.layer.addSublayer(strokeLayer)
        titleLabel.layer.masksToBounds = true
        titleLabel.layer.cornerRadius = 42
        titleLabel.textAlignment = .center
        NSLayoutConstraint.activate([
            titleLabel.heightAnchor.constraint(equalToConstant: 84),
            titleLabel.widthAnchor.constraint(equalToConstant: 84),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
}
