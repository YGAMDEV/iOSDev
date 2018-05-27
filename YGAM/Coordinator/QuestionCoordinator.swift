//
//  QuestionCoordinator.swift
//  YGAM
//
//  Created by Jon Fulton on 16/05/2018.
//  Copyright © 2018 Sky Betting and Gaming. All rights reserved.
//

import Foundation
import UIKit

protocol QuestionCoordinatorDelegate: AnyObject {
    
    func didFinish(questionID: String, answer: [Answer], action: Action?)
}

class QuestionCoordinator: NSObject, QuestionCoordinatorDelegate {
    
    weak var delegate: CoordinatorDelegate?
    var navController: UINavigationController
    var questions: [Question]
    var answers = [String: [Answer]]()
    var questionIndex = 0
    
    init(rootViewController: UINavigationController) {
        self.navController = rootViewController
        self.questions = [Question]()
        super.init()
    }
    
    public func start() {
        let questionsRequest = QuestionsRequest()
        questionsRequest.createModel() { result in
            switch result {
            case .failure(let error):
                print("Failed: \(error)")
            case .success(let questionList):
                self.questions = questionList.questions
                DispatchQueue.main.async {
                    self.display(question: self.questions.first!)
                }
            }
        }
    }
    
    private func display(question: Question) {
        var question = question
        
        if let previousQuestionID = question.answersFromQuestion {
            question.answers = answers[previousQuestionID]
        }
        
        let questionViewController = QuestionViewController(question: question, nibName: "QuestionViewController", bundle: nil)
        questionViewController.delegate = self;

        navController.pushViewController(questionViewController, animated: true)
    }
    
    // MARK: - QuestionCoordinatorDelegate
    
    func didFinish(questionID: String, answer: [Answer], action: Action?) {
        
        answers[questionID] = answer
        
        guard let action = action else {
            // Exit
            delegate?.coordinatorCompleted()
            return
        }
        
        switch action.type {
        case .app:
            // Exit
            delegate?.coordinatorCompleted()
            return
        case .question:
            guard let nextQuestion = questionFor(ID: action.value) else {
                // Exit
                delegate?.coordinatorCompleted()
                return
            }
            display(question: nextQuestion)
        }
    }
    
    // MARK: - Helpers
    private func questionFor(ID questionID: String) -> Question? {
        return questions.first(where: { $0.id == questionID })
    }
}
