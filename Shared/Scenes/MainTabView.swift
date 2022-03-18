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
  @State private var showAlert: Bool = false

  @ObservedObject var viewModel = MainTabViewViewModel()

  var body: some View {
    VStack {

//      Image(systemName: "fuelpump.fill")
//        .resizable()
//        .frame(width: 30, height: 30)
//        .aspectRatio(contentMode: .fit)
//        .clipped()
//      #if os(macOS)
//        .padding(.top, 20)
//      #endif
//        .onTapGesture {
//          showAlert = true
//        }

      TabView(selection: $tabSelected) {

        StationsListView(viewModel: viewModel.listViewViewModel)
          .tag(TabSelectedType.stations.rawValue)
          .tabItem {
            VStack {
              Image(systemName: "fuelpump.fill")
              Text("mainTab.stationsTabTitle".translated)
            }
          }

        FavoriteListView(viewModel: viewModel.favoriteViewViewModel)
          .tag(TabSelectedType.favorite.rawValue)
          .tabItem {
            VStack {
              Image(systemName: "star.fill")
              Text("mainTab.favTabTitle".translated)
            }
          }
          .onReceive(viewModel.listViewViewModel.$favorites, perform: { stations in
            viewModel.favoriteViewViewModel.updateFavoriteStations(allStations: stations)
          })

      }
      .padding(.top, 10)
      .font(.headline)
    }
    .alert("Developed by Aitor Sola using SwiftUI", isPresented: $showAlert) {
      Button("Thanks") { }
    } message: { }
  }
}

struct MainTabView_Previews: PreviewProvider {
  static var previews: some View {
    MainTabView()
  }
}
