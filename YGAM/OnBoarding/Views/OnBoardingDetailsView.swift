//
//  OnBoardingDetailsView.swift
//  YGAM
//
//  Created by Jon Fulton on 02/07/2018.
//  Copyright © 2018 Sky Betting and Gaming. All rights reserved.
//

import UIKit

@IBDesignable
class OnBoardingDetailsView: UIView {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var informationLabel: UILabel!
    
    @IBOutlet weak var magnifiedView: UIView!
    @IBOutlet weak var magnifiedImageView: UIImageView!
    @IBOutlet weak var magnifiedViewLeading: NSLayoutConstraint!
    @IBOutlet weak var magnifiedViewTop: NSLayoutConstraint!
    @IBOutlet weak var titleLabel: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    /// Loads view from Nib and sizes view using autoresizing masks.
    private func setup() {
        guard let contentView = loadViewFromNib() else {
            return
        }
        contentView.frame = bounds
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addSubview(contentView)
        
        magnifiedView.layer.borderColor = UIColor.white.cgColor
        magnifiedView.layer.borderWidth = 2.0
        magnifiedView.layer.cornerRadius = magnifiedView.frame.size.width / 2.0
        magnifiedView.layer.shadowColor = UIColor.black.cgColor
        magnifiedView.layer.shadowRadius = 2.0
        magnifiedView.layer.shadowOffset = CGSize(width: 2.0, height: 2.0)
        magnifiedView.layer.shadowOpacity = 0.8
        
        magnifiedImageView.layer.cornerRadius = magnifiedView.frame.size.width / 2.0
        magnifiedImageView.layer.masksToBounds = true
    }
    
    private func loadViewFromNib() -> UIView? {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: String(describing: type(of: self)), bundle: bundle)
        return nib.instantiate(withOwner: self, options: nil)[0] as? UIView
    }
}
