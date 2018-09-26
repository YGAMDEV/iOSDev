//
//  GradientBackgroundView.swift
//  YGAM
//
//  Created by Jon Fulton on 25/09/2018.
//  Copyright © 2018 Sky Betting and Gaming. All rights reserved.
//

import UIKit

class GradientBackgroundView: UIView {

    var gradient = CAGradientLayer()
    
    public func setupGradientView(startColor: CGColor, endColor: CGColor, startPoint: CGPoint = CGPoint(x: 0, y: 0.5), endPoint: CGPoint = CGPoint(x: 1, y: 0.5)) {
        guard let gradientLayer = self.layer as? CAGradientLayer else {
            return
        }
        
        gradient = gradientLayer
        
        gradient.colors = [startColor, endColor]
        gradient.startPoint = startPoint
        gradient.endPoint = endPoint
        gradient.drawsAsynchronously = true
        gradient.frame = bounds
        
        gradient.drawsAsynchronously = true
    }
    
    override class var layerClass: AnyClass {
        return CAGradientLayer.self
    }
}
