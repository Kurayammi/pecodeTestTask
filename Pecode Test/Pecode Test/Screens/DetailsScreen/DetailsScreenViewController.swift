//
//  DetailsScreenViewController.swift
//  Pecode Test
//
//  Created by Kito on 11/5/22.
//

import UIKit
import WebKit

final class DetailsScreenViewController: UIViewController, WKUIDelegate {
    
    @IBOutlet private var webViewContent: WKWebView!
    
    var urlPath: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        webViewContent.uiDelegate = self
        
        let url = URL(string: urlPath)!
        
        let request = URLRequest(url: url)
        
        webViewContent.load(request)
    }
    
}
