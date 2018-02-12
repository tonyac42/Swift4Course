//
//  ViewController.swift
//  findingLocation
//
//  Created by Tony Coniglio on 12/2/17.
//  Copyright © 2017 Resin. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

class ViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {
    
    var locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print(locations)
        let userLocation: CLLocation = locations[0]
        let latitude = userLocation.coordinate.latitude
        let longitude = userLocation.coordinate.longitude
        let location = CLLocation(latitude: latitude, longitude: longitude)
        CLGeocoder().reverseGeocodeLocation(location) { (placemarks, error) in
            if error != nil {
                print(error!)
            } else {
                if let placemark = placemarks?[0]{
                    print(placemark)
                    if let placemark = placemarks?[0]{
                        var subThrooughfare = ""
                        if placemark.subThoroughfare != nil {
                            subThrooughfare = placemark.subThoroughfare!
                            print(subThrooughfare)
                            //copy for thoroughfare, sublocality, subadministrativearea, post code, country
                        }
                    }
                }
            }
        }
    }
}
