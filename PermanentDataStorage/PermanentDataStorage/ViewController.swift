//
//  ViewController.swift
//  PermanentDataStorage
//
//  Created by Tony Coniglio on 11/27/17.
//  Copyright © 2017 Resin. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet var phoneNumber: UITextField!
    
    @IBAction func store(_ sender: Any) {
        UserDefaults.standard.set(phoneNumber.text, forKey: "number")
        
        let numberObject = UserDefaults.standard.object(forKey: "number")
        
        if let number = numberObject as? String {
            phoneNumber.text = number
        }
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
       // UserDefaults.standard.set("Tony", forKey: "name")
        //let name = UserDefaults.standard.object(forKey: "name")
        // Do any additional setup after loading the view, typically from a nib.
    /*
    let arr = ["Tinder", "Bumble", "OKCupid", "Match.com", "Hot or Not", "Coffee meets bagel", "Hinge", "Black People Meet", "JDate", "eHarmony", "Zoosk"]
    
    UserDefaults.standard.set(arr, forKey: "array")

        let arrayObject = UserDefaults.standard.object(forKey: "array")
    }
    
    if let array = arrayObject as? MSArray {
        print(array)
 
 }
 */
 
 }
 
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

