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
    
    let lightOrange = UIColor(red: (231.0/255.0), green: (138.0/255.0), blue: (27.0/255.0), alpha: 1.0).cgColor
    let darkOrange = UIColor(red: (215.0/255.0), green: (80.0/255.0), blue: (0.0/255.0), alpha: 1.0).cgColor
    
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
        
        gradient.colors = [darkOrange, lightOrange]
        gradient.startPoint = CGPoint(x: 0.7, y: 0)
        gradient.endPoint = CGPoint(x: 0.3, y: 1)
        gradient.locations = [0.0, 2.0]
        gradient.drawsAsynchronously = true
        gradient.frame = bounds
        
        gradient.drawsAsynchronously = true
    }
    
    public func animateGradient() {
        CATransaction.begin()
        CATransaction.setCompletionBlock {
            self.gradient.colors = [self.lightOrange, self.darkOrange]
            CATransaction.begin()
            CATransaction.setCompletionBlock {
                self.gradient.colors = [self.darkOrange, self.lightOrange]
            }
            self.animateGradient(colors: [self.darkOrange, self.lightOrange])
            CATransaction.commit()
        }
        animateGradient(colors: [lightOrange, darkOrange])
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
