//
//  VehicleViewViewModel.swift
//  Gas4Oil
//
//  Created by Aitor Sola on 21/3/22.
//

import Foundation

class VehicleViewViewModel: ObservableObject {

  // MARK: - Properties

  @Published var vehicleData: VehicleStored = VehicleStored(brand: "", model: "", capacity: "", fuel: .gas95)
  @Published var showSuccessAlert: Bool = false
  @Published var allFuelTypes = FuelType.allCases

  @Published var allBrands = [VehicleBrandEntity]()
  @Published var allModelsForBrand = [String]()

  @Published var selectedBrand: String?

  private var vehicleAPI: VehicleAPI = Network()

  // MARK: - Public

  func getVehicleData() {
    guard let vehicleData = VehicleFavorite.vehicleData else {
      return
    }
    self.vehicleData = vehicleData
  }

  func saveVehicleData() {
    guard !vehicleData.isEmpty() else {
      return
    }
    showSuccessAlert = true
    VehicleFavorite.saveVehicleData(data: vehicleData)
  }

  func removeVehicle() {
    VehicleFavorite.removeVehicleData()
    vehicleData.reset()
  }

  func getAllBrands() {
    vehicleAPI.getBrands { result in
      switch result {
      case .success(let brands):
        DispatchQueue.main.async {
          self.allBrands = brands
          self.selectedBrand = brands.first?.brand
        }
      case .failure(let error):
        print(error.localizedDescription)
      }
    }
  }

  func getModelByBrand() {
    vehicleAPI.getModelByBrand { result in

    }
  }
}

