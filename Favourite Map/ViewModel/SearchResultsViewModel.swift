//
//  SearchResultsViewModel.swift
//  Favourite Map
//
//  Created by Mike Kihiu on 09/08/2023.
//

import MapKit
import SwiftUI
import Combine

class SearchResultsViewModel {
    
    var searchCompleter: MKLocalSearchCompleter?
    private var searchRegion: MKCoordinateRegion = MKCoordinateRegion(MKMapRect.world)
    
    var completerResults: PassthroughSubject<[MKLocalSearchCompletion]?, Error>?
    var results: [MKLocalSearchCompletion]?
    
    private var localSearch: MKLocalSearch? {
        willSet {
            localSearch?.cancel()
        }
    }
    
    private var selectedRegion: MKCoordinateRegion?
    
    var selectedMapItem: PassthroughSubject<MKMapItem?, Error>?
    private var selectedLocation: MKMapItem?
    
    var cancellableStore = Set<AnyCancellable>()
    
    var mapScene: UIHostingController<MapScene> {
        let mapViewModel = MapViewViewModel(mapItem: selectedLocation, boundingRegion: selectedRegion)
        let controller = UIHostingController(rootView: MapScene(viewModel: mapViewModel))
        return controller
    }
    
    func startProvidingCompletions(_ delegate: MKLocalSearchCompleterDelegate) {
        searchCompleter = MKLocalSearchCompleter()
        searchCompleter?.delegate = delegate
        searchCompleter?.resultTypes = .pointOfInterest
        searchCompleter?.region = searchRegion
    }
}

extension SearchResultsViewModel {
    
    func search(for queryString: String?) {
        let searchRequest = MKLocalSearch.Request()
        searchRequest.naturalLanguageQuery = queryString
        search(using: searchRequest)
    }
    
    func search(using searchRequest: MKLocalSearch.Request) {
        searchRequest.resultTypes = .pointOfInterest
        localSearch = MKLocalSearch(request: searchRequest)
        localSearch?.start { [weak self] (response, error) in
            guard error == nil else {
                #if DEBUG
                print(error ?? "-")
                #endif
                return
            }
            self?.selectedRegion = response?.boundingRegion
            self?.selectedLocation = response?.mapItems.first
            self?.selectedMapItem?.send(response?.mapItems.first)
        }
    }
}
