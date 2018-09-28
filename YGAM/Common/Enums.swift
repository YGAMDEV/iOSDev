//
//  Enums.swift
//  NativeVegas
//
//  Created by Jon Fulton on 18/09/2017.
//  Copyright © 2017 Jon Fulton. All rights reserved.
//

import Foundation

public enum Result<Value> {
    case failure(Error)
    case success(Value)
}

public enum NetworkErrors: Error {
    case decodingError
    case invalidOrNoURL
    case malformedJSON
    case noImageAvailable
    case apiGeneratedError(String)
}

public enum QuestionType: String, Codable {
    case multi
    case single
}

public enum ActionType: String, Codable {
    case app
    case question
}

public enum TaskIdentifier: String {
    case control
    case money
    case time
}
