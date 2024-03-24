//
//  LocalSearchService.swift
//  WeatherApp
//
//  Created by Никита Пивоваров on 24.03.2024.
//

import MapKit
import Combine

final class LocalSearchService: NSObject, MKLocalSearchCompleterDelegate {

    let localSearchPublisher = PassthroughSubject<[MKMapItem], Never>()
    
    public func request(searchText: String) {
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = searchText
        request.resultTypes = .address
        request.region = MKCoordinateRegion(.world)
        let search = MKLocalSearch(request: request)

        search.start { [weak self] (response, _) in
            guard let response = response else {
                return
            }

            self?.localSearchPublisher.send(response.mapItems)
        }
    }
}
