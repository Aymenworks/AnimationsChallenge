//
//  TwitterFavoriteButton.swift
//  TwitterFavoriteButton
//
//  Created by Aymen Rebouh on 2018/12/14.
//  Copyright © 2018 Aymen Rebouh. All rights reserved.
//

import UIKit

class TwitterFavoriteButton: UIButton {
    
    // MARK: Properties
    
    let circleLayer = CAShapeLayer()
    
    // MARK: Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        setup()
    }
    
    override func layoutSublayers(of layer: CALayer) {
        super.layoutSublayers(of: layer)
        
        circleLayer.frame = layer.bounds
        circleLayer.cornerRadius = layer.bounds.height/2.0
    }
    
    // MARK: Setup
    
    private func setup() {
        layout: do {
            layer.addSublayer(circleLayer)
        }
        
        interactions: do {
            addTarget(self, action: #selector(didTapButton), for: .touchUpInside)
        }
        
        UI: do {
            circleLayer.fillColor = nil
            circleLayer.borderWidth = 10
            circleLayer.borderColor = #colorLiteral(red: 0.8196078431, green: 0.3019607843, blue: 0.5176470588, alpha: 1).cgColor
        }
        tests: do {
        }
    }
    
    // MARK: User Interaction
    
    @objc func didTapButton() {
        animate()
    }
    
    // MARK: Animation
    
    func animate() {
//        animationFirstStep()
        animateSecondStep()
    }
    
    func animationFirstStep() {
        let circleScaleAnimation = CABasicAnimation(keyPath: "transform.scale")
        circleScaleAnimation.fromValue = 1
        circleScaleAnimation.toValue = 2
        
        let circleColorAnimation = CABasicAnimation(keyPath: "borderColor")
        circleColorAnimation.fromValue = #colorLiteral(red: 0.8196078431, green: 0.3019607843, blue: 0.5176470588, alpha: 1).cgColor
        circleColorAnimation.toValue = #colorLiteral(red: 0.7803921569, green: 0.6392156863, blue: 0.8941176471, alpha: 1).cgColor
        
        let circleGroupAnimation = CAAnimationGroup()
        circleGroupAnimation.animations = [circleScaleAnimation, circleColorAnimation]
        circleGroupAnimation.duration = 2
        circleGroupAnimation.fillMode = .forwards
        circleGroupAnimation.isRemovedOnCompletion = false
        
        circleLayer.add(circleGroupAnimation, forKey: "circleGroupAnimation")
        
        let borderWidthAnimation = CABasicAnimation(keyPath: "borderWidth")
        borderWidthAnimation.fromValue = circleLayer.borderWidth
        borderWidthAnimation.toValue = 0
        borderWidthAnimation.duration = 2
        borderWidthAnimation.beginTime = CACurrentMediaTime() + circleGroupAnimation.duration
        borderWidthAnimation.fillMode = .forwards
        borderWidthAnimation.isRemovedOnCompletion = false
        
        
        circleLayer.add(borderWidthAnimation, forKey: "borderWidthAnimation")
    }
    
    // Particles
    func animateSecondStep() {
        print("emitter step 2")
        
        let emitterLayer = CAEmitterLayer()
        emitterLayer.emitterShape = .circle
        emitterLayer.emitterSize = circleLayer.bounds.size
            emitterLayer.emitterPosition = CGPoint(x: circleLayer.bounds.midX, y: circleLayer.bounds.midY)
        emitterLayer.emitterCells = emiterCells()
        emitterLayer.renderMode = .additive
        circleLayer.addSublayer(emitterLayer)
    }
    
    func emiterCells() -> [CAEmitterCell] {
        let fireworkCell = CAEmitterCell()
        fireworkCell.color = UIColor.red.cgColor
        fireworkCell.contents = UIImage(named: "circle")?.cgImage
        fireworkCell.lifetime = 100
        fireworkCell.birthRate = 20000
        fireworkCell.velocity = 130
        fireworkCell.scale = 0.6
        fireworkCell.spin = 2
        fireworkCell.alphaSpeed = -0.2
        fireworkCell.scaleSpeed = -0.1
        fireworkCell.beginTime = 1.5
        fireworkCell.duration = 0.1
        fireworkCell.emissionRange = CGFloat.pi * 2
        fireworkCell.yAcceleration = -80

        return [fireworkCell]
    }
}
