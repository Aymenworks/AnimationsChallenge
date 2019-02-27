//
//  ViewController.swift
//  InstagramProgressBar
//
//  Created by Rebouh Aymen on 27/02/2019.
//  Copyright © 2019 Rebouh Aymen. All rights reserved.
//

import UIKit


class ProgressContainerView: UIStackView {

    var numberOfItems: Int  {
        return self.arrangedSubviews.count
    }

    var isPaused: Bool = false

    //  Current item index
    var currentIndex: Int = 0

    init(numberOfItems: Int, animationDuration: TimeInterval = 5) {

        super.init(frame: .zero)
        
        setupStackView: do {
            self.axis = .horizontal
            self.spacing = 5
            self.distribution = .fillEqually
            self.alignment = .fill
        }
        
        setupItems: do {
            for _ in 0..<numberOfItems {
                self.addArrangedSubview(
                    ItemView(
                        animationDuration: animationDuration,
                        completionHandler: {
                            self.next()
                    })
                )
            }
        }
    }

    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
    }
    
    func start() {
        (arrangedSubviews[currentIndex] as? ItemView)?.start()
    }

    func toggle() {
        if isPaused {
            (arrangedSubviews[currentIndex] as? ItemView)?.resume()
        } else {
            (arrangedSubviews[currentIndex] as? ItemView)?.pause()
        }
        isPaused = !isPaused
    }


    func next() {
        // We reach the end
        if currentIndex == arrangedSubviews.count-1 {
            print("finish")
            return
        }
        
        currentIndex += 1
        start()
    }

    func previous() {
        // It's the first item, so cannot go before
        if currentIndex == 0 {
            return
        }
        
        currentIndex -= 1
        start()
    }

}

class ItemView: UIView {

    let foregroundLayer = CAShapeLayer()
    let backgroundLayer = CAShapeLayer()
    
    // Duration for each bar item
    let animationDuration: TimeInterval
    var completionHandler: (() -> ())?

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


    func start() {
        let animation = CABasicAnimation(keyPath: "path")
        animation.delegate = self
        animation.duration = animationDuration
        animation.toValue = UIBezierPath(roundedRect: CGRect(x: 0, y: 0, width: layer.bounds.width, height: layer.bounds.height), cornerRadius: layer.bounds.height/2.0).cgPath
        animation.fillMode = .forwards
        animation.isRemovedOnCompletion = false
        foregroundLayer.add(animation, forKey: "animation")
    }

    func pause() {

        let pausedTime = foregroundLayer.convertTime(CACurrentMediaTime(), from: nil)
        foregroundLayer.speed = 0.0
        foregroundLayer.timeOffset = pausedTime
    }

    func resume() {

        let pausedTime = foregroundLayer.timeOffset
        foregroundLayer.speed = 1.0
        foregroundLayer.timeOffset = 0.0
        foregroundLayer.beginTime = 0.0
        let timeSincePause =  foregroundLayer.convertTime(CACurrentMediaTime(), from: nil) - pausedTime
        foregroundLayer.beginTime = timeSincePause
    }
}

extension ItemView: CAAnimationDelegate  {
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        if flag {
            completionHandler?()
        }
    }
}

class ViewController: UIViewController {

    let rideauxImages = [#imageLiteral(resourceName: "rideau1"),#imageLiteral(resourceName: "rideau6"),#imageLiteral(resourceName: "rideau2"),#imageLiteral(resourceName: "rideau3"),#imageLiteral(resourceName: "rideau5"),#imageLiteral(resourceName: "rideau4"),#imageLiteral(resourceName: "rideau7")]
    let progressView = ProgressContainerView(numberOfItems: 3, animationDuration: 5)
    
    override func viewDidLoad() {
        super.viewDidLoad()

        progressView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(progressView)
        
        NSLayoutConstraint.activate([
            progressView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            progressView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 5),
            progressView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -5),
            progressView.heightAnchor.constraint(equalToConstant: 4)
        ])
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        progressView.start()
    }

    @IBAction func pause(_ sender: Any) {

        progressView.toggle()
    }

}
