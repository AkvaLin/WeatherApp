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

    enum CodingKeys: String, CodingKey {
        case main = "main"
        case icon = "icon"
    }
}

struct MainDTO: Decodable {
    let temp : Double
    let feelsLike : Double
    let tempMin : Double
    let tempMax : Double
    let pressure : Int
    let humidity : Int

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
    let speed : Double
    let deg : Int

    enum CodingKeys: String, CodingKey {
        case speed = "speed"
        case deg = "deg"
    }
}

struct CloudsDTO: Decodable {
    let all: Int
}
