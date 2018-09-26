//
//  GradientView.swift
//  YGAM
//
//  Created by Jon Fulton on 20/06/2018.
//  Copyright © 2018 Sky Betting and Gaming. All rights reserved.
//

import UIKit

class GradientView: UIView {
    
    var gradient = CAGradientLayer()

    let firstColour = UIColor(red:0.19, green:0.14, blue:0.68, alpha:1).cgColor
    let secondColour = UIColor(red:0.78, green:0.43, blue:0.84, alpha:1).cgColor
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
    
    /// Setups the view layer with a CAGradientLayer and assigns color
    private func setupView() {
        guard let gradientLayer = self.layer as? CAGradientLayer else {
            return
        }
        
        gradient = gradientLayer
        
        gradient.colors = [firstColour, secondColour]
        gradient.startPoint = CGPoint(x: 0.7, y: 0)
        gradient.endPoint = CGPoint(x: 0.3, y: 1)
        gradient.drawsAsynchronously = true
        gradient.frame = bounds
        
        gradient.drawsAsynchronously = true
    }
    
    public func animateGradient() {
        CATransaction.begin()
        CATransaction.setCompletionBlock {
            self.gradient.colors = [self.secondColour, self.firstColour]
            CATransaction.begin()
            CATransaction.setCompletionBlock {
                self.gradient.colors = [self.firstColour, self.secondColour]
            }
            self.animateGradient(colors: [self.firstColour, self.secondColour])
            CATransaction.commit()
        }
        animateGradient(colors: [secondColour, firstColour])
        CATransaction.commit()
    }
    
    private func animateGradient(colors: [CGColor]) {
        let gradientChangeAnimation = CABasicAnimation(keyPath: "colors")
        gradientChangeAnimation.duration = 1.0
        gradientChangeAnimation.toValue = colors
        gradientChangeAnimation.fillMode = kCAFillModeForwards
        gradientChangeAnimation.isRemovedOnCompletion = false
        gradient.add(gradientChangeAnimation, forKey: "colorChange")
    }
    
    override class var layerClass: AnyClass {
        return CAGradientLayer.self
    }
}
