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
    
    // TODO: Geocoder
    
    // TODO: LocalSearch
}

extension LocationManager: CLLocationManagerDelegate {
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        updateCurrentLocation()
    }
}
