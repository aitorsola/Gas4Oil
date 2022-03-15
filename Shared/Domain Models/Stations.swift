//
//  Stations.swift
//  Gas4Oil
//
//  Created by Aitor Sola on 4/3/22.
//

import Foundation
import CoreLocation

struct Stations {
  let stations: [Station]
}

struct Station: Identifiable, Codable {
  let id: Int
  let cp: String
  let provincia: String
  let municipio: String
  let direccion: String
  let horario: String
  let longitude: Double
  let latitude: Double
  let gasNaturalComprimido: String
  let gasNaturalLicuado: String
  let gasoleoA: String
  let gasoleoB: String
  let gasoleoPremium: String
  let gasolina95E10: String
  let gasolina95E5: String
  let gasolina95E5Premium: String
  let gasolina98E10: String
  let gasolina98E5: String
  let hidrogeno: String
  let rotulo: String
  var isFav: Bool

  func getCLLocationCoordinates() -> CLLocation {
    CLLocation(latitude: latitude, longitude: longitude)
  }
}
