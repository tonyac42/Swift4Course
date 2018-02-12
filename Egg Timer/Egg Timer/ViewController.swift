//
//  ViewController.swift
//  Egg Timer
//
//  Created by Tony Coniglio on 2/7/18.
//  Copyright © 2018 Resin. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var timer = Timer()
    var seconds = 211
    var isTimerRunning = false
    
    @IBOutlet weak var timerDisplay: UILabel!
    
    @IBAction func pauseTapped(_ sender: Any) {
        timer.invalidate()
        isTimerRunning = false
        displayTimer()
    }
    
    @IBAction func playTapped(_ sender: Any) {
        if isTimerRunning == false {
            runTimer()
            isTimerRunning = true
        }
        displayTimer()
    }
    
    @IBAction func minusTenTapped(_ sender: Any) {
        if seconds > 10 {
            seconds -= 10
        } else {
            seconds = 0
        }
        displayTimer()
    }
    
    @IBAction func resetTapped(_ sender: Any) {
        timer.invalidate()
        seconds = 210
        isTimerRunning = false
        displayTimer()
    }
    
    @IBAction func plusTenTapped(_ sender: Any) {
        seconds += 10
        displayTimer()
    }
    
    @objc func updateTimer() {
        if seconds > 0 {
         seconds -= 1
        } else {
            seconds = 0
        }
        displayTimer()
    }
    
    func displayTimer(){
        if seconds == 0 {
            timerDisplay.text = "Eggs are done."
        } else {
            timerDisplay.text = "\(seconds)"
        }
    }
    
    func runTimer() {
        timer = Timer.scheduledTimer(timeInterval: 1, target: self,   selector: (#selector(ViewController.updateTimer)), userInfo: nil, repeats: true)
        isTimerRunning = true
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateTimer()
        // Do any additional setup after loading the view, typically from a nib.
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

