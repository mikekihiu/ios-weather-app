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
        print("xct", app.scrollViews.otherElements.buttons.count)
        XCTAssertEqual(app.scrollViews.otherElements.buttons.count, 3)
        app.scrollViews.otherElements.buttons["Cancel"].tap()
    }
    
    func testBookmarkingALocation() throws {
        let app = XCUIApplication()
        let homeNavigationBar = app.navigationBars["Home"]
        let searchSearchField = homeNavigationBar.searchFields["Search"]
        searchSearchField.tap()
        searchSearchField.typeText("Berghof")
        sleep(3)
        app.tables["Search results"].cells.element(boundBy: 0).tap()
        app.navigationBars["_TtGC7SwiftUI19UIHosting"].buttons["Home"].tap()
        homeNavigationBar.buttons["Cancel"].tap()
        XCTAssertTrue(app.tables.staticTexts["Berghof"].exists, "Bookmark location added")
    }

    func testEndToEnd() throws {
        let app = XCUIApplication()
        let homeNavigationBar = app.navigationBars["Home"]
        let searchSearchField = homeNavigationBar.searchFields["Search"]
        searchSearchField.tap()
        searchSearchField.typeText("Sarit centre")
        sleep(3)
        // swiftlint: disable line_length
        app/*@START_MENU_TOKEN@*/.tables["Search results"].staticTexts["Lower Kabete Road, Nairobi, 00606, Kenya"]/*[[".otherElements[\"Double-tap to dismiss\"].tables[\"Search results\"]",".cells.staticTexts[\"Lower Kabete Road, Nairobi, 00606, Kenya\"]",".staticTexts[\"Lower Kabete Road, Nairobi, 00606, Kenya\"]",".tables[\"Search results\"]"],[[[-1,3,1],[-1,0,1]],[[-1,2],[-1,1]]],[0,0]]@END_MENU_TOKEN@*/.tap()
        // swiftlint: enable line_length
        app.images.firstMatch.tap()
        app.children(matching: .window).element(boundBy: 0).swipeDown(velocity: .fast)
        app.navigationBars["_TtGC7SwiftUI19UIHosting"].buttons["Home"].tap()
        searchSearchField.tap()
        homeNavigationBar.buttons["Cancel"].tap()
        // swiftlint: disable line_length
        app.tables/*@START_MENU_TOKEN@*/.staticTexts["Lower Kabete Road Nairobi 00606 Kenya"]/*[[".cells.staticTexts[\"Lower Kabete Road Nairobi 00606 Kenya\"]",".staticTexts[\"Lower Kabete Road Nairobi 00606 Kenya\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        // swiftlint: enable line_length
        app.navigationBars["Favourite_Map.ForecastView"].buttons["Home"].tap()
    }
}
