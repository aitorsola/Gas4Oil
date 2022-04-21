//
//  FakeView.swift
//  Gas4Oil
//
//  Created by Aitor Sola on 21/4/22.
//

import SwiftUI
import Shimmer

struct FakeView: View {
  var body: some View {
    VStack(alignment: .leading, spacing: 10) {
      HStack {
        VStack(spacing: 10) {
          Text("95E5")
            .font(.customSize(20, weight: .bold))
            .foregroundColor(.green)
          Text("Price")
            .foregroundColor(.orange)
            .font(.customSize(20, weight: .medium))
        }.padding(10)
        Spacer()
        VStack(spacing: 10) {
          Text("Diesel")
            .font(.customSize(20, weight: .bold))
            .foregroundColor(Color(.darkGray))
          Text("Price")
            .foregroundColor(.orange)
            .font(.customSize(20, weight: .medium))
        }.padding(10)
        Spacer()
        VStack(spacing: 10) {
          Text("98E5")
            .font(.customSize(20, weight: .bold))
            .foregroundColor(.red)
          Text("Price")
            .foregroundColor(.orange)
            .font(.customSize(20, weight: .medium))
        }.padding(10)
      }
      #if os(iOS)
      .background(Color(uiColor: UIColor.gray.withAlphaComponent(0.15))).cornerRadius(15)
      #endif
      Text("Distancia")
        .padding(.top, 15)
        .padding(.bottom, 15)
      HStack(spacing: 10) {
        Image("icn_main_logo")
          .resizable()
          .scaledToFit()
          .frame(width: 30, height: 30, alignment: .center)
          .cornerRadius(5)
        Text("brand.uppercased()")
      }.font(.customSize(20, weight: .bold))
      Spacer()
      Text("address.capitalized")
      Spacer()
      HStack(spacing: 8) {
        Text("station.fillPrice".translated)
        Text("Precio")
          .foregroundColor(.green)
          .font(.customSize(20, weight: .bold, design: .monospaced))
      }
      Spacer()

      HStack(alignment: .bottom) {
        Text("Horario")
        Spacer()
      }
    }
    .padding(.top, 15)
    .padding(.bottom, 15)
    .redacted(reason: .placeholder)
    .shimmering()
  }
}

struct FakeView_Previews: PreviewProvider {
    static var previews: some View {
      FakeView().frame(height: 300).padding()
    }
}
