//
//  URLBuilder.swift
//  WeatherApp
//
//  Created by Никита Пивоваров on 20.03.2024.
//

import Foundation

final class URLBuilder {
    
    private var components: URLComponents
    
    init(scheme: String, host: String?) {
        self.components = URLComponents()
        components.scheme = scheme
        components.host = host
    }
    
    private init(components: URLComponents) {
        self.components = components
    }
    
    func copy() -> URLBuilder {
        let builder = URLBuilder(components: components)
        return builder
    }
    
    func pathComponent(_ pathComponent: String) -> URLBuilder {
        components.path += "/\(pathComponent)"
        
        return copy()
    }
    
    func queryItems(_ queryItems: [URLQueryItem]) -> URLBuilder {
        components.queryItems = queryItems
        
        return copy()
    }
    
    func build() -> URL? {
        return components.url
    }
}
