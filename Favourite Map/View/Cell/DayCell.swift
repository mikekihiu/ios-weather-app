//
//  DayCell.swift
//  Favourite Map
//
//  Created by Mike on 14/03/2022.
//

import UIKit

class DayCell: UITableViewCell {

    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var icon: UIImageView!
    
}

extension DayCell {
    
    func configure(with forecast: Forecast?) {
        dayLabel.text = forecast?.date.asWeekDay
        temperatureLabel.text = "\(forecast?.temperature[1].asWholeNumber ?? "")°"
        guard let weather = forecast?.main, let condition = WeatherCondition(rawValue: weather) else { return }
        switch condition {
        case .rainy, .drizzle:
            icon.image = UIImage(named: "rain")
        case .cloudy:
            icon.image = UIImage(named: "partlysunny")
        case .sunny:
            icon.image = UIImage(named: "clear")
        }
    }
}
