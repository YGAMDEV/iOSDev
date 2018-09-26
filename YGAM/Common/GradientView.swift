//
//  GradientView.swift
//  YGAM
//
//  Created by Jon Fulton on 26/09/2018.
//  Copyright © 2018 Sky Betting and Gaming. All rights reserved.
//

import UIKit

@IBDesignable
class GradientView: UIView {
    @IBInspectable var firstColor: UIColor = .red
    @IBInspectable var secondColor: UIColor = .yellow
    @IBInspectable var startPoint: CGPoint = CGPoint(x: 0, y: 0.5)
    @IBInspectable var endPoint: CGPoint = CGPoint(x: 1, y: 0.5)
    
    override class var layerClass: AnyClass {
        return CAGradientLayer.self
    }
    
    override func layoutSubviews() {
        guard let layer = layer as? CAGradientLayer else {
            return
        }
        layer.colors = [firstColor.cgColor, secondColor.cgColor]
        layer.startPoint = startPoint
        layer.endPoint = endPoint
    }
}
