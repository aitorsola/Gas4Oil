//
//  FavoriteListViewViewModel.swift
//  Gas4Oil
//
//  Created by Aitor Sola on 11/3/22.
//

import Foundation

class FavoriteListViewViewModel: ObservableObject {

  @Published var favoriteStations: [Station] = []

  // MARK: - Public

  func updateFavoriteStations(allStations: [Station]) {
    favoriteStations = allStations
    allStations.forEach { station in
      FavoriteStations.updateFavorite(station)
    }
  }
}
