//
//  CitiesArrayCache.swift
//  WeatherProject
//
//  Created by Aleksandr Makarov on 05.06.2022.
//

import Foundation

struct CitiesArrayCache {
    static let key = "citiesArrayCache"
    static func save(_ value: [SearchCityElement]) {
         UserDefaults.standard.set(try? PropertyListEncoder().encode(value), forKey: key)
    }
    static func get() -> [SearchCityElement] {
        var cityData: [SearchCityElement]
        if let data = UserDefaults.standard.value(forKey: key) as? Data {
            cityData = try! PropertyListDecoder().decode([SearchCityElement].self, from: data)
            return cityData
        } else {
            return []
        }
    }
    static func remove() {
        UserDefaults.standard.removeObject(forKey: key)
    }
}
