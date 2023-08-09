//
//  UIStoryboard+.swift
//  Favourite Map
//
//  Created by Mike Kihiu on 07/08/2023.
//

import UIKit

extension UIStoryboard {
    
    static func scene<T: UIViewController>(named: String? = nil, type: T.Type) -> T {
        UIStoryboard(name: "Main", bundle: nil)
            .instantiateViewController(withIdentifier: named ?? String(describing: type)) as? T ?? T()
    }
}
