//
//  Favourite_MapTests.swift
//  Favourite MapTests
//
//  Created by Mike on 12/11/2020.
//

import XCTest
@testable import Favourite_Map

class Favourite_MapTests: XCTestCase {
    
    func testWeatherApi() {
        WeatherAPI.updateApiKey("")
        XCTAssert(!WeatherAPI.validateApiKey(), "empty space is invalid api key")
        WeatherAPI.updateApiKey(" ")
        XCTAssert(!WeatherAPI.validateApiKey(), "white space is invalid api key")
        WeatherAPI.updateApiKey("weather-key")
        XCTAssert(WeatherAPI.validateApiKey(), "text is valid api key")
    }

}
