//
//  TableView.swift
//  MyGarageApp
//
//  Created by Stefano Pedroli on 27/06/17.
//  Copyright © 2017 Stefano Pedroli. All rights reserved.
//

import UIKit

class ListOfCarsController: UIViewController, UITableViewDataSource, UITableViewDelegate, UIViewControllerTransitioningDelegate, UINavigationControllerDelegate {
    
    var refreshControl: UIRefreshControl!
    var userName = ""
    var password = ""
    var userId = ""
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var myActivity: UIActivityIndicatorView!
    
    var cellData = [[String:String]]()
    let customNavigationAnimationController = CustomNavigationAnimationController()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Refresh
        refreshControl = UIRefreshControl()
        tableView.addSubview(refreshControl)
        // Configure Refresh Control

        // Add Footer
        let footerView = UIView()
        footerView.backgroundColor = UIColor(hex: "#FFCA28")
        tableView.tableFooterView = footerView
        
        userName = StatusManager.sharedInstance.username
        password = StatusManager.sharedInstance.password
        userId = StatusManager.sharedInstance.codUtente
        self.navigationItem.title = "\(userName) Garage"
        
        loadSampleMeals() {
            DispatchQueue.main.sync {
                self.tableView.reloadData()
                self.animateTable()
            }
        }
        //for animation of nexVC
       navigationController?.delegate = self
    }
    
    func doSomething() {
        
        // code to reloadTable:
        cellData = []
        loadSampleMeals() {
            DispatchQueue.main.sync {
                self.tableView.reloadData()
            }
        }
        
        //aggiorna la pagina
        endOfWork()
    }
    
    func endOfWork() {
        refreshControl.endRefreshing()
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if refreshControl.isRefreshing {
            doSomething()
        }
    }
    
    func loadSampleMeals(onComplete:@escaping () -> () ) {
        
        parseAutoFromDb(userId: Int(userId)!) { json in

            var data = [String:String]()
            for item in json {
                for (key,value) in item {
                    data[key] = value
                }
              self.cellData.append(data)
            }
                onComplete()
        }


    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.delegate = self
    }
    
    func animateTable() {
        tableView.reloadData()
        
        let cells = tableView.visibleCells
        let tableHeight: CGFloat = tableView.bounds.size.height
        
        for i in cells {
            let cell: UITableViewCell = i as UITableViewCell
            cell.transform = CGAffineTransform(translationX: 0, y: tableHeight)
        }
        
        var index = 0
        
        for a in cells {
            let cell: UITableViewCell = a as UITableViewCell
            UIView.animate(withDuration: 1.5,
                           delay: 0.05 * Double(index),
                           usingSpringWithDamping: 0.8,
                initialSpringVelocity: 0,
                options: UIViewAnimationOptions(rawValue: 0),
                animations: {
                    cell.transform = CGAffineTransform(translationX: 0, y: 0);
            }, completion: nil)
            index += 1
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //return auto.count
        return cellData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "myTableViewCell", for: indexPath) as! AutoViewCell
        cell.autoName.text = cellData[indexPath.row]["nomeAuto"]
        cell.autoModel.text = cellData[indexPath.row]["modelloAuto"]
        
        /*if let filePath = Bundle.main.path(forResource: "imageName", ofType: "jpg"), let image = UIImage(contentsOfFile: filePath) {
            cell.imgAuto.contentMode = .scaleAspectFit
            cell.imgAuto.image = image
        }*/
        
        
        if let imageName = cellData[indexPath.row]["imgAuto"],
            let checkedUrl = URL(string: "http://mygarage.altervista.org/img/\(imageName)") {
            cell.imgAuto.contentMode = .scaleAspectFit
            downloadImage(url: checkedUrl, img: cell.imgAuto)
        }
        
        return cell
    }
    
    func downloadImage(url: URL, img: UIImageView) {
        print("Download Started")
        getDataFromUrl(url: url) { (data, response, error)  in
            guard let data = data, error == nil else { return }
            print(response?.suggestedFilename ?? url.lastPathComponent)
            print("Download Finished")
            DispatchQueue.main.async() { () -> Void in
                img.image = UIImage(data: data)
            }
        }
    }
    
    func getDataFromUrl(url: URL, completion: @escaping (_ data: Data?, _  response: URLResponse?, _ error: Error?) -> Void) {
        URLSession.shared.dataTask(with: url) {
            (data, response, error) in
            completion(data, response, error)
            }.resume()
    }
    
    //MARK: - editRows
    
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let deleteRowAction = UITableViewRowAction(style: UITableViewRowActionStyle.default, title: "Delete", handler:{action, indexpath in
            removeAutoFromDb(imgAuto: self.cellData[(indexPath.row)]["imgAuto"]!, userId: Int(self.cellData[indexPath.row]["codAuto"]!)!) { result, error in
                var title: String
                var message: String
                
                if(result) {
                    title = "Rimossa!"
                    //message = "Auto rimossa con successo, che è successo, hai fatto un incidente? Bevi prima di guidare? Ti consiglio un app fatta da noi per la sicurezza stradale, pensi sia un caso? Forse..."
                    message = "Rimossa con successo l'auto con codAuto: \(error))"
                } else  {
                    title = "Ops!"
                    message = "E' andato storto qualcosa: \(error)"
                }
                
                let alertController = UIAlertController(title: title, message:
                    message, preferredStyle: UIAlertControllerStyle.alert)
                alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default,handler: nil))
                
                self.present(alertController, animated: true, completion: nil)
            }
            self.cellData.remove(at: indexPath.row)
            tableView.reloadData()
        })
        
        deleteRowAction.backgroundColor = UIColor.red
        let editRowAction = UITableViewRowAction(style: UITableViewRowActionStyle.default, title: " Edit ", handler:{action, indexpath in
            self.performSegue(withIdentifier: "ShowDetail", sender: indexPath)
        })
        editRowAction.backgroundColor = UIColor.orange
        
        return [deleteRowAction, editRowAction]
    }
    
    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationControllerOperation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        customNavigationAnimationController.reverse = operation == .pop
        return customNavigationAnimationController
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "ShowDetail" {
                if let nextViewController = segue.destination as? AddVehicle {
                    
                    var indexPath = IndexPath()
                    
                    var fromEditAction: Bool = false
                    if ((sender as? IndexPath) != nil) { // controlla se gli sto mandando solo l'indexPath nel sender o altro.
                        indexPath = sender as! IndexPath
                        fromEditAction = true
                    } else { // qua appunto no quindi me lo devo recuperare io
                        indexPath = self.tableView.indexPathForSelectedRow!
                    }

                    // Creo un oggetto di tipo Auto() e lo passo alla schermata successiva
                    let auto = Auto(codAuto: Int(cellData[(indexPath.row)]["codAuto"]!)!, make: cellData[(indexPath.row)]["nomeAuto"]!, model: cellData[(indexPath.row)]["modelloAuto"]!, year: Int(cellData[(indexPath.row)]["annoAuto"]!)!, imgURL: "http://mygarage.altervista.org/img/\(cellData[(indexPath.row)]["imgAuto"] ?? "default.jpg")", targaFromDB: cellData[(indexPath.row)]["targaAuto"]!, cilindrataFromDB: Int(cellData[(indexPath.row)]["cilindrataAuto"]!)!,revisioneFromDB: cellData[(indexPath.row)]["immatricolazioneAuto"]!, latitudine: Float(cellData[(indexPath.row)]["latitude"]!)!, longitudine: Float(cellData[(indexPath.row)]["longitude"]!)!)
                    nextViewController.autoFromDB = auto
                    nextViewController.fromEditRowAction = fromEditAction
                    
                    tableView.deselectRow(at: indexPath, animated: true)
                    //let toViewController = segue.destination as? AddVehicle
                    //toViewController?.transitioningDelegate = self
                }
        }
    }
    
    @IBAction func unwindToMenu(segue: UIStoryboardSegue) {
        
    }
 
}
