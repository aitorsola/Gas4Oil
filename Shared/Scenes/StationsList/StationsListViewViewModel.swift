//
//  ListViewViewModel.swift
//  Gas4Oil
//
//  Created by Aitor Sola on 6/3/22.
//

import CoreLocation
import SwiftUI
import NotificationBannerSwift

enum CommonStationBrand: String {
  case alcampo
  case carrefour
  case bonarea
  case campsa
  case petroprix
  case eroski
  case repsol
  case cepsa
  case ballenoil
  case galp
  case bp
  case shell
  case avia
  case petronor
  case q8
  case unknown
}

class StationsListViewViewModel: ObservableObject {

  // MARK: - Properties

  private var locationManager: LocationManager
  private var servicesStationsAPI: ServiceStationsAPI

  private var kMaxLenght = 5

  let defaults: UserDefaults = UserDefaults.standard

  var allStations: [Station] = []
  var allMunicipios: [String] {
    allStations.map({$0.municipio}).unique().sorted(by: {$0<$1})
  }
  var currentSortType: SortType = .near95
  var currentCity: String?
  var currentSortBrand: FuelBrandSortType = .all
  var updateFavorites: Bool = true

  @Published var locationAllowed: Bool = false {
    didSet {
      isLoading = !locationAllowed
    }
  }
  @Published var isLoading: Bool = false
  @Published var navigationTitle: String?
  @Published var isLoaded: Bool = false
  @Published var stations: [Station] = []
  @Published var favorites: [Station] = []
  @Published var allBrands: [CommonStationBrand] = [
    .alcampo,
    .avia,
    .bp,
    .ballenoil,
    .q8,
    .bonarea,
    .campsa,
    .carrefour,
    .cepsa,
    .eroski,
    .galp,
    .petronor,
    .repsol,
    .petroprix,
    .shell].sorted(by: { $0.rawValue < $1.rawValue })

  // MARK: - Lifecycle

  init(locationManager: LocationManager = Managers.location, servicesAPI: ServiceStationsAPI = Network()) {
    self.locationManager = locationManager
    self.servicesStationsAPI = servicesAPI
#if os(macOS)
    self.locationAllowed = locationManager.currentAuth == .authorized || locationManager.currentAuth == .authorizedAlways
#else
    self.locationAllowed = locationManager.currentAuth == .authorizedWhenInUse
#endif
    _ = FavoriteStations.getAllFavorites()
    setupLocationManager()
  }

  // MARK: - Public

  func requestLocation() {
#if os(iOS)
    if locationManager.currentAuth == .denied {
      UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
      return
    }
#endif
    locationManager.requestAuth()
  }

  func favoriteStationTapAction(_ station: Station) {
    favorites = FavoriteStations.manageFavorite(station)
    // update model
    guard let index = stations.firstIndex(where: {$0.id == station.id }) else {
      return
    }
    stations[index].isFav = favorites.contains(where: {$0.id == stations[index].id })
  }

  func searchResults(text: String) -> [String] {
    if text.isEmpty {
      return allMunicipios
    } else {
      return allMunicipios.filter { $0.contains(text) }
    }
  }

  // MARK: - Private

  private func getStations() {
    locationAllowed = true
    isLoading = true
    allStations = []
    stations = []
    currentCity = nil
    currentSortType = .near95
    currentSortBrand = .all
    servicesStationsAPI.getAllStations { result in
      DispatchQueue.main.async {
        self.isLoaded = true
        self.isLoading = false
      }
      switch result {
      case .success(let stations):
        self.allStations = stations
        self.updateFavoriteStationsData(stations: stations)

        let stations = Array(self.allStations
          .filter { !$0.gasolina95E5.isEmpty }
          .sorted(by: { self.sortStationsByProximity(station1: $0, station2: $1, sortType: self.currentSortType) })
          .prefix(self.kMaxLenght))

        DispatchQueue.main.async {
          self.stations = stations
        }
      case .failure(let error):
        let banner = NotificationBanner(title: error.localizedDescription,
                                        subtitle: "",
                                        leftView: nil,
                                        rightView: nil,
                                        style: .warning,
                                        colors: nil)
        banner.show()
      }
    }
  }

  private func setupLocationManager() {
    locationManager.delegate = self
#if os(macOS)
    locationManager.requestAuth()
#endif
  }
}

// MARK: - Sorting

extension StationsListViewViewModel {

  func showByBrand(_ brandSortType: FuelBrandSortType) {
    self.currentSortBrand = brandSortType
    switch brandSortType {
    case .all:
      showFuelSorted(currentSortType)
    case .brand(let brand):
      let newStations = Array(self.allStations
        .filter { $0.rotulo.contains(brand.uppercased()) }
        .filter { station in
          guard let currentCity = currentCity else {
            return true
          }
          return station.municipio == currentCity.lowercased() || station.provincia == currentCity.lowercased()
        }
        .filter { station in
          switch self.currentSortType {
          case .near98, .price98Up, .price98Down:
            return !station.gasolina98E5.isEmpty
          case .near95, .price95Up, .price95Down:
            return !station.gasolina95E5.isEmpty
          case .nearDiesel, .priceDieselUp, .priceDieselDown:
            return !station.gasoleoA.isEmpty
          }
        }
        .sorted(by: { station1, station2 in
          switch self.currentSortType {
          case .near95, .near98, .nearDiesel:
            return true
          case .price95Down:
            return station1.gasolina95E5 < station2.gasolina95E5
          case .price95Up:
            return station1.gasolina95E5 > station2.gasolina95E5
          case .price98Down:
            return station1.gasolina98E5 < station2.gasolina98E5
          case .price98Up:
            return station1.gasolina98E5 > station2.gasolina98E5
          case .priceDieselDown:
            return station1.gasoleoA < station2.gasoleoA
          case .priceDieselUp:
            return station1.gasoleoA > station2.gasoleoA
          }
        })
        .sorted(by: { self.sortStationsByProximity(station1: $0, station2: $1, sortType: currentSortType) })
        .prefix(kMaxLenght))

      stations = newStations
    }
  }

  func showFuelByCity(_ city: String) {
    currentCity = city.lowercased()
    let newStations = Array(self.allStations
      .filter {$0.municipio == currentCity || $0.provincia == currentCity }
      .filter { station in
        switch self.currentSortBrand {
        case .all:
          return true
        case .brand(let brand):
          return station.rotulo.contains(brand.uppercased())
        }
      }
      .prefix(kMaxLenght)
      .sorted(by: { station1, station2 in
        switch self.currentSortType {
        case .near95, .near98, .nearDiesel:
          return sortStationsByProximity(station1: station1, station2: station2, sortType: self.currentSortType)
        case .price95Down:
          return station1.gasolina95E5 < station2.gasolina95E5
        case .price95Up:
          return station1.gasolina95E5 > station2.gasolina95E5
        case .price98Down:
          return station1.gasolina98E5 < station2.gasolina98E5
        case .price98Up:
          return station1.gasolina98E5 > station2.gasolina98E5
        case .priceDieselDown:
          return station1.gasoleoA < station2.gasoleoA
        case .priceDieselUp:
          return station1.gasoleoA > station2.gasoleoA
        }
      }))
    stations = newStations
    navigationTitle = currentCity?.capitalized ?? ""
  }

  func showFuelSorted(_ by: SortType) {
    self.currentSortType = by
    let newStations = Array(self.allStations
      .filter { station in
        guard let currentCity = currentCity else {
          return true
        }
        return station.municipio == currentCity.lowercased() || station.provincia == currentCity.lowercased()
      }
      .filter { station in
        switch self.currentSortType {
        case .near98, .price98Up, .price98Down:
          return !station.gasolina98E5.isEmpty
        case .near95, .price95Up, .price95Down:
          return !station.gasolina95E5.isEmpty
        case .nearDiesel, .priceDieselUp, .priceDieselDown:
          return !station.gasoleoA.isEmpty
        }
      }
      .filter { station in
        switch self.currentSortBrand {
        case .all:
          return true
        case .brand(let brand):
          return station.rotulo.contains(brand.uppercased())
        }
      }
      .sorted(by: { self.sortStationsByProximity(station1: $0, station2: $1, sortType: by) })
      .prefix(kMaxLenght)
      .sorted(by: { station1, station2 in
        switch self.currentSortType {
        case .near95, .near98, .nearDiesel:
          return sortStationsByProximity(station1: station1, station2: station2, sortType: currentSortType)
        case .price95Down:
          return station1.gasolina95E5 < station2.gasolina95E5
        case .price95Up:
          return station1.gasolina95E5 > station2.gasolina95E5
        case .price98Down:
          return station1.gasolina98E5 < station2.gasolina98E5
        case .price98Up:
          return station1.gasolina98E5 > station2.gasolina98E5
        case .priceDieselDown:
          return station1.gasoleoA < station2.gasoleoA
        case .priceDieselUp:
          return station1.gasoleoA > station2.gasoleoA
        }
      }))

    stations = newStations
  }

  private func sortStationsByProximity(station1: Station, station2: Station, sortType: SortType) -> Bool {
    guard let pointToCompare = locationManager.currentCoordinates else {
      return false
    }
    switch sortType {
    case .near95:
      if station1.gasolina95E5.isEmpty {
        return false
      }
    case .near98:
      if station1.gasolina98E5.isEmpty {
        return false
      }
    case .nearDiesel:
      if station1.gasoleoA.isEmpty {
        return false
      }
    default:
      break
    }
    let station1Coord = CLLocation(latitude: station1.latitude, longitude: station1.longitude)
    let station2Coord = CLLocation(latitude: station2.latitude, longitude: station2.longitude)
    return station1Coord.distance(from: pointToCompare) < station2Coord.distance(from: pointToCompare)
  }

  private func updateFavoriteStationsData(stations: [Station]) {
    var allFavs = FavoriteStations.getAllFavorites()
    allStations.forEach { station in
      if let index = allFavs.firstIndex(where: {$0.id == station.id}) {
        allFavs[index].gasolina95E5 = station.gasolina95E5
        allFavs[index].gasolina98E5 = station.gasolina98E5
        allFavs[index].gasoleoA = station.gasoleoA
      }
    }
    DispatchQueue.main.async {
      self.favorites = allFavs
    }
  }
}

// MARK: - LocationManagerDelegate

extension StationsListViewViewModel: LocationManagerDelegate {

  func didGet(city: String?) {
    self.navigationTitle = city?.capitalized
    getStations()
  }

  func didFailGettingLocation(_ error: Error) {
    self.isLoading = false
  }
}
