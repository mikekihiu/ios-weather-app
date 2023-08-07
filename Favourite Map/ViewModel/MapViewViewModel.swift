//
//  MapViewViewModel.swift
//  Favourite Map
//
//  Created by Mike Kihiu on 07/08/2023.
//

import MapKit

struct MapViewViewModel {
    
    var location: BookmarkedLocation?
    
    mutating func bookmark(_ mapItem: MKMapItem) {
        location = BookmarkedLocation.save(mapItem)
    }
    
    var cityScene: CityViewController? {
        let cityScene = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CityViewController") as? CityViewController
        cityScene?.viewModel.city = location
        return cityScene
    }
}
