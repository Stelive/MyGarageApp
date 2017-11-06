//
//  WebKitViewController.swift
//  MyGarageApp
//
//  Created by Stefano Pedroli on 06/11/17.
//  Copyright © 2017 Stefano Pedroli. All rights reserved.
//

import UIKit
import WebKit

class WebKitViewController: UIViewController, WKUIDelegate {
        
    @IBOutlet weak var webView: WKWebView!
    //var webView: WKWebView!
        
        override func loadView() {
            let webConfiguration = WKWebViewConfiguration()
            webView = WKWebView(frame: .zero, configuration: webConfiguration)
            webView.uiDelegate = self
            view = webView
        }
        override func viewDidLoad() {
            super.viewDidLoad()
            
            let myURL = URL(string: "https://www.google.it/imghp?hl=it")
            let myRequest = URLRequest(url: myURL!)
            webView.load(myRequest)
        }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
