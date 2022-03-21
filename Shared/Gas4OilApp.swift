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
//      VehicleView()
      if Device.isiOS {
        MainTabView()
      } else {
        MainTabView()
          .frame(minWidth: 500, maxWidth: .infinity, minHeight: 600, maxHeight: .infinity, alignment: .center)
      }
    }
  }
}
