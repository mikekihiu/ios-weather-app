//
//  HelpViewController.swift
//  Favourite Map
//
//  Created by Mike on 14/11/2020.
//

import UIKit
import WebKit

class HelpViewController: UIViewController {
    
    @IBOutlet weak var webView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let url = Bundle.main.url(forResource: "help", withExtension: "html") {
            webView.loadFileURL(url, allowingReadAccessTo: url.deletingLastPathComponent())
        }
    }
}
