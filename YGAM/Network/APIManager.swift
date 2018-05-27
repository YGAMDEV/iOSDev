//
//  APIManager.swift
//  YGAM
//
//  Created by Jon Fulton on 18/09/2017.
//  Copyright © 2017 Jon Fulton. All rights reserved.
//

import Foundation

public protocol APIRequest {
    associatedtype Model: Decodable

    func createModel(completion: @escaping (Result<Model>) -> Void)
}

extension APIRequest {
    var requestURL: URL? {
//        let baseURL = "http://ec2-52-208-210-208.eu-west-1.compute.amazonaws.com/games"
//        return URL(string: baseURL)
        
        return Bundle.main.url(forResource: "QuestionList", withExtension: ".json")
    }
    
    func createModel(completion: @escaping (Result<Model>) -> Void) {
        guard let url = requestURL else {
            completion(.failure(NetworkErrors.invalidOrNoURL))
            return
        }
        NetworkRequest.makeRequest(url: url) { result in
            switch result {
            case .failure(let error):
                completion(.failure(error))
            case .success(let value):
                let decoder = JSONDecoder()
                guard let model = try? decoder.decode(Model.self, from: value!) else {
                    completion(.failure(NetworkErrors.decodingError))
                    return
                }
                completion(.success(model))
            }
        }
    }
}
