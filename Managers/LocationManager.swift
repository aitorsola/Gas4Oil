//
//  LocationManager.swift
//  Test
//
//  Created by Aitor Sola on 22/2/22.
//

import CoreLocation

enum MeasurementUnit {
    case metters(Double)
    case km(Double)
}

@objc protocol LocationManagerDelegate: AnyObject {
    @objc optional func didGet(auth: CLAuthorizationStatus)
    @objc optional func didGet(city: String?)
    func didFailGettingLocation(_ error: Error)
}

protocol LocationManager {
    func requestAuth()
    var currentAuth: CLAuthorizationStatus { get }
    var delegate: LocationManagerDelegate? { get set }
    var currentCoordinates: CLLocation? { get set }
    var currentCity: String? { get set }
}

class Location: NSObject, LocationManager {
    
    private let manager: CLLocationManager = .init()
    
    weak var delegate: LocationManagerDelegate?
    
    var currentCoordinates: CLLocation?
    var currentCity: String?
    var currentAuth: CLAuthorizationStatus {
        manager.authorizationStatus
    }
    
    override init() {
        super.init()
        manager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        manager.delegate = self
    }
    
    func requestAuth() {
        if case .notDetermined  = manager.authorizationStatus {
            manager.requestWhenInUseAuthorization()
        } else {
            manager.startUpdatingLocation()
        }
    }
    
    func getCityNameFor(_ coordinate: CLLocation, completion: @escaping (CLPlacemark?) -> Void) {
        let geoCoder = CLGeocoder()
        geoCoder.reverseGeocodeLocation(coordinate) { placemarks, error in
            completion(placemarks?.first)
        }
    }
    
    static func distanceFromPoint(_ point: CLLocation) -> MeasurementUnit? {
        guard let currentPoint = Managers.location.currentCoordinates else {
            return nil
        }
        let distanceInMeters = point.distance(from: currentPoint)
        let squareKm = Measurement(value: distanceInMeters, unit: UnitArea.squareKilometers)
        let squareMetters = squareKm.converted(to: .squareKilometers)
        
        if squareKm.value < 1000 {
            return .metters(squareMetters.value.round(to: 0))
        } else {
            return .km(squareKm.value.round(to: 2))
        }
    }
}

extension Location: CLLocationManagerDelegate {
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        delegate?.didGet?(auth: manager.authorizationStatus)
        switch manager.authorizationStatus {
        case .authorizedWhenInUse, .authorizedAlways:
            manager.startUpdatingLocation()
        default:
            break
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else {
            return
        }
        currentCoordinates = location
        getCityNameFor(location) { placemark in
            self.manager.stopUpdatingLocation()
            self.currentCity = placemark?.locality
            self.delegate?.didGet?(city: placemark?.locality)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        delegate?.didFailGettingLocation(error)
    }
}
