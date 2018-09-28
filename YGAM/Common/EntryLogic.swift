//
//  EntryLogic.swift
//  YGAM
//
//  Created by Jon Fulton on 27/09/2018.
//  Copyright © 2018 Sky Betting and Gaming. All rights reserved.
//

import UIKit

struct EntryLogicConstants {
    static let onBoardingComplete = "OnBoardingComplete"
    static let allQuestionsAnswered = "AllQuestionsAnswered"
    
    static let taskStartDate = "TaskStartDate"
    static let selectedTask = "SelectedTask"
}

class EntryLogic: NSObject {
    
    private var controlQuestions: [Question]?
    private var moneyQuestions: [Question]?
    private var timeQuestions: [Question]?
    private var allQuestions: [Question]?
    
    override init() {
        super.init()
        loadQuestions()
    }
    
    private func loadQuestions() {
        let group = DispatchGroup()
        
        group.enter()
        let allQuestionsRequest = QuestionsRequest()
        allQuestionsRequest.createModel() { result in
            switch result {
            case .failure(let error):
                print("Failed: \(error)")
            case .success(let questionList):
                self.allQuestions = questionList.questions
            }
            group.leave()
        }
        
        group.enter()
        let controlRequest = ControlQuestionRequest()
        controlRequest.createModel() { result in
            switch result {
            case .failure(let error):
                print("Failed: \(error)")
            case .success(let questionList):
                self.controlQuestions = questionList.questions
            }
            group.leave()
        }
        
        group.enter()
        let moneyRequest = MoneyQuestionRequest()
        moneyRequest.createModel() { result in
            switch result {
            case .failure(let error):
                print("Failed: \(error)")
            case .success(let questionList):
                self.moneyQuestions = questionList.questions
            }
            group.leave()
        }
        
        group.enter()
        let timeRequest = TimeQuestionRequest()
        timeRequest.createModel() { result in
            switch result {
            case .failure(let error):
                print("Failed: \(error)")
            case .success(let questionList):
                self.timeQuestions = questionList.questions
            }
            group.leave()
        }
        
        group.wait()
    }
    
    public func intialViewContoller() -> UIViewController {
        // Need to show the onboarding screens
        if UserDefaults.standard.bool(forKey: EntryLogicConstants.onBoardingComplete) == false {
            let onBoardingStoryBoard = UIStoryboard(name: "OnBoarding", bundle: nil)
            return onBoardingStoryBoard.instantiateInitialViewController()!
        }
        
        // Need to show the full set of questions
        if UserDefaults.standard.bool(forKey: EntryLogicConstants.allQuestionsAnswered) == false {
            let questionsStoryboard = UIStoryboard(name: "Questions", bundle: nil)
            // Load the questionsViewController with the relevant questions for the Task selected
            let initialVC = questionsStoryboard.instantiateInitialViewController() as! BubbleQuestionViewController
            initialVC.questions = allQuestions
            return initialVC
        }
        
        // A task has been selected - show the dashboard
        if UserDefaults.standard.value(forKey: EntryLogicConstants.selectedTask) != nil {
            let dashboardStoryboard = UIStoryboard(name: "Dashboard", bundle: nil)
            return dashboardStoryboard.instantiateInitialViewController()!
        }
        
        // Need to show the results page - the user is yet to select a task
        let questionsStoryBoard = UIStoryboard(name: "Questions", bundle: nil)
        return questionsStoryBoard.instantiateViewController(withIdentifier: "ResultsViewController")
        
//        if UserDefaults.standard.bool(forKey: EntryLogicConstants.onBoardingComplete) == true {
//            if UserDefaults.standard.value(forKey: EntryLogicConstants.selectedTask) == nil {
//                // No current tasks
//                let dashboard = UIStoryboard(name: "Dashboard", bundle: nil)
//                return dashboard.instantiateInitialViewController()!
//            } else {
//                let questions = UIStoryboard(name: "Questions", bundle: nil)
//                // Load the questionsViewController with the relevant questions for the Task selected
//                let initialVC = questions.instantiateInitialViewController() as? BubbleQuestionViewController
//                initialVC?.questions = controlQuestions
//
//                return initialVC!
//            }
//        }
        

    }
}
