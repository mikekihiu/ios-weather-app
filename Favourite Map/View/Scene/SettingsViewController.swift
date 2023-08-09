//
//  SettingsViewController.swift
//  Favourite Map
//
//  Created by Mike on 14/11/2020.
//

import UIKit

class SettingsViewController: UIViewController {
    
    @IBOutlet weak var viewUnitSystem: UIView!
    @IBOutlet weak var viewClearLocations: UIView!
    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var lbUnit: UILabel!
    
    let unitSystems: [WeatherAPI.UnitSystem] = [.standard, .metric, .imperial]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewUnitSystem.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tappedUnitSystem)))
        viewClearLocations.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tappedClearLocations)))
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(hidePickerView(_:))))
        
        lbUnit.text = WeatherAPI.getUnitSystem()
        
        pickerView.dataSource = self
        pickerView.delegate = self
        pickerView.selectRow(unitSystems.firstIndex(of: WeatherAPI.UnitSystem(rawValue: lbUnit.text!)!)!, inComponent: 0, animated: false)
    }
    
    @objc func tappedUnitSystem() {
        pickerView.isHidden = false
    }
    
    @objc func tappedClearLocations() {
        let alertVC = UIAlertController(title: "clear".localized, message: "confirm-clear-bookmarks".localized, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "cancel".localized, style: .cancel, handler: nil))
        alertVC.addAction(UIAlertAction(title: "clear".localized, style: .destructive, handler: {_ in
            BookmarkedLocation.clearAll()
            UserDefaults.standard.set(true, forKey: UserDefaults.Keys.hasJustClearedBookmarks.rawValue)
        }))
        present(alertVC, animated: true, completion: nil)
    }

    @objc func hidePickerView(_ sender: UIView) {
        if pickerView.isHidden { return }
        if sender != pickerView {
            pickerView.isHidden = true
            return
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
            self.pickerView.isHidden = true
        })
    }
}

//MARK: Extensions
//MARK: Pickerview data source
extension SettingsViewController: UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return unitSystems.count
    }

}

//MARK: Pickerview data delegate
extension SettingsViewController: UIPickerViewDelegate {
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        hidePickerView(pickerView)
        lbUnit.text = unitSystems[row].rawValue
        WeatherAPI.updateUnitSystem(lbUnit.text!)
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return unitSystems[row].rawValue
    }
}
