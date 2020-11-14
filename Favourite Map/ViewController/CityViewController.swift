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
            showForecast()
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
    
    override func viewDidLoad() {
        collectionView.dataSource = self
        collectionView.delegate = self
        if let city = city {
            navigationItem.title = city.title
            WeatherAPI.get5DayForecast(lat: city.lat, lon: city.lon, completion: handleApiReponse(_:_:))
        }
    }
    
    func handleApiReponse(_ forecasts: [Forecast]?, _ error: Error?) {
        guard error == nil else {
            showError(error)
            return
        }
        self.forecasts = forecasts
    }
    
    func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter.string(from: date)
    }
    
    func showForecast() {
        if let forecast = forecasts?[selectedRow] {
            lbCityName.text = forecast.city
            lbDate.text = formatDate(forecast.date)
            lbTemperature.text = "\(forecast.temperature)°\(WeatherAPI.getTemperatureUnit())"
            lbDescription.text = forecast.description
            lbOther.text = "Humidity \(forecast.humidity)% | Wind speed \(forecast.windSpeed) \(WeatherAPI.getSpeedUnit())"
        }
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
        if selectedRow == indexPath.row {
            cell.selectedBackGround()
        } else {
            cell.defaultBackground()
        }
        return cell
        
    }
}

//MARK: CollectionView Delegate
extension CityViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        showForecast()
        collectionView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        selectedRow = indexPath.row
        return true
    }

}
