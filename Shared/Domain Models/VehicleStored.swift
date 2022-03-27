//
//  VehicleStored.swift
//  Gas4Oil
//
//  Created by Aitor Sola on 25/3/22.
//

import Foundation

enum FuelType: Codable, CaseIterable {
  case gas95
  case gas98
  case diesel
}

struct VehicleStored: Codable {
  var brand: String
  var model: String
  var capacity: String
  var fuel: FuelType

  func isEmpty() -> Bool {
    brand.isEmpty || model.isEmpty || capacity.isEmpty
  }

  mutating func reset() {
    brand = ""
    model = ""
    capacity = ""
  }
}
