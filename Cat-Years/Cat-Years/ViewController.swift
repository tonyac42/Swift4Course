//
//  ViewController.swift
//  Cat-Years
//
//  Created by Tony Coniglio on 2/7/18.
//  Copyright © 2018 Resin. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var age = 0
    var catAge = 0

    @IBOutlet weak var humanAge: UITextField!
    
    @IBAction func getCatAge(_ sender: Any) {
        if humanAge != nil {
            resultLabel.text = "Please enter a number"
        } else {
            if let result = humanAge.text {
                age = Int(result)!
                catAge = age * 7
            } else {
                resultLabel.text = "Something went wrong."
            }
            resultLabel.text = "Your cat is \(catAge) in cat years"
        }
    }
    @IBOutlet weak var resultLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

