//
//  WebKitViewController.swift
//  MyGarageApp
//
//  Created by Stefano Pedroli on 06/11/17.
//  Copyright © 2017 Stefano Pedroli. All rights reserved.
//

import UIKit
import WebKit
import Photos

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
            
            let longPressRecognizer = UILongPressGestureRecognizer(target: self, action: Selector(("longPressed:")))
            longPressRecognizer.minimumPressDuration = 0.5
            webView.addGestureRecognizer(longPressRecognizer)
            
            let myURL = URL(string: "https://www.google.it/imghp?hl=it")
            let myRequest = URLRequest(url: myURL!)
            webView.load(myRequest)
        }
    
    
    func webViewDidClose(_ webView: WKWebView) {
        self.performSegue(withIdentifier: "unwindToMenu", sender: self)
    }
    
    func longPressed(sender: UILongPressGestureRecognizer) {
        print("Save img")
        //UIImageWriteToSavedPhotosAlbum(imageview.image, self, "image:didFinishSavingWithError:contextInfo:", nil)
    }
    
    func image(image: UIImage!, didFinishSavingWithError error: NSError!, contextInfo: AnyObject!) {
        if (error != nil) {
            // Something wrong happened.
        } else {
            // Everything is alright.
        }
    }
    
    func webView(_ webView: WKWebView, runJavaScriptAlertPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping () -> Void) {
        print("sono entrato nell'alert di javascript")
    }
    
    func completionFunction(param: AnyObject)
    {
        print("entrato in copletion Function!")
    }
    
    override func viewDidLayoutSubviews() {
        if (!webView.isLoading) {
            let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main",bundle: nil)
            let nextVC = mainStoryboard.instantiateViewController(withIdentifier: "myNavigationController") as? MyNavigationController
            present(nextVC!, animated: true, completion: nil)
        }
    }

    
    /*override func viewDidDisappear(_ animated: Bool) {
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main",bundle: nil)
        let nextVC = mainStoryboard.instantiateViewController(withIdentifier: "listOfCars") as? ListOfCarsController
        present(nextVC!, animated: true, completion: nil)
    }
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        self.performSegue(withIdentifier: "unwindToMenu", sender: self)
    }*/

}
