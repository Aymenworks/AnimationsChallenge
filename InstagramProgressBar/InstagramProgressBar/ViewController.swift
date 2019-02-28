//
//  ViewController.swift
//  InstagramProgressBar
//
//  Created by Rebouh Aymen on 27/02/2019.
//  Copyright © 2019 Rebouh Aymen. All rights reserved.
//

import UIKit

class ProgressInCodeViewController: UIViewController {

    //  MARK: Properties
    
    @IBOutlet weak var imageView: UIImageView!
    let rideauxImages = [#imageLiteral(resourceName: "rideau1"),#imageLiteral(resourceName: "rideau6"),#imageLiteral(resourceName: "rideau2"),#imageLiteral(resourceName: "rideau3"),#imageLiteral(resourceName: "rideau5"),#imageLiteral(resourceName: "rideau4"),#imageLiteral(resourceName: "rideau7")]
    let humansImages = [#imageLiteral(resourceName: "shima1"),#imageLiteral(resourceName: "aymen1"),#imageLiteral(resourceName: "aymen2"),#imageLiteral(resourceName: "shima2")]
    let progressView = ASProgressView()
    
    // Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        progressView.dataSource = self
        progressView.delegate = self

        setupLayout: do {
            progressView.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(progressView)
            
            NSLayoutConstraint.activate([
                progressView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
                progressView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 5),
                progressView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -5),
                progressView.heightAnchor.constraint(equalToConstant: 4)
            ])
        }
        
        setupGestures: do {
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTapGesture(gesture:)))
            view.addGestureRecognizer(tapGesture)
            
            let longGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPressGesture(gesture:)))
            longGesture.minimumPressDuration = 0.2
            view.addGestureRecognizer(longGesture)
        }
    }
    
    // MARK: User Interaction
    
    @objc func handleLongPressGesture(gesture: UIGestureRecognizer) {
        switch gesture.state {
        case .began:
            progressView.pause()
        case .ended:
            progressView.resume()
        default: break
        }
    }

    @objc func handleTapGesture(gesture: UIGestureRecognizer) {

        let locationX = gesture.location(in: self.view).x
        let centerX = view.center.x
        
        if locationX < centerX {
            progressView.previous()
        } else {
            progressView.next()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        progressView.start()
    }
}

extension ProgressInCodeViewController: ASProgressViewDataSource  {
    func numberOfItems(in progressView: ASProgressView) -> Int {
        return humansImages.count
    }
    
    func durationAnimation(in progressView: ASProgressView, forItemAtIndex index: Int) -> TimeInterval {
        if index == 1 {
            return 2
        }
        
        return 2
    }
    
    func backgroundColor(in progressView: ASProgressView) -> UIColor {
        return UIColor.black.withAlphaComponent(0.5)
    }
    
    func foregroundColor(in progressView: ASProgressView) -> UIColor {
        return .white
    }
}

extension ProgressInCodeViewController: ASProgressViewDelegate {
    func progressView(_ progressView: ASProgressView, didStartDisplayingItemAtIndex index: Int) {
        imageView.image = humansImages[index]
    }
    
    func didFinishDisplayingAllItems(inProgressView progressView: ASProgressView) {
        print("delegate finish all")
    }
}
