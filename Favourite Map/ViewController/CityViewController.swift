//
//  CityViewController.swift
//  Favourite Map
//
//  Created by Mike on 13/11/2020.
//

import UIKit

class CityViewController: UIViewController {
    
    private enum ReuseID: String {
        case DateCell
    }
    private var forecasts: [Forecast]? {
        didSet {
            collectionView.reloadData()
            showForecast(selectedRow)
        }
    }
    
    private var selectedRow = 0
    var city: BookmarkedLocation?

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var lbCityName: UILabel!
    @IBOutlet weak var lbDate: UILabel!
    @IBOutlet weak var lbTemperature: UILabel!
    @IBOutlet weak var lbDescription: UILabel!
    @IBOutlet weak var lbOther: UILabel!
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        collectionView.dataSource = self
        collectionView.delegate = self
        if !WeatherAPI.validateApiKey() {
            showApiError()
            return
        }
        if let city = city {
            navigationItem.title = city.title
            indicator.startAnimating()
            WeatherAPI.get5DayForecast(lat: city.lat, lon: city.lon, completion: handleApiReponse(_:_:))
        }
    }
    
    func handleApiReponse(_ forecasts: [Forecast]?, _ error: Error?) {
        indicator.stopAnimating()
        guard error == nil else {
            showError(error)
            return
        }
        self.forecasts = forecasts
    }
    
    func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: date)
    }
    
    func showForecast(_ row: Int) {
        if let forecast = forecasts?[row] {
            lbCityName.text = forecast.city
            lbDate.text = formatDate(forecast.date)
            lbTemperature.text = "\(forecast.temperature)°\(WeatherAPI.getTemperatureUnit())"
            lbDescription.text = forecast.description
            lbOther.text = "Humidity \(forecast.humidity)% | Wind speed \(forecast.windSpeed) \(WeatherAPI.getSpeedUnit())"
        }
    }
    
    func showApiError() {
        let vc = UIAlertController(title: "Required!", message: "Set API_KEY at WeatherAPI.swift and run the app again", preferredStyle: .alert)
        vc.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
            self.navigationController?.popViewController(animated: true)
        }))
        present(vc, animated: true, completion: nil)
    }
}

//MARK: Extenstions
//MARK: CollectionView Datasource
extension CityViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return forecasts?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ReuseID.DateCell.rawValue, for: indexPath) as! DateCollectionViewCell
        if let forecast = forecasts?[indexPath.row] {
            cell.lbDate.text = formatDate(forecast.date)
        }
        if indexPath.row == selectedRow {
            cell.selectBackGround()
        } else {
            cell.defaultBackground()
        }
        return cell
        
    }
}

//MARK: CollectionView Delegate
extension CityViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        (collectionView.cellForItem(at: indexPath) as? DateCollectionViewCell)?.selectBackGround()
        showForecast(indexPath.row)
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        deselectItem(collectionView, indexPath)
    }
    
    func deselectItem(_ collectionView: UICollectionView, _ indexPath: IndexPath) {
        (collectionView.cellForItem(at: indexPath) as? DateCollectionViewCell)?.defaultBackground()
    }
    
    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        if selectedRow == 0 && indexPath.row != 0 {
            deselectItem(collectionView, IndexPath(row: 0, section: 0))
        }
        selectedRow = indexPath.row
        return true
    }

}
