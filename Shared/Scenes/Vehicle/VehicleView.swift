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
          TextField("brand",
                    text: $viewModel.vehicleData.brand,
                    prompt: Text("myVehicle.brand.placeholder".translated))
          .keyboardType(.asciiCapable)
          .disableAutocorrection(true)
        }
        .padding(10)
        HStack(spacing: 10) {
          Image("icn_car_model")
            .resizable()
            .frame(width: 30, height: 30)
            .clipped()
          TextField("model",
                    text: $viewModel.vehicleData.model,
                    prompt: Text("myVehicle.model.placeholder".translated))
          .keyboardType(.asciiCapable)
          .disableAutocorrection(true)
        }
        .padding(10)
        HStack(spacing: 10) {
          Image("icn_fuel_can")
            .resizable()
            .frame(width: 30, height: 30)
            .clipped()
          TextField("capacity",
                    text: $viewModel.vehicleData.capacity,
                    prompt: Text("myVehicle.capacity.placeholder".translated))
          .keyboardType(.numberPad)
          .disableAutocorrection(true)
        }
        Picker("FuelType", selection: $viewModel.vehicleData.fuel, content: {
          ForEach(viewModel.allFuelTypes, id: \.self) { item in
            switch item {
            case .gas95:
              Text("fuel.95".translated).tag(FuelType.gas95)
            case .gas98:
              Text("fuel.98".translated).tag(FuelType.gas98)
            case .diesel:
              Text("fuel.diesel".translated).tag(FuelType.diesel)
            }
          }
        })
        .padding(10)
        HStack {
          Gas4OilButton(title: "Save", image: nil, isDisabled: false) {
            viewModel.saveVehicleData()
          }
          Gas4OilButton(title: "Remove vehicle", image: nil, isDisabled: viewModel.vehicleData.isEmpty()) {
            viewModel.removeVehicle()
          }
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
