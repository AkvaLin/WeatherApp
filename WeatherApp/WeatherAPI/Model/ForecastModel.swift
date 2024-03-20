//
//  ForecastModel.swift
//  WeatherApp
//
//  Created by Никита Пивоваров on 20.03.2024.
//

import Foundation

struct ForecastModel: Decodable {
    let list: [CurrentWeatherModel]
}
