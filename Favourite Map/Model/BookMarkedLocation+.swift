//
//  BookMarkedLocation+.swift
//  Favourite Map
//
//  Created by Mike on 13/11/2020.
//

import Foundation
import MapKit
import Contacts
import CoreData

extension BookmarkedLocation {
    
    @discardableResult
    class func save(_ mapItem: MKMapItem, _ stack: CoreDataStack = CoreDataStack.shared) -> BookmarkedLocation {
        if let existing = findFirst(stack, mapItem) {
            return existing
        }
        let bookmarkedLocation = BookmarkedLocation(context: stack.viewContext)
        bookmarkedLocation.title = mapItem.name
        bookmarkedLocation.subtitle = extractAddress(mapItem.placemark)
        bookmarkedLocation.lat = mapItem.placemark.coordinate.latitude
        bookmarkedLocation.lon = mapItem.placemark.coordinate.longitude
        stack.saveViewContext()
        return bookmarkedLocation
    }
    
    static fileprivate func extractAddress(_ placemark: MKPlacemark) -> String {
        guard let postalAddress = placemark.postalAddress else { return "" }
        return CNPostalAddressFormatter.string(from: postalAddress, style: .mailingAddress).replacingOccurrences(of: "\n", with: " ")
    }
    
    /// Checks if location is already persisted to prevent duplicates. Can be improved to match using combo of lat and lon instead of name
    /// - Parameters:
    ///   - stack: core data stack
    ///   - mapItem: map item that's about to be converted to a BookmarkedLocation
    /// - Returns: value if exists, else nil
    static fileprivate func findFirst(_ stack: CoreDataStack, _ mapItem: MKMapItem) -> BookmarkedLocation? {
        let fetchRequest = getFetchRequest()
        fetchRequest.predicate = NSPredicate(format: "title == %@", mapItem.name!)
        return try! stack.viewContext.fetch(fetchRequest).first
    }
    
    class func delete(_ location: BookmarkedLocation?, _ coreDataStack: CoreDataStack = CoreDataStack.shared) {
        if let location = location {
            coreDataStack.viewContext.delete(location)
            coreDataStack.saveViewContext()
        }
    }
    
    class func getFetchRequest() -> NSFetchRequest<BookmarkedLocation> {
        let fetchRequest: NSFetchRequest<BookmarkedLocation> = BookmarkedLocation.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        return fetchRequest
    }
    
    /// Deletes all bookmarked location
    class func clearAll(_ stack: CoreDataStack = CoreDataStack.shared) {
        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: NSFetchRequest(entityName: "BookmarkedLocation"))
        do {
            try stack.persistentContainer.persistentStoreCoordinator.execute(batchDeleteRequest, with: stack.viewContext)
        } catch {
            #if DEBUG
            print(error)
            #endif
        }
    }
}
