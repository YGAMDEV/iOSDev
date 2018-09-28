//
//  Task.swift
//  YGAM
//
//  Created by Jon Fulton on 28/09/2018.
//  Copyright © 2018 Sky Betting and Gaming. All rights reserved.
//

import UIKit

class Task: NSObject {
    var gradientFirstColor: UIColor?
    var gradientSecondColor: UIColor?
    var signposts: [Signpost]?
    var taskDescription: String?
}

class ControlTask: Task {
    override init() {
        super.init()
        taskDescription = "Your goal was to gain back control of how you spend your time on your device"
        gradientFirstColor = UIColor(red:0.15, green:0.58, blue:0.85, alpha:1)
        gradientSecondColor =  UIColor(red:0.07, green:0.36, blue:0.7, alpha:1)
        signposts = [ Signpost(image: #imageLiteral(resourceName: "Thinkyouknowlogo_400x400"),
                               heading: "Tips for staying in control",
                               body: "Thinkuknow is the education programme from CEOP, a UK organisation which protects children both online and offline.",
                               url: URL(string: "https://www.thinkuknow.co.uk/8_10-archive/control/")),
                      Signpost(image: #imageLiteral(resourceName: "yound_minds_400x400"),
                               heading: "Get support with peer pressure, cyberbullying and more",
                               body: "We will make sure all young people get the best possible mental health support and have the resilience to overcome life's challenges.",
                               url: URL(string: "https://youngminds.org.uk/find-help/looking-after-yourself/online-pressures/")),
                      Signpost(image: #imageLiteral(resourceName: "Mind_400x400"),
                               heading: "Eat well",
                               body: "We provide advice and support to empower anyone experiencing a mental health problem. We campaign to improve services, raise awareness and promote understanding.",
                               url: URL(string: "https://www.mind.org.uk/information-support/tips-for-everyday-living/food-and-mood/about-food-and-mood/")),
                      Signpost(image: #imageLiteral(resourceName: "NHS_400x400"),
                               heading: "Pay attention to the present moment",
                               body: "Take control of your health and wellbeing. Get medical advice, information about healthcare services and support for a healthy life.",
                               url: URL(string: "https://www.nhs.uk/conditions/stress-anxiety-depression/mindfulness/"))
        ]
    }
}

class MoneyTask: Task {
    override init() {
        super.init()
        taskDescription = "Your goal was to reduce the amount of money you spend on your device"
        gradientFirstColor = UIColor(red:0.19, green:0.14, blue:0.68, alpha:1)
        gradientSecondColor =  UIColor(red:0.78, green:0.43, blue:0.84, alpha:1)
        signposts = [ Signpost(image: #imageLiteral(resourceName: "Money_advice_service_400x400"),
                               heading: "Set a budget",
                               body: "We change lives by helping people make the most of their money.",
                               url: URL(string: "https://www.moneyadviceservice.org.uk/en/tools/budget-planner")),
                      Signpost(image: #imageLiteral(resourceName: "Money_advice_service_400x400"),
                               heading: "Manage your money",
                               body: "We change lives by helping people make the most of their money.",
                               url: URL(string: "https://www.moneyadviceservice.org.uk/en/categories/managing-money")),
                      Signpost(image: #imageLiteral(resourceName: "Money_advice_service_400x400"),
                               heading: "Debt advice",
                               body: "We change lives by helping people make the most of their money.",
                               url: URL(string: "https://www.moneyadviceservice.org.uk/en/categories/debt-and-borrowing"))
        ]
    }
}

class TimeTask: Task {
    override init() {
        super.init()
        taskDescription = "Your goal was to reduce the amount of time you spend on your device"
        gradientFirstColor = UIColor(red:0.28, green:1, blue:0.86, alpha:1)
        gradientSecondColor =  UIColor(red:0.06, green:0.82, blue:0.67, alpha:1)
        signposts = [ Signpost(image: #imageLiteral(resourceName: "Mind_400x400"),
                               heading: "Manage your online/offline balance",
                               body: "We provide advice and support to empower anyone experiencing a mental health problem. We campaign to improve services, raise awareness and promote understanding.",
                               url: URL(string: "https://www.mind.org.uk/information-support/tips-for-everyday-living/online-mental-health/about-online-mental-health/")),
                      Signpost(image: #imageLiteral(resourceName: "yound_minds_400x400"),
                               heading: "Take time out",
                               body: "We will make sure all young people get the best possible mental health support and have the resilience to overcome life's challenges.",
                               url: URL(string: "https://youngminds.org.uk/find-help/looking-after-yourself/take-time-out/"))
        ]
        
    }
}
