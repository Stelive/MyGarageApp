//
//  extension.swift
//  MyGarageApp
//
//  Created by Stefano Pedroli on 10/10/17.
//  Copyright © 2017 Stefano Pedroli. All rights reserved.
//

import Foundation
import UIKit

// MARK : EXTENSION

extension String {
    // funzione che capitalizza la prima lettera
    func capitalizingFirstLetter() -> String {
        return prefix(1).uppercased() + dropFirst()
    }
    
    mutating func capitalizeFirstLetter() {
        self = self.capitalizingFirstLetter()
    }
    
    // funzione che fa l'opposto della precedente
    func decapitalizingFirstLetter() -> String {
        return prefix(1).lowercased() + dropFirst()
    }
    
    mutating func decapitalizeFirstLetter() {
        self = self.decapitalizingFirstLetter()
    }
    
    //funzione che prepara la stringa per essere salvata sul db senza gli spazi che conviene fidatevi
    func removeSpaceAndMakeCamelCase() -> String {
        let stringInputArr = self.components(separatedBy: " ")
        var stringNeed = ""
        
        for string in stringInputArr {
            stringNeed += string.capitalizingFirstLetter()
        }
        return stringNeed
    }
}

// HEX COLOR
extension UIColor {
    convenience init(hex: String) {
        let scanner = Scanner(string: hex)
        scanner.scanLocation = 0
        
        var rgbValue: UInt64 = 0
        
        scanner.scanHexInt64(&rgbValue)
        
        let r = (rgbValue & 0xff0000) >> 16
        let g = (rgbValue & 0xff00) >> 8
        let b = rgbValue & 0xff
        
        self.init(
            red: CGFloat(r) / 0xff,
            green: CGFloat(g) / 0xff,
            blue: CGFloat(b) / 0xff, alpha: 1
        )
    }
}

//estensione che fa perdere peso all'immagine per dare meno problemi di dimensioni
extension UIImage {
    func resized(withPercentage percentage: CGFloat) -> UIImage? {
        let canvasSize = CGSize(width: size.width * percentage, height: size.height * percentage)
        UIGraphicsBeginImageContextWithOptions(canvasSize, false, scale)
        defer { UIGraphicsEndImageContext() }
        draw(in: CGRect(origin: .zero, size: canvasSize))
        return UIGraphicsGetImageFromCurrentImageContext()
    }
    func resized(toWidth width: CGFloat) -> UIImage? {
        let canvasSize = CGSize(width: width, height: CGFloat(ceil(width/size.width * size.height)))
        UIGraphicsBeginImageContextWithOptions(canvasSize, false, scale)
        defer { UIGraphicsEndImageContext() }
        draw(in: CGRect(origin: .zero, size: canvasSize))
        return UIGraphicsGetImageFromCurrentImageContext()
    }
}
