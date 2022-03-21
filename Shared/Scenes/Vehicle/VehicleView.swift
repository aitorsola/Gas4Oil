//
//  VehicleView.swift
//  Gas4Oil
//
//  Created by Aitor Sola on 21/3/22.
//

import Foundation
import SwiftUI

struct VehicleView: View {

  @ObservedObject private var viewModel = VehicleViewViewModel()

  var body: some View {
    NavigationView {
      VStack(spacing: 10) {
        HStack(spacing: 10) {
          Image("icn_brand")
            .resizable()
            .frame(width: 30, height: 30)
            .clipped()
          TextField("brand", text: $viewModel.vehicleData.brand, prompt: Text(viewModel.vehicleData.brand))
            .keyboardType(.asciiCapable)
            .disableAutocorrection(true)
        }
        .padding(10)
        HStack(spacing: 10) {
          Image("icn_car_model")
            .resizable()
            .frame(width: 30, height: 30)
            .clipped()
          TextField("model", text: $viewModel.vehicleData.model, prompt: Text(viewModel.vehicleData.model))
            .keyboardType(.asciiCapable)
            .disableAutocorrection(true)
        }
        .padding(10)
        HStack(spacing: 10) {
          Image("icn_fuel_can")
            .resizable()
            .frame(width: 30, height: 30)
            .clipped()
          TextField("capacity", text: $viewModel.vehicleData.capacity, prompt: Text(viewModel.vehicleData.capacity + " l."))
            .keyboardType(.numberPad)
            .disableAutocorrection(true)
        }
        .padding(10)
        Gas4OilButton(title: "Save", image: nil) {
          viewModel.saveVehicleData()
        }
          .padding(20)
        Spacer()
      }.navigationTitle("My vehicle")
        .alert("Saved successfully", isPresented: $viewModel.showSuccessAlert) {
          VStack {
            Button("Ok") {
              print("action1")
            }
          }
        }
    }
    .onAppear {
      viewModel.getVehicleData()
    }
  }
}

struct VehicleView_Previews: PreviewProvider {
  static var previews: some View {
    VehicleView()
      .preferredColorScheme(.dark)
  }
}
