//
//  BubbleBehavior.swift
//  YGAM
//
//  Created by Jon Fulton on 01/06/2018.
//  Copyright © 2018 Sky Betting and Gaming. All rights reserved.
//

import UIKit

class BubbleBehavior: UIDynamicBehavior {
    
    private var collisionBehavior: UICollisionBehavior
    public var fieldBehavior: UIFieldBehavior
    
    override init() {
        collisionBehavior = UICollisionBehavior()
        collisionBehavior.translatesReferenceBoundsIntoBoundary = true
        fieldBehavior = UIFieldBehavior.springField()
        fieldBehavior.strength = 0.1
        
        super.init()
        
        addChildBehavior(collisionBehavior)
        addChildBehavior(fieldBehavior)
    }
    
    override func willMove(to dynamicAnimator: UIDynamicAnimator?) {
        super.willMove(to: dynamicAnimator)
        guard let bounds = dynamicAnimator?.referenceView?.bounds else { return }
        
        updateFieldForBounds(bounds)
    }
    
    public func addItem(_ item: BubbleAnswerView) {
        collisionBehavior.addItem(item)
        fieldBehavior.addItem(item)
        addChildBehavior(item.itemBehavior)
    }
        
    private func updateFieldForBounds(_ bounds: CGRect) {
        fieldBehavior.position = CGPoint(x: bounds.midX, y: bounds.midY)
        fieldBehavior.region = UIRegion(size: CGSize(width: bounds.width, height: bounds.height))
    }
}
