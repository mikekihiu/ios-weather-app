//
//  MapViewController.swift
//  Favourite Map
//
//  Created by Mike on 12/11/2020.
//

import UIKit
import MapKit
import SwiftUI

class MapViewController: UIViewController {
    
    @IBOutlet weak var mapView: MKMapView!
    
    var viewModel: MapViewViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindMapRegion()
        registerIdentifiers()
    }
    
    private func bindMapRegion() {
        mapView.delegate = self
        if let region = viewModel?.boundingRegion {
            mapView.region = region
        }
        if let mapItem = viewModel?.mapItem {
            mapView.region.center = mapItem.placemark.coordinate
            mapView.addAnnotation(Location(coordinate: mapItem.placemark.coordinate, title: mapItem.name!))
            viewModel?.bookmark(mapItem)
        }
    }
    
    private func registerIdentifiers() {
        mapView.register(MKMarkerAnnotationView.self, forAnnotationViewWithReuseIdentifier: AnnotationReusableID.pin.rawValue)
        mapView.register(MKMarkerAnnotationView.self, forAnnotationViewWithReuseIdentifier: MKMapViewDefaultClusterAnnotationViewReuseIdentifier)
    }
}

extension MapViewController: MKMapViewDelegate {
    func mapViewDidFailLoadingMap(_ mapView: MKMapView, withError error: Error) {
        #if DEBUG
        print("Failed to load the map: \(error)")
        #endif
        showError(error)
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard let annotation = annotation as? Location else { return nil }
        let view = mapView.dequeueReusableAnnotationView(withIdentifier: AnnotationReusableID.pin.rawValue, for: annotation) as? MKMarkerAnnotationView
        view?.clusteringIdentifier = "searchResult"
        return view
    }
}

// MARK: Helpers
private enum AnnotationReusableID: String {
    case pin
}



