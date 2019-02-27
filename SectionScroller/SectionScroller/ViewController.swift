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
        
        let gestureY = gesture.translation(in: view).y
        
        switch gesture.state {
            
        case .changed:
            let progress =
            print("moved to \(gestureY), progress = ")
            
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

