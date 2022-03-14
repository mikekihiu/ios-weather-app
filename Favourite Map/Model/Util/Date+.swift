//
//  Date+.swift
//  Favourite Map
//
//  Created by Mike on 14/03/2022.
//

import Foundation

extension Date {
    
    var asWeekDay: String? {
        DateFormatter().weekdaySymbols[Calendar.current.component(.weekday, from: self)]
    }
}
