//
//  ASItemView.swift
//  InstagramProgressBar
//
//  Created by Rebouh Aymen on 28/02/2019.
//  Copyright © 2019 Rebouh Aymen. All rights reserved.
//

import Foundation
import UIKit

class ASItemView: UIView {
    
    // MARK: Properties
    
    enum State {
        case empty, inProgress, full
    }
    
    var state: State = .empty {
        didSet {
            guard oldValue != state else { return }
            update()
        }
    }
    
    let foregroundLayer = CAShapeLayer()
    let backgroundLayer = CAShapeLayer()

    // Duration for each bar item
    let animationDuration: TimeInterval
    var completionHandler: (() -> ())?
    
    // MARK: Lifecycle
    
    init(animationDuration: TimeInterval, completionHandler: @escaping () -> ()) {
        
        self.animationDuration = animationDuration
        self.completionHandler = completionHandler
        
        super.init(frame: .zero)
        
        setupLayers: do {
            
            backgroundColor = .clear
            
            backgroundLayer.fillColor = UIColor.black.withAlphaComponent(0.4).cgColor
            foregroundLayer.fillColor = UIColor.white.cgColor
            
            layer.addSublayer(backgroundLayer)
            layer.addSublayer(foregroundLayer)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSublayers(of layer: CALayer) {
        super.layoutSublayers(of: layer)
        
        backgroundLayer.path = UIBezierPath(roundedRect: layer.bounds, cornerRadius: layer.bounds.height/2.0).cgPath
        foregroundLayer.path = UIBezierPath(roundedRect: CGRect(x: 0, y: 0, width: 0, height: layer.bounds.height), cornerRadius: layer.bounds.height/2.0).cgPath
    }
    
    // MARK: UI Appareance
    
    func update() {
        switch state {
        case .empty:
            let emptyPath = UIBezierPath(roundedRect: CGRect(x: 0, y: 0, width: 0, height: layer.bounds.height), cornerRadius: layer.bounds.height/2.0).cgPath
            foregroundLayer.path = emptyPath
            foregroundLayer.removeAllAnimations()
        case .inProgress:
            break
        case .full:
            let fullPath = UIBezierPath(roundedRect: CGRect(x: 0, y: 0, width: layer.bounds.width, height: layer.bounds.height), cornerRadius: layer.bounds.height/2.0).cgPath
            foregroundLayer.path = fullPath
            foregroundLayer.removeAllAnimations()
        }
    }
    
    func start() {
        foregroundLayer.removeAllAnimations()
        
        let animation = CABasicAnimation(keyPath: "path")
        animation.delegate = self
        animation.duration = animationDuration
        animation.toValue = UIBezierPath(roundedRect: CGRect(x: 0, y: 0, width: layer.bounds.width, height: layer.bounds.height), cornerRadius: layer.bounds.height/2.0).cgPath
        animation.fillMode = .forwards
        animation.isRemovedOnCompletion = false
        
        foregroundLayer.add(animation, forKey: "animation")
    }
    
    /// See https://developer.apple.com/library/archive/qa/qa1673/_index.html
    func pause() {
        let pausedTime = foregroundLayer.convertTime(CACurrentMediaTime(), from: nil)
        foregroundLayer.speed = 0
        foregroundLayer.timeOffset = pausedTime
    }
    
    /// See https://developer.apple.com/library/archive/qa/qa1673/_index.html
    func resume() {
        let pausedTime = foregroundLayer.timeOffset
        foregroundLayer.speed = 1.0
        foregroundLayer.timeOffset = 0.0
        foregroundLayer.beginTime = 0.0
        let timeSincePause =  foregroundLayer.convertTime(CACurrentMediaTime(), from: nil) - pausedTime
        foregroundLayer.beginTime = timeSincePause
    }
}

// MARK: CAAnimationDelegate
extension ASItemView: CAAnimationDelegate  {
    
    func animationDidStart(_ anim: CAAnimation) {
        state = .inProgress
    }
    
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        guard flag && self.state  == .inProgress else { return }
        self.state = .full
        self.completionHandler?()
    }
}
