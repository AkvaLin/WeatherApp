//
//  CurrentWeatherModel.swift
//  WeatherApp
//
//  Created by Никита Пивоваров on 20.03.2024.
//

import Foundation

struct CurrentWeatherModel: Decodable {
    let weather: [Weather]
    let main: Main
    let visibility: Int
    let wind: Wind
    let timestamp: Int

    enum CodingKeys: String, CodingKey {
        case coord = "coord"
        case weather = "weather"
        case base = "base"
        case main = "main"
        case visibility = "visibility"
        case wind = "wind"
        case clouds = "clouds"
        case timestamp = "dt"
        case sys = "sys"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        weather = try values.decode([Weather].self, forKey: .weather)
        main = try values.decode(Main.self, forKey: .main)
        visibility = try values.decode(Int.self, forKey: .visibility)
        wind = try values.decode(Wind.self, forKey: .wind)
        timestamp = try values.decode(Int.self, forKey: .timestamp)
    }
}
