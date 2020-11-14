//
//  Location.swift
//  Favourite Map
//
//  Created by Mike on 12/11/2020.
//

import MapKit

class Location: NSObject, MKAnnotation {
    
    @objc dynamic var coordinate: CLLocationCoordinate2D
    var title: String?
    
    init(coordinate: CLLocationCoordinate2D, title: String) {
        self.coordinate = coordinate
        self.title = title
        super.init()
    }
}
