//
//  HomeViewModel.swift
//  Favourite Map
//
//  Created by Mike on 15/03/2022.
//

import CoreData
import CoreLocation

struct HomeViewModel {
    
    enum TableViewReuseID: String {
        case bookmarkedItem
    }

    enum SegueID: String {
        case goToCity, goToSettings, goToHelp
    }

    var fetchedResultsController: NSFetchedResultsController<BookmarkedLocation>?
    
    var locationManager: CLLocationManager?
    
    var emptyBookmarks: Bool {
        fetchedResultsController?.sections?[0].numberOfObjects ?? 1 == 0
    }
}

