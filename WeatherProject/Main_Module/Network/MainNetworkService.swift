//
//  MainNetworkService.swift
//  WeatherProject
//
//  Created by Aleksandr Makarov on 03.06.2022.
//

import Foundation

final class MainNetworkService {
    
    
    func getWeatherData(lat: String, lon: String, completion: @escaping (Result<WeatherModel, Error>) -> Void) {
        var urlComponents = URLComponents()
        urlComponents.scheme = "http"
        urlComponents.host = "api.openweathermap.org"
        urlComponents.path = "/data/2.5/forecast"
        urlComponents.queryItems = [URLQueryItem(name: "lat", value: lat),
                                    URLQueryItem(name: "lon", value: lon),
                                    URLQueryItem(name: "units", value: "metric"),
                                    URLQueryItem(name: "lang", value: "ru"),
                                    URLQueryItem(name: "cnt", value: "40"),
                                    URLQueryItem(name: "appid", value: "d7404a6f2dbaaf98eb0cad1d35310aea")]
        
        guard let url = urlComponents.url else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        let session = URLSession.shared
        session.dataTask(with: request) { data, response, error in
            
            guard let data = data, error == nil else {
                print(error?.localizedDescription ?? "")
                return
            }
            
            guard let weather = try? JSONDecoder().decode(WeatherModel.self, from: data) else {
                print("Error parsing weather data")
                return
            }
            
            DispatchQueue.main.async {
                completion(.success(weather))
            }
        }.resume()
    }
}
