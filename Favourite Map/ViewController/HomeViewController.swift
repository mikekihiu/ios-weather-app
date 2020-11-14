//
//  HomeViewController.swift
//  Favourite Map
//
//  Created by Mike on 12/11/2020.
//

import UIKit
import MapKit
import CoreData

class HomeViewController: UITableViewController {

    private enum TableViewReuseID: String {
        case BookmarkedItem
    }
    
    private enum SegueID: String {
        case goToCity, goToSettings, goToHelp
    }
    
    private var fetchedResultsController: NSFetchedResultsController<BookmarkedLocation>?
    
    // MARK: View callbacks
    override func viewDidLoad() {
        super.viewDidLoad()
        let searchResultsViewController = SearchResultsViewController(style: .grouped)
        searchResultsViewController.host = self
        let searchController = UISearchController(searchResultsController: searchResultsViewController)
        searchController.searchResultsUpdater = searchResultsViewController
        searchController.obscuresBackgroundDuringPresentation = false

        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        definesPresentationContext = true
        
        tableView.delegate = self
        tableView.dataSource = self
        
        setupFetchedResultsController()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupFetchedResultsController()
        if UserDefaults.standard.bool(forKey: UserDefaults.Keys.hasJustClearedBookmarks.rawValue) {
            UserDefaults.standard.set(false, forKey: UserDefaults.Keys.hasJustClearedBookmarks.rawValue)
            tableView.reloadData()
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        fetchedResultsController = nil
    }
    
    @IBAction func tappedOptions(_ sender: Any) {
        let alertVC = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alertVC.addAction(UIAlertAction(title: "Settings", style: .default, handler: { _ in
            self.performSegue(withIdentifier: SegueID.goToSettings.rawValue, sender: self)
        }))
        alertVC.addAction(UIAlertAction(title: "Help", style: .default, handler: { _ in
            self.performSegue(withIdentifier: SegueID.goToHelp.rawValue, sender: self)
        }))
        alertVC.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(alertVC, animated: true, completion: nil)
    }
    

    // MARK: Helper methods
    private func setupFetchedResultsController() {
        fetchedResultsController = NSFetchedResultsController(fetchRequest: BookmarkedLocation.getFetchRequest(), managedObjectContext: DataController.shared.viewContext, sectionNameKeyPath: nil, cacheName: DataController.Cache.bookmarks.rawValue)
        fetchedResultsController?.delegate = self
        try? fetchedResultsController?.performFetch()
    }

    func deleteBookmark(at indexPath: IndexPath) {
        if let bookmarkToDelete = fetchedResultsController?.object(at: indexPath) {
            DataController.shared.viewContext.delete(bookmarkToDelete)
            DataController.shared.saveViewContext()
        }
    }
    
    //MARK: Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch SegueID(rawValue: segue.identifier!) {
        case .goToCity:
            if let vc = segue.destination as? CityViewController,
               let index = tableView.indexPathForSelectedRow, let city = fetchedResultsController?.object(at: index)  {
                vc.city = city
            }
            break
        default:
            break
        }
    }
    
}

//MARK: Extensions

//MARK: TableView dataSource
extension HomeViewController {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return fetchedResultsController?.sections?.count ?? 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fetchedResultsController?.sections?[section].numberOfObjects ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TableViewReuseID.BookmarkedItem.rawValue, for: indexPath)
        if let bookmark = fetchedResultsController?.object(at: indexPath) {
            cell.textLabel?.text = bookmark.title
            cell.detailTextLabel?.text = bookmark.subtitle
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Bookmarked locations"
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        switch editingStyle {
        case .delete: deleteBookmark(at: indexPath)
        default:
            break
        }
    }
    
}

//MARK: Fetched results delegate
extension HomeViewController: NSFetchedResultsControllerDelegate {
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            tableView.insertRows(at: [newIndexPath!], with: .fade)
            break
        case .delete:
            tableView.deleteRows(at: [indexPath!], with: .fade)
            break
        default:
            break
        }
    }
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
    
}


