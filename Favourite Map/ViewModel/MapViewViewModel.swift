//
//  MapViewViewModel.swift
//  Favourite Map
//
//  Created by Mike Kihiu on 07/08/2023.
//

import MapKit

struct MapViewViewModel {
    
    let mapItem: MKMapItem?
    let boundingRegion: MKCoordinateRegion?
    var location: BookmarkedLocation? {
        guard let mapItem else { return nil }
        return BookmarkedLocation.save(mapItem)
    }
    
    func bookmark(_ mapItem: MKMapItem) {
        BookmarkedLocation.save(mapItem)
    }
}
