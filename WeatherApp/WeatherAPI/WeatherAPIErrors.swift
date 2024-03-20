//
//  WeatherAPIErrors.swift
//  WeatherApp
//
//  Created by Никита Пивоваров on 20.03.2024.
//

import Foundation

enum WeatherAPIErrors: Error {
    case badURL
    case decodeError
    case fetchError
}
