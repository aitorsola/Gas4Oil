//
//  StationView.swift
//  Gas4Oil
//
//  Created by Aitor Sola on 6/3/22.
//

import SwiftUI
import CoreLocation

extension Formatter {
  static let withSeparator: NumberFormatter = {
    let formatter = NumberFormatter()
    formatter.numberStyle = .decimal
    formatter.groupingSeparator = " "
    return formatter
  }()
}

struct StationView: View {

  let price95: String
  let price98: String
  let priceDiesel: String
  let brand: String
  let address: String
  let schedule: String
  let coordinates: CLLocation
  let showFavButton: Bool

  @State var isFav: Bool
  @State var makeBig: Bool = false

  var favCompletion: (() -> Void)?

  var body: some View {
    VStack(alignment: .leading, spacing: 10) {
      HStack {
        VStack(spacing: 2) {
          Text("95E5")
            .font(.customSize(20, weight: .bold))
            .foregroundColor(.green)
          Text(price95.isEmpty ? "--" : price95 + " €")
            .foregroundColor(.orange)
            .font(.customSize(25, weight: .bold))
        }
        Spacer()
        VStack(spacing: 2) {
          Text("Diesel")
            .font(.customSize(20, weight: .bold))
            .foregroundColor(Color.init(uiColor: .darkGray))
          Text(priceDiesel.isEmpty ? "--" : priceDiesel + " €")
            .foregroundColor(.orange)
            .font(.customSize(25, weight: .bold))
        }
        Spacer()
        VStack(spacing: 2) {
          Text("98E5")
            .font(.customSize(20, weight: .bold))
            .foregroundColor(.red)
          Text(price98.isEmpty ? "--" : price98 + " €")
            .foregroundColor(.orange)
            .font(.customSize(25, weight: .bold))
        }
      }
      getDistanceLabel()
        .padding(.top, 15)
        .padding(.bottom, 15)
      Text(brand.capitalized)
        .font(.customSize(20, weight: .bold))
      Spacer()
      Text(address.capitalized)
      Spacer()
      HStack(alignment: .bottom) {
        Text("station.schedule".translated + ": " + schedule.capitalized)
        Spacer()
        if showFavButton {
          Image(systemName: isFav ? "star.fill" : "star")
            .foregroundColor(.orange)
            .scaleEffect(makeBig ? 2 : 1)
            .onTapGesture {
              withAnimation(.easeInOut(duration: 0.2)) {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                  withAnimation(.easeInOut(duration: 0.2)) {
                    makeBig.toggle()
                  }
                }
                makeBig.toggle()
                isFav.toggle()
              }
              favCompletion?()
            }
        }
      }
    }
    .padding(.top, 15)
    .padding(.bottom, 15)
  }
}

extension StationView {
  
  private func getDistanceLabel() -> some View {
    HStack(spacing: 5) {
      Image(systemName: "location.fill")
        .foregroundColor(.orange)
      switch Location.distanceFromPoint(coordinates) {
      case .km(let value):
        let value = "\((value / 1000).round(to: 1).toString()) km."
        Text(value)
          .foregroundColor(.orange)
          .font(.customSize(15, weight: .bold))
      case .metters(let value):
        let value = "\(value.toString()) m."
        Text(value)
          .foregroundColor(.orange)
          .font(.customSize(15, weight: .bold))
      case .none:
        EmptyView()
      }
    }
  }
}

struct StationView_Previews: PreviewProvider {
  static var previews: some View {
    StationView(price95: "1,966",
                price98: "2,065",
                priceDiesel: "1,964",
                brand: "Ballenoil",
                address: "Dirección",
                schedule: "Horario",
                coordinates: CLLocation(latitude: 40.42500000, longitude: -3.68300000),
                showFavButton: true,
                isFav: false)
    .frame(height: 100, alignment: .center)
    .preferredColorScheme(.dark)
  }
}
