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
    
    var mapItem: MKMapItem?
    var boundingRegion: MKCoordinateRegion?
    private lazy var viewModel = MapViewViewModel()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindMapRegion()
        registerIdentifiers()
        addCityNavigation()
    }
    
    private func bindMapRegion() {
        mapView.delegate = self
        if let region = boundingRegion {
            mapView.region = region
        }
        if let mapItem = mapItem {
            mapView.region.center = mapItem.placemark.coordinate
            mapView.addAnnotation(Location(coordinate: mapItem.placemark.coordinate, title: mapItem.name!))
            viewModel.bookmark(mapItem)
        }
    }
    
    private func registerIdentifiers() {
        mapView.register(MKMarkerAnnotationView.self, forAnnotationViewWithReuseIdentifier: AnnotationReusableID.pin.rawValue)
        mapView.register(MKMarkerAnnotationView.self, forAnnotationViewWithReuseIdentifier: MKMapViewDefaultClusterAnnotationViewReuseIdentifier)
    }
    
    private func addCityNavigation() {
        let fab = _UIHostingView(rootView: FloatingActionButton())
        fab.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(showCity)))
        view.addSubview(fab)
        NSLayoutConstraint.activate([
            fab.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            fab.widthAnchor.constraint(equalToConstant: 48),
            fab.heightAnchor.constraint(equalToConstant: 48),
            fab.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -24)
        ])
    }
    
    @objc private func showCity() {
        guard let cityScene = viewModel.cityScene else { return }
        present(cityScene, animated: true)
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



