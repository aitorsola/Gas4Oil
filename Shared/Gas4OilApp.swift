//
//  Gas4OilApp.swift
//  Shared
//
//  Created by Aitor Sola on 3/3/22.
//

import SwiftUI

@main
struct Gas4OilApp: App {

  var body: some Scene {
    WindowGroup {
      let locationManager = Managers.location
      switch locationManager.currentAuth {
      case .authorizedAlways, .authorizedWhenInUse:
        if Device.isiOS {
          MainTabView()
        } else {
          MainTabView()
            .frame(minWidth: 800, maxWidth: .infinity, minHeight: 500, maxHeight: .infinity, alignment: .center)
        }
      case .denied, .notDetermined, .restricted:
        if Device.isiOS {
          LandingView()
        } else {
          LandingView()
            .frame(minWidth: 800, maxWidth: .infinity, minHeight: 500, maxHeight: .infinity, alignment: .center)
        }
      @unknown default:
        EmptyView()
      }
    }
  }
}
