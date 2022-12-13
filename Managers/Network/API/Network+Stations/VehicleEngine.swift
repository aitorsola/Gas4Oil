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
    func getModelByBrand(brandId: Int, completion: @escaping (Result<[VehicleModelEntity], G4OError>) -> Void)
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
                let decoder = JSONDecoder()
                do {
                    let entity = try decoder.decode([VehicleBrand].self, from: data)
                    let finalData: [VehicleBrandEntity] = entity.compactMap { brand in
                        brand.domainEntity()
                    }
                    completion(.success(finalData))
                } catch {
                    completion(.failure(.parseProblems))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func getModelByBrand(brandId: Int, completion: @escaping (Result<[VehicleModelEntity], G4OError>) -> Void) {
        let url = VehicleEndpoints.modelByBrand.replacingOccurrences(of: "{brand_id}", with: String(brandId))
        let request = Request(url: url, method: .get)
        perform(request) { result in
            switch result {
            case .success(let data):
                let decoder = JSONDecoder()
                do {
                    let entity = try decoder.decode([VehicleModel].self, from: data)
                    let finalData: [VehicleModelEntity] = entity.compactMap { brand in
                        brand.domainEntity()
                    }
                    completion(.success(finalData))
                } catch {
                    completion(.failure(.parseProblems))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
