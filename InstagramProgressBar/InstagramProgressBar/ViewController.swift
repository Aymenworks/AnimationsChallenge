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

    //  Current item index
    var currentIndex = 0
    
    init(numberOfItems: Int, animationDuration: TimeInterval) {

        super.init(frame: .zero)
        
        setupStackView: do {
            self.axis = .horizontal
            self.spacing = 5
            self.distribution = .fillEqually
            self.alignment = .fill
        }
        
        setupItems: do {
            for _ in 0..<numberOfItems {
                self.addArrangedSubview(ItemView(animationDuration: animationDuration))
            }
        }
    }

    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        
    }
    
    func start() {

    }

    func stop() {

    }

    func resume() {

    }

    func next() {

    }

    func previous() {

    }

}

class ItemView: UIView {

    private var progress: Float = 0

    let foregroundLayer = CAShapeLayer()
    let backgroundLayer = CAShapeLayer()
    
    // Duration for each bar item
    let animationDuration: TimeInterval
    
    init(animationDuration: TimeInterval = 5) {
        self.animationDuration = animationDuration

        super.init(frame: .zero)

        setupLayers: do {

            backgroundColor = .clear

            backgroundLayer.fillColor = UIColor.red.cgColor
            foregroundLayer.fillColor = UIColor.yellow.cgColor

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
        
        // TODO:  Shima feedback -> check animation cost
        let progress:  CGFloat = 0.1
        foregroundLayer.path = UIBezierPath(roundedRect: CGRect(x: 0, y: 0, width: layer.bounds.width * progress, height: layer.bounds.height), cornerRadius: layer.bounds.height/2.0).cgPath
        
        // try
        start()
    }

    func start() {
        let animation = CABasicAnimation(keyPath: "path")
        animation.duration = 3
        animation.toValue = UIBezierPath(roundedRect: CGRect(x: 0, y: 0, width: layer.bounds.width, height: layer.bounds.height), cornerRadius: layer.bounds.height/2.0).cgPath
        foregroundLayer.add(animation, forKey: "animation")
    }

    func stop() {
    
    }

    func resume() {

    }
}

class ViewController: UIViewController {

    let rideauxImages = [#imageLiteral(resourceName: "rideau1"),#imageLiteral(resourceName: "rideau6"),#imageLiteral(resourceName: "rideau2"),#imageLiteral(resourceName: "rideau3"),#imageLiteral(resourceName: "rideau5"),#imageLiteral(resourceName: "rideau4"),#imageLiteral(resourceName: "rideau7")]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let progressView = ProgressContainerView(numberOfItems: 10, animationDuration: 1)
        progressView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(progressView)
        
        NSLayoutConstraint.activate([
            progressView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            progressView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 5),
            progressView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -5),
            progressView.heightAnchor.constraint(equalToConstant: 4)
        ])
    }
}
