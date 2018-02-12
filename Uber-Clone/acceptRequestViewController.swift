//
//  acceptRequestViewController.swift
//  Uber-Clone
//
//  Created by Tony Coniglio on 1/22/18.
//  Copyright © 2018 Resin. All rights reserved.
//

import UIKit
import MapKit
import FirebaseAuth
import FirebaseDatabase

class acceptRequestViewController: UIViewController, CLLocationManagerDelegate {
    
    var requestLocation = CLLocationCoordinate2D()
    var requestEmail = ""
    var driverLocation = CLLocationCoordinate2D()
    
    @IBAction func acceptRequestTapped(_ sender: Any) {
        //update the ride request
        Database.database().reference().child("RideRequests").queryOrdered(byChild: "email").queryEqual(toValue: requestEmail).observe(.childAdded) { (snapshot) in
            snapshot.ref.updateChildValues(["driverLat":self.driverLocation.latitude, "driverLon":self.driverLocation.longitude])
            Database.database().reference().child("RideRequests").removeAllObservers()
        }
        //get directions
        let requestCLLocation = CLLocation(latitude: requestLocation.latitude, longitude: requestLocation.longitude)
        CLGeocoder().reverseGeocodeLocation(requestCLLocation) { (placemarks, error) in
            if let placemarks = placemarks {
                if placemarks.count > 0 {
                    let placeMark = MKPlacemark(placemark: placemarks[0])
                    let mapItem = MKMapItem(placemark: placeMark)
                    mapItem.name = self.requestEmail
                    let options = [MKLaunchOptionsDirectionsModeKey:MKLaunchOptionsDirectionsModeDriving]
                    mapItem.openInMaps(launchOptions: options)
                }
            }
        }
    }
    @IBOutlet weak var map: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let region = MKCoordinateRegion(center: requestLocation, span:  MKCoordinateSpanMake(0.01, 0.01))
        map.setRegion(region, animated: false)
        let annotation = MKPointAnnotation()
        annotation.coordinate = requestLocation
        annotation.title = requestEmail
        map.addAnnotation(annotation)
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
}
