//
//  CurrentWeatherModel.swift
//  WeatherApp
//
//  Created by Никита Пивоваров on 20.03.2024.
//

import Foundation

struct CurrentWeatherDTO: Decodable {
    let weather: [WeatherDTO]
    let main: MainDTO
    let wind: WindDto
    let clouds: CloudsDTO
    let timestamp: Int

    enum CodingKeys: String, CodingKey {
        case weather = "weather"
        case main = "main"
        case wind = "wind"
        case clouds = "clouds"
        case timestamp = "dt"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        weather = try values.decode([WeatherDTO].self, forKey: .weather)
        main = try values.decode(MainDTO.self, forKey: .main)
        wind = try values.decode(WindDto.self, forKey: .wind)
        clouds = try values.decode(CloudsDTO.self, forKey: .clouds)
        timestamp = try values.decode(Int.self, forKey: .timestamp)
    }
}
