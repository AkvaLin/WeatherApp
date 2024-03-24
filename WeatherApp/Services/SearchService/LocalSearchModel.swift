//
//  LocalSearchModel.swift
//  WeatherApp
//
//  Created by Никита Пивоваров on 24.03.2024.
//

import MapKit

struct LocalSearchModel {
    
    enum State {
        case current
        case search
    }
    
    var title: String
    var subtitle: String
    var lat: Double
    var lon: Double
    var state: State
    
    init(mapItem: MKMapItem) {
        self.title = mapItem.name ?? ""
        self.subtitle = mapItem.placemark.country ?? ""
        self.lat = mapItem.placemark.coordinate.latitude
        self.lon = mapItem.placemark.coordinate.longitude
        self.state = .search
    }
    
    init(title: String) {
        self.title = title
        self.subtitle = ""
        self.lat = 0
        self.lon = 0
        self.state = .current
    }
}
