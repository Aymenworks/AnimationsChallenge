//
//  ViewController.swift
//  AppleMusicSelection
//
//  Created by Aymen Rebouh on 2020/11/02.
//

import UIKit

class ViewController: UIViewController {

    // MARK: Public
    
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var bottomView: UIView!
    
    // MARK: Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        UI: do {
            bottomView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
            bottomView.layer.cornerRadius = 20
        }
        
        behaviors: do {
            
            let faces: [UIImage] = [
                #imageLiteral(resourceName: "aymen5"),#imageLiteral(resourceName: "aymen3"),#imageLiteral(resourceName: "aymen1"),#imageLiteral(resourceName: "aymen2"),#imageLiteral(resourceName: "aymen7"),#imageLiteral(resourceName: "aymen6"),#imageLiteral(resourceName: "aymen4"),#imageLiteral(resourceName: "aymen10"),#imageLiteral(resourceName: "aymen8"),#imageLiteral(resourceName: "aymen9")
            ]
            
            let gravityBehavior = UIGravityBehavior(items: [])
            let dynamicItemBehavior = UIDynamicItemBehavior(items: [])
            dynamicItemBehavior.friction = 0
            dynamicItemBehavior.elasticity = 0
            collisionBehavior.addBoundary(
                withIdentifier: "left-wall" as NSCopying,
                for: .init(rect: CGRect(origin: .zero, size: CGSize(width: 1, height: UIScreen.main.bounds.height)))
            )
            
            collisionBehavior.addBoundary(
                withIdentifier: "right-wall" as NSCopying,
                for: .init(rect: CGRect(origin: CGPoint(x: UIScreen.main.bounds.width-1, y: 0),
                                        size: CGSize(width: 1, height: UIScreen.main.bounds.height))
                )
            )
            
            
            for (index, face) in faces.enumerated() {
                
                // 3: We delay the creation of the face view to display them "one by one"
                DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(index*150)) {

                    // 3: Faces will have a random size
                    let size: CGFloat = CGFloat([50.0, 65.0, 80.0, 100.0].randomElement()!)
                    
                    // 4
                    // x: We positionnate the face randomly in the x-axis, so that faces can fall down from different position
                    // y: negative so that they are falling from above
                    let bubbleView = FaceView(
                        frame: .init(
                            x: CGFloat.random(in: 0...UIScreen.main.bounds.width-size),
                            y: -50,
                            width: size,
                            height: size
                        ),
                        image: face
                    )

                    self.view.addSubview(bubbleView)

                    // 5: We add a gravity behavior for each of our face
                    gravityBehavior.addItem(bubbleView)
                    self.collisionBehavior.addItem(bubbleView)
                    dynamicItemBehavior.addItem(bubbleView)
                    
                    let panGesture = UIPanGestureRecognizer(target: self, action: #selector(self.handlePan(gesture:)))
                    bubbleView.addGestureRecognizer(panGesture)
                }
            }

            // 6: We ask our "manager" to add the gravity behavior, which will automatically trigger the animation.
            animator.addBehavior(gravityBehavior)
            animator.addBehavior(self.collisionBehavior)
            animator.addBehavior(dynamicItemBehavior)
        }
    }
    
    
    @objc func handlePan(gesture: UIPanGestureRecognizer) {
        switch gesture.state {
        case .ended:
            guard let bubbleView = gesture.view as? FaceView else {
                return
            }

            let velocity = gesture.velocity(in: self.view)
            let itemBehavior = UIDynamicItemBehavior(items: [bubbleView])
            itemBehavior.addLinearVelocity(velocity, for: bubbleView)

            animator.addBehavior(itemBehavior)
        default:
            break
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        collisionBehavior.addBoundary(withIdentifier: "modal-wall" as NSCopying, for: .init(roundedRect: self.bottomView.frame, cornerRadius: 20))
    }

    // 1: the class that will allow us to manage our behaviors aka specific dynamic behavior
    private lazy var animator = UIDynamicAnimator(referenceView: self.view)
    let collisionBehavior = UICollisionBehavior(items: [])
}
