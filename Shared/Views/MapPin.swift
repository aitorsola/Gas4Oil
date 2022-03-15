//
//  MapPin.swift
//  Gas4Oil
//
//  Created by Aitor Sola on 7/3/22.
//

import SwiftUI
import CoreLocation

struct MapPin: View {

  @Binding var station: Station
  var tapBlock: (() -> Void)?

  var body: some View {
    VStack(spacing: 0) {
      HStack {
        Image(systemName: "mappin.circle")
          .resizable()
          .frame(width: 20, height: 20)
        Text(station.direccion.capitalized).font(.body)
      }
      .padding(12)
      .background(Color(.white))
      .foregroundColor(.black)
      .cornerRadius(8)
      .offset(x: 0, y: -5)

      getStationImage(brand: station.rotulo)
        .resizable()
        .font(.title)
        .scaledToFit()
        .frame(width: 50, height: 50)
        .cornerRadius(10)
        .clipped()
    }
    .onTapGesture {
      tapBlock?()
    }
  }

  // MARK: - Private

  private func getStationImage(brand: String) -> Image {
      let rawBrand = brand
        .lowercased()
        .components(separatedBy: " ").first ?? ""
      let stationBrand = CommonStationBrand(rawValue: rawBrand) ?? .unknown
      let imageName: String
      switch stationBrand {
      case .alcampo:
        imageName = "logo_alcampo"
      case .carrefour:
        imageName = "logo_carrefour"
      case .bonarea:
        imageName = "logo_bonarea"
      case .campsa:
        imageName = "logo_campsa"
      case .petroprix:
        imageName = "logo_petroprix"
      case .eroski:
        imageName = "logo_eroski"
      case .repsol:
        imageName = "logo_repsol"
      case .cepsa:
        imageName = "logo_cepsa"
      case .ballenoil:
        imageName = "logo_ballenoil"
      case .galp:
        imageName = "logo_galp"
      case .bp:
        imageName = "logo_bp"
      case .shell:
        imageName = "logo_shell"
      case .avia:
        imageName = "logo_avia"
      case .petronor:
        imageName = "logo_petronor"
      case .q8:
        imageName = "logo_q8"
      case .unknown:
        return Image(systemName: "nosign")
      }
      return Image(imageName)
    }
}

struct MapPin_Previews: PreviewProvider {
  static var previews: some View {
    MapPin(station: .constant(Station(id: 0, cp: "", provincia: "", municipio: "", direccion: "", horario: "", longitude: 0, latitude: 0, gasNaturalComprimido: "", gasNaturalLicuado: "", gasoleoA: "", gasoleoB: "", gasoleoPremium: "", gasolina95E10: "", gasolina95E5: "", gasolina95E5Premium: "", gasolina98E10: "", gasolina98E5: "", hidrogeno: "", rotulo: "", isFav: false)))
  }
}
