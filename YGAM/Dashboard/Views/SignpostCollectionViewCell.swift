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
    
    public func setup(signpost: Signpost) {
        title.text = signpost.heading
        body.text = signpost.body
        imageView.image = signpost.image
    }
}
