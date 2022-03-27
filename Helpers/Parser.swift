//
//  Parser.swift
//  MVVM_New
//
//  Created by Aitor Sola on 12/2/22.
//  Copyright © 2022 Abhilash Mathur. All rights reserved.
//

import Foundation

struct Parser {

  static func mainParse<T: Decodable>(data: Data, entityType: T.Type) -> T? {
    let decoder = JSONDecoder()
    var returnValue: T?
    do {
      let data = (data.isEmpty) ? try JSONSerialization.data(withJSONObject: [:]) : data
      returnValue = try decoder.decode(entityType, from: data)
    } catch {
      if let derror = error as? DecodingError {
        print(derror.localizedDescription)
      }
    }
    return returnValue
  }
  
  static func parse<T: Decodable & DomainConvertible>(_ data: Data, entity: T.Type) -> T.DomainEntityType? {
    let entity = mainParse(data: data, entityType: entity)
    return entity?.domainEntity()
  }

  static func parse<T: Decodable & DomainConvertible>(_ data: Data, entity: [T].Type) -> [T.DomainEntityType]? {
    let entities = mainParse(data: data, entityType: entity)
    return entities?.compactMap { $0.domainEntity() }
  }
}
