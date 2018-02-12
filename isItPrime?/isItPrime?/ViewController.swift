//
//  ViewController.swift
//  isItPrime?
//
//  Created by Tony Coniglio on 2/7/18.
//  Copyright © 2018 Resin. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var isPrime = true
    var number = 0
    var factorsArray = [Int]()
    
    @IBOutlet weak var numberInQuestion: UITextField!
    @IBOutlet weak var resultLabel: UILabel!
    
    @IBAction func isItPrimeTapped(_ sender: Any) {
        factorsArray = []
        primeOrNah()
    }
    
    func factors(of number: Int) -> [Int] {
        return (1...number).filter { number % $0 == 0 }
    }
    
    func primeOrNah() {
        if let number = numberInQuestion.text {
            factorsArray += factors(of: Int(number)!)
            if factorsArray.count > 2 {
                resultLabel.text = "The number is not prime."
            } else {
                resultLabel.text = "The number is prime."
            }
        } else {
            resultLabel.text = "Please enter a number"
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        numberInQuestion.resignFirstResponder()
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

