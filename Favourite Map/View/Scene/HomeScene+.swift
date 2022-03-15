//
//  HomeScene+.swift
//  Favourite Map
//
//  Created by Mike on 15/03/2022.
//

import CoreLocation
import MapKit

extension HomeViewController: CLLocationManagerDelegate {
    
    func getCurrentLocation() {
        viewModel.locationManager = CLLocationManager()
        viewModel.locationManager?.delegate = self
        viewModel.locationManager?.desiredAccuracy = kCLLocationAccuracyBest
        viewModel.locationManager?.requestAlwaysAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            viewModel.locationManager?.startUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        saveCurrentLocation(locations.first)
        viewModel.locationManager?.stopUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
    
    func saveCurrentLocation(_ location: CLLocation?) {
        guard let location = location else { return }
        CLGeocoder().reverseGeocodeLocation(location) { placemarks, error in
            if let error = error {
                print(error)
            }
            if let placemark = placemarks?.first {
                let item = MKMapItem(placemark: MKPlacemark(placemark: placemark))
                BookmarkedLocation.save(item)
            }
        }
    }
}
