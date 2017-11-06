//
//  Autentication.swift
//  MyGarageApp
//
//  Created by Stefano Pedroli on 23/05/17.
//  Copyright © 2017 Stefano Pedroli. All rights reserved.
//

import Foundation


class AutenticationService {
    
    var username: String
    var password: String
    
    init(user: String, password: String) {
        self.username = user
        self.password = password
    }
    
    init(user: String) {
        self.username = user
        self.password = ""
    }
    
    func checkUsername(onComplete:@escaping ( _ result:Bool) -> () ) {
        

       downloadJSON() { userData in
            DispatchQueue.main.async {
                //controll existing username
                var trovato = false
                for item in userData {
                    if item["username"] == self.username {
                        trovato = true;
                    }
                }
                print("utente inserito: \(self.username) trovato: \(trovato)")
                onComplete(trovato)
            }
        }
        
    }
    
    
    func checkUser(onComplete:@escaping ( _ result:Bool, _ userId:String) -> ()  ) {
        //TODO: non ho gli utenti, come faccio?
        
        downloadJSON() { userData in
            
            //print(userData)
            var trovato = false
            var id:String = ""
            
            for item in userData {
                if item["username"] == self.username, item["pasword"] == self.password {
                    trovato = true
                    id = item["codUser"]!
                }
            }
            
            //TODO: loop dell'arrey e confonyo del user e password
            onComplete(trovato, id)
        }

        
    }
    
    func downloadJSON(onComplete:@escaping ( _ users:[[String:String]]) -> ())  -> () {
        
        let url = URL(string: "http://mygarage.altervista.org/service.php")!
        let request = URLRequest(url: url)
        
        // modify the request as necessary, if necessary
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data,
                let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [[String:String]]  else {
                    //print("request failed \(String(describing: error))")
                    return
            }
            
            guard let usersData = json else {
                return
            }
            
            onComplete(usersData)
            
        }
        task.resume()
    }
    
}





