//
//  ViewController+Extensions.swift
//  Favourite Map
//
//  Created by Mike on 13/11/2020.
//

import UIKit

extension UIViewController {
    
    func showError(_ error: Error?) {
        let alert = UIAlertController.init(title: "Error", message: "\(error?.localizedDescription ?? "Something went wrong.") Please try again later.", preferredStyle: .alert)
        alert.addAction(.init(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}
