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
    @IBOutlet weak var controlView: GradientBackgroundView!
    @IBOutlet weak var moneyLabel: UILabel!
    @IBOutlet weak var moneyProgressView: ProgressView!
    @IBOutlet weak var moneyView: GradientBackgroundView!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var timeProgressView: ProgressView!
    @IBOutlet weak var timeView: GradientBackgroundView!
    
    public var questions: [Question]!
    public var answers: [String: [Answer]]! {
        didSet {
            calculateControlResults()
            calculateMoneyResults()
            calculateTimeResults()
        }
    }
    
    private let center = UNUserNotificationCenter.current()
    
    private let controlResultScale = 12.5
    private let moneyResultScale = 50
    private let timeResultScale = 25
    
    private var controlResult = 0
    private var moneyResult = 0
    private var timeResult = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        controlLabel.text = "\(controlResult)%"
        moneyLabel.text = "\(moneyResult)%"
        timeLabel.text = "\(timeResult)%"
        
        controlView.setupGradientView(startColor: UIColor(red:0.15, green:0.58, blue:0.85, alpha:1).cgColor, endColor: UIColor(red:0.07, green:0.36, blue:0.7, alpha:1).cgColor)
        moneyView.setupGradientView(startColor: UIColor(red:0.19, green:0.14, blue:0.68, alpha:1).cgColor, endColor: UIColor(red:0.78, green:0.43, blue:0.84, alpha:1).cgColor)
        timeView.setupGradientView(startColor: UIColor(red:0.28, green:1, blue:0.86, alpha:1).cgColor, endColor: UIColor(red:0.06, green:0.82, blue:0.67, alpha:1).cgColor)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        controlProgressView.percent(controlResult)
        moneyProgressView.percent(moneyResult)
        timeProgressView.percent(timeResult)
    }
    
    // MARK: - Selections
    @IBAction func controlButton(_ sender: UIButton) {
        // Setup Tasks for Control
        scheduleNotifications()
    }
    
    @IBAction func moneyButton(_ sender: UIButton) {
        // Setup Tasks for Money
        scheduleNotifications()
    }
    
    @IBAction func timeButton(_ sender: UIButton) {
        // Setup Tasks for Time
        scheduleNotifications()
    }
    
    private func scheduleNotifications() {
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
//        let numberOfSecondsInADay: Double = 86400
        let numberOfSecondsInADay: Double = 10
        let numberOfDays = 3
        for i in 1...numberOfDays {
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: Double(i) * numberOfSecondsInADay, repeats: false)
            let request = UNNotificationRequest(identifier: "\(i)", content: self.notificationContent(), trigger: trigger)
            center.add(request, withCompletionHandler: nil)
        }
    }
    
    private func notificationContent() -> UNMutableNotificationContent {
        let content = UNMutableNotificationContent()
        content.body = "Come back and update us on your progress"
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
        let firstResult = Double(indexOf(answer: firstAnswer, in: firstQuestion)) * controlResultScale
        let secondResult = Double(indexOf(answer: secondAnswer, in: secondQuestion)) * controlResultScale
        
        controlResult = Int(firstResult + secondResult)
    }
    
    private func calculateMoneyResults() {
        // The id for the question relating to money is "7"
        guard let answer = answers["7"]?.first?.text, let question = questionFor(ID: "7") else {
            return
        }
        // There's only two outcomes - 50 or 100, so add 1 to the index to get the correct result
        moneyResult = (indexOf(answer: answer, in: question) + 1) * moneyResultScale
    }
    
    private func calculateTimeResults() {
        // The id for the question relating to time is "4"
        guard let answer = answers["4"]?.first?.text, let question = questionFor(ID: "4") else {
            return
        }
        timeResult = indexOf(answer: answer, in: question) * timeResultScale
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
