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

    @IBOutlet weak var wholeMap: MKMapView!
    
    let annotation = MKPointAnnotation()
    var locationManager: CLLocationManager = CLLocationManager()
    
    //Dati dal db
    var latitude: Float = 0
    var longitude: Float = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        annotation.coordinate = CLLocationCoordinate2D(latitude: CLLocationDegrees(latitude), longitude: CLLocationDegrees(longitude))
        wholeMap.addAnnotation(annotation)
        wholeMap.camera.centerCoordinate = annotation.coordinate
        let annotationPoint:MKMapPoint = MKMapPointForCoordinate(annotation.coordinate)
        let zoomRect:MKMapRect = MKMapRectMake(annotationPoint.x, annotationPoint.y, 0.1, 0.1);
        wholeMap.setVisibleMapRect(zoomRect, animated: true)
        
        //current location:
    
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        //Nel caso voglia tracciare il percorso in background..
        /*let authorizationStatus = CLLocationManager.authorizationStatus()
        switch authorizationStatus {
        case .authorizedAlways:
            print("authorized")
        case .authorizedWhenInUse:
            print("authorized when in use")
        case .denied:
            print("denied")
        case .notDetermined:
            print("not determined")
        case .restricted:
            print("restricted")
        }*/
        
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations[0] as CLLocation
        print("Latitude: \(location.coordinate.latitude). Longitude: \(location.coordinate.longitude).")
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .authorizedAlways:
            print("authorized")
        case .authorizedWhenInUse:
            print("authorized when in use")
        case .denied:
            print("denied")
        case .notDetermined:
            print("not determined")
        case .restricted:
            print("restricted")
        }
    }

}
