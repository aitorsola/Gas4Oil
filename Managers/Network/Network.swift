//
//  APIService.swift
//  MVVM_New
//
//  Created by Abhilash Mathur on 20/05/20.
//  Copyright © 2020 Abhilash Mathur. All rights reserved.
//

import Alamofire
import Foundation

struct Request {
  let url: String
  let method: HTTPMethod
  let parameters: [String:String]? = nil
  let headers: HTTPHeaders? = nil

  func toURL() -> URLConvertible {
    Gas4OilURL(url: url)
  }
}

struct Gas4OilURL: URLConvertible {
  let url: String
  func asURL() throws -> URL {
    URL(string: url)!
  }
}

enum G4OError: Error {
  case networkProblem
  case parseProblems
}

class Network {

  func perform(_ request: Request, completion: @escaping (Result<Data, G4OError>) -> Void) {
    AF.request(request.toURL(),
               method: request.method,
               parameters: request.parameters,
               encoder: .json, headers: request.headers).response { response in
      switch response.result {
      case .success(let data):
        guard let data = data else {
          completion(.failure(.networkProblem))
          return
        }
        completion(.success(data))
      case .failure:
        completion(.failure(.networkProblem))
      }
    }
  }
}
