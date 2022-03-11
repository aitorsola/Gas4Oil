//
//  LandingViewModel.swift
//  Gas4Oil
//
//  Created by Aitor Sola on 3/3/22.
//

import Foundation
import CoreLocation

class LandingViewModel: ObservableObject {

  // MARK: - Properties
  
  private var locationManager: LocationManager
  private var servicesStationsAPI: ServiceStationsAPI
  private var allStations: [Station] = []

  @Published var stations: [Station] = []
  @Published var isGettingLocation: Bool = false
  @Published var shouldShowList: Bool = false
  @Published var navigationTitle: String?
  @Published var showLocationDisabledButton: Bool = false

  // MARK: - Lifecycle

  init(locationManager: LocationManager = Managers.location, servicesAPI: ServiceStationsAPI = Network()) {
    self.locationManager = locationManager
    self.servicesStationsAPI = servicesAPI
    setupLocationManager()
  }

  // MARK: - Public

  func requestLocation() {
    isGettingLocation = true
    locationManager.requestAuth()
  }

  // MARK: - Private

  private func setupLocationManager() {
    locationManager.delegate = self
  }
}

// MARK: - LocationManagerDelegate

extension LandingViewModel: LocationManagerDelegate {

  func didGet(auth: CLAuthorizationStatus) {
    self.isGettingLocation = false
    if case .authorizedWhenInUse = auth {
      self.shouldShowList = true
    } else if case .denied = auth {
      showLocationDisabledButton = true
    }
  }

  func didFailGettingLocation(_ error: Error) {
    self.isGettingLocation = false
  }
}
