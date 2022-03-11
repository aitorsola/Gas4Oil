//
//  FavoriteListViewViewModel.swift
//  Gas4Oil
//
//  Created by Aitor Sola on 11/3/22.
//

import Foundation

class FavoriteListViewViewModel: ObservableObject {

  @Published var allStations: [Station] = []
  @Published var favoriteStations: [Station] = []

  // MARK: - Public

  func getFavoriteStations(allStations: [Station]) {
    self.allStations = allStations
    favoriteStations = allStations.filter { $0.isFav }
  }

  func setFavoriteStation(_ station: Station) {
    allStations = FavoriteStations.manageFavorite(station, stations: allStations)
    favoriteStations = allStations.filter { $0.isFav }
  }
}
