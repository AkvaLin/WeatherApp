//
//  SearchViewModel.swift
//  WeatherApp
//
//  Created by Никита Пивоваров on 24.03.2024.
//

import Foundation
import Combine

final class SearchViewModel {
    
    @Published var viewData = [LocalSearchModel(title: "Your location")]
    @Published var cityText = ""
    
    var service: LocalSearchService
    private var cancellables: Set<AnyCancellable> = []
    
    init() {
        service = LocalSearchService()
        
        service.localSearchPublisher
            .sink { mapItems in
                self.viewData = mapItems.map({ LocalSearchModel(mapItem: $0) })
                self.viewData.insert(LocalSearchModel(title: "Your location"), at: 0)
            }
            .store(in: &cancellables)
        
        $cityText
            .debounce(for: 0.5, scheduler: RunLoop.main)
            .removeDuplicates()
            .sink { _ in
                self.searchForCity()
            }
            .store(in: &cancellables)
    }
    
    public func searchForCity() {
        service.request(searchText: cityText)
    }
}
