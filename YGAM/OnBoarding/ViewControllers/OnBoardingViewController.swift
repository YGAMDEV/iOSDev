//
//  OnBoardingViewController.swift
//  YGAM
//
//  Created by Jon Fulton on 02/07/2018.
//  Copyright © 2018 Sky Betting and Gaming. All rights reserved.
//

import UIKit

class OnBoardingViewController: UIViewController {

    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var detailView1: OnBoardingDetailsView!
    @IBOutlet weak var detailView2: OnBoardingDetailsView!
    @IBOutlet weak var detailView3: OnBoardingDetailsView!
    
    @IBOutlet weak var backgroundViewLeading: NSLayoutConstraint!
    @IBOutlet weak var introSwipeToStartCenterY: NSLayoutConstraint!

    @IBOutlet weak var appBadge: UIView!
    @IBOutlet weak var startButton: UIButton!
    
    struct Constants {
        static let magnifiedOffset: CGFloat = 60.0
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        detailView1.titleLabel.text = "Take Control"
        detailView1.informationLabel.text = " Our questionnaire will help you identify any areas that may need extra focus. It's quick, simple and fun to use"
        setMagnifiedView(detailView1.magnifiedView, scale: 0.0)
        detailView1.magnifiedImageView.image = #imageLiteral(resourceName: "DetailView1MagnifiedView.png")
        detailView1.magnifiedViewLeading.constant = 97
        detailView1.magnifiedViewTop.constant = 25

        detailView2.titleLabel.text = "Set Goals"
        detailView2.informationLabel.text = "Take control and set relevant goals to help maintain a healthy relationship with your devices"
        setMagnifiedView(detailView2.magnifiedView, scale: 0.0)
        detailView2.magnifiedImageView.image = #imageLiteral(resourceName: "DetailView2MagnifiedView.png")
        detailView2.magnifiedViewLeading.constant = 147
        detailView2.magnifiedViewTop.constant = 97
        
        detailView3.titleLabel.text = "Earn Achievements"
        detailView3.informationLabel.text = "Get rewarded for your continued dedication to achieving device nirvana"
        setMagnifiedView(detailView3.magnifiedView, scale: 0.0)
        detailView3.magnifiedImageView.image = #imageLiteral(resourceName: "DetailView3MagnifiedView.png")
        detailView3.magnifiedViewLeading.constant = 55
        detailView3.magnifiedViewTop.constant = 97
        
        startButton.layer.borderColor = UIColor.white.cgColor
        startButton.layer.cornerRadius = 20.0
        startButton.layer.borderWidth = 1.0
    }
    
    fileprivate func setMagnifiedView(_ view: UIView, scale: CGFloat) {
        view.alpha = scale
        view.transform = CGAffineTransform(scaleX: scale, y: scale)
    }
}

extension OnBoardingViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        introSwipeToStartCenterY.constant = -(scrollView.contentOffset.x * 1.15)
        backgroundViewLeading.constant = -(scrollView.contentOffset.x * 0.35)

        let pageNumber = round(scrollView.contentOffset.x / scrollView.frame.size.width)
        let pageOffset = scrollView.contentOffset.x.remainder(dividingBy: view.frame.size.width)
        animateMagnifiedView(page: Int(pageNumber), offset: pageOffset)
        
        view.layoutIfNeeded()
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let pageNumber = round(scrollView.contentOffset.x / scrollView.frame.size.width)
        pageControl.currentPage = Int(pageNumber)
    }
    
    private func animateMagnifiedView(page: Int, offset: CGFloat) {
        let magnificationScale = normalizedOffset(offset)
        switch page {
        case 1:
            // DetailView1
            setMagnifiedView(detailView1.magnifiedView, scale: magnificationScale)
        case 2:
            // DetailView2
            setMagnifiedView(detailView2.magnifiedView, scale: magnificationScale)
        case 3:
            // DetailView3
            setMagnifiedView(detailView3.magnifiedView, scale: magnificationScale)
        case 4:
            // Notifications
            setMagnifiedView(appBadge, scale: magnificationScale)
        default:
            break
        }
    }
    
    private func normalizedOffset(_ offset: CGFloat) -> CGFloat {
        let max = view.frame.size.width
        let min = max - Constants.magnifiedOffset
        
        let currentOffset = max - fabs(offset)
        let normalizedOffset = (currentOffset - min)/(max - min)
        if normalizedOffset > 0 {
            return normalizedOffset
        }
        return 0.0
    }
}
