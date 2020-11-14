//
//  BookMarkedLocation+Extensions.swift
//  Favourite Map
//
//  Created by Mike on 13/11/2020.
//

import Foundation
import MapKit
import Contacts
import CoreData

extension BookmarkedLocation {
    class func save(_ mapItem: MKMapItem) {
        if exists(mapItem) { return }
        let bookmarkedLocation = BookmarkedLocation(context: DataController.shared.viewContext)
        bookmarkedLocation.title = mapItem.name
        bookmarkedLocation.subtitle = extractAddress(mapItem.placemark)
        bookmarkedLocation.lat = mapItem.placemark.coordinate.latitude
        bookmarkedLocation.lon = mapItem.placemark.coordinate.longitude
        DataController.shared.saveViewContext()
    }
    
    static fileprivate func extractAddress(_ placemark: MKPlacemark) -> String {
        guard let postalAddress = placemark.postalAddress else { return "" }
        return CNPostalAddressFormatter.string(from: postalAddress, style: .mailingAddress).replacingOccurrences(of: "\n", with: " ")
    }
    
    static fileprivate func exists(_ mapItem: MKMapItem) -> Bool {
        let fetchRequest = getFetchRequest()
        fetchRequest.predicate = NSPredicate(format: "title == %@", mapItem.name!)
        return try! DataController.shared.viewContext.fetch(fetchRequest).count > 0
    }
    
    class func getFetchRequest() -> NSFetchRequest<BookmarkedLocation> {
        let fetchRequest: NSFetchRequest<BookmarkedLocation> = BookmarkedLocation.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        return fetchRequest
    }
    
    
    /// Deletes all bookmarked location
    class func clearAll() {
        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: NSFetchRequest(entityName: "BookmarkedLocation"))
        do {
            try DataController.shared.persistentContainer.persistentStoreCoordinator.execute(batchDeleteRequest, with: DataController.shared.viewContext)
        } catch {
            print(error)
        }
    }
}
