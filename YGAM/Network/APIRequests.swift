//
//  APIRequests.swift
//  YGAM
//
//  Created by Jon Fulton on 18/09/2017.
//  Copyright © 2017 Jon Fulton. All rights reserved.
//

import Foundation

struct QuestionsRequest: APIRequest {
    var requestURL: URL? = Bundle.main.url(forResource: "QuestionList", withExtension: ".json")
    typealias Model = QuestionList
}

struct ControlQuestionRequest: APIRequest {
    typealias Model = QuestionList
    var requestURL: URL? = Bundle.main.url(forResource: "ControlTask", withExtension: ".json")
}

struct MoneyQuestionRequest: APIRequest {
    typealias Model = QuestionList
    var requestURL: URL? = Bundle.main.url(forResource: "MoneyTask", withExtension: ".json")
}

struct TimeQuestionRequest: APIRequest {
    typealias Model = QuestionList
    var requestURL: URL? = Bundle.main.url(forResource: "TimeTask", withExtension: ".json")
}
