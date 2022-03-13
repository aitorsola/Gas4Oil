//
//  Landing.swift
//  Gas4Oil
//
//  Created by Aitor Sola on 3/3/22.
//

import SwiftUI

struct LandingView: View {

  @StateObject private var viewModel: LandingViewModel = LandingViewModel()

  var body: some View {
    if viewModel.isGettingLocation {
      ProgressView(title: "common.loading".translated)
    } else {
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
        }.opacity(viewModel.showLocationDisabledButton ? 0 : 1)
        Gas4OilButton(title: "landingView.button.locationDenied".translated, image: nil) {
        #if os(iOS)
          UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
        #endif
        }.opacity(viewModel.showLocationDisabledButton ? 1 : 0)
        #if os(iOS)
          .font(.customSize(15))
        #endif
        Spacer()
      }
      #if os(iOS)
      .fullScreenCover(isPresented: $viewModel.shouldShowList) {
        MainTabView()
      }
      #else
      .sheet(isPresented: $viewModel.shouldShowList) {
        MainTabView()
      }
      #endif
    }
  }
}

struct Landing_Previews: PreviewProvider {
  static var previews: some View {
    LandingView()
      .preferredColorScheme(.dark)
  }
}
