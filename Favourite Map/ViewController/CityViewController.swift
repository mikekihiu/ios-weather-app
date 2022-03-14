//
//  CityViewController.swift
//  Favourite Map
//
//  Created by Mike on 13/11/2020.
//

import UIKit

class CityViewController: UIViewController {

    private var forecasts: [Forecast]? {
        didSet {
            if todaysForecast == nil { return }
            tableView.reloadData()
            showForecast()
        }
    }
    
    private var todaysForecast: SingleForecast? {
        didSet {
            if forecasts == nil { return }
            tableView.reloadData()
            showForecast()
        }
    }
    
    var city: BookmarkedLocation?

    @IBOutlet weak var weatherLabel: UILabel!
    @IBOutlet weak var weatherIcon: UIImageView!
    @IBOutlet weak var weatherBackground: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = .clear
        tableView.register(HeaderView.self, forHeaderFooterViewReuseIdentifier: HeaderView.identifier)
        
        if !WeatherAPI.validateApiKey() {
            showApiError()
            return
        }
        if let city = city {
//            navigationItem.title = city.title
            indicator.startAnimating()
            WeatherAPI.get5DayForecast(lat: city.lat, lon: city.lon, completion: handleApiReponse(_:_:))
            WeatherAPI.getTodaysForecast(lat: city.lat, lon: city.lon, completion: handleTodaysForecast(_:_:))
        }
    }
    
    private func showForecast() {
        guard let today = todaysForecast, let forecast = today.forecast,
        let condition = WeatherCondition(rawValue: forecast) else { return }
        let attrs = NSMutableAttributedString(string: "\(today.temperature(.mid).asWholeNumber)°", attributes: [.font: UIFont.systemFont(ofSize: 48, weight: .bold)])
        let conditionAttrs = NSAttributedString(string: "\n\(condition.text.uppercased())", attributes: [.font: UIFont.systemFont(ofSize: 20, weight: .semibold)])
        attrs.append(conditionAttrs)
        weatherLabel.attributedText = attrs
        switch condition {
        case .rainy:
            weatherIcon.image = UIImage(named: "rainy")
            weatherBackground.backgroundColor = UIColor(named: "rainy")
        case .cloudy:
            weatherIcon.image = UIImage(named: "cloudy")
            weatherBackground.backgroundColor = UIColor(named: "cloudy")
        case .sunny:
            weatherIcon.image = UIImage(named: "sunny")
            weatherBackground.backgroundColor = UIColor(named: "sunny")
        }
    }
    
    private func handleTodaysForecast(_ forecast: SingleForecast?, _ error: Error?) {
        guard error == nil else {
            showError(error)
            return
        }
        todaysForecast = forecast
    }
    
    func handleApiReponse(_ forecasts: [Forecast]?, _ error: Error?) {
        indicator.stopAnimating()
        guard error == nil else {
            showError(error)
            return
        }
        self.forecasts = forecasts
    }
    
    func showApiError() {
        let vc = UIAlertController(title: "Required!", message: "Set API_KEY at WeatherAPI.swift and run the app again", preferredStyle: .alert)
        vc.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
            self.navigationController?.popViewController(animated: true)
        }))
        present(vc, animated: true, completion: nil)
    }
}


//MARK: TableView Delegate & Datasource
extension CityViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        forecasts?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: DayCell.identifier) as? DayCell
        else { return UITableViewCell() }
        cell.configure(with: forecasts?[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let header = tableView.dequeueReusableHeaderFooterView(
            withIdentifier: HeaderView.identifier) as? HeaderView else { return nil }
        header.configure(with: todaysForecast)
        return header
    }
}
