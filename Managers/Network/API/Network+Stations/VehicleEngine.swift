//
//  VehicleEngine.swift
//  Gas4Oil
//
//  Created by Aitor Sola on 27/3/22.
//

import Foundation

protocol VehicleAPI {
  func getVehicleTypes()
  func getBrands(completion: @escaping (Result<[VehicleBrandEntity], G4OError>) -> Void)
  func getModelByBrand(completion: @escaping (Result<[VehicleBrand], G4OError>) -> Void)
}

private enum VehicleEndpoints {
  static var vehicleTypes = "https://the-vehicles-api.herokuapp.com/types/"
  static var allBrands = "https://the-vehicles-api.herokuapp.com/brands/"
  static var modelByBrand = "https://the-vehicles-api.herokuapp.com/models?brandId={brand_id}"
}

extension Network: VehicleAPI {

  func getVehicleTypes() {

  }

  func getBrands(completion: @escaping (Result<[VehicleBrandEntity], G4OError>) -> Void) {
    let request = Request(url: VehicleEndpoints.allBrands, method: .get)
    perform(request) { result in
      switch result {
      case .success(let data):
        print(data)
        guard let entity = Parser.parse(data, entity: [VehicleBrand].self) else {
          completion(.failure(.parseProblems))
          return
        }
        completion(.success(entity))
      case .failure(let error):
        completion(.failure(error))
      }
    }
  }

  func getModelByBrand(completion: @escaping (Result<[VehicleBrand], G4OError>) -> Void) {

  }
}
