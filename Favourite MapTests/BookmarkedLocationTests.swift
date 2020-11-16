//
//  BookmarkedLocationTests.swift
//  Favourite MapTests
//
//  Created by Mike on 16/11/2020.
//

import XCTest
import MapKit
@testable import Favourite_Map

class BookmarkedLocationTests: XCTestCase {

    var coreDataStack: TestCoreDataStack!
    
    override func setUpWithError() throws {
        coreDataStack = TestCoreDataStack()
    }

    override func tearDownWithError() throws {
        coreDataStack = nil
    }
    
    func testAdd() {
        let mapItem = getDummyMapItem()
        BookmarkedLocation.save(mapItem, coreDataStack)
        let locations = fetchAll()!
        
        XCTAssertNotNil(locations[0])
        XCTAssertTrue(locations.count == 1)
        XCTAssertTrue(mapItem.name == locations[0].title, "title matches")
        XCTAssertTrue("" == locations[0].subtitle, "subtitle matches")
        XCTAssertTrue(mapItem.placemark.coordinate.latitude == locations[0].lat, "latitude matches")
        XCTAssertTrue(mapItem.placemark.coordinate.longitude == locations[0].lon, "longitude matches")

        BookmarkedLocation.save(mapItem, coreDataStack)
        XCTAssertTrue(locations.count == 1, "Duplicates ignored")
        
        mapItem.name = "Location 2"
        BookmarkedLocation.save(mapItem, coreDataStack)
        XCTAssertTrue(fetchAll()!.count == 2)
    }
    
    func testDeleteOne() {
        let mapItem = getDummyMapItem()
        BookmarkedLocation.save(mapItem, coreDataStack)
        let locations = fetchAll()!
        XCTAssertTrue(locations.count == 1)
        let location = locations[0]
        BookmarkedLocation.delete(location, coreDataStack)
        XCTAssertTrue(fetchAll()!.count == 0)
    }
        
//    func testClearAll() {
//        let mapItem = getDummyMapItem()
//        var idx = 0
//        while idx < 5 {
//            mapItem.name = "Test location \(idx)"
//            BookmarkedLocation.save(mapItem, coreDataStack)
//            idx = idx + 1
//        }
//        XCTAssertTrue(fetchAll()?.count == 5, "Bookmarked 5 locations")
//        // Fails coz of NSInMemoryStoreType incompatible with NSBatchDeleteRequest
//        BookmarkedLocation.clearAll(coreDataStack)
//        XCTAssertTrue(fetchAll()?.count == 0, "Cleared all")
//    }
    
    func getDummyMapItem() -> MKMapItem {
        let mapItem = MKMapItem(placemark: MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: 1.2, longitude: 1.2)))
        mapItem.name = "Location 1"
        return mapItem
    }
    
    func fetchAll() -> [BookmarkedLocation]? {
        return try? coreDataStack.viewContext.fetch(BookmarkedLocation.getFetchRequest())
    }
}
