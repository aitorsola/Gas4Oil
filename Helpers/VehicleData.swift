//
//  VehicleData.swift
//  Gas4Oil
//
//  Created by Aitor Sola on 21/3/22.
//

import Foundation

class Vehicle {

  static var vehicleData: VehicleData? {
    getVehicleData()
  }

  static func getVehicleData() -> VehicleData? {
    guard let data = UserDefaults.standard.data(forKey: "car-data") else {
      return nil
    }
    return try? JSONDecoder().decode(VehicleData.self, from: data)
  }

  static func saveVehicleData(data: VehicleData) {
    guard let data = try? JSONEncoder().encode(data) else {
      return
    }
    UserDefaults.standard.set(data, forKey: "car-data")
    UserDefaults.standard.synchronize()
  }
}
