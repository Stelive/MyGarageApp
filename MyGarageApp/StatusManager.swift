//
//  StatusManager.swift
//  MyGarageApp
//
//  Created by Stefano Pedroli on 04/07/17.
//  Copyright © 2017 Stefano Pedroli. All rights reserved.
//

import Foundation

//Singleton
class StatusManager {
    
    static let sharedInstance = StatusManager()
    
    var username: String = ""
    var password: String = ""
    var codUtente: String = ""
    
    private init() {} //This prevents others from using the default '()' initializer for this class.
    
}
