//
//  ViewController.swift
//  ScrollToSearch
//
//  Created by Aymen Rebouh on 2018/12/13.
//  Copyright © 2018 Aymen Rebouh. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    // MARK: Properties
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var searchView: SearchView!
    let goal: CGFloat = 50
    var observeScrollViewContentOffset: NSKeyValueObservation?
    
    // MARK: Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        observeScrollViewContentOffset = scrollView.observe(\.contentOffset, options: .new) { [weak self] (scrollView, change) in
            guard let `self` = self, let newValue = change.newValue?.y else { return }
            
            var progress = -newValue/self.goal
            progress = (progress...progress).clamped(to: 0...1).upperBound
            self.searchView.update(progress: progress)
        }
    }
}

