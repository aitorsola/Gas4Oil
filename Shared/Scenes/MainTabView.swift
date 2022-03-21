//
//  MainTabView.swift
//  Gas4Oil
//
//  Created by Aitor Sola on 9/3/22.
//

import SwiftUI

private enum TabSelectedType: Int {
  case stations
  case vehicle
  case favorite
}

struct MainTabView: View {

  @State private var tabSelected: Int = TabSelectedType.stations.rawValue
  @State private var canShowFavorites: Bool = false
  @State private var showAlert: Bool = false

  @ObservedObject var viewModel = MainTabViewViewModel()

  var body: some View {
    VStack {

      TabView(selection: $tabSelected) {

        StationsListView(viewModel: viewModel.listViewViewModel)
          .tag(TabSelectedType.stations.rawValue)
          .tabItem {
            VStack {
              Image(systemName: "fuelpump.fill")
//              Text("mainTab.stationsTabTitle".translated)
            }
          }

        VehicleView()
          .tag(TabSelectedType.vehicle.rawValue)
          .tabItem {
            VStack {
              Image(systemName: "car.fill")
//              Text("mainTab.vehicle".translated)
            }
          }

        FavoriteListView(viewModel: viewModel.favoriteViewViewModel)
          .tag(TabSelectedType.favorite.rawValue)
          .tabItem {
            VStack {
              Image(systemName: "star.fill")
//              Text("mainTab.favTabTitle".translated)
            }
          }
          .onReceive(viewModel.listViewViewModel.$favorites, perform: { stations in
            viewModel.favoriteViewViewModel.updateFavoriteStations(allStations: stations)
          })

      }
      .padding(.top, 10)
      .font(.headline)
    }
    .ignoresSafeArea()
  }
}

struct MainTabView_Previews: PreviewProvider {
  static var previews: some View {
    MainTabView()
  }
}
