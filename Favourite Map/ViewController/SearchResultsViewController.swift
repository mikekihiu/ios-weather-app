//
//  SearchResultsViewController.swift
//  Favourite Map
//
//  Created by Mike on 12/11/2020.
//

import UIKit
import MapKit

class SearchResultsViewController: UITableViewController {
    
    private var searchCompleter: MKLocalSearchCompleter?
    private var searchRegion: MKCoordinateRegion = MKCoordinateRegion(MKMapRect.world)
    private var completerResults: [MKLocalSearchCompletion]? {
        didSet {
            tableView.reloadData()
        }
    }
    private var localSearch: MKLocalSearch? {
        willSet {
            // Cancel the currently running search before starting a new one.
            localSearch?.cancel()
        }
    }
    weak var host: UIViewController?
    var selectedRegion: MKCoordinateRegion?
    var selectedLocation: MKMapItem? {
        didSet {
            if let vc = host?.storyboard?.instantiateViewController(identifier: "MapViewController") as? MapViewController {
                vc.mapItem = selectedLocation
                vc.boundingRegion = selectedRegion
                host?.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
    
    // MARK: View callbacks
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(SearchResultsTableViewCell.self, forCellReuseIdentifier: SearchResultsTableViewCell.reusableID)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        startProvidingCompletions()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        searchCompleter = nil
    }
    
    // MARK: Helper fxs
    private func startProvidingCompletions() {
        searchCompleter = MKLocalSearchCompleter()
        searchCompleter?.delegate = self
        searchCompleter?.resultTypes = .pointOfInterest
        searchCompleter?.region = searchRegion
    }
}

extension SearchResultsViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return completerResults?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Search results"
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SearchResultsTableViewCell.reusableID, for: indexPath)

        if let result = completerResults?[indexPath.row] {
            cell.textLabel?.attributedText = createHighlightedString(text: result.title, rangeValues: result.titleHighlightRanges)
            cell.detailTextLabel?.attributedText = createHighlightedString(text: result.subtitle, rangeValues: result.subtitleHighlightRanges)
            cell.selectionStyle = .none
        }

        return cell
    }
    
    private func createHighlightedString(text: String, rangeValues: [NSValue]) -> NSAttributedString {
        let attributes = [NSAttributedString.Key.foregroundColor: UIColor.orange]
        let highlightedString = NSMutableAttributedString(string: text)
        let ranges = rangeValues.map { $0.rangeValue }
        ranges.forEach { (range) in
            highlightedString.addAttributes(attributes, range: range)
        }
        return highlightedString
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let selectedTitle = completerResults?[indexPath.row].title {
            search(for: selectedTitle)
        }
    }
}

extension SearchResultsViewController: MKLocalSearchCompleterDelegate {
    
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        completerResults = completer.results
        //print("results count \(completer.results.count)")
    }
    
    func completer(_ completer: MKLocalSearchCompleter, didFailWithError error: Error) {
        showError(error)
    }
}

extension SearchResultsViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        // Ask `MKLocalSearchCompleter` for new completion suggestions based on the change in the text entered in `UISearchBar`.
        searchCompleter?.queryFragment = searchController.searchBar.text ?? ""
    }
}

extension SearchResultsViewController {
    
    func search(for queryString: String?) {
        let searchRequest = MKLocalSearch.Request()
        searchRequest.naturalLanguageQuery = queryString
        search(using: searchRequest)
    }
    
    func search(using searchRequest: MKLocalSearch.Request) {
        // Confine the map search area to an area around the user's current location.
        //searchRequest.region = boundingRegion
        
        // Include only point of interest results. This excludes results based on address matches.
        searchRequest.resultTypes = .pointOfInterest
        
        localSearch = MKLocalSearch(request: searchRequest)
        localSearch?.start { [unowned self] (response, error) in
            guard error == nil else {
                self.showError(error)
                return
            }
            selectedRegion = response?.boundingRegion
            selectedLocation = response?.mapItems.first
            
        }
    }
}

// MARK: SearchResultsTableViewCell
class SearchResultsTableViewCell: UITableViewCell {
    
    static let reusableID = "SearchResultCell"
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

