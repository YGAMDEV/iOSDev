//
//  DailyResults.swift
//  YGAM
//
//  Created by Jon Fulton on 04/10/2018.
//  Copyright © 2018 Sky Betting and Gaming. All rights reserved.
//

import UIKit

struct DailyResultsConstants {
    static let dailyResults = "DailyResults"
    static let day = "Day"
    static let value = "Value"
    static let imageName = "ImageName"
}

class DailyResults {
    
    private let controlResultScale = 10
    private let moneyResultScale = 34
    private let timeResultScale = 20
    
    private var questions: [Question]!
    
    func saveData(day: Int, answers: [String: [Answer]], questions: [Question]!) {
        self.questions = questions
        if let task = UserDefaults.standard.value(forKey: EntryLogicConstants.selectedTask) as? String,
            let taskIdentifier = TaskIdentifier.init(rawValue: task) {
            switch taskIdentifier {
            case .control:
                calculateControlResults(day: day, answers: answers)
            case .money:
                calculateMoneyResults(day: day, answers: answers)
            case .time:
                calculateTimeResults(day: day, answers: answers)
            }
        }
    }
        
    // MARK: - Result Calculations
    private func calculateControlResults(day: Int, answers: [String: [Answer]]) {
        guard let firstAnswer = answers["1"]?.first?.text, let firstQuestion = questionFor(ID: "1"),
            let secondAnswer = answers["2"]?.first?.text, let secondQuestion = questionFor(ID: "2")else {
                return
        }
        let firstResult = (indexOf(answer: firstAnswer, in: firstQuestion) + 1) * controlResultScale
        let secondResult = (indexOf(answer: secondAnswer, in: secondQuestion) + 1) * controlResultScale
        
        let result = min(100, Int(firstResult + secondResult))
        save(key: day, value: result)
    }
    
    private func calculateMoneyResults(day: Int, answers: [String: [Answer]]) {
        var moneyResult = 34
        if let answer = answers["2"]?.first?.text, let question = questionFor(ID: "2") {
            moneyResult = min(100, (indexOf(answer: answer, in: question) + 2) * moneyResultScale)
        }
        save(key: day, value: moneyResult)
    }
    
    private func calculateTimeResults(day: Int, answers: [String: [Answer]]) {
        guard let answer = answers["1"]?.first?.text, let question = questionFor(ID: "1") else {
            return
        }
        let result = min(100, (indexOf(answer: answer, in: question)  + 1) * timeResultScale)
        save(key: day, value: result)
    }
    
    // MARK: - Helpers
    private func questionFor(ID questionID: String) -> Question? {
        return questions.first(where: { $0.id == questionID })
    }
    
    private func indexOf(answer: String, in question: Question) -> Int {
        guard let questionAnswers = question.answers, let index = questionAnswers.index(where: { $0.text == answer}) else {
            return 0
        }
        return index
    }
    
    private func image(`for` value: Int) -> String {
        switch value {
        case 0..<35:
            return "ChartGoodIcon"
        case 35..<69:
            return "ChartNeutralIcon"
        default:
            return "ChartBadIcon"
        }
    }
    
    private func save(key: Int, value: Int) {
        var results = [[String: Any]]()
        
        if let savedResults = UserDefaults.standard.array(forKey: DailyResultsConstants.dailyResults) as? [[String: Any]] {
            results = savedResults
        }
        
        let dailyResult: [String: Codable] = [DailyResultsConstants.value: value,
                                              DailyResultsConstants.day: key,
                                              DailyResultsConstants.imageName: image(for: value)]
        
        results.append(dailyResult)
        
        UserDefaults.standard.set(results, forKey: DailyResultsConstants.dailyResults)
        UserDefaults.standard.synchronize()
    }
}
