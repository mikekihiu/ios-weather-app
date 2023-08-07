//
//  ForecastViewModel.swift
//  Favourite Map
//
//  Created by Mike on 15/03/2022.
//

import Foundation

class ForecastViewModel {
    
    weak var delegate: ForecastDelegate?
    
    var forecasts: [Forecast]?
    
    var todaysForecast: SingleForecast?
    
    var location: BookmarkedLocation?
    
    init(delegate: ForecastDelegate) {
        self.delegate = delegate
    }
    
    func callWeatherApi() {
        guard let city = location else { return }
        WeatherAPI.get5DayForecast(lat: city.lat, lon: city.lon, completion: handle5DayReponse(_:_:))
        WeatherAPI.getTodaysForecast(lat: city.lat, lon: city.lon, completion: handleTodaysForecast(_:_:))
    }
    
    private func handle5DayReponse(_ forecasts: [Forecast]?, _ error: Error?) {
        delegate?.showProgress(false)
        guard error == nil else {
            delegate?.showError(error)
            return
        }
        self.forecasts = forecasts
        if todaysForecast == nil { return }
        delegate?.didCompleteNetworkCalls()
    }
    
    private func handleTodaysForecast(_ forecast: SingleForecast?, _ error: Error?) {
        guard error == nil else {
            delegate?.showError(error)
            return
        }
        todaysForecast = forecast
        if forecasts == nil { return }
        delegate?.didCompleteNetworkCalls()
    }
}
