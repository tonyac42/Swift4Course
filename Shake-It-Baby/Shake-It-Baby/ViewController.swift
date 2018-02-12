//
//  ViewController.swift
//  Shake-It-Baby
//
//  Created by Tony Coniglio on 12/10/17.
//  Copyright © 2017 Resin. All rights reserved.
//

import UIKit
import AVFoundation

var player = AVAudioPlayer()
let audioPath = Bundle.main.path(forResource: "pachelbel-fantasia-gminor-breemer", ofType: "mp3")

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        do {
            try player = AVAudioPlayer(contentsOf: URL(fileURLWithPath: audioPath!))
        } catch {
            print(error)
        }
    }
    
    override func motionEnded(_ motion: UIEventSubtype, with event: UIEvent?) {
        if event?.subtype == UIEventSubtype.motionShake {
            player.play()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
