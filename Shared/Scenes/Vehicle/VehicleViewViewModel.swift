//
//  VehicleViewViewModel.swift
//  Gas4Oil
//
//  Created by Aitor Sola on 21/3/22.
//

import Foundation
#if canImport(UIKit)
import NotificationBannerSwift
#endif

class VehicleViewViewModel: ObservableObject {

  // MARK: - Properties

  @Published var vehicleData: VehicleStored = VehicleStored(brand: "", model: "", capacity: "", fuel: .gas95)
  @Published var showSuccessAlert: Bool = false
  @Published var allFuelTypes = FuelType.allCases
  @Published var loading: Bool = false

  @Published var selectedBrandIndex: Int = 0
  @Published var selectedModelIndex: Int = 0

  @Published var allBrands = [VehicleBrandEntity]()
  @Published var allModelsForBrand = [VehicleModelEntity]()

  @Published var selectedBrand: VehicleBrandEntity?
  @Published var selectedModel: VehicleModelEntity?

  private var vehicleAPI: VehicleAPI = Network()

  init() {
    getVehicleData()
    getAllBrands()
  }

  // MARK: - Public

  func getVehicleData() {
    guard let vehicleData = VehicleFavorite.vehicleData else {
      return
    }
    self.vehicleData = vehicleData
  }

  func saveVehicleData(brandIndex: Int, modelIndex: Int, capacity: String) {
    vehicleData.brand = allBrands[brandIndex].brand
    vehicleData.model = allModelsForBrand[modelIndex].model
    vehicleData.capacity = capacity

    VehicleFavorite.saveVehicleData(data: vehicleData)

    showSuccessAlert = true
  }

  func removeVehicle() {
    VehicleFavorite.removeVehicleData()

    selectedBrandIndex = 0
    selectedModelIndex = 0
    vehicleData.reset()
  }

  func getAllBrands() {
    vehicleAPI.getBrands { result in
      DispatchQueue.main.async {
        self.loading = false
        switch result {
        case .success(let brands):
          self.allBrands = brands
          self.getSavedVehicleBrandIndex()
          self.getModelsForBrandIndex(self.selectedBrandIndex)
        case .failure(let error):
#if os(iOS)
          let banner = NotificationBanner(title: error.localizedDescription,
                                          subtitle: "",
                                          leftView: nil,
                                          rightView: nil,
                                          style: .warning,
                                          colors: nil)
          banner.show()
#else
          print(error.localizedDescription)
#endif
        }
      }
    }
  }

  func getModelsForBrandIndex(_ index: Int) {
    let brandId = allBrands[index].id
    vehicleAPI.getModelByBrand(brandId: brandId) { result in
      switch result {
      case .success(let models):
        DispatchQueue.main.async {
          self.allModelsForBrand = models
          self.getSaveVehicleModelIndex()
        }
      case .failure(let error):
#if os(iOS)
          let banner = NotificationBanner(title: error.localizedDescription,
                                          subtitle: "",
                                          leftView: nil,
                                          rightView: nil,
                                          style: .warning,
                                          colors: nil)
          banner.show()
#else
          print(error.localizedDescription)
#endif
      }
    }
  }

  private func getSavedVehicleBrandIndex() {
    selectedBrandIndex = allBrands.firstIndex(where: {$0.brand == vehicleData.brand }) ?? 0
  }

  private func getSaveVehicleModelIndex() {
    selectedModelIndex = allModelsForBrand.firstIndex(where: {$0.model == vehicleData.model }) ?? 0
  }
}

