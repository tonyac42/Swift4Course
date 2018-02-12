//
//  ViewController.swift
//  Instagram
//
//  Created by Tony Coniglio on 1/4/18.
//  Copyright © 2018 Resin. All rights reserved.
//

import UIKit
import Parse

class ViewController: UIViewController {
    
    func displayAlert(title:String, message:String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action) in
            self.dismiss(animated: true, completion: nil)
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    var signUpModeActive = true
    
    @IBOutlet weak var haveAccountLabel: UILabel!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    
    @IBAction func signUpOrLogIn(_ sender: Any) {
        if email.text == "" || password.text == "" {
            displayAlert(title:"Error in from", message: "Please enter an email and password")
        } else {
            
            let activityIndicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
            activityIndicator.center = self.view.center
            activityIndicator.hidesWhenStopped = true
            activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
            view.addSubview(activityIndicator)
            UIApplication.shared.beginIgnoringInteractionEvents()
            
            if (signUpModeActive) {
                print("Singning up....")
                let user = PFUser()
                user.username = email.text
                user.password = password.text
                user.email = email.text
                user.signUpInBackground(block: { (success, error) in
                    activityIndicator.stopAnimating()
                    UIApplication.shared.endIgnoringInteractionEvents()
                    if let error = error {
                        print(error)
                        self.displayAlert(title: "Could not sign you up", message: error.localizedDescription)
                        // Show the errorString somewhere and let the user try again.
                    } else {
                        print("Signed up")
                        self.performSegue(withIdentifier: "showUserTable", sender: self)
                        // Hooray! Let them use the app now.
                    }
                })
            } else {
                activityIndicator.stopAnimating()
                UIApplication.shared.endIgnoringInteractionEvents()
                PFUser.logInWithUsername(inBackground: email.text!, password: password.text!, block: {(user, Error) in
                    if user != nil {
                        print("Login Successful")
                        self.performSegue(withIdentifier: "showUserTable", sender: self)
                    } else {
                        var errorText = "Unknown error.  Please Try again."
                        if Error != nil {
                            errorText = Error!.localizedDescription
                            self.displayAlert(title: "Could not sign you in", message: errorText)
                        }
                    }
                })
            }
        }
    }
    @IBOutlet weak var signUpOrLogInButton: UIButton!
    @IBOutlet weak var switchLoginMode: UIButton!
    @IBAction func switchLogIn(_ sender: Any) {
        if (signUpModeActive) {
            signUpModeActive = false
            signUpOrLogInButton.setTitle("Login", for: [])
            switchLoginMode.setTitle("Sign Up", for: [])
            haveAccountLabel.text = "New to Instagram Sign Up:"
        } else {
            signUpModeActive = true
            signUpOrLogInButton.setTitle("Sign up", for: [])
            switchLoginMode.setTitle("Login", for: [])
            haveAccountLabel.text = "Already have an account?"
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if PFUser.current() != nil {
            self.performSegue(withIdentifier: "showUserTable", sender: self)
            self.navigationController?.navigationBar.isHidden = true
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if (textField == email) {
            password.becomeFirstResponder()
        } else if (textField == password) {
            self.signUpOrLogIn(<#Any#>)
        }
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        /*let gameScore = PFObject(className:"GameScore")
         gameScore["score"] = 1337
         gameScore["playerName"] = "Sean Plott"
         gameScore["cheatMode"] = false
         gameScore.saveInBackground {
         (success: Bool, error: Error?) in
         if (success) {
         // The object has been saved.
         print("success")
         } else {
         // There was a problem, check error.description
         print("failed")
         }
         }
         let comment = PFObject(className: "Comment")
         comment["Text"] = "Nice Shot"
         comment.saveInBackground { (success, error) in
         if (success) {
         print("save successful")
         } else {
         print("save failed")
         }
         }
         let query = PFQuery(className: "Comment")
         query.getObjectInBackground(withId: "NyjOp8Ssbi") { (object, error) in
         if let comment = object {
         print(comment)
         }
         }*/
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
