//
//  SignpostingViewController.swift
//  YGAM
//
//  Created by Jon Fulton on 28/09/2018.
//  Copyright © 2018 Sky Betting and Gaming. All rights reserved.
//

import UIKit

class SignpostingViewController: UIViewController {

    @IBOutlet weak var roundedTop: UIView!
    @IBOutlet weak var signpostCollectionView: UICollectionView!
    
    private struct Constants {
        static let signpostCell = "SignpostCollectionViewCell"
        static let shadowRadius: CGFloat = 4.0
        static let shadowColor = UIColor(red: (85.0/255.0), green: (85.0/255.0), blue: (85.0/255.0), alpha: 0.35).cgColor
    }
    
    private var signposts = SignpostingList().signposts
    
    override func viewDidLoad() {
        super.viewDidLoad()

        signpostCollectionView.register(UINib(nibName: Constants.signpostCell, bundle: nil), forCellWithReuseIdentifier: Constants.signpostCell)
        
        if let flowLayout = signpostCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.estimatedItemSize = UICollectionViewFlowLayoutAutomaticSize
        }
        
        roundedTop.layer.cornerRadius = 8
        roundedTop.layer.shadowColor = Constants.shadowColor
        roundedTop.layer.shadowRadius = Constants.shadowRadius
        roundedTop.layer.shadowOffset = .zero
        roundedTop.layer.shadowOpacity = 1.0
    }
    
    @IBAction func close(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
}

extension SignpostingViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return signposts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.signpostCell, for: indexPath) as! SignpostCollectionViewCell
        cell.setup(signpost: signposts[indexPath.row])
        if indexPath.row + 1 == signposts.count {
            // Last normal cell - hide the horizontal view
            cell.horizontalRule.isHidden = true
        }
        return cell
    }
}

extension SignpostingViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        UIApplication.shared.open(signposts[indexPath.row].url!)
    }
}
