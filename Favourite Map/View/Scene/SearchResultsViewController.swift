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
        tableView.register(SearchResultsTableViewCell.self, forCellReuseIdentifier: SearchResultsTableViewCell.identifier)
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

//MARK: Extensions
//MARK: Tableview data source
extension SearchResultsViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return completerResults?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Search results"
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SearchResultsTableViewCell.identifier, for: indexPath)

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

}

//MARK: Tableview delegate
extension SearchResultsViewController {
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let selectedTitle = completerResults?[indexPath.row].title {
            search(for: selectedTitle)
        }
    }
}

//MARK: Search completer delegate
extension SearchResultsViewController: MKLocalSearchCompleterDelegate {
    
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        completerResults = completer.results
    }
    
    func completer(_ completer: MKLocalSearchCompleter, didFailWithError error: Error) {
        showError(error)
    }
}

//MARK: Observe changes in searchbar text
extension SearchResultsViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        searchCompleter?.queryFragment = searchController.searchBar.text ?? ""
    }
}

//MARK: Search for MapItem given place name
extension SearchResultsViewController {
    
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
                self?.showError(error)
                return
            }
            self?.selectedRegion = response?.boundingRegion
            self?.selectedLocation = response?.mapItems.first
            
        }
    }
}

// MARK: SearchResultsTableViewCell
class SearchResultsTableViewCell: UITableViewCell {
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}

