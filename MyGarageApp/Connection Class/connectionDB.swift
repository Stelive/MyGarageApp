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

func parseAutoFromDb(userId: Int, onComplete:@escaping ( _ users:[[String:String]]) -> ())  -> () {
    
    let url = URL(string: "http://mygarage.altervista.org/listOfCars.php?userId=\(userId)")!
    let request = URLRequest(url: url)
    
    // modify the request as necessary, if necessary
    
    let task = URLSession.shared.dataTask(with: request) { data, response, error in
        guard let data = data,
            let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [[String:String]]  else {
                //print("request failed \(String(describing: error))")
                return
        }
        
        /*for item in json! {
            for (key,value) in item {
                print("\(key): \(value)")
            }
        }*/
        
        /*guard let listOfCars = json else {
            return
        }*/
        
        onComplete(json!)
        
    }
    task.resume()
}

func removeAutoFromDb(imgAuto: String, userId: Int, onComplete:@escaping (  _ result:Bool, _ error: String) -> ()) {
    
    var success = false
    
    let url = URL(string: "http://mygarage.altervista.org/removeAuto.php?userId=\(userId)&imgAuto=\(imgAuto)")!
    let request = URLRequest(url: url)
    
    let task = URLSession.shared.dataTask(with: request as URLRequest) {
        data, response, error in
        
        if error != nil {
            print("error=\(String(describing: error))") //prima era solo error, mi ha fatto aggiungere String(describing: ... )
            return
        } else {
            success = true
        }
        
        //print("response = \(response)")
        
        let responseString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
        print("responseString = \(String(describing: responseString))")
        
        onComplete(success, String(describing: error)) //return true if user was add right
        
    }
    task.resume()

}

//func updateAutoOnDB(codAuto: Int, nomeAuto:  String, modelloAuto: String, annoAuto: String, targaAuto: String, cilindrataAuto: Int, immatricolazioneAuto: Date, onComplete:@escaping ( _ result:Bool) -> ()) {
func updateAutoOnDB(codAuto: Int, nomeAuto:  String, modelloAuto: String, annoAuto: String, targaAuto: String, cilindrataAuto: Int, immatricolazioneAuto: String, latitude: Double, longitude: Double, onComplete:@escaping ( _ result:Bool) -> ()) {
    
    var success = false
    
    let request = NSMutableURLRequest(url: NSURL(string: "http://mygarage.altervista.org/updateAuto.php")! as URL)
    request.httpMethod = "POST"
    
    //let postString = "codAuto=\(codAuto)&nomeAuto=\(nomeAuto)&modelloAuto=\(modelloAuto)$annoAuto=\(annoAuto)&cilindrataAuto=\(cilindrataAuto)&immatricolazioneAuto=\(immatricolazioneAuto)&targaAuto=\(targaAuto)"
    let postString = "codAuto=\(codAuto)&nomeAuto=\(nomeAuto)&modelloAuto=\(modelloAuto)&annoAuto=\(annoAuto)&targaAuto=\(targaAuto)&cilindrataAuto=\(cilindrataAuto)&immatricolazioneAuto=\(immatricolazioneAuto)&latitude=\(latitude)&longitude=\(longitude)"
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


func addAutoOnDB(nomeAuto:  String, modelloAuto: String, annoAuto: String, targaAuto: String, cilindrataAuto: Int, immatricolazioneAuto: String, codUser: String, onComplete:@escaping ( _ result:Bool) -> ()) {
    
    var success = false
    
    let request = NSMutableURLRequest(url: NSURL(string: "http://mygarage.altervista.org/addNewAuto.php")! as URL)
    request.httpMethod = "POST"
    
    //let postString = "codAuto=\(codAuto)&nomeAuto=\(nomeAuto)&modelloAuto=\(modelloAuto)$annoAuto=\(annoAuto)&cilindrataAuto=\(cilindrataAuto)&immatricolazioneAuto=\(immatricolazioneAuto)&targaAuto=\(targaAuto)"
    let postString = "nomeAuto=\(nomeAuto)&modelloAuto=\(modelloAuto)&annoAuto=\(annoAuto)&targaAuto=\(targaAuto)&cilindrataAuto=\(cilindrataAuto)&immatricolazioneAuto=\(immatricolazioneAuto)&codUser=\(codUser)"
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


