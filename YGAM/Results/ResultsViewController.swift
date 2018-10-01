//
//  ResultsViewController.swift
//  YGAM
//
//  Created by Jon Fulton on 25/09/2018.
//  Copyright © 2018 Sky Betting and Gaming. All rights reserved.
//

import UIKit
import UserNotifications

class ResultsViewController: UIViewController {

    @IBOutlet weak var controlLabel: UILabel!
    @IBOutlet weak var controlProgressView: ProgressView!
    @IBOutlet weak var controlView: UIView!
    @IBOutlet weak var moneyLabel: UILabel!
    @IBOutlet weak var moneyProgressView: ProgressView!
    @IBOutlet weak var moneyView: UIView!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var timeProgressView: ProgressView!
    @IBOutlet weak var timeView: UIView!
    
    public var questions: [Question]!
    public var answers: [String: [Answer]]! {
        didSet {
            calculateControlResults()
            calculateMoneyResults()
            calculateTimeResults()
        }
    }
    
    public struct Constants {
        static let controlResult = "ControlResult"
        static let moneyResult = "MoneyResult"
        static let timeResult = "TimeResult"
    }
    
    private let center = UNUserNotificationCenter.current()
    
    private let controlResultScale = 10
    private let moneyResultScale = 34
    private let timeResultScale = 20
    
    private var cachedControlResult = 0
    private var cachedMoneyResult = 0
    private var cachedTimeResult = 0
    private var selectedTask: TaskIdentifier?
    
    private var controlResult: Int {
        get {
            guard let cachedControlResult = UserDefaults.standard.value(forKey: Constants.controlResult) as? Int else {
                return 0
            }
            return cachedControlResult
        }
        
        set {
            self.cachedControlResult = newValue
            UserDefaults.standard.set(cachedControlResult, forKey: Constants.controlResult)
        }
    }
    private var moneyResult: Int {
        get {
            guard let cachedMoneyResult = UserDefaults.standard.value(forKey: Constants.moneyResult) as? Int else {
                return 0
            }
            return cachedMoneyResult
        }
        
        set {
            self.cachedMoneyResult = newValue
            UserDefaults.standard.set(cachedMoneyResult, forKey: Constants.moneyResult)
        }
    }
    
    private var timeResult: Int {
        get {
            guard let cachedTimeResult = UserDefaults.standard.value(forKey: Constants.timeResult) as? Int else {
                return 0
            }
            return cachedTimeResult
        }
        
        set {
            self.cachedTimeResult = newValue
            UserDefaults.standard.set(cachedTimeResult, forKey: Constants.timeResult)
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        controlLabel.text = "\(controlResult)%"
        moneyLabel.text = "\(moneyResult)%"
        timeLabel.text = "\(timeResult)%"
        
        let borderColor = UIColor(red: 227/255, green: 227/255, blue: 227/255, alpha: 1.0).cgColor
        controlView.layer.borderColor = borderColor
        moneyView.layer.borderColor = borderColor
        timeView.layer.borderColor = borderColor
        
        controlView.layer.borderWidth = 1
        moneyView.layer.borderWidth = 1
        timeView.layer.borderWidth = 1
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        controlProgressView.percent(controlResult)
        moneyProgressView.percent(moneyResult)
        timeProgressView.percent(timeResult)
    }
    
    // MARK: - Selections
    @IBAction func controlButton(_ sender: UIButton) {
        scheduleNotifications(for: .control)
    }
    
    @IBAction func moneyButton(_ sender: UIButton) {
        scheduleNotifications(for: .money)
    }
    
    @IBAction func timeButton(_ sender: UIButton) {
        scheduleNotifications(for: .time)
    }
    
    private func setTask(task: TaskIdentifier) {
        UserDefaults.standard.setValue(task.rawValue, forKey: EntryLogicConstants.selectedTask)
        // Dependent on notifications
        Date().save(as: EntryLogicConstants.taskStartDate, stripTime: true)
        Date().save(as: EntryLogicConstants.dailyQuestionsAnsweredDate)
    }
    
    private func scheduleNotifications(`for` task: TaskIdentifier) {
        setTask(task: task)
        selectedTask = task
        center.getNotificationSettings { settings in
            if settings.authorizationStatus == .authorized {
                self.createNotifications()
            }
            self.dismiss()
        }
    }
    
    private func dismiss() {
        DispatchQueue.main.async {
            self.performSegue(withIdentifier: "DashboardSegue", sender: nil)
        }
    }
    
    // MARK: - Notification Creation
    private func createNotifications() {
        let numberOfSecondsInADay: Double = 86400
        let numberOfDays = 7
        for i in 1...numberOfDays {
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: Double(i) * numberOfSecondsInADay, repeats: false)
            let request = UNNotificationRequest(identifier: "\(i)", content: self.notificationContent(), trigger: trigger)
            center.add(request, withCompletionHandler: nil)
        }
    }
    
    private func notificationContent() -> UNMutableNotificationContent {
        let content = UNMutableNotificationContent()
        switch selectedTask! {
        case .control:
            content.body = "Are you still focussed on your personal goal of increasing your level of control? Let us know"
        case .money:
            content.body = "Are you still focussed on your personal goal of reducing money spent? Let us know"
        case .time:
            content.body = "Are you still focussed on your personal goal of reducing time spent on devices? Let us know"
        }
        content.sound = UNNotificationSound.default()
        
        return content
    }
    
    // MARK: - Result Calculations
    private func calculateControlResults() {
        // The id for the question relating to money is "7"
        guard let firstAnswer = answers["9"]?.first?.text, let firstQuestion = questionFor(ID: "9"),
              let secondAnswer = answers["10"]?.first?.text, let secondQuestion = questionFor(ID: "10")else {
            return
        }
        let firstResult = (indexOf(answer: firstAnswer, in: firstQuestion) + 1) * controlResultScale
        let secondResult = (indexOf(answer: secondAnswer, in: secondQuestion) + 1) * controlResultScale
        
        controlResult = min(100, Int(firstResult + secondResult))
    }
    
    private func calculateMoneyResults() {
        // The id for the question relating to money is "7"
        if let answer = answers["7"]?.first?.text, let question = questionFor(ID: "7") {
            moneyResult = min(100, (indexOf(answer: answer, in: question) + 2) * moneyResultScale)
        } else {
            // Set the result to be the smallest value possible
            moneyResult = 34
        }
    }
    
    private func calculateTimeResults() {
        // The id for the question relating to time is "4"
        guard let answer = answers["4"]?.first?.text, let question = questionFor(ID: "4") else {
            return
        }
        timeResult = min(100, (indexOf(answer: answer, in: question)  + 1) * timeResultScale)
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
}
