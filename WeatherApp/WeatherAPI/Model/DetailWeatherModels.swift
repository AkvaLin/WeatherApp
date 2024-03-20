//
//  DetailWeatherModels.swift
//  WeatherApp
//
//  Created by Никита Пивоваров on 20.03.2024.
//

import Foundation

struct Weather: Decodable {
    let id: Int
    let main: String
    let description: String
    let icon: String

    enum CodingKeys: String, CodingKey {

        case id = "id"
        case main = "main"
        case description = "description"
        case icon = "icon"
    }
}

struct Main: Decodable {
    let temp : Double
    let feelsLike : Double
    let tempMin : Double
    let tempMax : Double
    let pressure : Int
    let humidity : Int
    let seaLevel : Int
    let grndLevel : Int

    enum CodingKeys: String, CodingKey {

        case temp = "temp"
        case feelsLike = "feels_like"
        case tempMin = "temp_min"
        case tempMax = "temp_max"
        case pressure = "pressure"
        case humidity = "humidity"
        case seaLevel = "sea_level"
        case grndLevel = "grnd_level"
    }
}

struct Wind: Decodable {
    let speed : Double
    let deg : Int
    let gust : Double

    enum CodingKeys: String, CodingKey {

        case speed = "speed"
        case deg = "deg"
        case gust = "gust"
    }
}
