//
//  ViewController.swift
//  InstagramProgressBar
//
//  Created by Rebouh Aymen on 27/02/2019.
//  Copyright © 2019 Rebouh Aymen. All rights reserved.
//

import UIKit


class ProgressContainerView: UIStackView {

    let numberOfItems: Int

    private let items: [ItemView]

    let animationDuration: Float = 1

    init(numberOfItems: Int) {

        self.numberOfItems = numberOfItems

        items = (0..<numberOfItems).map { _ in
            ItemView()
        }

        super.init(frame: .zero)

    }

    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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

    init() {

        super.init(frame: .zero)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func start() {

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

        let progressView = ProgressContainerView(numberOfItems: 10)
        
        view.addSubview(progressView)
    }
}
