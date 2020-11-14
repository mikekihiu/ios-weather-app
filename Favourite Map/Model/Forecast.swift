//
//  Forecast.swift
//  Favourite Map
//
//  Created by Mike on 13/11/2020.
//

import Foundation

// MARK: - Forecast
struct Forecast {
    
    let date: Date
    let temperature: String
    let humidity: String
    let windSpeed: String
    let description: String
    let city: String
    
    init(_ list: List, _ city: City) {
        date = list.date
        temperature = String(describing: list.main.temp)
        humidity = String(describing: list.main.humidity)
        windSpeed = String(describing: list.wind.speed)
        description = list.weather.first!.weatherDescription
        self.city = "\(city.name), \(city.country)"
    }
}

// MARK: - Response
struct Response: Codable {
    let list: [List]
    let city: City
}

// MARK: - City
struct City: Codable {
    let name, country: String
}

// MARK: - List
struct List: Codable {
    let main: Main
    let weather: [Weather]
    let wind: Wind
    let date: Date

    enum CodingKeys: String, CodingKey {
        case main, weather, wind
        case date = "dt_txt"
    }
}

// MARK: - Main
struct Main: Codable {
    let temp: Double
    let humidity: Int
}

// MARK: - Weather
struct Weather: Codable {
    let weatherDescription: String

    enum CodingKeys: String, CodingKey {
        case weatherDescription = "description"
    }
}

// MARK: - Wind
struct Wind: Codable {
    let speed: Double
}
