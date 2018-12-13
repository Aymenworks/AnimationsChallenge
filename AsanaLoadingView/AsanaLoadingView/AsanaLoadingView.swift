//
//  AsanaLoadingView.swift
//  AnimationChallenge2
//
//  Created by Aymen Rebouh on 2018/12/12.
//  Copyright © 2018 Aymen Rebouh. All rights reserved.
//

import UIKit

class AsanaLoadingView: UIView {

    // MARK: Properties
    
    private struct Colors {
        static let pink = #colorLiteral(red: 0.9294117647, green: 0.5215686275, blue: 0.568627451, alpha: 1)
        static let beige = #colorLiteral(red: 0.968627451, green: 0.8274509804, blue: 0.6666666667, alpha: 1)
    }
    
    let gradientLayer = CAGradientLayer()

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
        
        gradientLayer.frame = bounds
    }
    
    // MARK: Setup

    private func setup() {
        gradientLayer.colors = [Colors.pink.cgColor, Colors.beige.cgColor, Colors.pink.cgColor]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1, y: 0.5)
        gradientLayer.locations = [0.0, 0.0, 0.4]
        layer.addSublayer(gradientLayer)
        
        NotificationCenter.default.addObserver(self, selector: #selector(startLoading), name: UIApplication.willEnterForegroundNotification, object: nil)
        startLoading()
    }
    
    // MARK: Animation
    
    @objc func startLoading() {
        let animation = CABasicAnimation(keyPath: "locations")
        animation.duration = 1.5
        animation.fromValue = [0.0, 0.0, 0.4]
        animation.toValue = [0.4, 0.9, 1]
        animation.repeatCount = .infinity
        gradientLayer.add(animation, forKey: "AsanaLoadingView")
    }
}
