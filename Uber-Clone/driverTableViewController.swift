//
//  driverTableViewController.swift
//  
//
//  Created by Tony Coniglio on 1/22/18.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import MapKit

class driverTableViewController: UITableViewController, CLLocationManagerDelegate {
    
    var rideRequest : [DataSnapshot] = []
    var locationManager = CLLocationManager()
    var driverLocation = CLLocationCoordinate2D()

   
    @IBAction func logoutTapped(_ sender: Any) {
        navigationController?.dismiss(animated: true, completion: nil)
        try? Auth.auth().signOut()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        Database.database().reference().child("RideRequests").observe(.childAdded) { (snapshot) in
            if let rideRequestDictionary = snapshot.value as? [String:Any] {
                if let driverLatitude = rideRequestDictionary["driverLatitude"] as? Double {
                } else {
                    self.rideRequest.append(snapshot)
                    self.tableView.reloadData()
                }
            }
            }
        Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { (timer) in
        self.tableView.reloadData()
        })
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let cord = manager.location?.coordinate {
            driverLocation = cord
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return rideRequest.count
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let snapshot = rideRequest[indexPath.row]
        performSegue(withIdentifier: "acceptorSegue", sender: snapshot)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let acceptVC = segue.destination as? acceptRequestViewController {
            if let snapshot = sender as? DataSnapshot {
                if let rideRequestDictionary = snapshot.value as? [String:Any] {
                    if let email = rideRequestDictionary["email"] as? String {
                        if let latitude = rideRequestDictionary["latitude"] as? Double {
                            if let longitude = rideRequestDictionary["longitude"] as? Double {
                                acceptVC.requestEmail = email
                                let location = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
                                acceptVC.requestLocation = location
                                acceptVC.driverLocation = driverLocation
                            }
                        }
                    }
                }
            }
        }
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "riders", for: indexPath)

        // Configure the cell...
        
        let snapshot = rideRequest[indexPath.row]
        if let rideRequestDictionary = snapshot.value as? [String:Any] {
            if let email = rideRequestDictionary["email"] as? String {
                cell.textLabel?.text = email
                if let latitude = rideRequestDictionary["latitude"] as? Double {
                    if let longitude = rideRequestDictionary["longitude"] as? Double {
                        let driverCLLocation = CLLocation(latitude: driverLocation.latitude, longitude: driverLocation.longitude)
                        let riderCLLocation = CLLocation(latitude: latitude, longitude: longitude)
                        let distance = driverCLLocation.distance(from: riderCLLocation) / 1000
                        let roundedDistance = round(distance * 100) / 100
                        cell.textLabel?.text = "\(email) - \(roundedDistance)km away"
                    }
                }
            }
        }

        return cell
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
