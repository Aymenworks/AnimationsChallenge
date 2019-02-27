//
//  ViewController.swift
//  SectionScroller
//
//  Created by Rebouh Aymen on 27/02/2019.
//  Copyright © 2019 Rebouh Aymen. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var scrubberView: UIView!
    @IBOutlet weak var scrubberViewTopConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        gestures: do {
            let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handleGesture(gesture:)))
            scrubberView.addGestureRecognizer(panGesture)
        }
    }
    
    @objc private func handleGesture(gesture: UIPanGestureRecognizer) {
        
        let translationY = gesture.translation(in: gesture.view!).y

        let contentInset = self.collectionView.contentInset
        let contentSize = self.collectionView.contentSize
        let scrubberOffsetRange = 0 ... self.collectionView.frame.height - scrubberView.frame.height
        let contentOffsetRange = contentInset.top ..< contentInset.top + contentSize.height

        switch gesture.state {
            
        case .changed:
            print("size: \(contentOffsetRange), offset: \(translationY)")
            let constant = self.scrubberViewTopConstraint.constant + translationY
            
            var progressScrubber = (scrubberOffsetRange.lowerBound + constant) / scrubberOffsetRange.upperBound
            progressScrubber = (progressScrubber...progressScrubber).clamped(to: 0...1)
            
            print("progress  = \(progressScrubber)")
            self.scrubberViewTopConstraint.constant = (constant ... constant).clamped(to: scrubberOffsetRange).lowerBound
            
            gesture.setTranslation(.zero, in: gesture.view!)
            
        default: break
        }
    }
}

extension ViewController:  UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 40
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 15
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard kind == UICollectionView.elementKindSectionHeader else {
            return UICollectionReusableView()
        }
        
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "Header", for: indexPath) as! HeaderCell
        header.titleLabel.text = "Section \(indexPath.section)"
        
        return header
    }
}

