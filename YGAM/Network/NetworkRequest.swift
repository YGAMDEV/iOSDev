//
//  NetworkRequest.swift
//  YGAM
//
//  Created by Jon Fulton on 18/09/2017.
//  Copyright © 2017 Jon Fulton. All rights reserved.
//

import Foundation
import UIKit

final class NetworkRequest: NSObject {
    static func makeRequest(url: URL, with completion: @escaping (Result<Data?>) -> Void) {
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        let task = session.dataTask(with: url) { (data, response, error) in
            if (error != nil) {
                return completion(.failure(error!))
            }
            if let httpResponse = response as? HTTPURLResponse {
                if httpResponse.statusCode != 200 {
                    return completion(.failure(NetworkErrors.invalidOrNoURL))
                }
            }
            return completion(.success(data))
        }
        task.resume()
    }
    
    static func imageRequest(url: URL, with completion: @escaping (Result<UIImage>) -> Void) {
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        let urlRequest = URLRequest(url: url, cachePolicy: .returnCacheDataElseLoad, timeoutInterval: 10)
        let task = session.dataTask(with: urlRequest) { (data, response, error) in
            if (error != nil) {
                return completion(.failure(error!))
            }
            
            if let httpResponse = response as? HTTPURLResponse {
                if httpResponse.statusCode != 200 {
                    return completion(.failure(NetworkErrors.invalidOrNoURL))
                }
            }
            
            guard let data = data, let image = UIImage(data: data) else {
                return completion(.failure(NetworkErrors.noImageAvailable))
            }
            
            return completion(.success(image))
        }
        task.resume()
    }
}
