//
//  VehicleViewViewModel.swift
//  Gas4Oil
//
//  Created by Aitor Sola on 21/3/22.
//

import Foundation

class VehicleViewViewModel: ObservableObject {

  // MARK: - Properties

  @Published var vehicleData: VehicleData = VehicleData(brand: "", model: "", capacity: "", fuel: .gas95)
  @Published var showSuccessAlert: Bool = false
  @Published var allFuelTypes = FuelType.allCases

  // MARK: - Public

  func getVehicleData() {
    guard let vehicleData = Vehicle.vehicleData else {
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

  func removeVehicle() {
    Vehicle.removeVehicleData()
    vehicleData.reset()
  }
}

