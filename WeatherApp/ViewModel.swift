//
//  ViewModel.swift
//  WeatherApp
//
//  Created by Никита Пивоваров on 22.03.2024.
//

import Foundation
import Combine
import CoreLocation

class ViewModel: NSObject {
    
    @Published private(set) var weatherModel: WeatherModel?
    @Published private(set) var forecastModel: [ForecastModel] = []
    @Published private(set) var countryTitleText = ""
    @Published private(set) var cityTitleText = ""
    private let weatherApi = WeatherAPIManager()
    private let locationManager = LocationManager()
    
    public func onAppear() {
        locationManager.setupDelegate(delegate: self)
        locationManager.requestAuthorization()
    }
    
    private func updateCurrentData() {
        locationManager.updateCurrentLocation()
        if let lat = locationManager.lat, let lon = locationManager.lon {
            DispatchQueue.global(qos: .userInitiated).async {
                self.weatherApi.getCurrentWeather(lat: lat, lon: lon) { result in
                    switch result {
                    case .success(let success):
                        self.weatherModel = self.convertToWeatherModel(from: success)
                    case .failure(let failure):
                        NSLog("%@", failure.localizedDescription)
                    }
                }
                self.weatherApi.getForecast(lat: lat, lon: lon) { result in
                    switch result {
                    case .success(let success):
                        self.forecastModel = self.convertToForecastModels(from: success)
                    case .failure(let failure):
                        NSLog("%@", failure.localizedDescription)
                    }
                }
            }
            
            locationManager.updateGeocode { [weak self] (city, area, county) in
                guard let self = self else { return }
                if let country = county {
                    if let city = city {
                        self.cityTitleText = city
                    } else if let area = area {
                        self.cityTitleText = area
                    }
                    self.countryTitleText = country
                } else {
                    self.countryTitleText = ""
                    self.cityTitleText = ""
                }
            }
        }
    }
    
    private func convertToWeatherModel(from currentWeather: CurrentWeatherDTO) -> WeatherModel {
        let temp = Measurement(value: currentWeather.main.temp, unit: UnitTemperature.kelvin)
            .formatted(.measurement(
                width: .abbreviated,
                numberFormatStyle: .number.precision(.fractionLength(0))
            ))
        let tempMin = "L:" + Measurement(value: currentWeather.main.tempMin, unit: UnitTemperature.kelvin)
            .formatted(.measurement(
                width: .narrow,
                numberFormatStyle: .number.precision(.fractionLength(0))
            ))
        let tempMax = "H:" + Measurement(value: currentWeather.main.tempMax, unit: UnitTemperature.kelvin)
            .formatted(.measurement(
                width: .narrow,
                numberFormatStyle: .number.precision(.fractionLength(0))
            ))
        let feelsLike = Measurement(value: currentWeather.main.feelsLike, unit: UnitTemperature.kelvin)
            .formatted(.measurement(
                width: .narrow,
                numberFormatStyle: .number.precision(.fractionLength(0))
            ))
        let humidity = currentWeather.main.humidity.formatted(.percent.rounded(rule: .awayFromZero))
        let pressure = Measurement(value: Double(currentWeather.main.pressure), unit: UnitPressure.hectopascals)
            .formatted(.measurement(
                width: .abbreviated,
                usage: .asProvided,
                numberFormatStyle: .number.precision(.fractionLength(0))
            ))
        let cloudiness = currentWeather.clouds.all.formatted(.percent.rounded(rule: .awayFromZero))
        let dateTime = Date(timeIntervalSince1970: Double(currentWeather.timestamp)).formatted()
        let weather = currentWeather.weather.first?.main ?? ""
        let windDeg = compassDirection(for: CLLocationDirection(currentWeather.wind.deg))
        let weatherImageName = convertImageName(from: currentWeather.weather.first?.icon ?? "")
        let windSpeed = Measurement(value: currentWeather.wind.speed, unit: UnitSpeed.metersPerSecond)
            .formatted(.measurement(
                width: .abbreviated,
                usage: .wind,
                numberFormatStyle: .number.precision(.fractionLength(0))
            ))
        
        return WeatherModel(temp: temp,
                            tempMin: tempMin,
                            tempMax: tempMax,
                            feelsLike: feelsLike,
                            humidity: humidity,
                            pressure: pressure,
                            cloudiness: cloudiness,
                            dateTime: dateTime,
                            weather: weather,
                            weatherImageName: weatherImageName,
                            windDeg: windDeg,
                            windSpeed: windSpeed)
    }
    
    private func convertToForecastModels(from forecastDTO: ForecastDTO) -> [ForecastModel] {
        
        guard let firstTimeStamp = forecastDTO.list.first?.timestamp else { return [] }
        
        var models = [ForecastModel]()
        var weather = [ForecastModel.ForecastWeatherModel]()
        var min = Double.greatestFiniteMagnitude
        var max = -Double.greatestFiniteMagnitude
        var currentDate = Date(timeIntervalSince1970: TimeInterval(firstTimeStamp)).formatted(date: .numeric, time: .omitted)
        
        for (index, weatherDTO) in forecastDTO.list.enumerated() {
            let date = Date(timeIntervalSince1970: TimeInterval(weatherDTO.timestamp))
            let tempMin = Measurement(value: min, unit: UnitTemperature.kelvin)
                .formatted(.measurement(
                    width: .narrow,
                    numberFormatStyle: .number.precision(.fractionLength(0))
                ))
            let tempMax = Measurement(value: max, unit: UnitTemperature.kelvin)
                .formatted(.measurement(
                    width: .narrow,
                    numberFormatStyle: .number.precision(.fractionLength(0))
                ))
            
            if currentDate != date.formatted(date: .numeric, time: .omitted) {
                
                models.append(ForecastModel(tempMin: tempMin, 
                                            tempMax: tempMax,
                                            dayOfWeek: date.formatted(.dateTime.weekday()),
                                            weather: weather))
                
                weather = []
                min = Double.greatestFiniteMagnitude
                max = -Double.greatestFiniteMagnitude
                
                currentDate = date.formatted(date: .numeric, time: .omitted)
            }
            
            min = weatherDTO.main.tempMin < min ? weatherDTO.main.tempMin : min
            max = weatherDTO.main.tempMax > max ? weatherDTO.main.tempMax : max
            weather.append(.init(time: date.formatted(.dateTime.hour()),
                                 weatherIconName: convertImageName(from: weatherDTO.weather.first?.icon ?? "")))
            
            if index == forecastDTO.list.count - 1 {
                models.append(ForecastModel(tempMin: tempMin,
                                            tempMax: tempMax,
                                            dayOfWeek: date.formatted(.dateTime.weekday()),
                                            weather: weather))
            }
        }
        
        return models
    }
    
    private func convertImageName(from name: String) -> String {
        switch name {
        case "01d":
            return "sun.max.fill"
        case "01n":
            return "moon.stars.fill"
        case "02d":
            return "cloud.sun.fill"
        case "02n":
            return "cloud.moon.fill"
        case "10d":
            return "cloud.sun.rain.fill"
        case "10n":
            return "cloud.moon.rain.fill"
        case "50d":
            return "sun.haze.fill"
        case "50n":
            return "moon.haze.fill"
        default:
            break
        }
        
        if name.hasPrefix("03") {
            return "cloud.fill"
        } else if name.hasPrefix("04") {
            return "smoke.fill"
        } else if name.hasPrefix("09") {
            return "cloud.heavyrain.fill"
        } else if name.hasPrefix("11") {
            return "cloud.bolt.rain.fill"
        } else if name.hasPrefix("13") {
            return "snowflake"
        } else {
            return ""
        }
    }
    
    func compassDirection(for heading: CLLocationDirection) -> String {
        if heading < 0 { return "" }
        
        let directions = ["N", "NE", "E", "SE", "S", "SW", "W", "NW"]
        let index = Int((heading / 45).rounded()) % 8
        return directions[index]
    }
}

extension ViewModel: CLLocationManagerDelegate {
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        updateCurrentData()
    }
}
