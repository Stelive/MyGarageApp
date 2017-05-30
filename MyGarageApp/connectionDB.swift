//
//  connectionDB.swift
//  MyGarageApp
//
//  Created by Stefano on 24/05/17.
//  Copyright © 2017 Stefano Pedroli. All rights reserved.
//

import Foundation

func addANewUser(username:  String, password: String, onComplete:@escaping ( _ result:Bool) -> ()) {
    
    var success = false
    
    let request = NSMutableURLRequest(url: NSURL(string: "http://mygarage.altervista.org/register.php")! as URL)
    request.httpMethod = "POST"
    
    let postString = "a=\(username)&b=\(password)"
    request.httpBody = postString.data(using: String.Encoding.utf8)
    
    let task = URLSession.shared.dataTask(with: request as URLRequest) {
        data, response, error in
        
        if error != nil {
            print("error=\(String(describing: error))") //prima era solo error, mi ha fatto aggiungere String(describing: ... )
            return
        } else {
            success = true //no error so user is add right
        }
        
        //print("response = \(response)")
        
        let responseString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
        print("responseString = \(String(describing: responseString))")
        
        onComplete(success) //return true if user was add right
        
    }
    task.resume()
    
}

