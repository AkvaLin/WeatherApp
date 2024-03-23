//
//  LocationManager.swift
//  WeatherApp
//
//  Created by Никита Пивоваров on 21.03.2024.
//

import Foundation
import CoreLocation

final class LocationManager: NSObject {
    
    private let manager = CLLocationManager()
    private let geoCoder = CLGeocoder()
    private(set) var lat: CLLocationDegrees?
    private(set) var lon: CLLocationDegrees?
    
    public func updateCurrentLocation() {
        if manager.authorizationStatus == .authorizedWhenInUse {
            guard let coordinate = manager.location?.coordinate else { return }
            lat = coordinate.latitude
            lon = coordinate.longitude
        }
    }
    
    public func requestAuthorization() {
        manager.delegate = self
        if manager.authorizationStatus != .authorizedWhenInUse {
            manager.requestWhenInUseAuthorization()
        }
    }

    public func updateGeocode(completion: @escaping ((city: String?, area: String?, country: String?)) -> Void) {
        guard let lat = lat, let lon = lon else { 
            completion((nil, nil, nil))
            return
        }
        geoCoder.reverseGeocodeLocation(CLLocation(latitude: lat, longitude: lon)) { placemark, error in
            guard let placemark = placemark?.first else {
                completion((nil, nil, nil))
                return
            }
            if let country = placemark.country {
                if let city = placemark.locality {
                    completion((city, nil, country))
                } else if let area = placemark.administrativeArea {
                    completion((nil, area, country))
                }
            } else {
                completion((nil, nil, nil))
            }
        }
    }
    
    // TODO: LocalSearch
}

extension LocationManager: CLLocationManagerDelegate {
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        updateCurrentLocation()
    }
}
