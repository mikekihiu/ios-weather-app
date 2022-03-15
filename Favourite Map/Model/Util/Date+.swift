//
//  Date+.swift
//  Favourite Map
//
//  Created by Mike on 14/03/2022.
//

import Foundation

extension Date {
    
    var asWeekDay: String? {
        let format = DateFormatter()
        format.dateFormat = "EEEE"
        return format.string(from: self)
    }
}
