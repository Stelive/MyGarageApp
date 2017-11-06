//
//  FirstViewOfSideMenuController.swift
//  MyGarageApp
//
//  Created by Stefano Pedroli on 12/10/17.
//  Copyright © 2017 Stefano Pedroli. All rights reserved.
//

import UIKit

class FirstViewSideMenu: UIViewController, ENSideMenuDelegate {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.sideMenuController()?.sideMenu?.delegate = self
    }
    
    @IBAction func toggleSideMenuBtn(_ sender: UIBarButtonItem) {
        toggleSideMenuView()
    }
    
    // MARK: - ENSideMenu Delegate
    func sideMenuWillOpen() {
        //print("sideMenuWillOpen")
    }
    
    func sideMenuWillClose() {
        //print("sideMenuWillClose")
    }
    
    func sideMenuShouldOpenSideMenu() -> Bool {
        //print("sideMenuShouldOpenSideMenu")
        return true
    }
    
    func sideMenuDidClose() {
        //print("sideMenuDidClose")
    }
    
    func sideMenuDidOpen() {
        //print("sideMenuDidOpen")
    }
}
