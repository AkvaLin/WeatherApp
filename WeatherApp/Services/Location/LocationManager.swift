//
//  LocationManager.swift
//  WeatherApp
//
//  Created by Никита Пивоваров on 21.03.2024.
//

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
        if manager.authorizationStatus != .authorizedWhenInUse {
            manager.requestWhenInUseAuthorization()
        }
    }

    public func updateGeocode(lat: CLLocationDegrees,
                              lon: CLLocationDegrees,
                              completion: @escaping ((area: String?, country: String?)) -> Void) {
        geoCoder.reverseGeocodeLocation(CLLocation(latitude: lat, longitude: lon)) { placemark, _ in
            guard let placemark = placemark?.first else {
                completion((nil, nil))
                return
            }
            if let country = placemark.country {
                if let city = placemark.locality {
                    completion((city, country))
                } else if let area = placemark.administrativeArea {
                    completion((area, country))
                }
            } else {
                completion((nil, nil))
            }
        }
    }
    
    public func setupDelegate(delegate: CLLocationManagerDelegate) {
        manager.delegate = delegate
    }
}
