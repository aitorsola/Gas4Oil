//
//  VehicleView.swift
//  Gas4Oil
//
//  Created by Aitor Sola on 21/3/22.
//

import Foundation
import Combine
import SwiftUI

struct VehicleView: View {

  @StateObject private var viewModel = VehicleViewViewModel()
  @State private var selectedBrandIndex: Int = 0
  @State private var selectedModelIndex: Int = 0

  @FocusState var brandFocused: Bool
  @FocusState var capacityFocused: Bool
  @FocusState var modelFocused: Bool

  var body: some View {
    ScrollView {
      Text("myVehicle.brand.title".translated)
        .font(.customSize(35, weight: .bold, design: .default))
        .padding(.bottom, 30)
        .padding(.top, 30)
        .frame(maxWidth: .infinity, alignment: .leading)

      VStack(alignment: .leading) {
        HStack {
        Text("Brand")
        Picker(selection: $selectedBrandIndex, label: Text("")) {
          ForEach(0 ..< viewModel.allBrands.count, id: \.self) {
            Text(self.viewModel.allBrands[$0].brand)
          }
        }
        .onChange(of: selectedBrandIndex, perform: { index in
          viewModel.getModelsForBrandIndex(index)
        })
      }
        .padding(.bottom, 20)
        HStack {
        Text("Model")
        Picker(selection: $selectedModelIndex, label: Text("")) {
          ForEach(0 ..< viewModel.allModelsForBrand.count, id: \.self) {
            Text(self.viewModel.allModelsForBrand[$0].model)
          }
        }
        .onChange(of: selectedModelIndex, perform: { index in
          print(index)
        })
      }
        .padding(.bottom, 20)
        HStack {
        Text("Combustible")
        Picker("common.fuelType".translated, selection: $viewModel.vehicleData.fuel, content: {
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
      }
        .padding(.bottom, 20)
      }
      .frame(maxWidth: .infinity, alignment: .leading)

      HStack {
        Gas4OilButton(title: "myVehicle.save".translated, image: nil, isDisabled: false) {
          unfocusAllResponders()
          viewModel.saveVehicleData()
        }
        Gas4OilButton(title: "myVehicle.remove".translated, image: nil, isDisabled: viewModel.vehicleData.isEmpty()) {
          viewModel.removeVehicle()
        }
      }
      .padding(20)
    }
    .frame(maxWidth: .infinity, alignment: .leading)
    .padding()
    .alert("myVehicle.saved.message".translated, isPresented: $viewModel.showSuccessAlert) {
      VStack {
        Button("Ok") {
          print("action1")
        }
      }
    }
    .onAppear {
      viewModel.getVehicleData()
      viewModel.getAllBrands()
    }
    .onTapGesture {
      unfocusAllResponders()
    }
  }

  // MARK: - Private

  private func unfocusAllResponders() {
    capacityFocused = false
    brandFocused = false
    modelFocused = false
  }
}

struct VehicleView_Previews: PreviewProvider {
  static var previews: some View {
    VehicleView()
      .preferredColorScheme(.dark)
  }
}
