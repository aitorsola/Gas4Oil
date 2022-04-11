//
//  VehicleView.swift
//  Gas4Oil
//
//  Created by Aitor Sola on 21/3/22.
//

import Foundation
import Combine
import SwiftUI
#if canImport(UIKit)
import Lottie
#endif

struct VehicleView: View {

  @State private var showAdView: Bool = true
  @State var showRemoveVehicleAlert: Bool = false
  @State private var offsetHeight: CGSize = .init(width: 0, height: 2000)
  @State var kOffsetHeightWhenShow = 200.0
  @State var kOffsetHeightWhenHidden = 2000.0

  @StateObject private var viewModel = VehicleViewViewModel()

  @FocusState var capacityFocused: Bool

  var body: some View {
    if viewModel.loading {
#if os(iOS)
      LottieView(name: "loading", loopMode: .loop)
#else
      ProgressView(title: "common.loading".translated)
#endif
    } else {
      ZStack {
        ScrollView {
          Text("myVehicle.brand.title".translated)
            .font(.customSize(35, weight: .bold, design: .default))
            .padding(.bottom, 30)
            .padding(.top, 30)
            .frame(maxWidth: .infinity, alignment: .leading)

          VStack(alignment: .leading) {
            HStack(spacing: 20) {
              Image("icn_brand").resizable().clipped().frame(width: 30, height: 30).scaledToFit()
              Picker(selection: $viewModel.selectedBrandIndex, label: Text("")) {
                ForEach(0..<viewModel.allBrands.count, id: \.self) {
                  Text(self.viewModel.allBrands[$0].brand)
                }
              }
              .onChange(of: viewModel.selectedBrandIndex, perform: { index in
                viewModel.selectedModelIndex = 0
                viewModel.selectedBrand = viewModel.allBrands[index]
                viewModel.getModelsForBrandIndex(index)
              })
            }
            .padding(.bottom, 20)
            HStack(spacing: 20) {
              Image("icn_car_model").resizable().clipped().frame(width: 30, height: 30).scaledToFit()
              Picker(selection: $viewModel.selectedModelIndex, label: Text("")) {
                ForEach(0..<viewModel.allModelsForBrand.count, id: \.self) {
                  Text(self.viewModel.allModelsForBrand[$0].model)
                }
              }
              .onChange(of: viewModel.selectedModelIndex, perform: { index in
                viewModel.selectedModel = viewModel.allModelsForBrand[index]
              })
            }
            .padding(.bottom, 20)
            HStack(spacing: 20) {
              Image("icn_fuel_can").resizable().clipped().frame(width: 30, height: 30).scaledToFit()
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

            HStack(spacing: 20) {
              Image("icn_capacity").resizable().clipped().frame(width: 30, height: 30).scaledToFit()
              TextField("",
                        text: $viewModel.vehicleData.capacity,
                        prompt: Text("myVehicle.capacity.placeholder".translated))
#if os(iOS)
              .keyboardType(.numberPad)
#endif
              .focused($capacityFocused)
            }
          }
          .frame(maxWidth: .infinity, alignment: .leading)

          HStack {
            Gas4OilButton(title: "myVehicle.save".translated, image: nil, isDisabled: false) {
              unfocusAllResponders()
              viewModel.saveVehicleData(brandIndex: viewModel.selectedBrandIndex,
                                        modelIndex: viewModel.selectedModelIndex,
                                        capacity: viewModel.vehicleData.capacity)
            }
            Gas4OilButton(title: "myVehicle.remove".translated,
                          image: nil,
                          isDisabled: viewModel.vehicleData.isEmpty()) {
              showRemoveVehicleAlert = true
            }
          }
          .padding(20)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .alert("myVehicle.saved.message".translated, isPresented: $viewModel.showSuccessAlert) {
          Button("Ok") { }
        }
        .onTapGesture {
          withAnimation(.spring()) {
            offsetHeight.height = kOffsetHeightWhenHidden
          }
          unfocusAllResponders()
        }
        .alert("myVehicle.remove.alert.title".translated, isPresented: $showRemoveVehicleAlert) {
          Button("myVehicle.remove".translated, role: .destructive) {
            viewModel.removeVehicle()
          }
          Button("common.cancel", role: .cancel) { }
        }

        draggableView()

        #if os(iOS)
          .cornerRadius(30, corners: .allCorners)
        #endif
      }
      .onAppear {
        if showAdView {
          withAnimation(.spring()) {
            self.showAdView = false
            offsetHeight.height = viewModel.vehicleData.isEmpty() ? kOffsetHeightWhenShow : kOffsetHeightWhenHidden
          }
        }
      }
    }
  }

  // MARK: - Private

  private func unfocusAllResponders() {
    capacityFocused = false
  }

  fileprivate func draggableView() -> some View {
    AdView(title: "myVehicle.ad.title".translated,
           descr: "myVehicle.ad.description".translated,
           buttonTitle: "OK",
           image: "icn_car") { withAnimation(.spring()) { offsetHeight.height = kOffsetHeightWhenHidden }}
      .offset(CGSize(width: 0, height: offsetHeight.height))
      .gesture(
        DragGesture()
          .onChanged { value in
            let height = value.translation.height
            self.offsetHeight.height = height < 0 ? value.translation.height * 0.2 + kOffsetHeightWhenShow : height + kOffsetHeightWhenShow
          }
          .onEnded { value in
            withAnimation(.spring()) {
              offsetHeight.height = value.translation.height > kOffsetHeightWhenShow ? kOffsetHeightWhenHidden : kOffsetHeightWhenShow
            }
          }
      )
  }
}

struct VehicleView_Previews: PreviewProvider {
  static var previews: some View {
    VehicleView()
      .preferredColorScheme(.dark)
  }
}
