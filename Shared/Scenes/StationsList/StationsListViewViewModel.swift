//
//  ListViewViewModel.swift
//  Gas4Oil
//
//  Created by Aitor Sola on 6/3/22.
//

import CoreLocation

class StationsListViewViewModel: ObservableObject {

  // MARK: - Properties

  private var locationManager: LocationManager
  private var servicesStationsAPI: ServiceStationsAPI

  let defaults: UserDefaults = UserDefaults.standard

  var allStations: [Station] = []
  var currentSortType: SortType = .near95
  var currentCity: String? = ""
  var currentSortBrand: FuelBrandSortType = .all

  @Published var stations: [Station] = []
  @Published var allBrands: [String] = ["Alcampo",
                                        "Carrefour",
                                        "Bonarea",
                                        "Campsa",
                                        "Petroprix",
                                        "Eroski",
                                        "Repsol",
                                        "Cepsa",
                                        "Ballenoil",
                                        "Galp",
                                        "BP",
                                        "Shell",
                                        "Avia",
                                        "Petronor"].sorted(by: {$0 < $1})
  @Published var isLoading: Bool = true
  @Published var navigationTitle: String?

  @Published var isLoaded: Bool = false

  // MARK: - Lifecycle

  init(locationManager: LocationManager = Managers.location, servicesAPI: ServiceStationsAPI = Network()) {
    self.locationManager = locationManager
    self.servicesStationsAPI = servicesAPI
    setupLocationManager()
  }

  // MARK: - Public

  func requestLocation() {
    isLoading = true
    locationManager.requestAuth()
  }

  func saveFavoriteStation(_ station: Station) {
    stations = FavoriteStations.manageFavorite(station, stations: stations)
    allStations = stations
  }

  // MARK: - Private

  private func getStations(for city: String?) {
    isLoading = true
    allStations = []
    stations = []
    currentSortType = .near95
    currentSortBrand = .all
    self.servicesStationsAPI.getAllStations { result in
      self.isLoaded = true
      switch result {
      case .success(let stations):
        self.allStations = stations
        self.stations = self.allStations
          .filter {$0.municipio == city?.lowercased() || $0.provincia == city?.lowercased() }
          .filter {!$0.gasolina95E5.isEmpty
          }
          .sorted(by: { station1, station2 in
            switch self.currentSortType {
            case .near98, .near95, .nearDiesel:
              return self.sortStationsByProximity(station1: station1, station2: station2, sortType: self.currentSortType)
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
          .filter({ station in
            switch self.currentSortType {
            case .near98, .price98Up, .price98Down:
              return !station.gasolina98E5.isEmpty
            case .near95, .price95Up, .price95Down:
              return !station.gasolina95E5.isEmpty
            case .nearDiesel, .priceDieselUp, .priceDieselDown:
              return !station.gasoleoA.isEmpty
            }
          })
          .filter({ station in
            switch self.currentSortBrand {
            case .all:
              return true
            case .brand(let brand):
              return station.rotulo.contains(brand.uppercased())
            }
          })
        self.isLoading = false
      case .failure(let error):
        print(error.localizedDescription)
      }
    }
  }

  private func setupLocationManager() {
    locationManager.delegate = self
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
      self.stations = self.allStations
        .filter({$0.rotulo.contains(brand.uppercased())})
        .filter {$0.municipio == currentCity?.lowercased() || $0.provincia == currentCity?.lowercased() }
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
        })
        .filter({ station in
          switch self.currentSortType {
          case .near98, .price98Up, .price98Down:
            return !station.gasolina98E5.isEmpty
          case .near95, .price95Up, .price95Down:
            return !station.gasolina95E5.isEmpty
          case .nearDiesel, .priceDieselUp, .priceDieselDown:
            return !station.gasoleoA.isEmpty
          }
        })
    }
  }

  func showFuelByCity(_ city: String) {
    currentCity = city.lowercased()
    self.stations = self.allStations
      .filter {$0.municipio == city.lowercased() || $0.provincia == city.lowercased() }
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
      })
      .filter({ station in
        switch self.currentSortBrand {
        case .all:
          return true
        case .brand(let brand):
          return station.rotulo.contains(brand.uppercased())
        }
      })
    navigationTitle = city.capitalized
  }

  func showFuelSorted(_ by: SortType) {
    self.currentSortType = by
    self.stations = self.allStations
      .filter {$0.municipio == currentCity?.lowercased() || $0.provincia == currentCity?.lowercased() }
      .sorted(by: { station1, station2 in
        switch self.currentSortType {
        case .near95, .near98, .nearDiesel:
          return sortStationsByProximity(station1: station1, station2: station2, sortType: by)
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
      .filter({ station in
        switch self.currentSortType {
        case .near98, .price98Up, .price98Down:
          return !station.gasolina98E5.isEmpty
        case .near95, .price95Up, .price95Down:
          return !station.gasolina95E5.isEmpty
        case .nearDiesel, .priceDieselUp, .priceDieselDown:
          return !station.gasoleoA.isEmpty
        }
      })
      .filter({ station in
        switch self.currentSortBrand {
        case .all:
          return true
        case .brand(let brand):
          return station.rotulo.contains(brand.uppercased())
        }
      })
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
    let station1Coord = CLLocation(latitude: station1.coordinates.latitude,
                                   longitude: station1.coordinates.longitude)
    let station2Coord = CLLocation(latitude: station2.coordinates.latitude,
                                   longitude: station2.coordinates.longitude)
    return station1Coord.distance(from: pointToCompare) < station2Coord.distance(from: pointToCompare)
  }

}

// MARK: - LocationManagerDelegate

extension StationsListViewViewModel: LocationManagerDelegate {

  func didGet(city: String?) {
    self.currentCity = city?.lowercased()
    self.navigationTitle = city?.capitalized
    getStations(for: currentCity)
  }

  func didFailGettingLocation(_ error: Error) {
    self.isLoading = false
  }
}
