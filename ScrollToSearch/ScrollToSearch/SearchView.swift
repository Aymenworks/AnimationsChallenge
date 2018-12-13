//
//  SearchView.swift
//  ScrollToSearch
//
//  Created by Aymen Rebouh on 2018/12/13.
//  Copyright © 2018 Aymen Rebouh. All rights reserved.
//

import UIKit

class SearchView: UIView {

    // MARK: Properties
    
    struct Colors {
        static let backgroundButtonBackgroundColor = UIColor.clear
        static let backgroundButtonTintColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        static let foregroundButtonBackgroundColor = #colorLiteral(red: 1, green: 0.8, blue: 0, alpha: 1)
        static let foregroundButtonTintColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
    }
    
    let shapeLayer = CAShapeLayer()
    let backgroundButton = UIButton()
    let foregroundButton = UIButton()

    enum AnimationState: CGFloat {
        case start = 0.0, full = 0.7, finalBigSize = 1
    }
    
    let maxScale: CGFloat = 1.3
    
    // MARK: Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        setup()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        foregroundButton.layer.cornerRadius = foregroundButton.bounds.height / 2.0
    }
    
    // MARK: Setup
    
    func setup() {
        UI: do {
            backgroundButton.setImage(UIImage(named: "search"), for: .normal)
            backgroundButton.backgroundColor = Colors.backgroundButtonBackgroundColor
            backgroundButton.tintColor = Colors.backgroundButtonTintColor
            
            foregroundButton.setImage(UIImage(named: "search"), for: .normal)
            foregroundButton.backgroundColor = Colors.foregroundButtonBackgroundColor
            foregroundButton.tintColor = Colors.foregroundButtonTintColor
        }
        layers: do {
            foregroundButton.layer.mask = shapeLayer
            foregroundButton.layer.masksToBounds = true
        }
        layout: do {
            addSubview(backgroundButton)
            addSubview(foregroundButton)
            
            backgroundButton.translatesAutoresizingMaskIntoConstraints = false
            foregroundButton.translatesAutoresizingMaskIntoConstraints = false
            
            NSLayoutConstraint.activate([
                backgroundButton.leadingAnchor.constraint(equalTo: leadingAnchor),
                backgroundButton.topAnchor.constraint(equalTo: topAnchor),
                backgroundButton.trailingAnchor.constraint(equalTo: trailingAnchor),
                backgroundButton.bottomAnchor.constraint(equalTo: bottomAnchor),
                
                foregroundButton.leftAnchor.constraint(equalTo: backgroundButton.leftAnchor),
                foregroundButton.topAnchor.constraint(equalTo: backgroundButton.topAnchor),
                foregroundButton.rightAnchor.constraint(equalTo: backgroundButton.rightAnchor),
                foregroundButton.bottomAnchor.constraint(equalTo: backgroundButton.bottomAnchor),
            ])
        }
    }
    
    // MARK: Animation
    
    func update(progress: CGFloat) {
        let progressForFullState = (progress - AnimationState.start.rawValue) / (AnimationState.full.rawValue - AnimationState.start.rawValue)
        let height: CGFloat = foregroundButton.bounds.height * progressForFullState
        let rect = CGRect(x: 0, y: foregroundButton.bounds.height - height, width: foregroundButton.bounds.width, height: height)
        let path = UIBezierPath(rect: rect).cgPath
        shapeLayer.path = path
        
        switch progress {
        case AnimationState.full.rawValue...:
            let newProgress = (progress - AnimationState.full.rawValue) / (AnimationState.finalBigSize.rawValue - AnimationState.full.rawValue)
            let scale = 1 + (maxScale-1) * newProgress
            foregroundButton.transform = CGAffineTransform(scaleX: scale, y: scale)
            
        case ...AnimationState.full.rawValue:
            foregroundButton.transform = .identity
        default:
            print("error weird value surprise")
        }
    }
}
