//
//  ForecastModel.swift
//  WeatherApp
//
//  Created by Никита Пивоваров on 23.03.2024.
//

import Foundation

struct ForecastModel {
    
    struct ForecastWeatherModel {
        let time: String
        let weatherIconName: String
    }
    
    let tempMin: String
    let tempMax: String
    let dayOfWeek: String
    let weather: [ForecastWeatherModel]
    
}
