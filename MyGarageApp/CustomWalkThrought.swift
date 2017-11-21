//
//  customWalkThrought.swift
//  MyGarageApp
//
//  Created by Stefano Pedroli on 08/11/17.
//  Copyright © 2017 Stefano Pedroli. All rights reserved.
//

import UIKit
import CoreGraphics

class CustomWalkThrought: UIViewController {

    var navController: UINavigationController?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        //Looks for single or multiple taps.
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.dismissView))
        
        //Uncomment the line below if you want the tap not not interfere and cancel other interactions.
        //tap.cancelsTouchesInView = false
        
        view.addGestureRecognizer(tap)
        
        //self.view.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        let subview = createOverlay(frame: view.frame, xOffset: view.frame.width - 30, yOffset: 67, radius: 40)
        view.addSubview(subview)
        subview.layer.pulsate() // non pulsa manco per il cazzo
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    //Calls this function when the tap is recognized.
    @objc func dismissView() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
         self.dismiss(animated: true, completion: nil)
    }
    
    func createOverlay(frame : CGRect, xOffset: CGFloat, yOffset: CGFloat, radius: CGFloat) -> UIView {
        let overlayView = UIView(frame: frame)
        overlayView.alpha = 0.6
        overlayView.backgroundColor = UIColor.black
        
        // Create a path with the rectangle in it.
        let path = CGMutablePath()
        path.addArc(center: CGPoint(x: xOffset, y: yOffset), radius: radius, startAngle: 0.0, endAngle: 2 * 3.14, clockwise: false)
        path.addRect(CGRect(x: 0, y: 0, width: overlayView.frame.width, height: overlayView.frame.height))
        
        let maskLayer = CAShapeLayer()
        maskLayer.backgroundColor = UIColor.white.cgColor
        maskLayer.path = path;
        maskLayer.fillRule = kCAFillRuleEvenOdd
        // Release the path since it's not covered by ARC.
        overlayView.layer.mask = maskLayer
        overlayView.clipsToBounds = true
        
        // Add Arrow
        let imageName = "arrow.png"
        let image = UIImage(named: imageName)
        let imageView = UIImageView(image: image!)
        
        imageView.frame = CGRect(x: frame.width - 160, y: 75, width: 100, height: 200)
        overlayView.addSubview(imageView)
        
        return overlayView
    }
}

