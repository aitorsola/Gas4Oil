//
//  StationsEngine.swift
//  Gas4Oil
//
//  Created by Aitor Sola on 4/3/22.
//

import CoreLocation

protocol ServiceStationsAPI {
    func getAllStations(completion: @escaping (Result<[Station], G4OError>) -> Void)
}

private enum StationsEndpoints {
    static var allStations = "https://sedeaplicaciones.minetur.gob.es/ServiciosRESTCarburantes/PreciosCarburantes/EstacionesTerrestres/"
}

extension Network: ServiceStationsAPI {
    
    func getAllStations(completion: @escaping (Result<[Station], G4OError>) -> Void) {
        let request = Request(url: StationsEndpoints.allStations, method: .get)
        perform(request) { result in
            switch result {
            case .success(let data):
                do {
                    let decoder = JSONDecoder()
                    let entity = try decoder.decode(StationsResponse.self, from: data)
                    guard let stations = entity.domainEntity()?.stations else {
                        completion(.failure(.parseProblems))
                        return
                    }
                    completion(.success(stations))
                } catch {
                    completion(.failure(.parseProblems))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
