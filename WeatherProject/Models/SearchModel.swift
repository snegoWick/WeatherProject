//
//  SearchModel.swift
//  WeatherProject
//
//  Created by Aleksandr Makarov on 05.06.2022.
//

import Foundation

struct SearchCityElement: Codable, Hashable {
    let lat, lon, displayName: String
    let address: Address

    enum CodingKeys: String, CodingKey {
        case lat, lon
        case address
        case displayName = "display_name"
    }
}

struct Address: Hashable, Codable {
    let city: String?
}

typealias SearchCity = [SearchCityElement]
