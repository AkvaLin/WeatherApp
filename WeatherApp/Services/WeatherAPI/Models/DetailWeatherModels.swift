//
//  DetailWeatherModels.swift
//  WeatherApp
//
//  Created by Никита Пивоваров on 20.03.2024.
//

import Foundation

struct WeatherDTO: Decodable {
    let main: String
    let icon: String
}

struct MainDTO: Decodable {
    let temp: Double
    let feelsLike: Double
    let tempMin: Double
    let tempMax: Double
    let pressure: Int
    let humidity: Int

    enum CodingKeys: String, CodingKey {

        case temp = "temp"
        case feelsLike = "feels_like"
        case tempMin = "temp_min"
        case tempMax = "temp_max"
        case pressure = "pressure"
        case humidity = "humidity"
    }
}

struct WindDto: Decodable {
    let speed: Double
    let deg: Int
}

struct CloudsDTO: Decodable {
    let all: Int
}
