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
    @IBOutlet weak var notificationBackgroundView: GradientBackgroundView!
    
    @IBOutlet weak var appBadge: UIView!
    @IBOutlet weak var skipButton: UIButton!
    @IBOutlet weak var doneButton: UIButton!
    
    @IBOutlet weak var leftArrow: UIImageView!
    @IBOutlet weak var rightArrow: UIImageView!
    
    private var initialQuestions: [Question]?
    
    struct Constants {
        static let magnifiedOffset: CGFloat = 60.0
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let gradientStartPoint = CGPoint(x: 0.7, y: 0)
        let gradientEndPoint = CGPoint(x: 0.3, y: 1)
        
        loadQuestions()
        
        detailView1.backgroundView.setupGradientView(startColor: UIColor(red:0.28, green:1, blue:0.86, alpha:1).cgColor,
                                                     endColor: UIColor(red:0.06, green:0.82, blue:0.67, alpha:1).cgColor,
                                                     startPoint: gradientStartPoint,
                                                     endPoint: gradientEndPoint)
        detailView1.titleLabel.text = "Get a glimpse into how your habits add up"
        detailView1.infoText = "Answer 10 questions to get a tailored summary of your activity and habits"
        setMagnifiedView(detailView1.magnifiedView, scale: 0.0)
        detailView1.magnifiedImageView.image = #imageLiteral(resourceName: "DetailView1MagnifiedView.png")
        detailView1.magnifiedViewLeading.constant = 97
        detailView1.magnifiedViewTop.constant = 25

        detailView2.backgroundView.setupGradientView(startColor: UIColor(red:0.15, green:0.58, blue:0.85, alpha:1).cgColor,
                                                     endColor: UIColor(red:0.07, green:0.36, blue:0.7, alpha:1).cgColor,
                                                     startPoint: gradientStartPoint,
                                                     endPoint: gradientEndPoint)
        detailView2.titleLabel.text = "Complete tasks and help improve your habits"
        detailView2.infoText = "Answer 10 questions to get a tailored summary of your activity and habits"
        setMagnifiedView(detailView2.magnifiedView, scale: 0.0)
        detailView2.magnifiedImageView.image = #imageLiteral(resourceName: "DetailView2MagnifiedView.png")
        detailView2.magnifiedViewLeading.constant = 147
        detailView2.magnifiedViewTop.constant = 97
        
        detailView3.backgroundView.setupGradientView(startColor: UIColor(red:0.19, green:0.14, blue:0.68, alpha:1).cgColor,
                                                     endColor: UIColor(red:0.78, green:0.43, blue:0.84, alpha:1).cgColor,
                                                     startPoint: gradientStartPoint,
                                                     endPoint: gradientEndPoint)
        detailView3.titleLabel.text = "Keep track of your task progression"
        detailView3.infoText = "Answer 10 questions to get a tailored summary of your activity and habits"
        setMagnifiedView(detailView3.magnifiedView, scale: 0.0)
        detailView3.magnifiedImageView.image = #imageLiteral(resourceName: "DetailView3MagnifiedView.png")
        detailView3.magnifiedViewLeading.constant = 55
        detailView3.magnifiedViewTop.constant = 97
        
        notificationBackgroundView.setupGradientView(startColor: UIColor(red:0.14, green:0.27, blue:0.51, alpha:1).cgColor,
                                                     endColor: UIColor(red:0.15, green:0.41, blue:0.54, alpha:1).cgColor,
                                                     startPoint: gradientStartPoint,
                                                     endPoint: gradientEndPoint)
    }
    
    fileprivate func setMagnifiedView(_ view: UIView, scale: CGFloat) {
        view.alpha = scale
        view.transform = CGAffineTransform(scaleX: scale, y: scale)
    }

    func loadQuestions() {
        let questionsRequest = QuestionsRequest()
        questionsRequest.createModel() { result in
            switch result {
            case .failure(let error):
                print("Failed: \(error)")
            case .success(let questionList):
                self.initialQuestions = questionList.questions
            }
        }
    }

    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "QuestionSegue":
            if let controller = segue.destination as? BubbleQuestionViewController {
                controller.questions = initialQuestions
            }
        default:
            break
        }
    }
}

extension OnBoardingViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {

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
            rightArrow.alpha = 1 - magnificationScale
            doneButton.alpha = magnificationScale
        default:
            skipButton.alpha = magnificationScale
            leftArrow.alpha = 1 - magnificationScale
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
