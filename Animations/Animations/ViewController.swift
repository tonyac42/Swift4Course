//
//  ViewController.swift
//  Animations
//
//  Created by Tony Coniglio on 11/29/17.
//  Copyright © 2017 Resin. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var counter = 0
    
    @IBOutlet weak var image: UIImageView!
    @IBAction func action(_ sender: Any) {
        counter += 1
        image.image = UIImage(named: "frame_0\(counter)_delay-0.07s.gif")
        if counter == 25 {
            counter = 0
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

