//
//  UITableView+.swift
//  Favourite Map
//
//  Created by Mike on 14/03/2022.
//

import UIKit

extension UITableViewCell {
    
    static var identifier: String {
        return String(describing: self)
    }
}

extension UITableViewHeaderFooterView {
    
    static var identifier: String {
        return String(describing: self)
    }
}
