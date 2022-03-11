//
//  FavoriteStations.swift
//  Gas4Oil
//
//  Created by Aitor Sola on 9/3/22.
//

import Foundation
import SwiftUI

class FavoriteStations {

  private static var defaults = UserDefaults.standard
  private static var allFavorites: [Int] = defaults.value(forKey: "favs") as? [Int] ?? []

  static func manageFavorite(_ station: Station, stations: [Station]) -> [Station] {
    if allFavorites.isEmpty {
      return saveNewFavorite(station, stations: stations)
    } else {
      if allFavorites.contains(where: {$0 == station.id }) {
        return removeFavorite(station, stations: stations)
      } else {
        return saveNewFavorite(station, stations: stations)
      }
    }
  }

  static private func saveNewFavorite(_ station: Station, stations: [Station]) -> [Station] {
    allFavorites.append(station.id)
    defaults.set(allFavorites, forKey: "favs")
    return getNewFavoriteStations(stations)
  }

  static private func removeFavorite(_ station: Station, stations: [Station]) -> [Station] {
    allFavorites.removeAll(where: {$0 == station.id})
    defaults.set(allFavorites, forKey: "favs")
    return getNewFavoriteStations(stations)
  }

  static private func getNewFavoriteStations(_ stations: [Station]) -> [Station] {
    var stations = stations
    for i in 0..<stations.count {
      stations[i].isFav = allFavorites.contains(where: {$0 == stations[i].id})
    }
    return stations
  }
}
