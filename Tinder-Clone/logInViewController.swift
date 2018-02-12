//
//  logInViewController.swift
//  
//
//  Created by Tony Coniglio on 1/8/18.
//

import UIKit
import Parse

class logInViewController: UIViewController {
    
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginOrSignUpButton: UIButton!
    @IBOutlet weak var changeButton: UIButton!
    @IBAction func loginSignUpTapped(_ sender: Any) {
        if signUpMode == true {
            let user = PFUser()
            user.username = usernameTextField.text
            user.password = passwordTextField.text
            user.signUpInBackground(block: {(success, error) in
                if error != nil {
                    var errMessage = "Sign up failed, try again"
                    if let newError = error as NSError? {
                        if let detailedError = newError.userInfo["error"] as? String {
                            errMessage = detailedError
                            self.errorLabel.text = errMessage
                        }
                    }
                }
            })
            self.performSegue(withIdentifier: "updateSegue", sender: nil)
        } else {
            if let username = self.usernameTextField.text {
                if let password = self.passwordTextField.text{
                    PFUser.logInWithUsername(inBackground: username, password: password, block: {(user, error) in
                        if error != nil {
                            var errMessage = "Login failed, try again"
                            if let newError = error as NSError? {
                                if let detailedError = newError.userInfo["error"] as? String {
                                    errMessage = detailedError
                                    self.errorLabel.text = errMessage
                                }
                            }
                        }
                    })
                }
            }
            if PFUser.current()?["isFemale"] != nil {
                self.performSegue(withIdentifier: "loginToSwipingSegue", sender: nil)
            } else {
                self.performSegue(withIdentifier: "updateSegue ", sender: nil)
            }
        }
    }
    
    override func  viewDidAppear(_ animated: Bool) {
        if PFUser.current() != nil {
            if PFUser.current()?["isFemale"] != nil {
                self.performSegue(withIdentifier: "loginToSwipingSegue", sender: nil)
            } else {
                self.performSegue(withIdentifier: "updateSegue", sender: nil)
            }
        }
    }
    
    @IBAction func changeLoginSignUpTapped(_ sender: Any) {
        if signUpMode == true {
            loginOrSignUpButton.setTitle("login", for: .normal)
            changeButton.setTitle("Sign Up", for: .normal)
            signUpMode = false
        } else {
            loginOrSignUpButton.setTitle("Sign Up", for: .normal)
            changeButton.setTitle("login", for: .normal)
            signUpMode = true
        }
    }
    
    var signUpMode = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

/*
 // MARK: - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
 // Get the new view controller using segue.destinationViewController.
 // Pass the selected object to the new view controller.
 }
 */
