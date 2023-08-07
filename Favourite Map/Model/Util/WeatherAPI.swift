//
//  WeatherAPI.swift
//  Favourite Map
//
//  Created by Mike on 12/11/2020.
//

import Foundation
import Keys


class WeatherAPI {
    
    private static var apiKey = FavouriteMapKeys().weatherApiKey
    
    public enum UnitSystem: String {
        case standard, metric, imperial
    }
    
    private enum Speed: String {
        case miPH = "miles/hour", mePS = "meter/sec"
    }
    
    private enum Temperature: String {
        case kelvin, fahrenheit, celsius
    }
    
    class func get5DayForecast(lat: Double, lon: Double, completion: @escaping ([Forecast]?, Error?) -> Void) {
        let url = "https://api.openweathermap.org/data/2.5/forecast?lat=\(lat)&lon=\(lon)&units=\(getUnitSystem())&appid=\(apiKey)"
        let request = URLRequest(url: URL(string: url)!)
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
                return
            }
            do {
                let decoder = JSONDecoder()
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                decoder.dateDecodingStrategy = .formatted(dateFormatter)
                let results = try decoder.decode(Response.self, from: data)
                
                var forecasts: [Forecast] = []
                var idx = 39
                while (idx >= 7) {
                    forecasts.append(Forecast(results.list[idx], results.city))
                    idx -= 8
                }
                DispatchQueue.main.async {
                    completion(forecasts.reversed(), nil)
                }
            } catch {
                #if DEBUG
                print(error)
                #endif
                DispatchQueue.main.async {
                    completion(nil, error)
                }
            }
        }.resume()
    }
    
    class func getTodaysForecast(lat: Double, lon: Double, completion: @escaping (SingleForecast?, Error?) -> Void) {
        let url = "https://api.openweathermap.org/data/2.5/weather?lat=\(lat)&lon=\(lon)&units=\(getUnitSystem())&appid=\(apiKey)"
        let request = URLRequest(url: URL(string: url)!)
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
                return
            }
            do {
                let decoder = JSONDecoder()
                let result = try decoder.decode(SingleForecast.self, from: data)
                DispatchQueue.main.async {
                    completion(result, nil)
                }
            } catch {
                #if DEBUG
                print(error)
                #endif
                DispatchQueue.main.async {
                    completion(nil, error)
                }
            }
        }.resume()
    }

}

extension WeatherAPI {
    
    class func getUnitSystem() -> String {
       return UserDefaults.standard.string(forKey: UserDefaults.Keys.unitSystem.rawValue) ?? UnitSystem.metric.rawValue
    }
    
    class func updateUnitSystem(_ system: String) {
        UserDefaults.standard.set(system, forKey: UserDefaults.Keys.unitSystem.rawValue)
    }
    
    class func getSpeedUnit() -> String {
        switch UnitSystem(rawValue: getUnitSystem()) {
        case .imperial:
            return Speed.miPH.rawValue
        case .metric, .standard:
            return Speed.mePS.rawValue
        default:
            return ""
        }
    }
    
    class func updateApiKey(_ newKey: String) {
        apiKey = newKey
    }
    
    class func validateApiKey() -> Bool {
        return !apiKey.replacingOccurrences(of: " ", with: "").isEmpty
    }
}
