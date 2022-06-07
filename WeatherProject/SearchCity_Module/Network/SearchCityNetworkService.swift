//
//  SearchCityNetworkService.swift
//  WeatherProject
//
//  Created by Aleksandr Makarov on 05.06.2022.
//

import Foundation

final class SearchCityNetworkService {
    
    func getCity(searchText: String, completion: @escaping ([SearchCityElement]) -> Void) {
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "nominatim.openstreetmap.org"
        urlComponents.path = "/search/\(searchText)"
        urlComponents.queryItems = [URLQueryItem(name: "format", value: "json"),
                                    URLQueryItem(name: "addressdetails", value: "10"),
                                    URLQueryItem(name: "polygon_threshold", value: "0.2"),
                                    URLQueryItem(name: "limit", value: "10")]
        
        guard let url = urlComponents.url else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        let session = URLSession.shared
        session.dataTask(with: request) { data, response, error in
            
            guard let data = data, error == nil else {
                print(error?.localizedDescription ?? "")
                return
            }
                        
            guard let cityArray = try? JSONDecoder().decode(SearchCity.self, from: data) else {
                print("Error parsing search data")
                return
            }
                                    
            DispatchQueue.main.async {
                completion(cityArray)
            }
        }.resume()
    }
}
