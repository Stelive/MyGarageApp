//
//  ViewController.swift
//  MyGarageApp
//
//  Created by Stefano Pedroli on 18/04/17.
//  Copyright © 2017 Stefano Pedroli. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var lblUsername: UITextField!
    @IBOutlet weak var lblPassword: UITextField!
    @IBOutlet weak var usernameError: UILabel!
    @IBOutlet weak var passwordError: UILabel!
    @IBOutlet weak var AutenticationError: UIView!
    @IBOutlet weak var AutenticationErrorLabel: UILabel!
    @IBOutlet weak var addUser: UIButton!
    @IBOutlet weak var logo: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        AutenticationError.isHidden = true
        logo.image = UIImage(named: "logo")
        usernameError.isHidden = true
        passwordError.isHidden = true
    }

    
    @IBAction func loginAction(_ sender: Any) {
        
        var usernameEmpty = false
        var passwordEmpty = false
        usernameError.isHidden = true
        passwordError.isHidden = true
        
        if (lblUsername.text?.isEmpty)! {
            
            //output message
            self.AutenticationError.backgroundColor = UIColor.red
            self.AutenticationErrorLabel.text = "Login errato"
            self.AutenticationError.isHidden = false
            usernameError.isHidden = false
            usernameError.text = errors[10]
            
            print(errors[10]!)
            usernameEmpty = true
        }
        
        if (lblPassword.text?.isEmpty)! {
            
            //output message
            self.AutenticationError.backgroundColor = UIColor.red
            self.AutenticationErrorLabel.text = "Login errato"
            self.AutenticationError.isHidden = false
            passwordError.isHidden = false
            passwordError.text = errors[11]
            
            
            print(errors[11]!)
            passwordEmpty = true
        }
        
        if !usernameEmpty && !passwordEmpty { //don't run code if user and pw field are empty
        
        let checker = AutenticationService(user: lblUsername.text!, password: lblPassword.text!)
        
        checker.checkUser() { result in
            print(result)
            if result {
                DispatchQueue.main.async {
                    self.AutenticationError.backgroundColor = UIColor.green
                    self.AutenticationErrorLabel.text = "Login avvenuto con successo"
                    //self.output.text = "Login avvenuto con successo"
                    self.AutenticationError.isHidden = false
                }
            } else {
                DispatchQueue.main.async {
                    self.AutenticationError.backgroundColor = UIColor.red
                    self.AutenticationErrorLabel.text = "Utente o password non corretti"
                    self.AutenticationError.isHidden = false
                    //self.output.text = "Login errato"
                }
            }
        }
        
        }
        
    } // end loginAction(_ sender: Any)

}

