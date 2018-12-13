//
//  RadarView.swift
//  AnimationChallenge2
//
//  Created by Aymen Rebouh on 2018/12/12.
//  Copyright © 2018 Aymen Rebouh. All rights reserved.
//

import UIKit

class RadarView: UIView {
    
    // MARK: Properties
    
    struct Colors {
        static let start = #colorLiteral(red: 0.721568644, green: 0.8862745166, blue: 0.5921568871, alpha: 0.5)
        static let end = #colorLiteral(red: 0.2745098174, green: 0.4862745106, blue: 0.1411764771, alpha: 0.5)
    }

    let circleLayer = CAShapeLayer()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        setup()
    }
    
    // MARK: Setup
    
    private func setup() {
        backgroundColor = Colors.start
        layer.addSublayer(circleLayer)
        
        NotificationCenter.default.addObserver(self, selector: #selector(startLoading), name: UIApplication.willEnterForegroundNotification, object: nil)
        startLoading()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        layer.cornerRadius = bounds.height / 2.0
        circleLayer.frame = bounds
    }
    
    override func layoutSublayers(of layer: CALayer) {
        super.layoutSublayers(of: layer)

        let bezierPath = UIBezierPath(roundedRect: bounds, cornerRadius: bounds.height / 2.0)
        circleLayer.path = bezierPath.cgPath
    }
    
    @objc func startLoading() {
        let scaleAnimation = CABasicAnimation(keyPath: "transform.scale")
        scaleAnimation.fromValue = 1
        scaleAnimation.toValue = 4
        
        let fillColorAnimation = CABasicAnimation(keyPath: "fillColor")
        fillColorAnimation.fromValue = Colors.start.cgColor
        fillColorAnimation.toValue = Colors.end.cgColor
        
        let opacityAnimation = CABasicAnimation(keyPath: "opacity")
        opacityAnimation.fromValue = 1
        opacityAnimation.toValue = 0
        
        let animationGroup = CAAnimationGroup()
        animationGroup.animations = [scaleAnimation, fillColorAnimation, opacityAnimation]
        animationGroup.duration = 2
        animationGroup.repeatCount = .infinity
    
        circleLayer.add(animationGroup, forKey: "RadarView")
    }
    
}

