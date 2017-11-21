//
//  AddVehicle.swift
//  MyGarageApp
//
//  Created by Stefano Pedroli on 25/09/17.
//  Copyright © 2017 Stefano Pedroli. All rights reserved.
//

import UIKit

class AddVehicle: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, URLSessionDelegate {

    let picker = UIImagePickerController()
    
    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var makeLabel: UITextField!
    @IBOutlet weak var modelLabel: UITextField!
    @IBOutlet weak var yearLabel: UITextField!
    
    @IBOutlet weak var targa: UITextField!
    @IBOutlet weak var revisione: UITextField!
    @IBOutlet weak var cilindrata: UITextField!
    
    @IBOutlet weak var barButtonItem: UIBarButtonItem!
    
    var fromWhatView = ""
    
    var autoFromDB = Auto()
    var fromEditRowAction: Bool = false
    
    let customDismissAnimationController = CustomDismissAnimationController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(fromEditRowAction)
        makeLabel.text = autoFromDB.make
        modelLabel.text = autoFromDB.model
        yearLabel.text = String(autoFromDB.year)
        targa.text = autoFromDB.targaFromDB
        revisione.text = String(describing: autoFromDB.revisioneFromDB)
        cilindrata.text = String(autoFromDB.cilindrataFromDB)
        
        if fromWhatView == "choseModel" || fromWhatView == "allVehicles" {
            barButtonItem.title = "Done"
            disableAll(youWantDisableAll: true)
            
        } else {
            barButtonItem.title = "Edit"
            disableAll(youWantDisableAll: false)
        }
        
        self.title = "Your Car"
        
        if autoFromDB.imgURL != "" {
            let url = URL(string: autoFromDB.imgURL)
            let data = try? Data(contentsOf: url!)
            if data != nil {
                img.image = UIImage(data: data!)
            }
        }
        
        if fromEditRowAction {
            let alert = Bundle.main.loadNibNamed("customWalkThrought", owner: self, options: nil)?.last as! CustomWalkThrought
            alert.navController = self.navigationController
            
            alert.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
            alert.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
            
            self.present(alert, animated: true, completion: nil)
        }
        
        navigationController?.delegate = self
        // Do any additional setup after loading the view.
    }
    
    func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return customDismissAnimationController
    }

    @IBAction func barButtonItemAction(_ sender: Any) {
        if barButtonItem.title == "Done" {
            //DONE BUTTON
            if fromWhatView == "choseModel" || fromWhatView == "allVehicles" { //Add to DB only if we are in addNewVehicle Section
                //Save New Auto on DB
                
                addAutoOnDB(nomeAuto: makeLabel.text!, modelloAuto: modelLabel.text!, annoAuto: yearLabel.text!, targaAuto: targa.text!, cilindrataAuto: Int(cilindrata.text!)!, immatricolazioneAuto: revisione.text!, codUser: StatusManager.sharedInstance.codUtente, onComplete: { result in
                    //code
                    // Tuttavia se i campi sono vuoti bisogna mettere una stringa vuota che va benissimo e verranno valorizzati in seguito quando l'utente vorrà
                    if result {
                        print("Auto aggiunta con successo")
                    } else {
                        print("Ops... c'è stato qualche problema!")
                    }
                })
                
                //Close windows using unwind self to menù
                self.performSegue(withIdentifier: "unwindToMenu", sender: self)
            } else {
                //Update auto
                //updateAutoOnDB(codAuto: codAuto, nomeAuto:  makeLabel.text!, modelloAuto: modelLabel.text!, annoAuto: yearLabel.text!, targaAuto: targa.text!, cilindrataAuto: Int(cilindrata.text!)!, immatricolazioneAuto: revisioneFromDB){ result in
                updateAutoOnDB(codAuto: autoFromDB.codAuto, nomeAuto:  makeLabel.text!, modelloAuto: modelLabel.text!, annoAuto: yearLabel.text!, targaAuto: targa.text!, cilindrataAuto: Int(cilindrata.text!)!, immatricolazioneAuto: revisione.text!){ result in
                    print(result)
                    if result {
                            print("Dati modificati con successo")
                        DispatchQueue.main.async {
                            self.barButtonItem.title = "Edit"
                            self.disableAll(youWantDisableAll: false)
                        }
                    } else {
                            print("Dati non modificati")
                        DispatchQueue.main.async {
                            self.barButtonItem.title = "Edit"
                            self.disableAll(youWantDisableAll: false)
                        }
                    }
                }
            }
        } else {
            barButtonItem.title = "Done"
            //EDIT BUTTON
            //We need to Edit auto
            disableAll(youWantDisableAll: true)
        }
    }

    
    
    //CODE FOR IMG:
    
    @IBAction func imageTapped(sender: AnyObject) {
        
        if barButtonItem.title == "Done" { // u can edit only if you are in EDIT MODE
            let alert = UIAlertController(title: "Upload New Img", message: "If you want to upload and edit new img click one of those action!", preferredStyle: .actionSheet)
            alert.addAction(UIAlertAction(title: "Take Photo From Library", style: .default) { action in
                self.picker.delegate = self
                
                self.picker.sourceType = UIImagePickerControllerSourceType.photoLibrary
                self.picker.allowsEditing = false //true quando creo la custom view
                //picker.allowsEditing.customMirror = ImageCropperViewController
                //picker.preferredContentSize = CGSize(width: 1200, height: 400)
                self.picker.modalPresentationStyle = .popover
                self.present(self.picker, animated: true, completion: nil)
            })
            
            alert.addAction(UIAlertAction(title: "Take Photo From Camera", style: .default) { action in
                if UIImagePickerController.isSourceTypeAvailable(.camera) {
                    self.picker.allowsEditing = false
                    self.picker.sourceType = UIImagePickerControllerSourceType.camera
                    self.picker.cameraCaptureMode = .photo
                    self.picker.modalPresentationStyle = .fullScreen
                    //self.picker.view.snapshotView(afterScreenUpdates: true)
                    DispatchQueue.global(qos: .userInitiated).async {
                        self.present(self.picker,animated: true,completion: nil)
                    }
                } else {
                    self.noCamera()
                }
            })
            
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel) { action in
            })
            //aggiungo una gesture che inizia quando clicco nello sfondo per eliminare l'alertview
            
            self.present(alert, animated: true, completion : nil)
        }
    }
    
    // Metodo che cancella l'alert controll se clicco da qualche parte
    @objc func alertControllerBackgroundTapped() {
        self.dismiss(animated: true, completion: nil)
    }
    
    func noCamera(){
        let alertVC = UIAlertController(
            title: "No Camera",
            message: "Sorry, this device has no camera",
            preferredStyle: .alert)
        let okAction = UIAlertAction(
            title: "OK",
            style:.default,
            handler: nil)
        alertVC.addAction(okAction)
        present(
            alertVC,
            animated: true,
            completion: nil)
    }
    
    //MARK: - Delegates
    
    func croppImage(originalImage:UIImage, toRect rect:CGRect) -> UIImage{
        
        let imageRef:CGImage = originalImage.cgImage!.cropping(to: rect)! //CGImageCreateWithImageInRect(originalImage.cgImage!, rect)!
        let croppedimage:UIImage = UIImage.init(cgImage: imageRef) //UIImage(CGImage: imageRef)
            //UIImage(cgImage: croppedImage, scale: croppedImage.scale, orientation: croppedImage.imageOrientation)
        return croppedimage
    }
    
    // selected image
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        //img.image = info[UIImagePickerControllerEditedImage] as? UIImage
        var chosenImage = UIImage()
        chosenImage = info[UIImagePickerControllerOriginalImage] as! UIImage //2
        //myImageView.contentMode = .scaleAspectFit //non vogliamo che il size dell'immagine ci fotta tutto :)
        
        let cropperViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "cropperViewController") as! ImageCropperViewController
        cropperViewController.selectedImage = chosenImage
        
        picker.pushViewController(cropperViewController, animated: true)
        
        
        // --> Da qua in giù ho commentato!
        //img.image = croppImage(originalImage: chosenImage, toRect: CGRect(x: 600, y: 280, width: 2000, height: 1000)) //Programmo inserendo numeri a caso!! Prima o poi funzionerà
        //self.dismiss(animated: true, completion: nil)
        
        // call function of uploading image file to server
        //uploadImage()
    }
    
    func setImg(image: UIImage) -> () {
        img.image = image
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: SEGUE
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "showLocationSegue"{
            if let nextViewController = segue.destination as? MapView{
                nextViewController.latitude = autoFromDB.latitude
                nextViewController.longitude = autoFromDB.longitude
                nextViewController.make = autoFromDB.make
                nextViewController.model = autoFromDB.model
            }
        }
    }

    // MARK: OTHER FUNCTION
    
    func disableAll(youWantDisableAll: Bool) -> () {
        makeLabel.isUserInteractionEnabled = youWantDisableAll
        targa.isUserInteractionEnabled = youWantDisableAll
        modelLabel.isUserInteractionEnabled = youWantDisableAll
        yearLabel.isUserInteractionEnabled = youWantDisableAll
        revisione.isUserInteractionEnabled = youWantDisableAll
        cilindrata.isUserInteractionEnabled = youWantDisableAll
    }
    
    
    @IBAction func unwindToVeichleView(sender: UIStoryboardSegue) {
        if let sourceViewController = sender.source as? ImageCropperViewController {
            setImg(image: sourceViewController.selectedImage)
            uploadImage(image: sourceViewController.selectedImage) { result in
                print("Immagine inviata al server")
            }
        }
    }
    
    
    // upload image to server
    func uploadImage(image: UIImage, onComplete:@escaping ( _ result:Bool) -> ()) {
        let url = URL(string: "http://mygarage.altervista.org/uploadImg.php")
            
        let request = NSMutableURLRequest(url: url!)
        request.httpMethod = "POST"
            
        let boundary = generateBoundaryString()
            
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        var image_data = UIImagePNGRepresentation(image)
        // Provo a resizzare l'immagine in modo che non sia troppo pesante!
        if let imageResized:UIImage = image.resized(withPercentage: 0.2) {
            image_data = UIImagePNGRepresentation(imageResized)
        }
            
        
        //let image_data = UIImagePNGRepresentation(image.resized(withPercentage: 0.2)!)
            
        let body = NSMutableData()
        
        // qua preparo una dicitura specifica del nome che contiene anche il "codAuto" perche passarlo nell'oggetto data... non era cosa
        let prepareFileName = (autoFromDB.make.removeSpaceAndMakeCamelCase() + autoFromDB.model.removeSpaceAndMakeCamelCase()).decapitalizingFirstLetter()
            
        let fname = "\(prepareFileName).jpg_\(String(autoFromDB.codAuto))" // ERA PNG
        let mimetype = "image/jpg"
        
        //GLI DOBBIAMO PASSARE IL CODAUTO PER UPLOADDARE IL CAZZO DI CAMPO DI TESTO NEL DB POI MAGARI DECAPITALIZZIAMO IL NOME E SIAMO A POSTO!
            
        body.append("--\(boundary)\r\n".data(using: String.Encoding.utf8)!)
        body.append("Content-Disposition:form-data; name=\"test\"\r\n\r\n".data(using: String.Encoding.utf8)!)
        body.append("hi\r\n".data(using: String.Encoding.utf8)!)
            
        body.append("--\(boundary)\r\n".data(using: String.Encoding.utf8)!)
        body.append("Content-Disposition:form-data; name=\"file\"; filename=\"\(fname)\"\r\n".data(using: String.Encoding.utf8)!)
        body.append("Content-Type: \(mimetype)\r\n\r\n".data(using: String.Encoding.utf8)!)
        body.append(image_data!)
        body.append("\r\n".data(using: String.Encoding.utf8)!)
            
        body.append("--\(boundary)--\r\n".data(using: String.Encoding.utf8)!)
            
        request.httpBody = body as Data
        //let session = URLSession.shared
            
        let task = URLSession.shared.dataTask(with: request as URLRequest) { (data, response, error) in
                
            guard let _:Data = data, let _:URLResponse = response  , error == nil else {
                print("error")
                return
            }
                
            let dataString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
                
            print(dataString ?? "no dataString")
            onComplete(true)
        }
        
        task.resume()
    }
        
    func generateBoundaryString() -> String {
        return "Boundary-\(UUID().uuidString)"
    }
}


