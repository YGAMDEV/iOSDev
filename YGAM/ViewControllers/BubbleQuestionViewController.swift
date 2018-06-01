//
//  BubbleQuestionViewController.swift
//  YGAM
//
//  Created by Jon Fulton on 01/06/2018.
//  Copyright © 2018 Sky Betting and Gaming. All rights reserved.
//

import UIKit

private enum Edge: Int {
    case top = 0
    case bottom
    case left
    case right
}

class BubbleQuestionViewController: UIViewController {

    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var questionLabelBackground: UIView!
    @IBOutlet weak var dynamicAnimatorReferenceView: UIView!
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var infoLabelVerticalSpacing: NSLayoutConstraint!
    
    public var question: Question
    public weak var delegate: QuestionCoordinatorDelegate?
    
    private var animator: UIDynamicAnimator!
    private var answers = [Answer]()
    private var answerViews = [BubbleAnswerView]()
    private var bubbleBehavior: BubbleBehavior!
    private var nudged = false
    
    init(question: Question, nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        self.question = question
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        animator = UIDynamicAnimator(referenceView: dynamicAnimatorReferenceView)
        bubbleBehavior = BubbleBehavior()
        animator.addBehavior(bubbleBehavior)
//        animator.setValue(true, forKey: "debugEnabled")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        questionLabel.text = question.text
        questionLabelBackground.layer.cornerRadius = questionLabel.frame.size.height / 2
        questionLabelBackground.layer.shadowColor = UIColor.darkGray.cgColor
        questionLabelBackground.layer.shadowOpacity = 0.6
        questionLabelBackground.layer.shadowOffset = CGSize.zero
        questionLabelBackground.layer.shadowRadius = 7
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        displayAnswers()
    }
    
    @IBAction func nextTapped(_ sender: UIButton) {
        let selectedItems = answerViews.filter({ $0.isSelected })
        
        // Check single questions
        if (question.type == .single && selectedItems.count != 1) {
            showInfoLabelWith("You need to select an answer")
            return
        }
        
        // Check Min Selection
        if let minSelections = question.minSelections {
            if selectedItems.count < minSelections || (question.type == .single && selectedItems.count != 1) {
                showInfoLabelWith("You need to select at least \(minSelections) answer(s)")
                return
            }
        }
        
        // Save the answers
        answers = selectedItems.map{ $0.answer }
        
        // Check for any nudges
        if let nudge = question.nudge {
            let filter = answers.filter() { nudge.trigger.contains($0.text) }
            let textAnswers = answers.map { $0.text }
            if nudge.trigger == textAnswers || filter.count > 0 {
                // Check the users answers against the triggers
                if nudged {
                    delegate?.didFinish(questionID: question.id, answer: answers, action: nudge.confirmedAction)
                } else {
                    var message = nudge.text
                    if nudge.text.range(of: "{answer}") != nil, let answer = answers.first {
                        message = nudge.text.replacingOccurrences(of: "{answer}", with: answer.text)
                    }
                    showInfoLabelWith(message)
                    nudged = true
                }
                return
            }
        }
        
        // Single answer question - action is associated with the selected answer
        if question.type == .single, let action = answers.first?.action {
            delegate?.didFinish(questionID: question.id, answer: answers, action: action)
            return
        }
        
        delegate?.didFinish(questionID: question.id, answer: answers, action: question.completeAction)
    }
    
    func showInfoLabelWith(_ message: String) {
        infoLabel.text = message
        self.infoLabelVerticalSpacing.constant = 12
        UIView.animate(withDuration: 0.3) {
            self.infoLabel.alpha = 1
            self.view.layoutIfNeeded()
        }
    }
    
    // MARK: - AnswerViews
    
    private func displayAnswers() {
        for answer in question.answers! {
            let answerView: BubbleAnswerView = Bundle.main.loadNibNamed("BubbleAnswerView", owner: nil, options: nil)![0] as! BubbleAnswerView
            answerView.answer = answer
            answerView.delegate = self
            answerView.center = randomStartPoint()
        
            dynamicAnimatorReferenceView.addSubview(answerView)
            UIView.animate(withDuration: 0.7) {
                answerView.alpha = 1.0
            }
            bubbleBehavior.addItem(answerView)
            answerViews.append(answerView)
        }
    }
    
    private func randomStartPoint() -> CGPoint {
        let point = randomPoint()
        switch randomEdge() {
        case .top:
            return CGPoint(x: point.x, y: 0)
        case .bottom:
            return CGPoint(x: point.x, y: dynamicAnimatorReferenceView.frame.size.height)
        case .left:
            return CGPoint(x: 0, y: point.y)
        case .right:
            return CGPoint(x: dynamicAnimatorReferenceView.frame.size.width, y: point.y)
        }
    }
    
    private func randomEdge() -> Edge {
        return Edge(rawValue: (Int(arc4random_uniform(4))))!
    }
    
    private func randomPoint() -> (x: CGFloat, y: CGFloat) {
        let randomX = CGFloat(arc4random_uniform(UInt32(dynamicAnimatorReferenceView.frame.width)))
        let randomY = CGFloat(arc4random_uniform(UInt32(dynamicAnimatorReferenceView.frame.height)))
        
        return (randomX, randomY)
    }
}

extension BubbleQuestionViewController: BubbleAnswerViewDelegate {
    func answerViewTapped(answerView: BubbleAnswerView) {
        // Check if it's toggle-able due to constraints (single/multi)
        if question.type == .single {
            for answerView in answerViews {
                answerView.isSelected = false
            }
        }
        answerView.toggle()
    }
}
