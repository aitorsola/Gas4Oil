//
//  Vehicle.swift
//  Gas4Oil
//
//  Created by Aitor Sola on 27/3/22.
//

import Foundation

struct VehicleBrand: Decodable, DomainConvertible {
  typealias DomainEntityType = VehicleBrandEntity

  let id: Int
  let brand: String

  func domainEntity() -> VehicleBrandEntity? {
    VehicleBrandEntity(id: id, brand: brand)
  }
}
