//
//  register.swift
//  MyGarageApp
//
//  Created by Stefano on 25/05/17.
//  Copyright © 2017 Stefano Pedroli. All rights reserved.
//

import UIKit


enum RegistrationFormErrorType {
    case userEmptyField
    case passwordEmptyField
}

enum LoginFormErrorType {
    case userEmptyField
    case passwordEmptyField
}

/*
    //register page error
    12 : "username field empty",
    13 : "password field empty",
    14 : "confirm password field empty",
    15 : "password didn't pay",
    16 : "you don't accept term and condition!",
    17 : "username already exist"*/



class RegisterPage: UIViewController, UIPopoverPresentationControllerDelegate {
    
    @IBOutlet weak var logo: UIImageView!
    @IBOutlet weak var lblUsername: UITextField!
    @IBOutlet weak var usernameError: UILabel!
    @IBOutlet weak var lblPassword: UITextField!
    @IBOutlet weak var passwordError: UILabel!
    @IBOutlet weak var lblConfirmPassword: UITextField!
    @IBOutlet weak var confirmPasswordError: UILabel!
    @IBOutlet weak var condition: UISwitch!
    @IBOutlet weak var btnRegister: UIButton!
    @IBOutlet weak var AutenticationError: UIView!
    @IBOutlet weak var AutenticationErrorLabel: UILabel!
    @IBOutlet weak var confirmError: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        AutenticationError.isHidden = true
        logo.image = UIImage(named: "logo")
        usernameError.isHidden = true
        passwordError.isHidden = true
        confirmPasswordError.isHidden = true
        confirmError.isHidden = true
        
    }
    
    @IBAction func usernameControll(_ sender: Any) {
        checkUserName() { result in
            //non c'è niente da fare...
        }
        

    }
    
    
     func checkUserName(onComplete:@escaping ( _ result:Bool) -> ()) {
        if (lblUsername.text?.isEmpty)! {
            printErrorFunction(autenticationErrorLabel: AutenticationErrorLabel, autenticationError: AutenticationError, relativeLabel: usernameError,numberOfError: 15 )
            return
        }
        let checker = AutenticationService(user: lblUsername.text!)
        checker.checkUsername() { result in
            print("Risultato utente già esistente: \(result)")
            
            if result {
                DispatchQueue.main.async {
                self.printErrorFunction(autenticationErrorLabel: self.AutenticationErrorLabel, autenticationError: self.AutenticationError, relativeLabel: self.usernameError, numberOfError: 17)
                }
            } else {
                DispatchQueue.main.async {
                self.AutenticationError.isHidden = true
                self.usernameError.text = ""
                self.usernameError.isHidden = true
                }
            }
         
            onComplete(result)
        }
        
        
        
    }
    
    @IBAction func passwordControll(_ sender: Any) {
        
        if (lblPassword.text?.isEmpty)! {
            
            printErrorFunction(autenticationErrorLabel: AutenticationErrorLabel, autenticationError: AutenticationError, relativeLabel: passwordError, numberOfError: 13)
            
        } else {
            passwordError.isHidden = true
        }
        
    }
    
    @IBAction func confirmPasswordControll(_ sender: Any) {
        
        if (lblConfirmPassword.text?.isEmpty)! {
            
            printErrorFunction(autenticationErrorLabel: AutenticationErrorLabel, autenticationError: AutenticationError, relativeLabel: confirmPasswordError, numberOfError: 14)
        } else {
            self.AutenticationError.isHidden = true
            confirmPasswordError.isHidden = true
        }
        
    }
    
    
    
    @IBAction func addUser(_ sender: Any) {
        
        checkUserName() { result in
            print("risultato funzione checkUserName: \(result)")
            if !result {
                if !self.condition.isOn {
                    self.printErrorFunction(autenticationErrorLabel: self.AutenticationErrorLabel, autenticationError: self.AutenticationError, relativeLabel: self.confirmError, numberOfError: 16)
                } else {
                    self.AutenticationError.isHidden = true
                    self.confirmError.text = ""
                    self.confirmError.isHidden = true
                }
                
                if !(self.lblUsername.text?.isEmpty)! && !(self.lblPassword.text?.isEmpty)! && !(self.lblConfirmPassword.text?.isEmpty)! && self.condition.isOn && !result{
                    
                    if self.lblPassword.text == self.lblConfirmPassword.text {
                        
                        addANewUser(username: self.lblUsername.text!, password: self.lblPassword.text!) { result in
                            print(result)
                            if result {
                                DispatchQueue.main.async {
                                    //correct add user
                                    self.AutenticationError.backgroundColor = UIColor.green
                                    self.AutenticationErrorLabel.text = "Utente aggiunto con successo"
                                    //self.output.text = "Login avvenuto con successo"
                                    self.AutenticationError.isHidden = false
                                    print("Utente aggiunto con successo")
                                }
                            } else {
                                DispatchQueue.main.async {
                                    //uncorrect add user
                                    self.AutenticationError.backgroundColor = UIColor.red
                                    self.AutenticationErrorLabel.text = "Inserimento utente non andato a buon fine"
                                    self.AutenticationError.isHidden = false
                                    print("Inserimento utente non andato a buon fine")
                                }
                            }
                        }
                        
                    } else {
                        DispatchQueue.main.async {
                        // if password and confirmPassword ar not equal it show an error
                        self.printErrorFunction(autenticationErrorLabel: self.AutenticationErrorLabel, autenticationError: self.AutenticationError, relativeLabel:  self.confirmPasswordError, numberOfError: 15)
                        }
                    }
                    
                } else {
                    DispatchQueue.main.async {
                    //if someone click register first of all, message of empty field text are not shown so here they are shown
                    self.usernameControll(Any.self)
                    self.passwordControll(Any.self)
                    self.confirmPasswordControll(Any.self)
                    }
                }

            }
        }
        
        
    } // END addUser Button
    
    func printErrorFunction(autenticationErrorLabel: UILabel, autenticationError: UIView, relativeLabel: UILabel, numberOfError:Int ){
        //output message
        AutenticationError.isHidden = true
        relativeLabel.isHidden = false
        relativeLabel.text = errors[numberOfError]
        print(errors[numberOfError]!)
    }
    
    
    func showErrorOnUserLabel() {
    }
    
    func showErrorOnPwdLabel() {
    }
    
}
