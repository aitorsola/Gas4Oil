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

#if os(iOS)
  @EnvironmentObject var appDelegate: AppDelegate
#endif

  var body: some View {
    VStack {

      TabView(selection: $tabSelected) {

        StationsListView(viewModel: viewModel.listViewViewModel)
          .tag(TabSelectedType.stations.rawValue)
          .tabItem {
            VStack {
              Image(systemName: "fuelpump.fill")
#if os(macOS)
              Text("mainTab.stationsTabTitle".translated)
#endif
            }
          }

        VehicleView()
          .tag(TabSelectedType.vehicle.rawValue)
          .tabItem {
            VStack {
              Image(systemName: "car.fill")
#if os(macOS)
              Text("mainTab.vehicle".translated)
#endif
            }
          }
#if os(macOS)
          .frame(width: 500)
#endif

        FavoriteListView(viewModel: viewModel.favoriteViewViewModel)
          .tag(TabSelectedType.favorite.rawValue)
          .tabItem {
            VStack {
              Image(systemName: "star.fill")
#if os(macOS)
              Text("mainTab.favTabTitle".translated)
#endif
            }
          }
          .onReceive(viewModel.listViewViewModel.$favorites, perform: { stations in
            viewModel.favoriteViewViewModel.updateFavoriteStations(allStations: stations)
          })

      }
      .padding(.top, 10)
      .font(.headline)
    }
#if os(iOS)
    .ignoresSafeArea()
#endif
  }
}

struct MainTabView_Previews: PreviewProvider {
  static var previews: some View {
    MainTabView()
  }
}
