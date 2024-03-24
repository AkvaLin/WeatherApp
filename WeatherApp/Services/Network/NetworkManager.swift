//
//  NetworkManager.swift
//  WeatherApp
//
//  Created by Никита Пивоваров on 20.03.2024.
//

import Foundation

final class NetworkManager {
    
    static public func fethcData(url: URL, completion: @escaping (Result<Data, NetworkErros>) -> Void) {
        let request = URLRequest(url: url)
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                if let response = response as? HTTPURLResponse {
                    switch response.statusCode {
                    case 400...499:
                        completion(.failure(.clientError))
                    case 500...599:
                        completion(.failure(.serverError))
                    default:
                        completion(.failure(.unknownError(error: error)))
                    }
                }
                return
            }
            
            guard let data = data else { return }
            completion(.success(data))
        }.resume()
    }
}
