//
//  FaceView.swift
//  AppleMusicSelection
//
//  Created by Aymen Rebouh on 2020/11/02.
//

import Foundation
import UIKit

final class FaceView: UIControl {
    
    // MARK: Public
    
    init(frame: CGRect, image: UIImage) {
        super.init(frame: frame)
                
        backgroundColor = .clear

        addSubview(imageView)
        imageView.contentMode = .scaleAspectFill
        imageView.layer.masksToBounds = true
        imageView.frame = .init(x: spacing, y: spacing, width: frame.width-(spacing*2), height: frame.height-(spacing*2))
        
        imageView.image = image
    }
    
    override var collisionBoundsType: UIDynamicItemCollisionBoundsType {
        return .ellipse
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        
        layer.cornerRadius = bounds.width / 2.0
        imageView.layer.cornerRadius = imageView.bounds.width / 2.0
    }
    
    // MARK: Private
    
    private let imageView = UIImageView()
    private let spacing: CGFloat = 2
}
