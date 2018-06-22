//
//  BubbleQuestionView.swift
//  YGAM
//
//  Created by Jon Fulton on 01/06/2018.
//  Copyright © 2018 Sky Betting and Gaming. All rights reserved.
//

import UIKit

protocol BubbleAnswerViewDelegate: AnyObject {
    func answerViewTapped(answerView: BubbleAnswerView)
}

private enum State {
    case selected
    case unselected
}

class BubbleAnswerView: UIView {

    @IBOutlet weak var answerLabel: UILabel!
    
    public weak var delegate: BubbleAnswerViewDelegate?
    public var itemBehavior: UIDynamicItemBehavior!
    public var answer: Answer! {
        didSet {
            answerLabel.text = answer.text
        }
    }
    
    public var isSelected = false {
        didSet {
            updateUI(state: .unselected)
        }
    }
    
    private let selectedModifier: CGFloat = 1.25
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        itemBehavior = UIDynamicItemBehavior(items: [self])
        itemBehavior.density = 0.01
        itemBehavior.resistance = 3
        itemBehavior.elasticity = 0.5
        itemBehavior.friction = 0.0
        itemBehavior.allowsRotation = false
        
        layer.cornerRadius = frame.width/2
        layer.borderWidth = 2
        layer.borderColor = UIColor.white.cgColor
        backgroundColor = .clear
    }
    
    override var collisionBoundsType: UIDynamicItemCollisionBoundsType {
        return .ellipse
    }
    
    @IBAction func tapped(_ sender: UITapGestureRecognizer) {
        delegate?.answerViewTapped(answerView: self)
    }
    
    public func toggle() {
        isSelected = !isSelected
        isSelected ? updateUI(state: .selected) : updateUI(state: .unselected)
    }
    
    private func updateUI(state: State) {
        switch state {
        case .selected:
            backgroundColor = .white
            answerLabel.textColor = UIColor(red: (255.0/255.0), green: (133.0/255.0), blue: (14.0/255.0), alpha: 1.0)
        case .unselected:
            backgroundColor = .clear
            answerLabel.textColor = .white
        }
    }
}
