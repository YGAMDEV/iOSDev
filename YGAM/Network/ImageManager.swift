//
//  ImageManager.swift
//  YGAM
//
//  Created by Jon Fulton on 28/09/2017.
//  Copyright © 2017 Jon Fulton. All rights reserved.
//

import Foundation
import UIKit

typealias ImageResult = Result<(image: UIImage?, imageURLString: String)>

final class ImageManager: NSObject {
    
    struct Constants {
        static let cacheLimit: Int = 50
    }
    
    static let sharedInstance = ImageManager()
    
    func image(`for` imageURLString: String, completion: @escaping (ImageResult) -> Void) {
        // Try and load the image if available and set the cache
        if let imageURL = URL(string: imageURLString) {
            NetworkRequest.imageRequest(url: imageURL) { result in
                switch result {
                case .failure(let error):
                        completion(.failure(error))
                case .success(let image):
                        completion(.success((image, imageURLString)))
                }
            }
        }
    }
}
