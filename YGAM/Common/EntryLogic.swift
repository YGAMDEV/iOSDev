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
    static let dailyQuestionsAnsweredDate = "DailyQuestionsAnsweredDate"
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
        
        // Need to show the full set of questions - either they haven't completed it yet or it's been
        // longer than seven days since they set their task
        if UserDefaults.standard.bool(forKey: EntryLogicConstants.allQuestionsAnswered) == false {
            let questionsStoryboard = UIStoryboard(name: "Questions", bundle: nil)
            // Load the questionsViewController with the relevant questions for the Task selected
            let initialVC = questionsStoryboard.instantiateInitialViewController() as! BubbleQuestionViewController
            initialVC.questions = allQuestions
            return initialVC
        }
        
        // A task has been selected
        if UserDefaults.standard.value(forKey: EntryLogicConstants.selectedTask) != nil {
            if Calendar.current.isDateInToday(UserDefaults.standard.value(forKey: EntryLogicConstants.dailyQuestionsAnsweredDate) as! Date) ||
               Date().daysPastSinceTaskStartDate() > 7 {
                // Questions have been answered for today OR it's been 7 days past so don't show the task questions again - show the dashboard
                let dashboardStoryboard = UIStoryboard(name: "Dashboard", bundle: nil)
                return dashboardStoryboard.instantiateInitialViewController()!
            }
            
            // Load the questionsViewController with the relevant questions for the Task selected
            let questions = UIStoryboard(name: "Questions", bundle: nil)
            let initialVC = questions.instantiateInitialViewController() as! BubbleQuestionViewController
            
            if let task = UserDefaults.standard.value(forKey: EntryLogicConstants.selectedTask) as? String,
                let taskIdentifier = TaskIdentifier.init(rawValue: task) {
                switch taskIdentifier {
                case .control:
                    initialVC.questions = controlQuestions
                case .money:
                    initialVC.questions = moneyQuestions
                case .time:
                    initialVC.questions = timeQuestions
                }
            }
            return initialVC
        }
        
        let questionsStoryBoard = UIStoryboard(name: "Questions", bundle: nil)
        return questionsStoryBoard.instantiateViewController(withIdentifier: "ResultsViewController")
    }
}
