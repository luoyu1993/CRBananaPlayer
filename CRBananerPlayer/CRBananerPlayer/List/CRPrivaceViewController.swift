//
//  CRPrivaceViewController.swift
//  CRBananerPlayer
//
//  Created by CRMO on 2018/10/10.
//  Copyright © 2018 CRMO. All rights reserved.
//

import UIKit
import WebKit

class CRPrivaceViewController: UIViewController {

    var webView : WKWebView = WKWebView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(webView)
        webView.frame = self.view.bounds
        let request = URLRequest.init(url: URL.init(string: "https://www.freeprivacypolicy.com/privacy/view/f87a42c0b8dfd9826af1fb914a805abf")!)
        webView.load(request)
    }

}
