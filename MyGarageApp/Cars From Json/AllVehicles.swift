//
//  AllVehicles.swift
//  MyGarageApp
//
//  Created by Stefano Pedroli on 22/09/17.
//  Copyright © 2017 Stefano Pedroli. All rights reserved.
//

import UIKit

class AllVehicles: UITableViewController, UISearchBarDelegate, UINavigationControllerDelegate, URLSessionDelegate  {
    
    var pickerData = [String]()
    var modelsData = [[String]]()
    var searchActive : Bool = false
    var filtered = [Make]()
    
    // pickerData = ["BMW", "TOYOTA"...]
    // modelsData = [["modello1","modello2"],["modello1","modello2"]]
    // USARE: grazie all'index row che magari è 1 ovvero: make: "toyota", modles: index 1
    
    var allMakes = [Make]()
    
    @IBOutlet var tableViewVehicles: UITableView!
    @IBOutlet var searchBar: UISearchBar!
    
    let customDismissAnimationController = CustomDismissAnimationController()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        searchBar.delegate = self
        
        parseVehiclesFromAnotherDB() {
            //DispatchQueue.main.sync {
                self.tableViewVehicles.reloadData()
            //}
        }
        
        navigationController?.delegate = self
    }
    
    func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return customDismissAnimationController
    }

    // MARK: - Table view data source
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchActive = true;
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchActive = false;
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchActive = false;
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchActive = false;
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        filtered = allMakes.filter({ (text) -> Bool in
            let tmp: NSString = text.make as NSString
            let range = tmp.range(of: searchText, options: NSString.CompareOptions.caseInsensitive)
            return range.location != NSNotFound
        })
        
        if(filtered.count == 0){
            searchActive = false;
        } else {
            searchActive = true;
        }
        self.tableViewVehicles.reloadData()
    }


    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if(searchActive) {
            return filtered.count
        }
        return allMakes.count
    }
    
    func parseVehiclesFromAnotherDB(onComplete:@escaping () -> () ) -> () {
        if let JSONData = try? Data(contentsOf: URL(string: "http://mygarage.altervista.org/json_data.json")!) {
            do {
                let parsed = try JSONSerialization.jsonObject(with: JSONData, options: .mutableContainers) as? NSArray
                var currentMake: String = ""
                //var arrayOfModelsOfOneMake = [String]()
                let make = Make(make: "")
                
                for obj in parsed! {
                    if let dict = obj as? NSDictionary {
                        // Now reference the data you need using:
                        //var thisMake = dict.value(forKey: "make") as! String
                        let thisMake = ((dict.value(forKey: "make") as! String).lowercased()).capitalizingFirstLetter()
                        //let model = dict.value(forKey: "model") as! String
                        //let year = dict.value(forKey: "year") as! Int
                        
                        //let make = Make(make: dict.value(forKey: "make") as! String)
                        let modelOfVehicle = Model(model: ((dict.value(forKey: "model") as! String).lowercased()).capitalizingFirstLetter(), year: dict.value(forKey: "year") as! Int)
 
                        if currentMake == "" {
                            currentMake = thisMake
                            //pickerData.append("\(make)(\(year))")
                            //allMakes.append(Make(make: make))
                            make.make = thisMake
                            make.models.append(modelOfVehicle)
                        } else {
                            if currentMake == thisMake {
                                make.models.append(modelOfVehicle)
                            } else {
                                //Siamo alla marca dopo
                                let newMake = Make(make: make.make) //Qua servirebbe un metodo che non passi per referenza...
                                newMake.models =  make.models //Altrimenti mi tocca fare così
                                allMakes.append(newMake) //aggiungo all'array globale la marca precedente (perchè solo ora sappiamo che sono finite i modelli
                                currentMake = thisMake
                                make.make = thisMake
                                make.models.removeAll()
                                make.models.append(modelOfVehicle)
                            }
                        }
                    }
                }
                        
            } catch let parseError {
                print(parseError)
            }
        }
        onComplete()
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "mycell", for: indexPath) as! MakeViewCell

        if(searchActive){
            cell.make.text = "\(filtered[indexPath.row].make)(\(filtered[indexPath.row].models[0].year))"
            let n = indexPath.row
            if n % 2 == 0 {
                cell.make.textColor = UIColor(hex: "9c6f24")
            }
        } else {
            let n = indexPath.row
            if n % 2 == 0 {
                cell.make.textColor = UIColor(hex: "9c6f24")
            }
            cell.make.text = "\(allMakes[indexPath.row].make)(\(allMakes[indexPath.row].models[0].year))"
        }

        return cell
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.performSegue(withIdentifier: "GoToModel", sender: self)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "GoToModel"{
            if let nextViewController = segue.destination as? ChooseModel{
                let indexPath = self.tableViewVehicles.indexPathForSelectedRow
                var make:String = ""
                if(searchActive){
                    make = filtered[(indexPath?.row)!].make
                } else {
                    make = allMakes[(indexPath?.row)!].make
                }
                nextViewController.titlePage = make
            
                if(searchActive){
                    nextViewController.allModelsOfOneMake = filtered[(indexPath?.row)!].models
                    nextViewController.year = filtered[(indexPath?.row)!].models[0].year
                } else {
                    nextViewController.allModelsOfOneMake = allMakes[(indexPath?.row)!].models
                    nextViewController.year = allMakes[(indexPath?.row)!].models[0].year
                }
                nextViewController.allMakes = allMakes
            }
        }
    }

}

class ChooseModel: UITableViewController {
    
    var allModelsOfOneMake = [Model]()
    var allMakes = [Make]()
    var year: Int = 0
    
    var titlePage: String? = "Chose Models: "
    
    @IBOutlet var tableViewVehicles: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = titlePage

    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return allModelsOfOneMake.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "mycell", for: indexPath) as! MakeViewCell
        
        cell.make.text = allModelsOfOneMake[indexPath.row].model
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.performSegue(withIdentifier: "goToAddNewVehicle", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "goToAddNewVehicle"{
            if let nextViewController = segue.destination as? AddVehicle{
                let indexPath = self.tableViewVehicles.indexPathForSelectedRow
                
                // Creo un oggetto di tipo Auto() e lo passo alla schermata successiva
                let auto = Auto()
                auto.make = titlePage!
                auto.model = allModelsOfOneMake[(indexPath?.row)!].model
                auto.year = allModelsOfOneMake[(indexPath?.row)!].year
                auto.imgURL = "http://mygarage.altervista.org/img/default.jpg"
                nextViewController.autoFromDB = auto
                
                nextViewController.fromWhatView = "choseModel"
                
            }
        } else if segue.identifier == "addNewModel" {
            if let nextViewController = segue.destination as? AddVehicle{
                
                // Creo un oggetto di tipo Auto() e lo passo alla schermata successiva
                let auto = Auto()
                auto.make = titlePage!
                auto.year = year
                auto.imgURL = "http://mygarage.altervista.org/img/default.jpg"
                nextViewController.autoFromDB = auto
                
                nextViewController.fromWhatView = "allVehicles"
    
            }
        }
    }
    
}


class MakeViewCell: UITableViewCell {
    
    @IBOutlet weak var make: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}


class Make{
    var make: String
    var models = [Model]()
    
    init(make: String) {
        self.make = make
    }
}


class Model {
    var model: String
    var year: Int
    
    init(model: String, year: Int) {
        self.model = model
        self.year = year
    }
    
}

