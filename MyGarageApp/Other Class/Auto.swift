//
//  Auto.swift
//  MyGarageApp
//
//  Created by Stefano Pedroli on 17/10/17.
//  Copyright © 2017 Stefano Pedroli. All rights reserved.
//

import Foundation

class Auto {
    
    var make = ""
    var model = ""
    var year: Int = 0
    var imgURL = ""
    var targaFromDB = ""
    var cilindrataFromDB = 0
    var revisioneFromDB = ""
    var codAuto = 0
    var latitude: Float = 45.074486
    var longitude: Float = 7.653723
    
    init() {}
    
    init(codAuto: Int, make: String, model: String, year: Int, imgURL: String, targaFromDB: String, cilindrataFromDB: Int, revisioneFromDB: String, latitudine: Float, longitudine: Float) {
        self.codAuto = codAuto
        self.make = make
        self.model = model
        self.year = year
        self.imgURL = imgURL
        self.targaFromDB = targaFromDB
        self.cilindrataFromDB = cilindrataFromDB
        self.revisioneFromDB = revisioneFromDB
        self.latitude = latitudine
        self.longitude = longitudine
    }
    
}
