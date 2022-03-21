//
//  VehicleViewViewModel.swift
//  Gas4Oil
//
//  Created by Aitor Sola on 21/3/22.
//

import Foundation

struct VehicleData: Codable {
  var brand: String
  var model: String
  var capacity: String

  func isEmpty() -> Bool {
    return brand.isEmpty || model.isEmpty || capacity.isEmpty
  }
}

class VehicleViewViewModel: ObservableObject {

  // MARK: - Properties

  @Published var vehicleData: VehicleData = VehicleData(brand: "", model: "", capacity: "")
  @Published var showSuccessAlert: Bool = false

  // MARK: - Public

  func getVehicleData() {
    guard let vehicleData = Vehicle.getVehicleData() else {
      return
    }
    self.vehicleData = vehicleData
  }

  func saveVehicleData() {
    guard !vehicleData.isEmpty() else {
      return
    }
    showSuccessAlert = true
    Vehicle.saveVehicleData(data: vehicleData)
  }
}

