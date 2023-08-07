//
//  ForecastViewController.swift
//  Favourite Map
//
//  Created by Mike on 13/11/2020.
//

import UIKit

protocol ForecastDelegate: AnyObject {
    func didCompleteNetworkCalls()
    func showError(_ error: Error?)
    func showProgress(_ show: Bool)
}

class ForecastViewController: UIViewController {

    lazy var viewModel = ForecastViewModel(delegate: self)

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
        if viewModel.location != nil {
            showProgress(true)
            viewModel.callWeatherApi()
        }
    }
    
    private func showForecast() {
        guard let today = viewModel.todaysForecast, let forecast = today.forecast,
        let condition = WeatherCondition(rawValue: forecast) else { return }
        let attrs = NSMutableAttributedString(string: "\(today.temperature(.mid).asWholeNumber)°", attributes: [.font: UIFont.systemFont(ofSize: 48, weight: .bold)])
        let conditionAttrs = NSAttributedString(string: "\n\(condition.text.uppercased())", attributes: [.font: UIFont.systemFont(ofSize: 20, weight: .semibold)])
        attrs.append(conditionAttrs)
        weatherLabel.attributedText = attrs
        switch condition {
        case .rainy, .drizzle:
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
    
    func showApiError() {
        let vc = UIAlertController(title: "required".localized, message: "weather-api-key-error".localized, preferredStyle: .alert)
        vc.addAction(UIAlertAction(title: "ok".localized, style: .default, handler: { _ in
            self.navigationController?.popViewController(animated: true)
        }))
        present(vc, animated: true, completion: nil)
    }
}


//MARK: TableView Delegate & Datasource
extension ForecastViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.forecasts?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: DayCell.identifier) as? DayCell
        else { return UITableViewCell() }
        cell.configure(with: viewModel.forecasts?[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let header = tableView.dequeueReusableHeaderFooterView(
            withIdentifier: HeaderView.identifier) as? HeaderView else { return nil }
        header.configure(with: viewModel.todaysForecast)
        return header
    }
}

//MARK: CityDelegate
extension ForecastViewController: ForecastDelegate {
    
    func didCompleteNetworkCalls() {
        tableView.reloadData()
        showForecast()
    }
    
    func showProgress(_ show: Bool) {
        show ? indicator.startAnimating() : indicator.stopAnimating()
    }
}
