//
//  ProgressView.swift
//  YGAM
//
//  Created by Jon Fulton on 25/09/2018.
//  Copyright © 2018 Sky Betting and Gaming. All rights reserved.
//

import UIKit

class ProgressView: UIView {

    public func percent(_ percent: Int) {

        let percentComplete = Double(percent)/100
        let rotationOffset = CGFloat.pi / 2
        let shapeLayer = CAShapeLayer()
        
        let circleCenter = CGPoint(x: frame.width/2, y: frame.height/2)
        let circularPath = UIBezierPath(arcCenter: circleCenter, radius: frame.width/2, startAngle: 0 - rotationOffset , endAngle: (2 * CGFloat.pi) - rotationOffset, clockwise: true)
        shapeLayer.path = circularPath.cgPath
        
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeColor = UIColor.white.cgColor
        shapeLayer.lineWidth = 6
        shapeLayer.lineCap = kCALineCapRound
        shapeLayer.strokeEnd = 0
        
        layer.addSublayer(shapeLayer)
        
        let basicAnimation = CABasicAnimation(keyPath: "strokeEnd")
        basicAnimation.toValue = percentComplete
        basicAnimation.duration = 1
        basicAnimation.fillMode = kCAFillModeForwards
        basicAnimation.isRemovedOnCompletion = false
        shapeLayer.add(basicAnimation, forKey: "progress")
    }
}
