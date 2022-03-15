//
//  HeaderLabel.swift
//  Favourite Map
//
//  Created by Mike on 14/03/2022.
//

import UIKit

class HeaderLabel: UILabel {

    override init(frame: CGRect) {
        super.init(frame: frame)
        setUp()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    private func setUp() {
        translatesAutoresizingMaskIntoConstraints = false
        numberOfLines = 2
    }
    
    func configure(value: String, intensity: TemperatureIntensity) {
        let attrs = NSMutableAttributedString(string: "\(value)°", attributes: [.font: UIFont.systemFont(ofSize: 15, weight: .bold)])
        let textAttrs = NSAttributedString(string: "\n\(intensity.text)", attributes: [.font: UIFont.systemFont(ofSize: 14, weight: intensity == .mid ? .semibold : .regular)])
        attrs.append(textAttrs)
        attributedText = attrs
        textAlignment = intensity == .min ? .left : intensity == .max ? .right : .center
    }
}
