//
//  QuestionCollectionViewCell.swift
//  YGAM
//
//  Created by Jon Fulton on 26/05/2018.
//  Copyright © 2018 Sky Betting and Gaming. All rights reserved.
//

import UIKit

class QuestionCollectionViewCell: UICollectionViewCell {

    override var isSelected: Bool {
        willSet (newValue) {
            if newValue == true {
                self.backgroundColor = .white
                self.answerLabel.textColor = .purple
            } else {
                self.backgroundColor = .clear
                self.answerLabel.textColor = .white
            }
        }
    }
    
    @IBOutlet weak var answerLabel: UILabel!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        layer.cornerRadius = frame.width/2
        layer.borderWidth = 1
        layer.borderColor = UIColor.white.cgColor
        backgroundColor = .clear
    }
}
