//
//  DateCollectionViewCell.swift
//  Favourite Map
//
//  Created by Mike on 13/11/2020.
//

import UIKit

class DateCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var lbDate: UILabel!
    
    func defaultBackground() {
        layer.cornerRadius = frame.height * 0.375
        layer.backgroundColor = UIColor.systemBackground.cgColor
        layer.borderWidth = 1
        layer.borderColor = UIColor.secondaryLabel.cgColor
        lbDate.textColor = .label
    }
    
    func selectedBackGround() {
        layer.cornerRadius = frame.height * 0.375
        layer.backgroundColor = UIColor.systemBlue.cgColor
        layer.borderWidth = 0
        layer.borderColor = UIColor.clear.cgColor
        lbDate.textColor = .white
    }
}
