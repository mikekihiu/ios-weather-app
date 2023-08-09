//
//  String+.swift
//  Favourite Map
//
//  Created by Mike on 14/03/2022.
//

import Foundation

extension String {
    
    var asWholeNumber: String {
        guard let number = Double(self) else { return self }
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 0
        formatter.roundingMode = .halfUp
        return formatter.string(from: NSNumber(value: number)) ?? self
    }
    
    var localized: String {
        NSLocalizedString(self, comment: "")
    }
}
