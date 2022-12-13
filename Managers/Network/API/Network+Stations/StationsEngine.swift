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
                guard let entity = Parser.parse(data, entity: StationsResponse.self) else {
                    return
                }
                completion(.success(entity.stations))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
