//
//  StationsListView.swift
//  Gas4Oil
//
//  Created by Aitor Sola on 6/3/22.
//

import SwiftUI
import MapKit

enum SortType {
  case near95
  case near98
  case nearDiesel
  case price95Down
  case price95Up
  case price98Down
  case price98Up
  case priceDieselDown
  case priceDieselUp
}

enum FuelBrandSortType: Hashable {
  case all
  case brand(String)
}

struct StationsListView: View {

  @StateObject var viewModel: StationsListViewViewModel

  @State private var sortType: SortType = .near95
  @State private var sortBrand: FuelBrandSortType = .all
  @State private var queryString: String = ""

  @FocusState private var focused: Bool

  var body: some View {
    if !viewModel.locationAllowed {
      VStack(spacing: 10) {
        Spacer()
        HStack {
          Image("icn_main_logo", bundle: nil)
            .resizable()
            .scaledToFit()
            .frame(width: 40, height: 40, alignment: .center)
            .clipped()
          Text("Gas4Oil").font(.customSize(50))
        }
        Text("landingView.title.discover".translated)
          .font(.customSize(20)).multilineTextAlignment(.center)
        Spacer()
        Gas4OilButton(title: "landingView.button.requestLocationPermission".translated, image: nil) {
          self.viewModel.requestLocation()
        }
        Spacer()
      }
    } else if viewModel.isLoading {
#if os(iOS)
      LottieView(name: "location", loopMode: .loop)
        .frame(width: 100, height: 100)
#else
      ProgressView(title: "common.gettingLocation".translated)
#endif
    } else {
      NavigationView {
        VStack(spacing: 15) {
          List(viewModel.stations) { station in
            createNavigationLink(station)
          }
          .navigationTitle(viewModel.navigationTitle ?? "")
#if os(iOS)
          .navigationBarTitleDisplayMode(.automatic)
#endif
          .searchable(text: $queryString, placement: .automatic, prompt: Text("listView.search.placeholder")) {
            ForEach(viewModel.searchResults(text: queryString.lowercased()), id: \.self) { province in
              Text(province.capitalized)
                .searchCompletion(province.capitalized)
            }
          }
          .onSubmit(of: .search) {
            focused = false
            viewModel.showFuelByCity(queryString)
          }
#if os(macOS)
          .listStyle(.sidebar)
#elseif os(iOS)
          .listStyle(.plain)
#endif

          HStack {
            Spacer()
            Picker("Brand", selection: $sortBrand) {
              Label("All", systemImage: "fuelpump.fill").tag(FuelBrandSortType.all)
              Divider()
              ForEach(viewModel.allBrands, id: \.self) { brand in
                Label(brand.rawValue.uppercased(), systemImage: "")
                  .tag(FuelBrandSortType.brand(brand.rawValue))
              }
            }.onChange(of: sortBrand) { newValue in
              viewModel.showByBrand(newValue)
            }
            Spacer()
            Picker("Sort", selection: $sortType) {
              Group {
                Label("listView.sortType.near95.button".translated, systemImage: "location.fill")
                  .tag(SortType.near95)
                Label("listView.sortType.down95.button".translated, systemImage: "arrow.down")
                  .tag(SortType.price95Down)
                Label("listView.sortType.up95.button".translated, systemImage: "arrow.up")
                  .tag(SortType.price95Up)
              }
              Divider()
              Group {
                Label("listView.sortType.nearDiesel.button".translated, systemImage: "location.fill")
                  .tag(SortType.near98)
                Label("listView.sortType.downDiesel.button".translated, systemImage: "arrow.down")
                  .tag(SortType.priceDieselDown)
                Label("listView.sortType.upDiesel.button".translated, systemImage: "arrow.up")
                  .tag(SortType.priceDieselUp)
              }
              Divider()
              Group {
                Label("listView.sortType.near98.button".translated, systemImage: "location.fill")
                  .tag(SortType.nearDiesel)
                Label("listView.sortType.down98.button".translated, systemImage: "arrow.down")
                  .tag(SortType.price98Down)
                Label("listView.sortType.up98.button".translated, systemImage: "arrow.up")
                  .tag(SortType.price98Up)
              }
            }
            .pickerStyle(.menu)
            .onChange(of: sortType) { value in
              viewModel.showFuelSorted(value)
            }
            Spacer()
          }

          Gas4OilButton(title: "listView.button.requestLocation".translated, image: Image(systemName: "location")) {
            self.sortBrand = .all
            self.sortType = .near95
            viewModel.requestLocation()
          }
          .padding(.bottom, 10)
#if os(macOS)
          .frame(minWidth: 350, idealWidth: 350, maxWidth: 350)
          .ignoresSafeArea()
#endif
        }
      }
    }
  }

  func createNavigationLink(_ station: Station) -> some View {
    NavigationLink(destination: {
      MapView(station: station)
    }, label: {
      getStationView(station)
    })
  }
}

#if canImport(UIKit)
extension View {
  func hideKeyboard() {
    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
  }
}
#endif

extension StationsListView {

  private func getStationView(_ station: Station) -> StationView {
    StationView(price95: station.gasolina95E5,
                price98: station.gasolina98E5,
                priceDiesel: station.gasoleoA,
                brand: station.rotulo,
                address: station.direccion,
                schedule: station.horario,
                coordinates: station.getCLLocationCoordinates(),
                showFavButton: true,
                isFav: station.isFav) {
      viewModel.favoriteStationTapAction(station)
    }
  }
}

struct StationsListView_Previews: PreviewProvider {
  static var previews: some View {
    StationsListView(viewModel: StationsListViewViewModel())
      .preferredColorScheme(.dark)
  }
}
