
//
//  ASProgressView.swift
//  InstagramProgressBar
//
//  Created by Rebouh Aymen on 28/02/2019.
//  Copyright © 2019 Rebouh Aymen. All rights reserved.
//

import Foundation
import UIKit

// Why protocol ? Because we should be able to setup the progress view even if we create it from the storyboard
protocol ASProgressViewDataSource: class {
    func numberOfItems(in progressView: ASProgressView) -> Int
    func foregroundColor(in progressView: ASProgressView) -> UIColor
    func backgroundColor(in progressView: ASProgressView) -> UIColor
    func durationAnimation(in progressView: ASProgressView, forItemAtIndex index: Int) -> TimeInterval
}

protocol ASProgressViewDelegate: class {
    func progressView(_ progressView: ASProgressView, didStartDisplayingItemAtIndex index: Int)
    func didFinishDisplayingAllItems(inProgressView progressView: ASProgressView)
}

class ASProgressView: UIView {
    
    // MARK: Properties

    weak var delegate: ASProgressViewDelegate?
    weak var dataSource: ASProgressViewDataSource? {
        didSet {
            setupItems()
        }
    }
    
    /// Stackview containing the items
    private let stackView = UIStackView()
    
    /// Whether the progress view is running or paused
    private var isPaused = false
    
    ///  Current item index
    private var currentIndex = 0
    
    // MARK: Lifecycle
    
    init() {
        super.init(frame: .zero)
        
        setupStackView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupStackView()
    }
    
    private func setupStackView() {
        stackView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(stackView)
            
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
        
        stackView.axis = .horizontal
        stackView.spacing = 5
        stackView.distribution = .fillEqually
        stackView.alignment = .fill
    }
    
    private func setupItems() {
        stackView.arrangedSubviews.forEach { $0.removeFromSuperview()  }

        guard  let dataSource = dataSource else { return }
        
        for i in 0..<dataSource.numberOfItems(in: self) {
            let animationDuration = dataSource.durationAnimation(in: self, forItemAtIndex: i)
            let item = ASItemView(animationDuration: animationDuration) {
                self.next()
            }
            stackView.addArrangedSubview(item)
        }
    }
    
    func start() {
        guard dataSource != nil else { fatalError("ASProgressView data source is not set") }
        
        delegate?.progressView(self, didStartDisplayingItemAtIndex: currentIndex)
        currentItem?.start()
    }
    
    func pause() {
        guard isPaused == false else { return }
        
        isPaused = true
        currentItem?.pause()
    }
    
    func resume() {
        guard isPaused == true else { return }
        
        isPaused = false
        currentItem?.resume()
    }

    private var currentItem: ASItemView?  {
        return stackView.arrangedSubviews[currentIndex] as? ASItemView
    }
    
    /// The current item will be full and the next item will start.
    /// If the current item is the last item, then we will notify the delegate that we reached the end.
    func next() {
        
        // We reach the end
        if currentIndex == stackView.arrangedSubviews.count-1 {
            currentItem?.state = .full
            delegate?.didFinishDisplayingAllItems(inProgressView: self)
            return
        }
        
        currentItem?.state = .full
        currentIndex += 1
        start()
    }
    
    /// The current and previous items will be reset to empty, and the previous item will start.
    func previous() {
        if currentIndex == 0 {
            currentItem?.state = .empty
            start()
            return
        }
        
        currentItem?.state = .empty
        (stackView.arrangedSubviews[currentIndex-1] as? ASItemView)?.state = .empty
        currentIndex -= 1
        start()
    }
}
