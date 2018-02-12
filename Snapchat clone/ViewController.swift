//
//  ViewController.swift
//  Snapchat clone
//
//  Created by Tony Coniglio on 2/4/18.
//  Copyright © 2018 Resin. All rights reserved.
//

//Login - top button, sign up - bottom button

import UIKit
import FirebaseAuth
import FirebaseStorage
import FirebaseDatabase

class ViewController: UIViewController {
    
    var signupMode = false
    
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var signupButton: UIButton!
    
    @IBAction func loginTapped(_ sender: Any) {
        if let email = email.text {
            if let password = password.text {
                if signupMode {
                    //sign up
                    Auth.auth().createUser(withEmail: email, password: password, completion: { (user, error) in
                        if let error = error {
                            self.presentAlert(alert: error.localizedDescription)
                        } else {
                            print("sign up success")
                            if let user = user {
                                Database.database().reference().child("users").child(user.uid).child(email).setValue(user.email)
                                self.performSegue(withIdentifier: "moveToSnaps", sender: nil)
                            }
                        }
                    })
                } else {
                    //log in
                    Auth.auth().signIn(withEmail: email, password: password, completion: { (user, error) in
                        if let error = error {
                            self.presentAlert(alert: error.localizedDescription)
                        } else {
                            print("login success")
                            self.performSegue(withIdentifier: "moveToSnaps", sender: nil)
                        }
                    })
                }
            }
        }
    }
    
    @IBAction func signupTapped(_ sender: Any) {
        if signupMode {
            //switch to login
            signupMode = false
            loginButton.setTitle("Login", for: .normal)
            signupButton.setTitle("Sign Up", for: .normal)
        } else {
            //switch to sign up
            signupMode = true
            loginButton.setTitle("Sign Up", for: .normal)
            signupButton.setTitle("Login", for: .normal)
        }
    }
    
    func presentAlert(alert: String) {
        let alertVC = UIAlertController.init(title: "Error", message: alert, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) { (action) in
            alertVC.dismiss(animated: true, completion: nil)
        }
        alertVC.addAction(okAction)
        present(alertVC, animated: true, completion: nil)
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
