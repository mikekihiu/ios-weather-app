//
//  HeaderView.swift
//  Favourite Map
//
//  Created by Mike on 14/03/2022.
//

import UIKit

class HeaderView: UITableViewHeaderFooterView {
    
    private let leftLabel = HeaderLabel()
    private let centerLabel = HeaderLabel()
    private let rightLabel = HeaderLabel()
    
    private let divider = UIView()
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        setUp()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    private func setUp() {
        divider.backgroundColor = .clear
        divider.translatesAutoresizingMaskIntoConstraints = false
        
        [leftLabel, centerLabel, rightLabel, divider].forEach { addSubview($0) }
        let spacing = CGFloat(16)
        NSLayoutConstraint.activate([
            leftLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: spacing),
            leftLabel.trailingAnchor.constraint(equalTo: centerLabel.leadingAnchor, constant: -spacing),
            leftLabel.topAnchor.constraint(equalTo: topAnchor),
            leftLabel.bottomAnchor.constraint(equalTo: divider.topAnchor, constant: -spacing/2),
            
            centerLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            centerLabel.centerYAnchor.constraint(equalTo: leftLabel.centerYAnchor),
            
            rightLabel.leadingAnchor.constraint(equalTo: centerLabel.trailingAnchor, constant: spacing),
            rightLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -spacing),
            rightLabel.centerYAnchor.constraint(equalTo: leftLabel.centerYAnchor),
            
            divider.widthAnchor.constraint(equalTo: widthAnchor),
            divider.heightAnchor.constraint(equalToConstant: 0.5),
            divider.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    func configure(with forecast: SingleForecast?) {
        guard let forecast = forecast else { return }
        leftLabel.configure(value: forecast.temperature(.min), intensity: .min)
        centerLabel.configure(value: forecast.temperature(.mid), intensity: .mid)
        rightLabel.configure(value: forecast.temperature(.max), intensity: .max)
        divider.backgroundColor = .white
    }
}
