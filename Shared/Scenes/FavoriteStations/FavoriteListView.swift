//
//  FavoriteListView.swift
//  Gas4Oil
//
//  Created by Aitor Sola on 11/3/22.
//

import SwiftUI

struct FavoriteListView: View {

  @ObservedObject private var viewModel: FavoriteListViewViewModel

  init(viewModel: FavoriteListViewViewModel) {
    self.viewModel = viewModel
  }

  var body: some View {
    NavigationView {
      if viewModel.favoriteStations.isEmpty {
        Text("No favorite stations")
      } else {
        List(viewModel.favoriteStations) { station in
          ZStack(alignment: .leading) {
            NavigationLink(destination: {
              MapView(station: station)
            }, label: {
              EmptyView()
            }).opacity(0)
            getStationView(station)
          }
        }
        #if os(macOS)
        .frame(minWidth: 350, idealWidth: 350, maxWidth: 350)
        .listStyle(.sidebar)
        #elseif os(iOS)
        .listStyle(.plain)
        #endif
        .navigationTitle("Favorite Stations")
      }
    }
    .onAppear {
      viewModel.getFavorites()
    }
  }
}

extension FavoriteListView {

  private func getStationView(_ station: Station) -> StationView {
    var fillPrice: Double?
    let vehicle = VehicleFavorite.vehicleData
    let formatter = NumberFormatter()
    formatter.locale = Locale.current
    formatter.numberStyle = .decimal
    formatter.decimalSeparator = ","
    formatter.groupingSeparator = ""
    if let vehicle = vehicle {
      switch vehicle.fuel {
      case .gas95:
        let fuelPrice = formatter.number(from: station.gasolina95E5)?.doubleValue ?? 0
        let vehicleCapacity = formatter.number(from: vehicle.capacity)?.doubleValue ?? 0
        fillPrice = (fuelPrice * vehicleCapacity)
      case .gas98:
        let fuelPrice = formatter.number(from: station.gasolina98E5) ?? 0
        let vehicleCapacity = formatter.number(from: vehicle.capacity) ?? 0
        fillPrice = fuelPrice.doubleValue * vehicleCapacity.doubleValue
      case .diesel:
        let fuelPrice = formatter.number(from: station.gasoleoA) ?? 0
        let vehicleCapacity = formatter.number(from: vehicle.capacity) ?? 0
        fillPrice = fuelPrice.doubleValue * vehicleCapacity.doubleValue
      }
    }
    return StationView(price95: station.gasolina95E5,
                price98: station.gasolina98E5,
                priceDiesel: station.gasoleoA,
                brand: station.rotulo,
                address: station.direccion,
                schedule: station.horario,
                coordinates: station.getCLLocationCoordinates(),
                showFavButton: false,
                fillPrice: fillPrice,
                isFav: station.isFav)
  }
}

struct FavoriteListView_Previews: PreviewProvider {
  static var previews: some View {
    FavoriteListView(viewModel: FavoriteListViewViewModel())
  }
}
