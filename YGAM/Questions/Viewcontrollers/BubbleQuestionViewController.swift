//
//  BubbleQuestionViewController.swift
//  YGAM
//
//  Created by Jon Fulton on 01/06/2018.
//  Copyright © 2018 Sky Betting and Gaming. All rights reserved.
//

import UIKit
import UserNotifications

private enum Edge: Int {
    case top = 0
    case bottom
    case left
    case right
}

class BubbleQuestionViewController: UIViewController {

    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var dynamicAnimatorReferenceView: UIView!
    @IBOutlet weak var gradient: AnimatedGradientView!
    @IBOutlet weak var infoView: InfoView!
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var progressBar: UIProgressView!

    public var questions: [Question]! {
        didSet {
            currentQuestion = questions.first!
        }
    }
    
    private var animator: UIDynamicAnimator!
    private var answers = [String: [Answer]]()
    private var answerViews = [BubbleAnswerView]()
    private var bubbleBehavior: BubbleBehavior!
    private var currentAnswer = [Answer]()
    private var currentQuestion: Question!
    private var nudged = false

    private var answerLocations = [(Edge, CGFloat)]()
    private let possibleAnswerLocations: [(Edge, CGFloat)] = [ (.top, 0.25), (.top, 0.50), (.top, 0.75),
                                                      (.right, 0.25), (.right, 0.50), (.right, 0.75),
                                                      (.bottom, 0.25), (.bottom, 0.50), (.bottom, 0.75),
                                                      (.left, 0.25), (.left, 0.50), (.left, 0.75) ]

    private var modifier: CGFloat = 0.25

    override func viewDidLoad() {
        navigationController?.navigationBar.isHidden = true
        
        animator = UIDynamicAnimator(referenceView: dynamicAnimatorReferenceView)
        bubbleBehavior = BubbleBehavior()
        animator.addBehavior(bubbleBehavior)
        
        progressBar.layer.cornerRadius = 5
        progressBar.layer.borderWidth = 1.0
        progressBar.layer.borderColor = UIColor.white.cgColor
        progressBar.clipsToBounds = true
        progressBar.layer.sublayers![1].cornerRadius = 5
        progressBar.subviews[1].clipsToBounds = true
        
        showQuestion()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        bubbleBehavior.willMove(to: animator)
    }
    // MARK: - Logic
    
    private func showQuestion() {
        answerLocations = possibleAnswerLocations
        updateProgress()
        if let previousQuestionID = currentQuestion.answersFromQuestion {
            currentQuestion.answers = answers[previousQuestionID]
        }
        questionLabel.text = currentQuestion.text
        UIView.animate(withDuration: 0.3, animations: {
            if self.questionLabel.alpha == 0 {
                self.questionLabel.alpha = 1.0
            }
        }) { _ in
            self.displayAnswers()
        }
    }
    
    @IBAction func nextTapped(_ sender: UIButton) {
        let selectedItems = answerViews.filter({ $0.isSelected })
        
        // Check single questions
        if (currentQuestion.type == .single && selectedItems.count != 1) {
            showInfoWith("You need to select an answer")
            return
        }
        
        // Check Min Selection
        if let minSelections = currentQuestion.minSelections {
            if selectedItems.count < minSelections || (currentQuestion.type == .single && selectedItems.count != 1) {
                showInfoWith("You need to select at least \(minSelections) answer(s)")
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
                    showInfoWith(message)
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
            performSegue(withIdentifier: "unwindToDashboard", sender: self)
            return
        }
        
        switch action.type {
        case .app:
            if UserDefaults.standard.value(forKey: EntryLogicConstants.selectedTask) == nil {
                if action.value == "exit" {
                    // The user has dropped out of the first 10 question by not using a device. Show them the dropout page
                    performSegue(withIdentifier: "DropoutSegue", sender: self)
                    return
                }
                
                // The user has successfully answered all questions required. Don't show them it again until it's time
                UserDefaults.standard.set(true, forKey: EntryLogicConstants.allQuestionsAnswered)
                performSegue(withIdentifier: "ResultsSegue", sender: self)
                return
            }
            
            // The user is currently doing their daily task questions
            performSegue(withIdentifier: "DashboardSegue", sender: self)
            Date().save(as: EntryLogicConstants.dailyQuestionsAnsweredDate)
            
            // Cancel any notifications for today
            UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: ["\(Date().daysPastSinceTaskStartDate())"])
            return
        case .question:
            guard let nextQuestion = questionFor(ID: action.value) else {
                // Exit
                performSegue(withIdentifier: "unwindToDashboard", sender: self)
                return
            }
            currentQuestion = nextQuestion
            reset()
        }
    }
    
    func reset() {
        currentAnswer = []
        nudged = false
        gradient.animateGradient()
        UIView.animate(withDuration: 0.3, animations: {
            self.questionLabel.alpha = 0.0
            self.infoView.alpha = 0.0
            for answerView in self.answerViews {
                self.bubbleBehavior.removeItem(answerView)
                answerView.removeFromSuperview()
            }
            self.answerViews.removeAll()
            self.view.layoutSubviews()
        }) { _ in
            self.showQuestion()
        }
    }
    
    func showInfoWith(_ message: String) {
        infoLabel.text = message
        infoView.setNeedsDisplay()
        UIView.animate(withDuration: 0.3) {
            self.infoView.alpha = 1
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
        switch randomAnswerLocation() {
        case (.top, let modifier):
            return CGPoint(x: dynamicAnimatorReferenceView.frame.size.width * modifier, y: 0)
        case (.bottom, let modifier):
            return CGPoint(x: dynamicAnimatorReferenceView.frame.size.width * modifier, y: dynamicAnimatorReferenceView.frame.size.height)
        case (.left, let modifier):
            return CGPoint(x: 0, y: dynamicAnimatorReferenceView.frame.size.height * modifier)
        case (.right, let modifier):
            return CGPoint(x: dynamicAnimatorReferenceView.frame.size.width, y: dynamicAnimatorReferenceView.frame.size.height * modifier)
        }
    }
    
    private func randomAnswerLocation() -> (edge: Edge, modifier: CGFloat) {
        let randomIndex = Int(arc4random_uniform(UInt32(answerLocations.count)))
        let randomAnswerLocation = answerLocations[randomIndex]
        answerLocations.remove(at: randomIndex)
        return randomAnswerLocation
    }
    
    // MARK: - Helpers
    private func questionFor(ID questionID: String) -> Question? {
        return questions.first(where: { $0.id == questionID })
    }
    
    private func updateProgress() {
        let index = questions.index(where: { (question) -> Bool in
            question.id == currentQuestion.id
        })
        let progress = Float(index!) / Float(questions.count)
        progressBar.setProgress(progress, animated: true)
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ResultsSegue" {
            if let controller = segue.destination as? ResultsViewController {
                controller.questions = questions
                controller.answers = answers
            }
        }
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
        
        guard let views = adjacentViews(to: answerView) else {
            return
        }

        for adjacentView in views {
            let pushBehavior = UIPushBehavior(items: [adjacentView], mode: .instantaneous)
            pushBehavior.pushDirection = vector(selectedAnswer: answerView, to: adjacentView)
            pushBehavior.magnitude = 0.04
            pushBehavior.active = true
            pushBehavior.action = {
                if !pushBehavior.active {
                    self.animator.removeBehavior(pushBehavior)
                }
            }
            animator.addBehavior(pushBehavior)
        }
    }
    
    private func adjacentViews(to selectedAnswer: BubbleAnswerView) -> [BubbleAnswerView]? {
        return answerViews.filter({ isAdjacent(selectedAnswer: selectedAnswer, to: $0) })
    }
    
    private func isAdjacent(selectedAnswer: BubbleAnswerView, to answerView: BubbleAnswerView) -> Bool {
        let distanceBetweenCenters = sqrt(pow((selectedAnswer.center.x - answerView.center.x), 2) + pow((selectedAnswer.center.y - answerView.center.y), 2))
        if distanceBetweenCenters >= selectedAnswer.frame.size.width - 2 && distanceBetweenCenters <= selectedAnswer.frame.size.width + 2 {
            return true
        }
        return false
    }
    
    private func vector(selectedAnswer: BubbleAnswerView, to answerView: BubbleAnswerView) -> CGVector {
        return CGVector(dx: answerView.center.x - selectedAnswer.center.x, dy: answerView.center.y - selectedAnswer.center.y)
    }
}
