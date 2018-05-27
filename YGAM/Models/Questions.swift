//
//  Questions.swift
//  YGAM
//
//  Created by Jon Fulton on 16/05/2018.
//  Copyright © 2018 Sky Betting and Gaming. All rights reserved.
//

import Foundation

struct Action: Codable {
    let type: ActionType
    let value: String
}

struct Answer: Codable {
    let text: String
    let action: Action?
}

struct Nudge: Codable {
    let text: String
    let trigger: [String]
    let confirmedAction: Action
}

struct Question: Codable {
    let id: String
    let type: QuestionType
    let text: String
    
    var answers: [Answer]?
    let answersFromQuestion: String?
    
    let minSelections: Int?
    
    let nudge: Nudge?
    let completeAction: Action?
}

struct QuestionList: Codable {
    let questions: [Question]
}
