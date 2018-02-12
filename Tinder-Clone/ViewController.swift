//
//  ViewController.swift
//  Tinder-Clone
//
//  Created by Tony Coniglio on 1/7/18.
//  Copyright © 2018 Resin. All rights reserved.

import UIKit
import Parse
import ObjectiveC

class ViewController: UIViewController {
    
    var displayUserId = ""
    var ignoredUsers : [String] = []
    
    @IBAction func logoutTapped(_ sender: Any) {
        performSegue(withIdentifier: "logoutSegue", sender: nil)
        PFUser.logOut()
    }
    
    @IBOutlet weak var matchImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let testObject = PFObject(className: "Testing")
        testObject["foo"] = "bar"
        testObject.saveInBackground(block: {(object, error) in
            print("Object has been saved")
        })
        let gesture = UIPanGestureRecognizer(target: self, action: #selector(wasDragged(gestureRecognize:)))
        matchImageView.addGestureRecognizer(gesture)
        updateImage()
        PFGeoPoint.geoPointForCurrentLocation { (geoPoint, error) in
            if let point = geoPoint {
                PFUser.current()?["location"] = point
                PFUser.current()?.saveInBackground()
            }
        }
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    @objc func wasDragged(gestureRecognize: UIPanGestureRecognizer) {
        let labelPoint = gestureRecognize.translation(in: view)
        matchImageView.center = CGPoint(x: view.bounds.width / 2 + labelPoint.x, y: view.bounds.height / 2 + labelPoint.y)
        let xFromCenter = view.bounds.width / 2 - matchImageView.center.x
        var rotation = CGAffineTransform(rotationAngle: xFromCenter / 250)
        let scale = min(100 / abs(xFromCenter), 1)
        var scaledAndRotated = rotation.scaledBy(x: scale, y: scale)
        matchImageView.transform = scaledAndRotated
        if gestureRecognize.state == .ended {
            var acceptedOrRejected = ""
            if matchImageView.center.x < (view.bounds.width / 2 - 100) {
                print("Not interested")
                acceptedOrRejected = "Rejected"
            }
            if matchImageView.center.x > (view.bounds.width / 2 - 100) {
                print("Interested")
                acceptedOrRejected = "Accepted"
            }
            
            if acceptedOrRejected != "" && displayUserId != "" {
                PFUser.current()?.addUniqueObject(displayUserId, forKey: acceptedOrRejected)
                PFUser.current()?.signUpInBackground(block: { (success, error) in
                    if success {
                        self.updateImage()
                    }
                })
            }
            
            rotation = CGAffineTransform(rotationAngle: 0)
            scaledAndRotated = rotation.scaledBy(x: 1, y: 1)
            matchImageView.transform = scaledAndRotated
            matchImageView.center = CGPoint(x: view.bounds.width / 2, y: view.bounds.height / 2)
        }
    }
    
    func updateImage() {
        if let query = PFUser.query() {
            if let isInterestedInWomen = PFUser.current()?["isInterestedInWomen"] {
                query.whereKey("isFemale", equalTo: isInterestedInWomen)
            }
            if let isFemale = PFUser.current()?["isFemale"] {
                query.whereKey("isInterestedInWomen", equalTo: isFemale)
            }
            if let acceptedUsers = PFUser.current()?["Accepted"] as? [String] {
                ignoredUsers += acceptedUsers
            }
            if let rejectedUsers = PFUser.current()?["Rejected"] as? [String] {
                ignoredUsers += rejectedUsers
            }
            if let geoPoint = PFUser.current()?["location"] as? PFGeoPoint {
                let southwest = PFGeoPoint.init(latitude: geoPoint.latitude - 1, longitude: geoPoint.longitude - 1)
                let northeast = PFGeoPoint.init(latitude: geoPoint.latitude + 1, longitude: geoPoint.longitude + 1)
                query.whereKey("location", withinGeoBoxFromSouthwest: southwest, toNortheast: northeast)
            }
            query.whereKey("objectId", notContainedIn: ignoredUsers)
            query.limit = 1
            query.findObjectsInBackground { (objects, Error) in
                if let users = objects {
                    for object in users {
                        if let user = object as? PFUser {
                            if let imageFile = user["photo"] as? PFFile {
                                imageFile.getDataInBackground(block: { (data, error) in
                                    if let imageData = data {
                                        self.matchImageView.image = UIImage(data: imageData)
                                        if let objectId = object.objectId {
                                            self.displayUserId = objectId
                                        }
                                    }
                                })
                            }
                        }
                    }
                }
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
