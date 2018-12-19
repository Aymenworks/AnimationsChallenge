//
//  ViewController.swift
//  TextEmitterAnimation
//
//  Created by Aymen Rebouh on 2018/12/19.
//  Copyright © 2018 Aymen Rebouh. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    let textToDraw = "AYMEN"

    override func viewDidLoad() {
        super.viewDidLoad()
        
        drawLetters()
    }

    func drawLetters() {
        let ctFont = UIFont.systemFont(ofSize: 200) as CTFont
        var glyphs: [CGGlyph] = [CGGlyph].init(repeating: 0, count: textToDraw.count)
        CTFontGetGlyphsForCharacters(ctFont, Array(textToDraw.utf16), &glyphs, textToDraw.count)
        
        for (index, glyph) in glyphs.enumerated() {
            let path = CTFontCreatePathForGlyph(ctFont, glyph, nil)
            let bezierPath = UIBezierPath(cgPath: path!).reversing()
            drawLetter(path: bezierPath, forIndex: index)
        }
    }
    
    
    func drawLetter(path: UIBezierPath, forIndex index: Int) {
        let emitterLayer = createEmitter()
        let margin: CGFloat = 50
        let usableWidth = view.bounds.width - (margin*CGFloat(textToDraw.count+1))
        let letterWidth: CGFloat = usableWidth/CGFloat(textToDraw.count)
        let x = (CGFloat(index) * margin + margin/2.0) + (CGFloat(index) * letterWidth)
        emitterLayer.frame = CGRect(x: x, y: view.bounds.height/2.0 - path.bounds.height/2.0, width: letterWidth, height: path.bounds.height)
        self.view.layer.addSublayer(emitterLayer)
        
        let animation = CAKeyframeAnimation(keyPath: "emitterPosition")
        animation.path = path.cgPath
        emitterLayer.isGeometryFlipped = true
        animation.duration = 1.5
        animation.beginTime = CACurrentMediaTime() + animation.duration * CFTimeInterval(index)
        animation.repeatCount = .infinity
        animation.calculationMode = .paced
        emitterLayer.add(animation, forKey: "\(index)")
    }
    
    func createEmitter() -> CAEmitterLayer {
        let emitter = CAEmitterLayer()
        emitter.emitterCells    = [createEmitterCell(withImage: UIImage(named: "heart")!)]
        return emitter
    }
    
    func createEmitterCell(withImage image: UIImage, usingColor color: UIColor? = nil) -> CAEmitterCell {
        let emitterCell = CAEmitterCell()
        emitterCell.birthRate         = 400
        emitterCell.lifetime          = 2
        emitterCell.velocity          = 10
        emitterCell.velocityRange = 2 * .pi
        emitterCell.color = #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1)
        emitterCell.redRange = 0.7
        emitterCell.emissionRange = 2 * .pi
        emitterCell.contents = image.cgImage
        emitterCell.scale = 0.3
        
        return emitterCell
    }
    
}

