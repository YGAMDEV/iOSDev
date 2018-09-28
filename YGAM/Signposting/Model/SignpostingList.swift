//
//  SignpostingList.swift
//  YGAM
//
//  Created by Jon Fulton on 28/09/2018.
//  Copyright © 2018 Sky Betting and Gaming. All rights reserved.
//

import UIKit

class SignpostingList: NSObject {
    let signposts = [
        Signpost(image: #imageLiteral(resourceName: "NHS_400x400"),
                 heading: "What is addiction and where can you get help?",
                 body: "Take control of your health and wellbeing. Get medical advice, information about healthcare services and support for a healthy life.",
                 url: URL(string: "https://www.nhs.uk/live-well/healthy-body/addiction-what-is-it/")),
        Signpost(image: #imageLiteral(resourceName: "NHS_400x400"),
                 heading: "Advice, tips and tools to help you make the best choices about your health and wellbeing",
                 body: "Take control of your health and wellbeing. Get medical advice, information about healthcare services and support for a healthy life.",
                 url: URL(string: "https://www.nhs.uk/live-well/")),
        Signpost(image: #imageLiteral(resourceName: "NHS_400x400"),
                 heading: "What is addiction and where can you get help?",
                 body: "Take control of your health and wellbeing. Get medical advice, information about healthcare services and support for a healthy life.",
                 url: URL(string: "https://www.nhs.uk/live-well/healthy-body/gambling-addiction/")),
        Signpost(image: #imageLiteral(resourceName: "UATC_400x400"),
                 heading: "Help with gaming addiction",
                 body: "Our purpose is to provide excellent care and treatment to enable all those suffering from addictive disorders to achieve a goal of life-long recovery.",
                 url: URL(string: "https://www.ukat.co.uk/gaming-addiction/")),
        Signpost(image: #imageLiteral(resourceName: "UATC_400x400"),
                 heading: "Help with internet addiction",
                 body: "Our purpose is to provide excellent care and treatment to enable all those suffering from addictive disorders to achieve a goal of life-long recovery.",
                 url: URL(string: "https://www.ukat.co.uk/internet-addiction/")),
        Signpost(image: #imageLiteral(resourceName: "Mind_400x400"),
                 heading: "Help with choices about treatment, understand your rights or reach out to sources of support",
                 body: "We provide advice and support to empower anyone experiencing a mental health problem. We campaign to improve services, raise awareness and promote understanding.",
                 url: URL(string: "https://www.mind.org.uk/")),
        Signpost(image: #imageLiteral(resourceName: "Samaritans_400x400"),
                 heading: "A safe place for you to talk any time you like, in your own way – about whatever’s getting to you",
                 body: "A safe place for you to talk any time you like, in your own way – about whatever’s getting to you",
                 url: URL(string: "https://www.samaritans.org/")),
        Signpost(image: #imageLiteral(resourceName: "YGAM_400x400"),
                 heading: "Informing, educatind and safeguarding young people against problematic gambling & social gaming",
                 body: "Informing, educatind and safeguarding young people against problematic gambling & social gaming",
                 url: URL(string: "http://www.ygam.org/")),
        Signpost(image: #imageLiteral(resourceName: "Money_advice_service_400x400"),
                 heading: "Free and impartial money advice, set up by the UK government",
                 body: "We change lives by helping people make the most of their money.",
                 url: URL(string: "https://www.moneyadviceservice.org.uk/en")),
        
        Signpost(image: #imageLiteral(resourceName: "Thinkyouknowlogo_400x400"),
                 heading: "Advice to help young people stay safe online",
                 body: "Thinkuknow is the education programme from CEOP, a UK organisation which protects children both online and offline.",
                 url: URL(string: "https://www.thinkuknow.co.uk/"))
    ]
}
