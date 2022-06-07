//
//  WeatherModel.swift
//  WeatherProject
//
//  Created by Aleksandr Makarov on 03.06.2022.
//


import Foundation

struct WeatherModel: Codable, Hashable {
    let list: [List]
    let city: City
}

struct City: Codable, Hashable {
    let name: String
}

struct List: Codable, Hashable {
    let dt: Int
    let main: MainClass
    let weather: [WeatherElement]

    enum CodingKeys: String, CodingKey {
        case dt, main, weather
    }
}

struct MainClass: Codable, Hashable {
    let temp, tempMin, tempMax: Double
    let humidity: Int

    enum CodingKeys: String, CodingKey {
        case temp
        case tempMin = "temp_min"
        case tempMax = "temp_max"
        case humidity
    }
}

struct WeatherElement: Codable, Hashable {
    let main: MainEnum
    let weatherDescription: String

    enum CodingKeys: String, CodingKey {
        case main
        case weatherDescription = "description"
    }
}

enum MainEnum: String, Codable {
    case clear = "Clear"
    case clouds = "Clouds"
    case rain = "Rain"
}
