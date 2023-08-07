//
//  ViewController+.swift
//  Favourite Map
//
//  Created by Mike on 13/11/2020.
//

import UIKit

extension UIViewController {
    
    func showError(_ error: Error?) {
        let alert = UIAlertController(
            title: "error".localized, message: error?.localizedDescription ?? "generic-error".localized, preferredStyle: .alert)
        alert.addAction(.init(title: "ok".localized, style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}
