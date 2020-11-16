//
//  HomeViewControllerTests.swift
//  Favourite MapUITests
//
//  Created by Mike on 16/11/2020.
//

import XCTest

class HomeViewControllerTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        XCUIApplication().launch()

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testDisplayActionSheet() throws {
        let app = XCUIApplication()
        app.navigationBars["Home"].buttons["Item"].tap()
        XCTAssertEqual(app.sheets.scrollViews.otherElements.buttons.count, 3)
        app.sheets.scrollViews.otherElements.buttons["Cancel"].tap()
    }
    
    func testBookmarkALocation() throws {
        let app = XCUIApplication()
        let homeNavigationBar = app.navigationBars["Home"]
        let searchSearchField = homeNavigationBar.searchFields["Search"]
        searchSearchField.tap()
        searchSearchField.typeText("Spurs")
        app/*@START_MENU_TOKEN@*/.tables["Search results"].cells.containing(.staticText, identifier:"Spurs").element/*[[".otherElements[\"Double-tap to dismiss\"].tables[\"Search results\"]",".cells.containing(.staticText, identifier:\"782 High Road, London, N17 0BX, England\").element",".cells.containing(.staticText, identifier:\"Spurs\").element",".tables[\"Search results\"]"],[[[-1,3,1],[-1,0,1]],[[-1,2],[-1,1]]],[0,0]]@END_MENU_TOKEN@*/.tap()
        app.navigationBars["Favourite_Map.MapView"].buttons["Home"].tap()
        homeNavigationBar.buttons["Cancel"].tap()
        XCTAssertTrue(app.tables.staticTexts["Tottenham Hotspur Football Club"].exists, "Bookmark location added")
    }

    func testTapBookmarkedLocationToViewWeather() throws {
        let app = XCUIApplication()
        XCTAssertTrue(app.tables.cells.count > 0, "There is atleast one bookmarked location")
        app.tables.cells.element(boundBy: 0).tap()
        XCTAssertTrue(app.alerts["Required!"].exists, "API error shown")
    }
    
}
