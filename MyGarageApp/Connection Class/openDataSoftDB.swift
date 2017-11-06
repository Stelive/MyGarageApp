//
//  openDataSoftDB.swift
//  MyGarageApp
//
//  Created by Stefano Pedroli on 21/09/17.
//  Copyright © 2017 Stefano Pedroli. All rights reserved.
//

import Foundation

func parseFromOpenDataSoft(onComplete:@escaping ( _ vheicles:NSDictionary) -> ())  -> () {

    if let JSONData = try? Data(contentsOf: URL(string: "http://mygarage.altervista.org/vehicles.json")!) {
        do {
            let parsed = try JSONSerialization.jsonObject(with: JSONData, options: .mutableContainers) as? NSArray
            for obj in parsed! {
                if let dict = obj as? NSDictionary {
                    // Now reference the data you need using:
                    let id = dict.value(forKey: "title")
                    print(id ?? "non ha funzionato")
                }
            }
        } catch let parseError {
            print(parseError)
        }
    
    }
}

