//
//  ViewController.swift
//  TicTacToe
//
//  Created by Tony Coniglio on 11/30/17.
//  Copyright © 2017 Resin. All rights reserved.
//

import UIKit
import ObjectiveC

class ViewController: UIViewController {
    
    var ownersTurnX = true
    var winner = 2
    let crossImage = UIImage(named: "cross.png")
    let noughtImage = UIImage(named: "nought.png")
    var turnValueUL = ""
    var turnValueUC = ""
    var turnValueUR = ""
    var turnValueML = ""
    var turnValueMC = ""
    var turnValueMR = ""
    var turnValueLL = ""
    var turnValueLC = ""
    var turnValueLR = ""
    
    @IBOutlet weak var gameOverLabel: UILabel!
    @IBOutlet weak var playAgain: UIButton!
    
    @IBAction func playAgainTapped(_ sender: Any) {
        gameOverLabel.isHidden = true
        ownersTurnX = true
        winner = 2
        turnValueUL = ""
        turnValueUC = ""
        turnValueUR = ""
        turnValueML = ""
        turnValueMC = ""
        turnValueMR = ""
        turnValueLL = ""
        turnValueLC = ""
        turnValueLR = ""
        upperLeft.setBackgroundImage(nil, for: .normal)
        upperCenter.setBackgroundImage(nil, for: .normal)
        upperRight.setBackgroundImage(nil, for: .normal)
        middleLeft.setBackgroundImage(nil, for: .normal)
        middleCenter.setBackgroundImage(nil, for: .normal)
        middleRight.setBackgroundImage(nil, for: .normal)
        lowerLeft.setBackgroundImage(nil, for: .normal)
        lowerCenter.setBackgroundImage(nil, for: .normal)
        lowerRight.setBackgroundImage(nil, for: .normal)
        upperLeft.isUserInteractionEnabled = true
        upperCenter.isUserInteractionEnabled = true
        upperRight.isUserInteractionEnabled = true
        middleLeft.isUserInteractionEnabled = true
        middleCenter.isUserInteractionEnabled = true
        middleRight.isUserInteractionEnabled = true
        lowerLeft.isUserInteractionEnabled = true
        lowerCenter.isUserInteractionEnabled = true
        lowerRight.isUserInteractionEnabled = true
        playAgain.isHidden = true
    }
    
    @IBOutlet weak var upperLeft: UIButton!
    @IBOutlet weak var upperCenter: UIButton!
    @IBOutlet weak var upperRight: UIButton!
    @IBOutlet weak var middleLeft: UIButton!
    @IBOutlet weak var middleCenter: UIButton!
    @IBOutlet weak var middleRight: UIButton!
    @IBOutlet weak var lowerLeft: UIButton!
    @IBOutlet weak var lowerCenter: UIButton!
    @IBOutlet weak var lowerRight: UIButton!
    
    @IBAction func upperLeftTapped(_ sender: Any) {
        if ownersTurnX == true {
            upperLeft.setBackgroundImage(crossImage, for: .normal)
            ownersTurnX = false
            turnValueUL = "x"
        } else if ownersTurnX == false {
            upperLeft.setBackgroundImage(noughtImage, for: .normal)
            ownersTurnX = true
            turnValueUL = "o"
        }
        upperLeft.isUserInteractionEnabled = false
        checkGameOver()
    }
    
    @IBAction func upperCenterTapped(_ sender: Any) {
        if ownersTurnX == true {
            upperCenter.setBackgroundImage(crossImage, for: .normal)
            ownersTurnX = false
            turnValueUC = "x"
        } else if ownersTurnX == false {
            upperCenter.setBackgroundImage(noughtImage, for: .normal)
            ownersTurnX = true
            turnValueUC = "o"
        }
        upperCenter.isUserInteractionEnabled = false
        checkGameOver()
    }
    
    @IBAction func upperRightTapped(_ sender: Any) {
        if ownersTurnX == true {
            upperRight.setBackgroundImage(crossImage, for: .normal)
            ownersTurnX = false
            turnValueUR = "x"
        } else if ownersTurnX == false {
            upperRight.setBackgroundImage(noughtImage, for: .normal)
            ownersTurnX = true
            turnValueUR = "o"
        }
        upperRight.isUserInteractionEnabled = false
        checkGameOver()
    }
    
    @IBAction func middleLeftTapped(_ sender: Any) {
        if ownersTurnX == true {
            middleLeft.setBackgroundImage(crossImage, for: .normal)
            ownersTurnX = false
            turnValueML = "x"
        } else if ownersTurnX == false {
            middleLeft.setBackgroundImage(noughtImage, for: .normal)
            ownersTurnX = true
            turnValueML = "o"
        }
        middleLeft.isUserInteractionEnabled = false
        checkGameOver()
    }
    
    @IBAction func middleCenterTapped(_ sender: Any) {
        if ownersTurnX == true {
            middleCenter.setBackgroundImage(crossImage, for: .normal)
            ownersTurnX = false
            turnValueMC = "x"
        } else if ownersTurnX == false {
            middleCenter.setBackgroundImage(noughtImage, for: .normal)
            ownersTurnX = true
            turnValueMC = "o"
        }
        middleCenter.isUserInteractionEnabled = false
        checkGameOver()
    }
    
    @IBAction func middleRightTapped(_ sender: Any) {
        if ownersTurnX == true {
            middleRight.setBackgroundImage(crossImage, for: .normal)
            ownersTurnX = false
            turnValueMR = "x"
        } else if ownersTurnX == false {
            middleRight.setBackgroundImage(noughtImage, for: .normal)
            ownersTurnX = true
            turnValueMR = "o"
        }
        middleRight.isUserInteractionEnabled = false
        checkGameOver()
    }
    
    @IBAction func lowerLeftTapped(_ sender: Any) {
        if ownersTurnX == true {
            lowerLeft.setBackgroundImage(crossImage, for: .normal)
            ownersTurnX = false
            turnValueLL = "x"
        } else if ownersTurnX == false {
            lowerLeft.setBackgroundImage(noughtImage, for: .normal)
            ownersTurnX = true
            turnValueLL = "o"
        }
        lowerLeft.isUserInteractionEnabled = false
        checkGameOver()
    }
    
    @IBAction func lowerCenterTapped(_ sender: Any) {
        if ownersTurnX == true {
            lowerCenter.setBackgroundImage(crossImage, for: .normal)
            ownersTurnX = false
            turnValueLC = "x"
        } else if ownersTurnX == false {
            lowerCenter.setBackgroundImage(noughtImage, for: .normal)
            ownersTurnX = true
            turnValueLC = "o"
        }
        lowerCenter.isUserInteractionEnabled = false
        checkGameOver()
    }
    
    @IBAction func lowerRightTapped(_ sender: Any) {
        if ownersTurnX == true {
            lowerRight.setBackgroundImage(crossImage, for: .normal)
            ownersTurnX = false
            turnValueLR = "x"
        } else if ownersTurnX == false {
            lowerRight.setBackgroundImage(noughtImage, for: .normal)
            ownersTurnX = true
            turnValueLR = "o"
        }
        lowerRight.isUserInteractionEnabled = false
        checkGameOver()
    }
    
    func checkGameOver() {
        if turnValueUL == "x" && turnValueUC == "x" && turnValueUR == "x" {
            winner = 0
            gameOver()
        } else if turnValueUL == "o" && turnValueUC == "o" && turnValueUR == "o" {
            winner = 1
            gameOver()
        } else if turnValueML == "x" && turnValueMC == "x" && turnValueMR == "x" {
            winner = 0
            gameOver()
        } else if turnValueML == "o" && turnValueMC == "o" && turnValueMR == "o" {
            winner = 1
            gameOver()
        } else if turnValueLL == "x" && turnValueLC == "x" && turnValueLR == "x" {
            winner = 0
            gameOver()
        } else if turnValueLL == "o" && turnValueLC == "o" && turnValueLR == "o" {
            winner = 1
            gameOver()
        } else if turnValueUL == "x" && turnValueML == "x" && turnValueLL == "x" {
            winner = 0
            gameOver()
        } else if turnValueUL == "o" && turnValueML == "o" && turnValueLL == "o" {
            winner = 1
            gameOver()
        } else if turnValueUC == "x" && turnValueMC == "x" && turnValueLC == "x" {
            winner = 0
            gameOver()
        } else if turnValueUC == "o" && turnValueMC == "o" && turnValueLC == "o" {
            winner = 1
            gameOver()
        } else if turnValueUR == "x" && turnValueMR == "x" && turnValueLR == "x" {
            winner = 0
            gameOver()
        } else if turnValueUR == "o" && turnValueMR == "o" && turnValueLR == "o" {
            winner = 1
            gameOver()
        } else if turnValueUR == "x" && turnValueMC == "x" && turnValueLL == "x" {
            winner = 0
            gameOver()
        } else if turnValueUR == "o" && turnValueMC == "o" && turnValueLL == "o" {
            winner = 1
            gameOver()
        } else if turnValueUL == "x" && turnValueMC == "x" && turnValueLR == "x" {
            winner = 0
            gameOver()
        } else if turnValueUL == "o" && turnValueMC == "o" && turnValueLR == "o" {
            winner = 1
            gameOver()
        } else if upperLeft.isUserInteractionEnabled == false && upperCenter.isUserInteractionEnabled == false && upperRight.isUserInteractionEnabled == false && middleLeft.isUserInteractionEnabled == false && middleCenter.isUserInteractionEnabled == false && middleRight.isUserInteractionEnabled == false && lowerLeft.isUserInteractionEnabled == false && lowerCenter.isUserInteractionEnabled == false && lowerRight.isUserInteractionEnabled == false {
            winner = 3
            gameOver()
        }
    }
    
    func gameOver() {
        gameOverLabel.isHidden = false
        playAgain.isHidden = false
        if winner == 0 {
            gameOverLabel.text = "Game Over.  Player X wins."
        } else if winner == 1 {
            gameOverLabel.text = "Game Over. Player O wins."
        } else if winner == 3 {
            gameOverLabel.text = "Game Over. Cat's game."
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        gameOverLabel.isHidden = true
        playAgain.isHidden = true
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

