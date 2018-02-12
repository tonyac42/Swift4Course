//
//  ViewController.swift
//  Animations - II
//
//  Created by Tony Coniglio on 2/7/18.
//  Copyright © 2018 Resin. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var isPlaying = false
    var timer = Timer()
    var counter = 0
    
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var playOrPause: UIButton!
    
    @IBAction func playTapped(_ sender: Any) {
        if isPlaying == false {
            playOrPause.setTitle("Stop", for: .normal)
            isPlaying = true
            runTimer()
            updateTimer()
        } else {
            playOrPause.setTitle("Play", for: .normal)
            timer.invalidate()
            isPlaying = false
        }
    }
    
    func runTimer() {
        timer = Timer.scheduledTimer(timeInterval: 1, target: self,   selector: (#selector(ViewController.updateTimer)), userInfo: nil, repeats: true)
        isPlaying = true
    }
    
    @objc func updateTimer() {
        if counter <= 24 {
            counter += 1
        } else {
            counter = 0
        }
        image.image = UIImage(named: "frame_\(counter).gif")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        image.image = UIImage(named: "frame_0.gif")
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

