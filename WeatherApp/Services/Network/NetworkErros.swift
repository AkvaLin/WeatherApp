//
//  NetworkErros.swift
//  WeatherApp
//
//  Created by Никита Пивоваров on 20.03.2024.
//

enum NetworkErros: Error {
    case unknownError(error: Error)
    case serverError
    case clientError
}
