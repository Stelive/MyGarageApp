//
//  MapView.swift
//  MyGarageApp
//
//  Created by Stefano Pedroli on 08/10/17.
//  Copyright © 2017 Stefano Pedroli. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class MapView: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {

    @IBOutlet weak var myMaps: MKMapView!
    
    var locationManager = CLLocationManager()
    
    var auto = Auto()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // TODO: codice per localizzazione utente
        determineCurrentLocation()
        
        let longPressRecogniser = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(gestureRecognise:)))
        longPressRecogniser.minimumPressDuration = 1.0 // 1 secondo
        myMaps.addGestureRecognizer(longPressRecogniser)
        
        let coordinate = CLLocationCoordinate2D(latitude: CLLocationDegrees(auto.latitude), longitude: CLLocationDegrees(auto.longitude))
        let vehicleAnnotation = VehicleAnnotation(title: "\(auto.make) \(auto.model)", coordinate: coordinate)
        myMaps.addAnnotation(vehicleAnnotation)
        //37.331039, -122.033864
        myMaps.delegate = self
    }
    
    func determineCurrentLocation() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            locationManager.startUpdatingLocation()
        }
    }
    
    @objc func handleLongPress(gestureRecognise: UIGestureRecognizer) {
        //print("Sono stato premuto a lungo")
        if gestureRecognise.state != .ended { return }
        let touchPoint = gestureRecognise.location(in: self.myMaps)
        let touchMapCoord = myMaps.convert(touchPoint, toCoordinateFrom: myMaps)
        auto.latitude = Float(touchMapCoord.latitude)
        auto.longitude = Float(touchMapCoord.longitude)
        let annotation = VehicleAnnotation(title: "\(auto.make) \(auto.model)", coordinate: touchMapCoord)
        if myMaps.annotations.count > 0 {
            myMaps.removeAnnotations(myMaps.annotations)
        }
        myMaps.addAnnotation(annotation)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else {
            print("Not found user location")
            return
        }
        
        let latitude = location.coordinate.latitude
        let longitude = location.coordinate.longitude
        print("lat: \(location.coordinate.latitude), long: \(location.coordinate.longitude)")
        let newLocation = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        let span = MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005)
        let region = MKCoordinateRegion(center: newLocation, span: span)
        myMaps.setRegion(region, animated: true)
        locationManager.stopUpdatingLocation()
        myMaps.showsUserLocation = true
    }
    
    @IBAction func saveNewCoordinate(_ sender: Any) {
        
        print(auto)
        updateAutoOnDB(codAuto: auto.codAuto, nomeAuto: auto.make, modelloAuto: auto.model, annoAuto: String(auto.year), targaAuto: auto.targaFromDB, cilindrataAuto: auto.cilindrataFromDB, immatricolazioneAuto: auto.revisioneFromDB, latitude: Double(auto.latitude), longitude: Double(auto.longitude)) { (result) in
            if result {
                let alert = UIAlertController(title: "Posizione Salvata!", message: "Abbiamo aggiornato la posizione della tua auto nel db", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            } else {
                let alert = UIAlertController(title: "ERRORE nel salvataggio!", message: "Non siamo riusciti a salvare l'a posizione, qualcosa è andato storto non sappiamo cosa. Ciao.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    @IBAction func showRoute(_ sender: Any) {
        drawRoute()
    }
    
    func drawRoute () {
        
        //remove old route
        myMaps.removeOverlays(myMaps.overlays)
        //draw other route
        let request = MKDirectionsRequest()
        request.source = MKMapItem(placemark: MKPlacemark(coordinate: (locationManager.location?.coordinate)!, addressDictionary: nil))
        request.destination = MKMapItem(placemark: MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: CLLocationDegrees(auto.latitude), longitude: CLLocationDegrees(auto.longitude)), addressDictionary: nil))
        request.requestsAlternateRoutes = false
        request.transportType = .walking
        
        let directions = MKDirections(request: request)
        
        directions.calculate { [unowned self] response, error in
            guard let unwrappedResponse = response else { return }
            
            for route in unwrappedResponse.routes {
                self.myMaps.add(route.polyline)
                self.myMaps.setVisibleMapRect(route.polyline.boundingMapRect, animated: true)
            }
        }
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let polylineRenderer = MKPolylineRenderer(overlay: overlay)
        polylineRenderer.strokeColor = UIColor.blue
        polylineRenderer.fillColor = UIColor.red
        polylineRenderer.lineWidth = 2
        return polylineRenderer
    }
    
}

class VehicleAnnotation: NSObject, MKAnnotation {
    
    let title: String?
    let coordinate: CLLocationCoordinate2D
    
    init(title: String, coordinate: CLLocationCoordinate2D) {
        self.title = title
        self.coordinate = coordinate
    }
    
}

extension ViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        return nil
    }
    
}
