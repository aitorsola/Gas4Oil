//
//  MainTabView.swift
//  Gas4Oil
//
//  Created by Aitor Sola on 9/3/22.
//

import SwiftUI

private enum TabSelectedType: Int {
  case stations
  case favorite
}

struct MainTabView: View {

  @State private var tabSelected: Int = TabSelectedType.stations.rawValue
  @State private var canShowFavorites: Bool = false

  @ObservedObject var viewModel = MainTabViewViewModel()

  var body: some View {
    TabView(selection: $tabSelected) {
      
      StationsListView(viewModel: viewModel.listViewViewModel)
        .tag(TabSelectedType.stations.rawValue)
        .tabItem {
          VStack {
            Image(systemName: "fuelpump.fill").renderingMode(.original)
            Text("mainTab.stationsTabTitle".translated)
          }
        }
      
      FavoriteListView(viewModel.favoriteViewViewModel)
        .tag(TabSelectedType.favorite.rawValue)
        .tabItem {
          VStack {
            Image(systemName: tabSelected == TabSelectedType.stations.rawValue ? "star" : "star.fill").renderingMode(.original)
            Text("mainTab.favTabTitle".translated)
          }
        }
        .onReceive(viewModel.listViewViewModel.$stations, perform: { stations in
          viewModel.favoriteViewViewModel.getFavoriteStations(allStations: stations)
        })
    }
    .font(.headline)
    .accentColor(.white)
  }
}

struct MainTabView_Previews: PreviewProvider {
  static var previews: some View {
    MainTabView()
  }
}
