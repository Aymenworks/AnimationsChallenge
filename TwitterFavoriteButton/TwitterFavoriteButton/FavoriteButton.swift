//
//  FavoriteButton.swift
//  FavoriteButton
//
//  Created by Aymen Rebouh on 2018/12/14.
//  Copyright © 2018 Aymen Rebouh. All rights reserved.
//

import UIKit

struct SmallCircleConfiguration {
    let startColor: UIColor
    let endColor: UIColor
}

class FavoriteButton: UIButton {
    
    // MARK: Properties
    
    let heartImage = CALayer()
    let circleLayer = CAShapeLayer()
    var smallCirclesLayers: [CAShapeLayer] = []
    
    var smallCirclesConfigurations: [SmallCircleConfiguration] = [
        .init(startColor: #colorLiteral(red: 0.6784313725, green: 0.8196078431, blue: 0.937254902, alpha: 1), endColor: #colorLiteral(red: 0.7803921569, green: 0.6392156863, blue: 0.8941176471, alpha: 1)),
        .init(startColor: #colorLiteral(red: 0.7725490196, green: 0.6352941176, blue: 0.9176470588, alpha: 1), endColor: #colorLiteral(red: 0.9098039216, green: 0.7843137255, blue: 0.368627451, alpha: 1)),
        .init(startColor: #colorLiteral(red: 0.7058823529, green: 0.8784313725, blue: 0.8156862745, alpha: 1), endColor: #colorLiteral(red: 0.8078431373, green: 0.7490196078, blue: 0.6431372549, alpha: 1)),
        .init(startColor: #colorLiteral(red: 0.9019607843, green: 0.6039215686, blue: 0.6941176471, alpha: 1), endColor: #colorLiteral(red: 0.3725490196, green: 0.6549019608, blue: 0.9215686275, alpha: 1)),
        .init(startColor: #colorLiteral(red: 0.6784313725, green: 0.8196078431, blue: 0.937254902, alpha: 1), endColor: #colorLiteral(red: 0.7647058824, green: 0.8784313725, blue: 0.6980392157, alpha: 1)),
        .init(startColor: #colorLiteral(red: 0.7725490196, green: 0.6352941176, blue: 0.9176470588, alpha: 1), endColor: #colorLiteral(red: 0.7058823529, green: 0.8784313725, blue: 0.8156862745, alpha: 1)),
        .init(startColor: #colorLiteral(red: 0.7058823529, green: 0.8784313725, blue: 0.8156862745, alpha: 1), endColor: #colorLiteral(red: 0.7803921569, green: 0.6392156863, blue: 0.8941176471, alpha: 1)),
    ]
    
    let smallCircleSize: CGSize = CGSize(width: 3, height: 3)

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
        
        heartImage.frame = CGRect(x: layer.bounds.width/2.0 - 8, y: layer.bounds.height/2.0 - 8, width: 16, height: 16)
        circleLayer.frame = CGRect(x: layer.bounds.width/2.0 - layer.bounds.width/4, y: layer.bounds.height/2.0 - layer.bounds.height/4.0, width: layer.bounds.width/2.0, height: layer.bounds.height/2.0)
        circleLayer.cornerRadius = circleLayer.bounds.height/2.0
    }
    
    // MARK: Setup
    
    private func setup() {
        self.isSelected = false
        
        layout: do {
            setupSmallCircles()
            layer.addSublayer(circleLayer)
            layer.addSublayer(heartImage)
            heartImage.contents = UIImage(named: "like")?.cgImage

            print("circlelayer bounds = \(circleLayer.bounds)")
            positionnateSmallCirclesPoints(numberOfPoints: smallCirclesLayers.count, radius: layer.bounds.width/7.0, center: CGPoint(x: layer.bounds.width/2.0 - smallCircleSize.width/2.0, y: layer.bounds.width/2.0 - smallCircleSize.height/2.0))
        }
        
        UI: do {
            circleLayer.fillColor = nil
            circleLayer.opacity = 0
            circleLayer.borderWidth = bounds.width/4.0
            circleLayer.borderColor = #colorLiteral(red: 0.8196078431, green: 0.3019607843, blue: 0.5176470588, alpha: 1).cgColor
        }
        
        interactions: do {
            addTarget(self, action: #selector(didTapButton), for: .touchUpInside)
        }
    }
    
    // MARK: User Interaction
    
    @objc func didTapButton() {
        animate()
    }
    
    // MARK: Animation
    
    func animate() {
        if self.isSelected {
            self.isSelected = false
            backToNormal()
        } else {
            self.isSelected = true
            animationFirstStep()
        }
    }
    
    func backToNormal() {
        makeHeartBiggerAndBounce: do {
            let contentAnimation = CABasicAnimation(keyPath: "contents")
            contentAnimation.fromValue = self.heartImage.contents
            contentAnimation.toValue = UIImage(named: "like")?.cgImage
            contentAnimation.duration = 0.05
            contentAnimation.fillMode = .forwards
            contentAnimation.isRemovedOnCompletion = false
            self.heartImage.add(contentAnimation, forKey: "contentAnimation")
            
            let scaleAnimation = CABasicAnimation(keyPath: "transform.scale")
            scaleAnimation.fromValue = 1
            scaleAnimation.toValue = 1.5
            scaleAnimation.fillMode = .forwards
            scaleAnimation.isRemovedOnCompletion = false
            scaleAnimation.duration = 0.15
            scaleAnimation.timingFunction = CAMediaTimingFunction(name: .easeIn)
            scaleAnimation.beginTime = CACurrentMediaTime() + contentAnimation.duration
            self.heartImage.add(scaleAnimation, forKey: "scaleAnimation")
            
            let scaleAnimation2 = CABasicAnimation(keyPath: "transform.scale")
            scaleAnimation2.fromValue = 1.5
            scaleAnimation2.toValue = 1
            scaleAnimation2.fillMode = .forwards
            scaleAnimation2.isRemovedOnCompletion = false
            scaleAnimation2.beginTime =  CACurrentMediaTime() + scaleAnimation.duration + contentAnimation.duration
            scaleAnimation2.timingFunction = CAMediaTimingFunction(name: .easeOut)
            scaleAnimation2.duration = 0.15
            self.heartImage.add(scaleAnimation2, forKey: "scaleAnimation2")
        }
    }
    
    func animationFirstStep() {
        var totalDuration: CFTimeInterval = 0
        var totalDurationForThin: CFTimeInterval = 0

        hideHeartImage: do {
            let heartScaleAnimation = CABasicAnimation(keyPath: "transform.scale")
            heartScaleAnimation.fromValue = 1
            heartScaleAnimation.toValue = 0
            heartScaleAnimation.fillMode = .forwards
            heartScaleAnimation.duration = 0.05
            heartScaleAnimation.isRemovedOnCompletion = false
            heartImage.add(heartScaleAnimation, forKey: "heartScaleAnimation")
            totalDuration += heartScaleAnimation.duration
        }
        
        showCircle: do {
            let circleOpacityAnimation = CABasicAnimation(keyPath: "opacity")
            circleOpacityAnimation.fromValue = 0
            circleOpacityAnimation.toValue = 1
            circleOpacityAnimation.duration = 0.05
            circleOpacityAnimation.fillMode = .forwards
            circleOpacityAnimation.isRemovedOnCompletion = false
            circleOpacityAnimation.beginTime = CACurrentMediaTime() + totalDuration
            totalDuration += circleOpacityAnimation.duration
            circleLayer.add(circleOpacityAnimation, forKey: "circleOpacityAnimation")
        }
        
        changeCircleSizeAndolor: do {
            let changeCircleSizeColorGroupAnimation = CAAnimationGroup()
            
            let circleScaleAnimation = CABasicAnimation(keyPath: "transform.scale")
            circleScaleAnimation.fromValue = 1
            circleScaleAnimation.toValue = 2
            
            let circleColorAnimation = CABasicAnimation(keyPath: "borderColor")
            circleColorAnimation.fromValue = #colorLiteral(red: 0.8274509804, green: 0.2431372549, blue: 0.4196078431, alpha: 1).cgColor
            circleColorAnimation.toValue = #colorLiteral(red: 0.7803921569, green: 0.6392156863, blue: 0.8941176471, alpha: 1).cgColor
            
            changeCircleSizeColorGroupAnimation.animations = [circleScaleAnimation, circleColorAnimation]
            changeCircleSizeColorGroupAnimation.duration = 0.1
            changeCircleSizeColorGroupAnimation.fillMode = .forwards
            changeCircleSizeColorGroupAnimation.isRemovedOnCompletion = false
            changeCircleSizeColorGroupAnimation.beginTime = CACurrentMediaTime() + totalDuration
            totalDuration += changeCircleSizeColorGroupAnimation.duration
            
            circleLayer.add(changeCircleSizeColorGroupAnimation, forKey: "changeCircleSizeColorGroupAnimation")
        }

        let borderWidthAnimation = CABasicAnimation(keyPath: "borderWidth")
        makeCircleThinner: do {
            borderWidthAnimation.fromValue = circleLayer.borderWidth
            borderWidthAnimation.toValue = 0
            borderWidthAnimation.duration = 0.1
            borderWidthAnimation.beginTime = CACurrentMediaTime() + totalDuration
            borderWidthAnimation.fillMode = .forwards
            borderWidthAnimation.isRemovedOnCompletion = false
            totalDuration += borderWidthAnimation.duration
            circleLayer.add(borderWidthAnimation, forKey: "borderWidthAnimation")
        }
        
        totalDurationForThin = totalDuration - (borderWidthAnimation.duration/2)

        makeHeartBiggerAndBounce: do {
            let contentAnimation = CABasicAnimation(keyPath: "contents")
            contentAnimation.fromValue = self.heartImage.contents
            contentAnimation.toValue = UIImage(named: "like-filled")?.cgImage
            contentAnimation.duration = 0.05
            contentAnimation.fillMode = .forwards
            contentAnimation.isRemovedOnCompletion = false
            contentAnimation.beginTime = CACurrentMediaTime() + totalDurationForThin
            totalDurationForThin = totalDuration - (borderWidthAnimation.duration/2)
            totalDuration += contentAnimation.duration - (borderWidthAnimation.duration/2)
            self.heartImage.add(contentAnimation, forKey: "contentAnimation")

            let scaleAnimation = CABasicAnimation(keyPath: "transform.scale")
            scaleAnimation.fromValue = 0
            scaleAnimation.toValue = 1.2
            scaleAnimation.fillMode = .forwards
            scaleAnimation.isRemovedOnCompletion = false
            scaleAnimation.duration = 0.15
            scaleAnimation.timingFunction = CAMediaTimingFunction(name: .easeIn)
            scaleAnimation.beginTime = CACurrentMediaTime() + totalDurationForThin
            self.heartImage.add(scaleAnimation, forKey: "scaleAnimation")
    
            let scaleAnimation2 = CABasicAnimation(keyPath: "transform.scale")
            scaleAnimation2.fromValue = 1.2
            scaleAnimation2.toValue = 1
            scaleAnimation2.fillMode = .forwards
            scaleAnimation2.isRemovedOnCompletion = false
            scaleAnimation2.beginTime =  CACurrentMediaTime() + totalDurationForThin + scaleAnimation.duration
            scaleAnimation2.timingFunction = CAMediaTimingFunction(name: .easeOut)
            scaleAnimation2.duration = 0.05
            totalDuration += scaleAnimation2.duration
            self.heartImage.add(scaleAnimation2, forKey: "scaleAnimation2")
        }
        
        animateSmallCircles: do {
            for (i, smallCircleLayer) in smallCirclesLayers.enumerated() {
                let smallCircleOpacityAnimation = CABasicAnimation(keyPath: "opacity")
                smallCircleOpacityAnimation.fromValue = 0
                smallCircleOpacityAnimation.toValue = 1
                smallCircleOpacityAnimation.duration = 0.1
                smallCircleOpacityAnimation.fillMode = .forwards
                smallCircleOpacityAnimation.isRemovedOnCompletion = false
                smallCircleOpacityAnimation.beginTime = CACurrentMediaTime() + totalDurationForThin
                smallCircleLayer.add(smallCircleOpacityAnimation, forKey: "smallCircleOpacityAnimation")
                
                let smallCircleScaleAnimation = CABasicAnimation(keyPath: "transform.scale")
                smallCircleScaleAnimation.fromValue = 1
                smallCircleScaleAnimation.toValue = 0
                
                let smallCircleColorAnimation = CABasicAnimation(keyPath: "borderColor")
                smallCircleColorAnimation.fromValue = smallCirclesConfigurations[i].startColor.cgColor
                smallCircleColorAnimation.toValue = smallCirclesConfigurations[i].endColor.cgColor
                
                let smallCirclePositionAnimation = CABasicAnimation(keyPath: "position")
                smallCirclePositionAnimation.fromValue = smallCircleLayer.position
                smallCirclePositionAnimation.toValue = positionForSmallCircle(atIndex: i, radius: layer.bounds.width * 1.2, center:  CGPoint(x: layer.bounds.width/2.0 - smallCircleSize.width/2.0, y: layer.bounds.width/2.0 - smallCircleSize.height/2.0))
                
                let smallCirclGroupAnimation = CAAnimationGroup()
                smallCirclGroupAnimation.animations = [smallCircleScaleAnimation, smallCircleColorAnimation, smallCirclePositionAnimation]
                smallCirclGroupAnimation.duration = 1
                smallCirclGroupAnimation.timingFunction = CAMediaTimingFunction(name: .easeOut)
                smallCirclGroupAnimation.fillMode = .forwards
                smallCirclGroupAnimation.isRemovedOnCompletion = false
                smallCirclGroupAnimation.beginTime = CACurrentMediaTime() + totalDurationForThin
                
                smallCircleLayer.add(smallCirclGroupAnimation, forKey: "smallCirclGroupAnimation")
            }
        }
    }
    
    // MARK: Setup
    
    func setupSmallCircles() {
        for smallCircleConfiguration in smallCirclesConfigurations {
            let circle = CAShapeLayer()
            circle.opacity = 0
            circle.fillColor = nil
            circle.borderColor = smallCircleConfiguration.startColor.cgColor
            circle.borderWidth = 10
            layer.addSublayer(circle)
            smallCirclesLayers.append(circle)
        }
    }
    
    func positionForSmallCircle(atIndex i: Int, radius: CGFloat, center: CGPoint) -> CGPoint {
        let slice: CGFloat = CGFloat.pi * 2.0 / CGFloat(smallCirclesLayers.count)
        let angle = slice * CGFloat(i)
        let x = center.x + radius * cos(angle)
        let y = center.y + radius * sin(angle)
        let point = CGPoint(x: x, y: y)
        
        return point
    }
    
    func positionnateSmallCirclesPoints(numberOfPoints: Int, radius: CGFloat, center: CGPoint) {
        for i in 0..<numberOfPoints {
            let position = positionForSmallCircle(atIndex: i, radius: radius, center: center)
            let smallCircleLayer = smallCirclesLayers[i]
            smallCircleLayer.frame = CGRect(origin: position, size: smallCircleSize)
            smallCircleLayer.cornerRadius = smallCircleLayer.bounds.height/2.0
        }
    }
}
