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

    lazy var viewModel = HomeViewModel()
    
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
        if viewModel.emptyBookmarks { getCurrentLocation() }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        viewModel.fetchedResultsController = nil
    }
    
    @IBAction func tappedOptions(_ sender: Any) {
        let alertVC = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alertVC.addAction(UIAlertAction(title: "settings".localized, style: .default, handler: { _ in
            self.performSegue(withIdentifier: HomeViewModel.SegueID.goToSettings.rawValue, sender: self)
        }))
        alertVC.addAction(UIAlertAction(title: "help".localized, style: .default, handler: { _ in
            self.performSegue(withIdentifier: HomeViewModel.SegueID.goToHelp.rawValue, sender: self)
        }))
        alertVC.addAction(UIAlertAction(title: "cancel".localized, style: .cancel, handler: nil))
        present(alertVC, animated: true, completion: nil)
    }
    

    // MARK: Helper methods
    private func setupFetchedResultsController() {
        viewModel.fetchedResultsController = NSFetchedResultsController(
            fetchRequest: BookmarkedLocation.getFetchRequest(),
            managedObjectContext: CoreDataStack.shared.viewContext,
            sectionNameKeyPath: nil,
            cacheName: CoreDataStack.Cache.bookmarks.rawValue)
        viewModel.fetchedResultsController?.delegate = self
        try? viewModel.fetchedResultsController?.performFetch()
    }
    
    //MARK: Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch HomeViewModel.SegueID(rawValue: segue.identifier!) {
        case .goToCity:
            if let vc = segue.destination as? ForecastViewController,
               let index = tableView.indexPathForSelectedRow, let city = viewModel.fetchedResultsController?.object(at: index)  {
                vc.viewModel.city = city
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
        return viewModel.fetchedResultsController?.sections?.count ?? 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.fetchedResultsController?.sections?[section].numberOfObjects ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: HomeViewModel.TableViewReuseID.bookmarkedItem.rawValue, for: indexPath)
        if let bookmark = viewModel.fetchedResultsController?.object(at: indexPath) {
            cell.textLabel?.text = bookmark.title
            cell.detailTextLabel?.text = bookmark.subtitle
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "bookmarks".localized
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        switch editingStyle {
        case .delete: BookmarkedLocation.delete(viewModel.fetchedResultsController?.object(at: indexPath))
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


