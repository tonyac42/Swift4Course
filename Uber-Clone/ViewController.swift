//
//  ViewController.swift
//  Uber-Clone
//
//  Created by Tony Coniglio on 1/15/18.
//  Copyright © 2018 Resin. All rights reserved.
//

import UIKit
import FirebaseAuth

class ViewController: UIViewController {

    @IBOutlet weak var driverLabel: UILabel!
    @IBOutlet weak var riderLabel: UILabel!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var riderDriverSwitch: UISwitch!
    @IBOutlet weak var topButtom: UIButton!
    @IBOutlet weak var bottomButton: UIButton!
    @IBAction func topTapped(_ sender: Any) {
        if emailTextField.text == "" || passwordTextField.text == "" {
            displayAlert(title: "Missing Info", message: "You must provide BOTH an email and password")
        } else {
            if signUpMode == true {
                Auth.auth().createUser(withEmail: String(describing: emailTextField.text), password: String(describing: passwordTextField.text), completion: { (user, error) in
                    if error != nil {
                        self.displayAlert(title: "Error", message: (error?.localizedDescription)!)
                    } else {
                        print("Sign up success!")
                        if self.riderDriverSwitch.isOn {
                            //Driver
                            self.performSegue(withIdentifier: "driverSegue", sender: nil)
                            let req = Auth.auth().currentUser?.createProfileChangeRequest()
                            req?.displayName = "Driver"
                            req?.commitChanges(completion: nil)
                        } else {
                            //rider
                            self.performSegue(withIdentifier: "riderSegue", sender: nil)
                            let req = Auth.auth().currentUser?.createProfileChangeRequest()
                            req?.displayName = "Rider"
                            req?.commitChanges(completion: nil)
                        }
                    }
                })
            } else {
                Auth.auth().signIn(withEmail: String(describing: emailTextField.text), password: String(describing: passwordTextField.text), completion: { (user, error) in
                    if error != nil {
                        self.displayAlert(title: "Error", message: (error?.localizedDescription)!)
                    } else {
                        print("Log in success!")
                        if user?.displayName == "Driver" {
                            //driver
                            self.performSegue(withIdentifier: "driverSegue", sender: nil)
                        } else {
                            //rider
                        self.performSegue(withIdentifier: "riderSegue", sender: nil)
                    }
                    }
                })
            }
        }
    }
    @IBAction func bottomTapped(_ sender: Any) {
        if signUpMode == true {
            topButtom.setTitle("Login", for: .normal)
            bottomButton.setTitle("Signup", for: .normal)
            riderLabel.isHidden = true
            driverLabel.isHidden = true
            riderDriverSwitch.isHidden = true
            signUpMode = false
        } else {
            signUpMode = true
            topButtom.setTitle("Signup", for: .normal)
            bottomButton.setTitle("Login", for: .normal)
            riderLabel.isHidden = false
            driverLabel.isHidden = false
            riderDriverSwitch.isHidden = false
        }
    }
    
    var signUpMode = true
    
    func displayAlert(title:String, message:String){
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alertController, animated: true, completion: nil)
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


