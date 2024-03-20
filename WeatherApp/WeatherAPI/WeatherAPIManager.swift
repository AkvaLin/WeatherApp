//
//  WeatherAPIManager.swift
//  WeatherApp
//
//  Created by Никита Пивоваров on 20.03.2024.
//

import Foundation

class WeatherAPIManager {
    
    enum WeatherAPIRequestType {
        case currentWeather
        case forecast
    }
    
    private var weatherDataDefaultURL: URLBuilder {
        URLBuilder(scheme: WeatherAPIConstants.scheme, host: WeatherAPIConstants.host)
            .pathComponent(WeatherAPIConstants.weatherData)
            .pathComponent(WeatherAPIConstants.apiVersion)
    }
    
    public func getCurrentWeather(lat: Double,
                                  lon: Double,
                                  completion: @escaping (Result<CurrentWeatherModel, WeatherAPIErrors>) -> Void) {
        guard let url = getURL(lat: lat, lon: lon, type: .currentWeather) else {
            completion(.failure(.badURL))
            return
        }
        
        NetworkManager.fethcData(url: url) { result in
            switch result {
            case .success(let data):
                do {
                    let weather = try JSONDecoder().decode(CurrentWeatherModel.self, from: data)
                    completion(.success(weather))
                } catch {
                    completion(.failure(.decodeError))
                }
            case .failure:
                completion(.failure(.fetchError))
            }
        }
    }
    
    public func getForecast(lat: Double,
                            lon: Double,
                            completion: @escaping (Result<ForecastModel, WeatherAPIErrors>) -> Void) {
        guard let url = getURL(lat: lat, lon: lon, type: .forecast) else {
            completion(.failure(.badURL))
            return
        }
        
        NetworkManager.fethcData(url: url) { result in
            switch result {
            case .success(let data):
                do {
                    let forecast = try JSONDecoder().decode(ForecastModel.self, from: data)
                    completion(.success(forecast))
                } catch {
                    completion(.failure(.decodeError))
                }
            case .failure:
                completion(.failure(.fetchError))
            }
        }
    }
    
    private func getURL(lat: Double, lon: Double, type: WeatherAPIRequestType) -> URL? {
        var url = weatherDataDefaultURL
            .queryItems([
                URLQueryItem(name: "lat", value: "\(lat)"),
                URLQueryItem(name: "lon", value: "\(lon)"),
                URLQueryItem(name: "appid", value: WeatherAPIConstants.token)
            ])
        switch type {
        case .currentWeather:
            url = url.pathComponent(WeatherAPIConstants.weatherPath)
        case .forecast:
            url = url.pathComponent(WeatherAPIConstants.forecastPath)
        }
        return url.build()
    }
}
