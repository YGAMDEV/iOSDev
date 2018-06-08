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
    @IBOutlet weak var progressBar: UIProgressView!
    
    private var animator: UIDynamicAnimator!
    private var answers = [String: [Answer]]()
    private var answerViews = [BubbleAnswerView]()
    private var bubbleBehavior: BubbleBehavior!
    private var currentAnswer = [Answer]()
    private var currentQuestion: Question
    private var navController: UINavigationController
    private var nudged = false
    private let questions: [Question]
    
    init(navController: UINavigationController, questions: [Question], nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        self.questions = questions
        self.currentQuestion = self.questions.first!
        self.navController = navController
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        animator = UIDynamicAnimator(referenceView: dynamicAnimatorReferenceView)
        bubbleBehavior = BubbleBehavior()
        animator.addBehavior(bubbleBehavior)
        
        questionLabelBackground.layer.cornerRadius = questionLabel.frame.size.height / 2
        questionLabelBackground.layer.shadowColor = UIColor.darkGray.cgColor
        questionLabelBackground.layer.shadowOpacity = 0.6
        questionLabelBackground.layer.shadowOffset = CGSize.zero
        questionLabelBackground.layer.shadowRadius = 7
        
        progressBar.layer.cornerRadius = 5
        progressBar.layer.borderWidth = 1.0
        progressBar.layer.borderColor = UIColor.white.cgColor
        progressBar.clipsToBounds = true
        progressBar.layer.sublayers![1].cornerRadius = 5
        progressBar.subviews[1].clipsToBounds = true
        
        showQuestion()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    // MARK: - Logic
    
    private func showQuestion() {
        updateProgress()
        if let previousQuestionID = currentQuestion.answersFromQuestion {
            currentQuestion.answers = answers[previousQuestionID]
        }
        questionLabel.text = currentQuestion.text
        questionLabelBackground.invalidateIntrinsicContentSize()
        UIView.animate(withDuration: 0.3, animations: {
            if self.questionLabel.alpha == 0 {
                self.questionLabel.alpha = 1.0
                self.view.layoutIfNeeded()
            }
        }) { _ in
            self.displayAnswers()
        }
    }
    
    @IBAction func nextTapped(_ sender: UIButton) {
        let selectedItems = answerViews.filter({ $0.isSelected })
        
        // Check single questions
        if (currentQuestion.type == .single && selectedItems.count != 1) {
            showInfoLabelWith("You need to select an answer")
            return
        }
        
        // Check Min Selection
        if let minSelections = currentQuestion.minSelections {
            if selectedItems.count < minSelections || (currentQuestion.type == .single && selectedItems.count != 1) {
                showInfoLabelWith("You need to select at least \(minSelections) answer(s)")
                return
            }
        }
        
        // Save the answers
        currentAnswer = selectedItems.map{ $0.answer }
        
        // Check for any nudges
        if let nudge = currentQuestion.nudge {
            let filter = currentAnswer.filter() { nudge.trigger.contains($0.text) }
            let textAnswers = currentAnswer.map { $0.text }
            if nudge.trigger == textAnswers || filter.count > 0 {
                // Check the users answers against the triggers
                if nudged {
                    questionComplete(action: nudge.confirmedAction)
                } else {
                    var message = nudge.text
                    if nudge.text.range(of: "{answer}") != nil, let answer = currentAnswer.first {
                        message = nudge.text.replacingOccurrences(of: "{answer}", with: answer.text)
                    }
                    showInfoLabelWith(message)
                    nudged = true
                }
                return
            }
        }
        
        // Single answer question - action is associated with the selected answer
        if currentQuestion.type == .single, let action = currentAnswer.first?.action {
            questionComplete(action: action)
            return
        }
        
        questionComplete(action: currentQuestion.completeAction)
    }
    
    func questionComplete(action: Action?) {
        answers[currentQuestion.id] = currentAnswer
        guard let action = action else {
            // Exit
            navController.popViewController(animated: true)
            return
        }
        
        switch action.type {
        case .app:
            // Exit
            navController.popViewController(animated: true)
            return
        case .question:
            guard let nextQuestion = questionFor(ID: action.value) else {
                // Exit
                navController.popViewController(animated: true)
                return
            }
            currentQuestion = nextQuestion
            reset()
        }
    }
    
    func reset() {
        currentAnswer = []
        self.infoLabelVerticalSpacing.constant = 0.0
        UIView.animate(withDuration: 0.3, animations: {
            self.questionLabel.alpha = 0.0
            self.infoLabel.alpha = 0.0
            for answerView in self.answerViews {
                answerView.alpha = 0.0
                self.bubbleBehavior.removeItem(answerView)
            }
            self.answerViews.removeAll()
            self.view.layoutSubviews()
        }) { _ in
            self.showQuestion()
        }
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
        for answer in currentQuestion.answers! {
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
    
    // MARK: - Helpers
    private func questionFor(ID questionID: String) -> Question? {
        return questions.first(where: { $0.id == questionID })
    }
    
    private func updateProgress() {
        let index = questions.index(where: { (question) -> Bool in
            question.id == currentQuestion.id
        })
        let test = Float(index!) / Float(questions.count)
        progressBar.progress = test
    }
}

extension BubbleQuestionViewController: BubbleAnswerViewDelegate {
    func answerViewTapped(answerView: BubbleAnswerView) {
        // Check if it's toggle-able due to constraints (single/multi)
        if currentQuestion.type == .single {
            for answerView in answerViews {
                answerView.isSelected = false
            }
        }
        answerView.toggle()
    }
}
