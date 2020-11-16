//
//  WeatherAPITests.swift
//  Favourite MapTests
//
//  Created by Mike on 12/11/2020.
//

import XCTest
@testable import Favourite_Map

class WeatherAPITests: XCTestCase {
    
    func testWeatherApiKey() {
        WeatherAPI.updateApiKey("")
        XCTAssertFalse(WeatherAPI.validateApiKey(), "empty space is invalid api key")
        WeatherAPI.updateApiKey(" ")
        XCTAssertFalse(WeatherAPI.validateApiKey(), "white space is invalid api key")
        WeatherAPI.updateApiKey("weather-key")
        XCTAssertTrue(WeatherAPI.validateApiKey(), "text is valid api key")
    }
    
    func testUnitSystem() {
        WeatherAPI.updateUnitSystem(WeatherAPI.UnitSystem.metric.rawValue)
        XCTAssertTrue(WeatherAPI.getUnitSystem() == WeatherAPI.UnitSystem.metric.rawValue)
    }
    

}
