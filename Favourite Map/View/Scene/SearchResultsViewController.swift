//
//  SearchResultsViewController.swift
//  Favourite Map
//
//  Created by Mike on 12/11/2020.
//

import UIKit
import MapKit

class SearchResultsViewController: UITableViewController {
    
    private lazy var viewModel = SearchResultsViewModel()
   
    weak var host: UIViewController?
    
    // MARK: View callbacks
    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel()
        tableView.register(SearchResultsTableViewCell.self, forCellReuseIdentifier: SearchResultsTableViewCell.identifier)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.startProvidingCompletions(self)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        viewModel.searchCompleter = nil
    }
    
    private func bindViewModel() {
        viewModel.completerResults?
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { error in
                #if DEBUG
                print(error)
                #endif
            }, receiveValue: { [weak self] _ in
                self?.tableView.reloadData()
            }).store(in: &viewModel.cancellableStore)
        
        viewModel.selectedMapItem?
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { error in
                #if DEBUG
                print(error)
                #endif
            }, receiveValue: { [weak self] _ in
                guard let self else { return }
                self.host?.navigationController?.pushViewController(self.viewModel.mapScene, animated: true)
            }).store(in: &viewModel.cancellableStore)
    }
}

// MARK: Tableview data source
extension SearchResultsViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.results?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "results".localized
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SearchResultsTableViewCell.identifier, for: indexPath)

        if let result = viewModel.results?[indexPath.row] {
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
        ranges.forEach { range in
            highlightedString.addAttributes(attributes, range: range)
        }
        return highlightedString
    }

}

// MARK: Tableview delegate
extension SearchResultsViewController {
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let selectedTitle = viewModel.results?[indexPath.row].title {
            viewModel.search(for: selectedTitle)
        }
    }
}

// MARK: Observe changes in searchbar text
extension SearchResultsViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        viewModel.searchCompleter?.queryFragment = searchController.searchBar.text ?? ""
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

// MARK: Search completer delegate
extension SearchResultsViewController: MKLocalSearchCompleterDelegate {
    
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        viewModel.completerResults?.send(completer.results)
        viewModel.results = completer.results
    }
    
    func completer(_ completer: MKLocalSearchCompleter, didFailWithError error: Error) {
        #if DEBUG
        print(error)
        #endif
    }
}
