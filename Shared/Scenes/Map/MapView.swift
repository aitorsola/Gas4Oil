//
//  MapView.swift
//  Gas4Oil
//
//  Created by Aitor Sola on 7/3/22.
//

import MapKit
import SwiftUI

struct MapView: View {

  @StateObject var viewModel: MapViewViewModel = MapViewViewModel()
  @Binding var station: Station

  var body: some View {
    let coordinateRegion = MKCoordinateRegion(center: station.coordinates, span: .init(latitudeDelta: 0.01, longitudeDelta: 0.01))
    Map(coordinateRegion: .constant(coordinateRegion), annotationItems: [station]) { place in
      MapAnnotation(coordinate: CLLocationCoordinate2D(latitude: place.coordinates.latitude,
                                                       longitude: place.coordinates.longitude)) {
        MapPin(title: place.direccion) {
          goToMaps(coordinates: place.coordinates)
        }
        .frame(width: UIScreen.main.bounds.width * 0.9)
      }
    }
    .ignoresSafeArea(.all, edges: .top)
  }
}

extension MapView {

  func goToMaps(coordinates: CLLocationCoordinate2D) {
    let string = "maps://?saddr=&daddr=\(coordinates.latitude),\(coordinates.longitude)"
    guard let url = URL(string: string) else {
      return
    }
    #if os(iOS)
    if UIApplication.shared.canOpenURL(url) {
      UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
    #endif
  }
}

struct MapView_Previews: PreviewProvider {
  static var previews: some View {
    let station = Station(id: 0, cp: "", provincia: "", municipio: "", direccion: "", horario: "", coordinates: CLLocationCoordinate2D(latitude: 0, longitude: 0), gasNaturalComprimido: "", gasNaturalLicuado: "", gasoleoA: "", gasoleoB: "", gasoleoPremium: "", gasolina95E10: "", gasolina95E5: "", gasolina95E5Premium: "", gasolina98E10: "", gasolina98E5: "", hidrogeno: "", rotulo: "", isFav: true)
    MapView(station: .constant(station))
  }
}
