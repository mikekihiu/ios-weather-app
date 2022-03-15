//
//  CityViewModel.swift
//  Favourite Map
//
//  Created by Mike on 15/03/2022.
//

import Foundation

class CityViewModel {
    
    weak var cityDelegate: CityDelegate?
    
    var forecasts: [Forecast]?
    
    var todaysForecast: SingleForecast?
    
    var city: BookmarkedLocation?
    
    init(cityDelegate: CityDelegate) {
        self.cityDelegate = cityDelegate
    }
    
    func callWeatherApi() {
        guard let city = city else { return }
        WeatherAPI.get5DayForecast(lat: city.lat, lon: city.lon, completion: handle5DayReponse(_:_:))
        WeatherAPI.getTodaysForecast(lat: city.lat, lon: city.lon, completion: handleTodaysForecast(_:_:))
    }
    
    private func handle5DayReponse(_ forecasts: [Forecast]?, _ error: Error?) {
        cityDelegate?.showProgress(false)
        guard error == nil else {
            cityDelegate?.showError(error)
            return
        }
        self.forecasts = forecasts
        if todaysForecast == nil { return }
        cityDelegate?.didCompleteNetworkCalls()
    }
    
    private func handleTodaysForecast(_ forecast: SingleForecast?, _ error: Error?) {
        guard error == nil else {
            cityDelegate?.showError(error)
            return
        }
        todaysForecast = forecast
        if forecasts == nil { return }
        cityDelegate?.didCompleteNetworkCalls()
    }
}
