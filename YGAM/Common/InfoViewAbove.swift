//
//  NudgeView.swift
//  YGAM
//
//  Created by Jon Fulton on 19/06/2018.
//  Copyright © 2018 Sky Betting and Gaming. All rights reserved.
//

import UIKit

class InfoViewAbove: UIView {

    private var tooltipWidth = 0
    private var tooltipHeight = 0

    private struct Constants {
        static let borderRadius: CGFloat = 4.0
        static let shadowRadius: CGFloat = 4.0
        static let shadowColor = UIColor(red: (85.0/255.0), green: (85.0/255.0), blue: (85.0/255.0), alpha: 0.35).cgColor
    }
    
    private func topLeft(_ x: CGFloat, _ y: CGFloat) -> CGPoint {
        return CGPoint(x: x, y: y)
    }
    
    private func topRight(_ x: CGFloat, _ y: CGFloat) -> CGPoint {
        return CGPoint(x: CGFloat(tooltipWidth) - x, y: y)
    }
    
    private func bottomLeft(_ x: CGFloat, _ y: CGFloat) -> CGPoint {
        return CGPoint(x: x, y: CGFloat(tooltipHeight) - y)
    }
    
    private func bottomRight(_ x: CGFloat, _ y: CGFloat) -> CGPoint {
        return CGPoint(x: CGFloat(tooltipWidth) - x, y: CGFloat(tooltipHeight) - y)
    }
    
    override func draw(_ rect: CGRect) {
        for shapeLayer in (layer.sublayers?.filter({ $0 is CAShapeLayer}))! {
            shapeLayer.removeFromSuperlayer()
        }
        
        tooltipWidth = Int(bounds.width)
        tooltipHeight = Int(bounds.height)
        
        // Define Bubble Shape
        let toolTipPath = UIBezierPath()
        
        // Top left corner
        toolTipPath.move(to: topLeft(0, Constants.borderRadius))
        toolTipPath.addCurve(to: topLeft(Constants.borderRadius, 0), controlPoint1: topLeft(0, Constants.borderRadius / 2), controlPoint2: topLeft(Constants.borderRadius / 2, 0))
        
        // Top right corner
        toolTipPath.addLine(to: topRight(Constants.borderRadius, 0))
        toolTipPath.addCurve(to: topRight(0, Constants.borderRadius), controlPoint1: topRight(Constants.borderRadius / 2, 0), controlPoint2: topRight(0, Constants.borderRadius / 2))
        
        // Bottom right corner
        toolTipPath.addLine(to: bottomRight(0, Constants.borderRadius))
        toolTipPath.addCurve(to: bottomRight(Constants.borderRadius, 0), controlPoint1: bottomRight(0, Constants.borderRadius / 2), controlPoint2: bottomRight(Constants.borderRadius / 2, 0))
        
        // Bottom left corner
        toolTipPath.addLine(to: bottomLeft(Constants.borderRadius, 0))
        toolTipPath.addCurve(to: bottomLeft(0, Constants.borderRadius), controlPoint1: bottomLeft(Constants.borderRadius / 2, 0), controlPoint2: bottomLeft(0, Constants.borderRadius / 2))
        toolTipPath.close()
        
        // Arrow
        toolTipPath.move(to: bottomLeft(CGFloat((tooltipWidth / 2) - 8), 0))
        toolTipPath.addLine(to: bottomLeft(CGFloat(tooltipWidth / 2), -8))
        toolTipPath.addLine(to: bottomLeft(CGFloat(tooltipWidth / 2 + 8), 0))
        toolTipPath.close()
        
        // Shadow Layer
        let shadowShape = CAShapeLayer()
        shadowShape.path = toolTipPath.cgPath
        shadowShape.shadowColor = Constants.shadowColor
        shadowShape.shadowRadius = Constants.shadowRadius
        shadowShape.shadowOffset = .zero
        shadowShape.shadowOpacity = 1.0

        // Fill Layer
        let fillShape = CAShapeLayer()
        fillShape.path = toolTipPath.cgPath
        fillShape.fillColor = UIColor.white.cgColor
        
        // Add Sublayers
        self.layer.insertSublayer(shadowShape, at: 0)
        self.layer.insertSublayer(fillShape, at: 1)
    }
}
