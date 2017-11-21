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

class MapView: UIViewController, CLLocationManagerDelegate{

    @IBOutlet weak var myMaps: MKMapView!
    
    var locationManager = CLLocationManager()
    
    var latitude: Float = 0
    var longitude: Float = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // TODO: codice per localizzazione utente
        determineCurrentLocation()
        
        let longPressRecogniser = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(gestureRecognise:)))
        longPressRecogniser.minimumPressDuration = 1.0 // 1 secondo
        myMaps.addGestureRecognizer(longPressRecogniser)
        
        let coordinate = CLLocationCoordinate2D(latitude: CLLocationDegrees(latitude), longitude: CLLocationDegrees(longitude))
        let vehicleAnnotation = VehicleAnnotation(title: "Lamborghini Murcielago", coordinate: coordinate)
        myMaps.addAnnotation(vehicleAnnotation)
        //37.331039, -122.033864
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
        print("Sono stato premuto a lungo")
        if gestureRecognise.state != .ended { return }
        let touchPoint = gestureRecognise.location(in: self.myMaps)
        let touchMapCoord = myMaps.convert(touchPoint, toCoordinateFrom: myMaps)
        let annotation = VehicleAnnotation(title: "nuovo punto", coordinate: touchMapCoord)
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
