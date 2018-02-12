//
//  ViewController.swift
//  Bluetooth-learning
//
//  Created by Tony Coniglio on 2/6/18.
//  Copyright © 2018 Resin. All rights reserved.
//

import UIKit
import CoreBluetooth

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, CBCentralManagerDelegate {
    
    var centralManager : CBCentralManager?
    var names : [String] = []
    var RSSIs : [NSNumber] = []
    var timer : Timer?
    
    @IBAction func refreshTapped(_ sender: Any) {
        timer?.invalidate()
        startScan()
        startTimer()
    }
    @IBOutlet weak var tableView: UITableView!
    
    //Bluetooth
    
    func startScan() {
        names = []
        RSSIs = []
        tableView.reloadData()
        centralManager?.stopScan()
        centralManager?.scanForPeripherals(withServices: nil, options: nil) //apple documentation
    }
    
    func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 10, repeats: true, block: { (timer) in
            self.startScan()
        })
    }
    
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        if central.state == .poweredOn { //you can give many reasons why bluetooth isnt working!!
            startScan()
            startTimer()
        } else {
            let alertVC = UIAlertController(title: "Bluetooth isn't working", message: "I know why but I'm not telling you.  Get your shit together", preferredStyle: .alert)
            let action = UIAlertAction(title: "I'll get my shit together", style: .default, handler: { (action) in
                alertVC.dismiss(animated: true, completion: nil)
            })
            alertVC.addAction(action)
            present(alertVC, animated: true, completion: nil)
        }
    }
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        if let name = peripheral.name {
            names.append(name)
        } else {
            names.append(peripheral.identifier.uuidString)
        }
        RSSIs.append(RSSI)
        tableView.reloadData()
    }
    
    /*print("Peripheral Name: \(name)")
     print("Peripheral UUID: \(peripheral.identifier.uuidString)")
     print("Peripheral RSSI: \(RSSI)")
     print("Ad Data \(advertisementData)")
     print("***********")
     */
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        centralManager = CBCentralManager(delegate: self, queue: nil)
        
    }
    
    //table view
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1_000
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "tooth", for: indexPath) as? TableViewCell {
            cell.peripheralName.text = names[indexPath.row]
            cell.rssiLabel.text = "RSSI: \(RSSIs[indexPath.row])"
            return cell
        }
        return UITableViewCell()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
