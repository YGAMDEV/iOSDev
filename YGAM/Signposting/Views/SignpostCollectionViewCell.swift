//
//  SignpostCollectionViewCell.swift
//  YGAM
//
//  Created by Jon Fulton on 28/09/2018.
//  Copyright © 2018 Sky Betting and Gaming. All rights reserved.
//

import UIKit

class SignpostCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var body: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var horizontalRule: UIView!
    @IBOutlet weak var cellWidthConstraint: NSLayoutConstraint!
    
    public func setup(signpost: Signpost) {
        title.text = signpost.heading
        body.text = signpost.body
        imageView.image = signpost.image
        
        cellWidthConstraint.constant = UIScreen.main.bounds.size.width

        let titleAttributedString = NSMutableAttributedString(string: signpost.heading!)
        let titleParagraphStyle = NSMutableParagraphStyle()
        titleParagraphStyle.lineHeightMultiple = 1.1
        titleAttributedString.addAttribute(NSAttributedStringKey.paragraphStyle, value:titleParagraphStyle, range:NSMakeRange(0, titleAttributedString.length))
        title.attributedText = titleAttributedString

        let bodyAttributedString = NSMutableAttributedString(string: signpost.body!)
        let bodyParagraphStyle = NSMutableParagraphStyle()
        bodyParagraphStyle.lineHeightMultiple = 1.2
        bodyAttributedString.addAttribute(NSAttributedStringKey.paragraphStyle, value:bodyParagraphStyle, range:NSMakeRange(0, bodyAttributedString.length))
        body.attributedText = bodyAttributedString
    }
}
