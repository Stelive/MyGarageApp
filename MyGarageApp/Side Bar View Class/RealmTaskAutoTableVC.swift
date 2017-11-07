//
//  RealmTaskAutoTableVC.swift
//  MyGarageApp
//
//  Created by Stefano Pedroli on 05/11/17.
//  Copyright © 2017 Stefano Pedroli. All rights reserved.
//

import UIKit

class RealmTaskAutoTableVC: UITableViewController {

    @IBOutlet weak var addTask: UIBarButtonItem!
    
    //Realm Obj
    var taskList = TaskManager().getAllTask()
    
    // Refresh Control
    var refreshControll: UIRefreshControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addTask.isEnabled = true
        // Do any additional setup after loading the view.
        
        // refresh control
        //Refresh
        refreshControll = UIRefreshControl()
        tableView.addSubview(refreshControll)
        let footerView = UIView()
        footerView.backgroundColor = UIColor.clear
        tableView.tableFooterView = footerView
    }
    
    func doSomething() {
        
        // code to reloadTable:
        taskList = TaskManager().getAllTask()
        tableView.reloadData()
        //aggiorna la pagina
        endOfWork()
    }
    
    func endOfWork() {
        refreshControll.endRefreshing()
    }
    
    override func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if refreshControll.isRefreshing {
            doSomething()
        }
    }
    
    func doSomething(refreshControl: UIRefreshControl) {
        print("Hello World!")
        
        // somewhere in your code you might need to call:
        refreshControll.endRefreshing()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    @IBAction func addTask(_ sender: Any) {
        
        //OLD CODE
        /*let popOverVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "sbPopUpID") as! PopUpViewController
        self.addChildViewController(popOverVC)
        popOverVC.view.frame = tableView.frame
        //popOverVC.view.frame = self.view.frame
        tableView.addSubview(popOverVC.view)
        //self.view.addSubview(popOverVC.view)
        //addTask.isEnabled = false
        popOverVC.didMove(toParentViewController: self)
        //tableView.reloadData()*/
        
        let alert = Bundle.main.loadNibNamed("customPopUp", owner: self, options: nil)?.last as! UIViewController
        alert.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        alert.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
        
        self.present(alert, animated: true, completion: nil)
    }
    
    // TABLE VIEW PART
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 96
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return taskList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "taskCell", for: indexPath) as? TaskCell
        cell?.taskLabel.text = taskList[indexPath.row].taskName
        
        return cell!
    }
    
    //For checkmark
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if let cell = tableView.cellForRow(at: indexPath as IndexPath) {
            if cell.accessoryType == .checkmark{
                cell.accessoryType = .none
            }
            else{
                cell.accessoryType = .checkmark
            }
        }
        
    }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let deleteRowAction = UITableViewRowAction(style: UITableViewRowActionStyle.default, title: "Delete", handler:{action, indexpath in
            // rimuovere da realm
            TaskManager().deleteTask(task: self.taskList[indexPath.row])
            //self.catNames.remove(at: indexPath.row)
            // rimuovere dalla table
            self.tableView.deleteRows(at: [indexPath], with: .automatic)
            //tableView.reloadData()
        })
        
        deleteRowAction.backgroundColor = UIColor.red
        let editRowAction = UITableViewRowAction(style: UITableViewRowActionStyle.default, title: " Edit ", handler:{action, indexpath in
            
            // rimuovere da realm
            TaskManager().deleteTask(task: self.taskList[indexPath.row])
            self.tableView.deleteRows(at: [indexPath], with: .automatic)
            
            let popOverVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "sbPopUpID") as! PopUpViewController
            self.addChildViewController(popOverVC)
            popOverVC.view.frame = tableView.frame
            //popOverVC.view.frame = self.view.frame
            tableView.addSubview(popOverVC.view)
            //self.view.addSubview(popOverVC.view)
            //addTask.isEnabled = false
            popOverVC.didMove(toParentViewController: self)
        })
        editRowAction.backgroundColor = UIColor.orange
        
        return [deleteRowAction, editRowAction]
    }
    
}

extension UIImage {
    
    func imageResize (sizeChange:CGSize)-> UIImage{
        
        let hasAlpha = true
        let scale: CGFloat = 0.0 // Use scale factor of main screen
        
        UIGraphicsBeginImageContextWithOptions(sizeChange, !hasAlpha, scale)
        self.draw(in: CGRect(origin: CGPoint.zero, size: sizeChange))
        
        let scaledImage = UIGraphicsGetImageFromCurrentImageContext()
        return scaledImage!
    }
    
}

class TaskCell: UITableViewCell {
    
    @IBOutlet weak var taskLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}


// REALM CLASS IMPLEMENTATION

import Foundation
import RealmSwift

class Task: Object {
    
    @objc dynamic var identifier = NSUUID().uuidString
    @objc dynamic var taskName = ""
    
    convenience init(taskName: String) {
        self.init()
        self.taskName = taskName
    }
}

class TaskManager {
    
    let realm = try! Realm()
    
    func getAllTask() -> Results<Task> {
        return realm.objects(Task.self).sorted(byKeyPath: "taskName", ascending: false)
    }
    
    func addTask(task: Task) -> () {
        try? realm.write {
            realm.add(task)
        }
    }
    
    func deleteTask(task: Task) -> () {
        try? realm.write {
            realm.delete(task)
        }
    }
    
}

