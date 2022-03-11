//
//  Parser.swift
//  MVVM_New
//
//  Created by Aitor Sola on 12/2/22.
//  Copyright © 2022 Abhilash Mathur. All rights reserved.
//

import Foundation

class Parser {
  
  static func parse<T: Decodable & DomainConvertible>(_ data: Data, entity: T.Type) -> T.DomainEntityType? {
    let decoder = JSONDecoder()
    let entity = try? decoder.decode(T.self, from: data)
    return entity?.domainEntity()
  }
}
