//
//  MapView.swift
//  Gas4Oil
//
//  Created by Aitor Sola on 7/3/22.
//

import MapKit
import SwiftUI

struct MapView: View {

  @State private var station: Station
  @State private var coordinates: MKCoordinateRegion

  init(station: Station) {
    self.station = station
    self.coordinates = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: station.latitude, longitude: station.longitude),
                                          span: .init(latitudeDelta: 0.01, longitudeDelta: 0.01))
  }

  var body: some View {
    Map(coordinateRegion: $coordinates, showsUserLocation: true, annotationItems: [station]) { place in
      MapAnnotation(coordinate: CLLocationCoordinate2D(latitude: place.latitude,
                                                       longitude: place.longitude)) {
        MapPin(station: $station) {
          goToMaps(coordinates: CLLocationCoordinate2D(latitude: place.latitude, longitude: place.longitude))
        }
        #if os(iOS)
        .frame(width: UIScreen.main.bounds.width * 0.9)
        #endif
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
    let station = Station(id: 0, cp: "", provincia: "", municipio: "", direccion: "", horario: "", longitude: 0, latitude: 0, gasNaturalComprimido: "", gasNaturalLicuado: "", gasoleoA: "", gasoleoB: "", gasoleoPremium: "", gasolina95E10: "", gasolina95E5: "", gasolina95E5Premium: "", gasolina98E10: "", gasolina98E5: "", hidrogeno: "", rotulo: "", isFav: true)
    MapView(station: station)
  }
}
