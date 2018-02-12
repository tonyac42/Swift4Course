//
//  riderViewController.swift
//  Uber-Clone
//
//  Created by Tony Coniglio on 1/21/18.
//  Copyright © 2018 Resin. All rights reserved.
//

import UIKit
import MapKit
import FirebaseDatabase
import FirebaseAuth

class riderViewController: UIViewController, CLLocationManagerDelegate {
    
    var locationManager = CLLocationManager()
    var userLocation = CLLocationCoordinate2D()
    var uberHasBeenCalled = false
    var driverOnTheWay = false
    var driverLocation = CLLocationCoordinate2D()
    
    @IBAction func logOutTapped(_ sender: Any) {
        navigationController?.dismiss(animated: true, completion: nil)
        try? Auth.auth().signOut()
    }
    @IBOutlet weak var callUber: UIButton!
    
    @IBAction func callUberTapped(_ sender: Any) {
        
        if driverOnTheWay == false {
            
            if let email = Auth.auth().currentUser?.email {
                if uberHasBeenCalled == false {
                    let rideRequestDictionary : [String:Any] = ["email":email, "latitude":userLocation.latitude, "longitude":userLocation.longitude]
                    Database.database().reference().child("RideRequests").childByAutoId().setValue(rideRequestDictionary)
                    uberHasBeenCalled = true
                    callUber.setTitle("Cancel Uber", for: .normal)
                } else {
                    uberHasBeenCalled = false
                    callUber.setTitle("Call yo' ass an uber I got somewhere to be", for: .normal)
                    Database.database().reference().child("RideRequests").queryOrdered(byChild: "email").queryEqual(toValue: email).observe(.childAdded, with: { (snapshot) in
                        snapshot.ref.removeValue()
                        Database.database().reference().child("RideRequests").removeAllObservers()
                        if let rideRequestDictionary = snapshot.value as? [String:Any] {
                            if let driverLatitude = rideRequestDictionary["driverLatitude"] as? Double {
                                if let driverLongitude = rideRequestDictionary["driverLongitude"] as? Double {
                                    self.driverLocation = CLLocationCoordinate2D(latitude: driverLatitude, longitude: driverLongitude)
                                    self.driverOnTheWay = true
                                    self.displayDriverAndRider()
                                    if let email = Auth.auth().currentUser?.email {
                                        Database.database().reference().child("RideRequests").queryOrdered(byChild: "email").queryEqual(toValue: email).observe(.childChanged, with: { (snapshot) in
                                            if let rideRequestDictionary = snapshot.value as? [String:Any] {
                                                if let driverLatitude = rideRequestDictionary["driverLatitude"] as? Double {
                                                    if let driverLongitude = rideRequestDictionary["driverLongitude"] as? Double {
                                                        self.driverLocation = CLLocationCoordinate2D(latitude: driverLatitude, longitude: driverLongitude)
                                                        self.driverOnTheWay = true
                                                        self.displayDriverAndRider()
                                                    }
                                                }
                                            }
                                        })
                                    }
                                }
                            }
                        }
                    })
                }
            }
        } else {
            
        }
    }
    @IBOutlet weak var map: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        if let email = Auth.auth().currentUser?.email {
            Database.database().reference().child("RideRequests").queryOrdered(byChild: "email").queryEqual(toValue: email).observe(.childAdded, with: { (snapshot) in
                self.uberHasBeenCalled = true
                self.callUber.setTitle("Cancel Uber", for: .normal)
                Database.database().reference().child("RideRequests").removeAllObservers()
            })
        }
        
        // Do any additional setup after loading the view.
    }
    
    func displayDriverAndRider() {
        let driverCLLocation = CLLocation(latitude: driverLocation.latitude, longitude: driverLocation.longitude)
        let riderCLLocation = CLLocation(latitude: userLocation.latitude, longitude: userLocation.longitude)
        let distance = driverCLLocation.distance(from: riderCLLocation) / 1000
        let roundedDistance = round(distance * 100) / 100
        callUber.setTitle("Your Driver is \(roundedDistance)km away!(getting gas)", for: .normal)
        map.removeAnnotation(map.annotations as! MKAnnotation)
        let latDelta = abs(driverLocation.latitude - userLocation.latitude) * 2 + 0.005
        let lonDelta = abs(driverLocation.longitude - userLocation.longitude) * 2 + 0.005
        let region = MKCoordinateRegionMake(userLocation, MKCoordinateSpanMake(lonDelta, latDelta))
        map.setRegion(region, animated: true)
        let riderAnnotation = MKPointAnnotation()
        riderAnnotation.coordinate = userLocation
        riderAnnotation.title = "Your Location"
        map.addAnnotation(riderAnnotation)
        let driverAnnotation = MKPointAnnotation()
        driverAnnotation.coordinate = driverLocation
        driverAnnotation.title = "Your Driver"
        map.addAnnotation(driverAnnotation)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let cord = manager.location?.coordinate {
            let center = CLLocationCoordinate2DMake(cord.latitude, cord.longitude)
            userLocation = center
            if uberHasBeenCalled {
                displayDriverAndRider()
            } else {
                let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
                map.setRegion(region, animated: true)
                map.removeAnnotations(map.annotations)
                let annotation = MKPointAnnotation()
                annotation.coordinate = center
                annotation.title = "Your Location"
                map.addAnnotation(annotation)
            }
        }
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
