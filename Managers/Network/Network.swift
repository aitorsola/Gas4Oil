//
//  APIService.swift
//  MVVM_New
//
//  Created by Abhilash Mathur on 20/05/20.
//  Copyright © 2020 Abhilash Mathur. All rights reserved.
//

import Foundation

enum HTTPMethod: String {
    case post
    case get
    case patch
    case delete
}

struct Request {
    let url: String
    let method: HTTPMethod
    let parameters: [String: String]? = nil
    let headers: [String: String]? = nil
}

enum G4OError: Error {
    case networkProblem
    case parseProblems
}

class Network {
    
    func perform(_ request: Request, completion: @escaping (Result<Data, G4OError>) -> Void) {
        guard let url = URL(string: request.url) else {
            completion(.failure(.networkProblem))
            return
        }
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = request.method.rawValue
        
        URLSession.shared.dataTask(with: urlRequest, completionHandler: { data, response, error in
            guard let data = data, error == nil else {
                completion(.failure(.networkProblem))
                return
            }
            completion(.success(data))
        })
        .resume()
    }
}
