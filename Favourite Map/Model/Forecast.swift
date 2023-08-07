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
    let temperature: [String]
    let humidity: String
    let windSpeed: String
    let main: String?
    let city: String
    
    init(_ list: List, _ city: City) {
        date = list.date
        temperature = [list.main.tempMin, list.main.temp, list.main.tempMax].map { String(describing: $0) }
        humidity = String(describing: list.main.humidity)
        windSpeed = String(describing: list.wind.speed)
        main = list.weather.first?.main
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
    let temp,tempMin,tempMax: Double
    let humidity: Int
    
    enum CodingKeys: String, CodingKey {
        case temp, humidity
        case tempMin = "temp_min"
        case tempMax = "temp_max"
    }
}

// MARK: - Weather
struct Weather: Codable {
    let main, description: String
}

// MARK: - Wind
struct Wind: Codable {
    let speed: Double
}

// MARK: - SingleForecast
struct SingleForecast: Decodable {
    private let weather: [Weather]
    private let main: Main
    
    var forecast: String? {
        weather.first?.main
    }
    
    func temperature(_ intensity: TemperatureIntensity) -> String {
        switch intensity {
        case .min:
            return String(describing: main.tempMin).asWholeNumber
        case .mid:
            return String(describing: main.temp).asWholeNumber
        case .max:
            return String(describing: main.tempMax).asWholeNumber
        }
        
    }
}

// MARK: - TemperatureIntensity
enum TemperatureIntensity {
    case min, mid, max
    
    var text: String {
        switch self {
        case .min:
            return "min".localized
        case .mid:
            return "current".localized
        case .max:
            return "max".localized
        }
    }
}

// MARK: - WeatherCondition
enum WeatherCondition: String {
    case rainy = "Rain"
    case cloudy = "Clouds"
    case sunny = "Clear"
    case drizzle = "Drizzle"
    
    var text: String {
        switch self {
        case .cloudy:
            return "cloudy".localized
        case .rainy:
            return "rainy".localized
        case .sunny:
            return "sunny".localized
        case .drizzle:
            return "drizzly".localized
        }
    }
}
