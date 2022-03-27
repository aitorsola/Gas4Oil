//
//  VehicleData.swift
//  Gas4Oil
//
//  Created by Aitor Sola on 21/3/22.
//

import Foundation

class VehicleFavorite {

  static var vehicleData: VehicleStored? {
    getVehicleData()
  }

  private static func getVehicleData() -> VehicleStored? {
    guard let data = UserDefaults.standard.data(forKey: "car-data") else {
      return nil
    }
    return try? JSONDecoder().decode(VehicleStored.self, from: data)
  }

  static func saveVehicleData(data: VehicleStored) {
    guard let data = try? JSONEncoder().encode(data) else {
      return
    }
    UserDefaults.standard.set(data, forKey: "car-data")
    UserDefaults.standard.synchronize()
  }

  static func removeVehicleData() {
    UserDefaults.standard.removeObject(forKey: "car-data")
    UserDefaults.standard.synchronize()
  }
}
