//
//  OnBoardingViewController.swift
//  YGAM
//
//  Created by Jon Fulton on 02/07/2018.
//  Copyright © 2018 Sky Betting and Gaming. All rights reserved.
//

import UIKit
import UserNotifications

class OnBoardingViewController: UIViewController {

    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var scrollView: UIScrollView!

    @IBOutlet weak var notificationBackgroundView: GradientView!
    @IBOutlet weak var notificationSwitch: UISwitch!
    
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
        loadQuestions()
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
    @IBAction func dismiss(_ sender: UIButton) {
        if notificationSwitch.isOn {
            notificationAuthorizationRequest()
        } else {
            self.performSegue(withIdentifier: "QuestionSegue", sender: nil)
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
    
    private func notificationAuthorizationRequest() {
        let center = UNUserNotificationCenter.current()
        let options: UNAuthorizationOptions = [.badge, .alert, .sound]
        center.requestAuthorization(options: options) { granted, error in
            DispatchQueue.main.async {
                self.performSegue(withIdentifier: "QuestionSegue", sender: nil)
            }
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
            print("Page 1")
        case 2:
            // DetailView2
            print("Page 2")
        case 3:
            // DetailView3
            print("Page 3")
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
