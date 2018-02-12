//
//  updateViewController.swift
//  Bolts
//
//  Created by Tony Coniglio on 1/8/18.
//

import UIKit
import Parse

class updateViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var userGenderSwitch: UISwitch!
    @IBOutlet weak var interestedInGenderSwitch: UISwitch!
    @IBOutlet weak var profileImageView: UIImageView!
    
    @IBAction func updateImageTapped(_ sender: Any) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = false
        present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            profileImageView.image = image
        }
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func updateTapped(_ sender: Any) {
        PFUser.current()?["isFemale"] = userGenderSwitch.isOn
        PFUser.current()?["isInterestedInWomen"] = interestedInGenderSwitch.isOn
        if let image = profileImageView.image {
            if let imageData = UIImagePNGRepresentation(image) {
                PFUser.current()?["photo"] = PFFile(name: "profile.png", data: imageData)
                PFUser.current()?.signUpInBackground(block: {(success, error) in
                    if error != nil {
                        var errMessage = "Update, try again"
                        if let newError = error as NSError? {
                            if let detailedError = newError.userInfo["error"] as? String {
                                errMessage = detailedError
                                self.errorLabel.text = errMessage
                            }
                        }
                    } else {
                        self.performSegue(withIdentifier: "updateToSwipeSegue", sender: nil)
                    }
                })
            }
        }
    }
    
    func createWomen(){
        let imageURLs = ["https://pics.wikifeet.com/Alyssa-Reid-Feet-1714559.jpg", "https://i.pinimg.com/736x/a8/cf/7b/a8cf7b68e0fec442e51475d5c0e275ef--paget-brewster-interesting-photos.jpg", "https://blog.stylewe.com/wp-content/uploads/2016/11/liv-tyler-fashion-style.jpg", "https://www.newhdwallpapers.in/wp-content/uploads/2014/02/Hayden-Panettiere-Latest-HD-Wallpapers.jpg"] //celberity crushes
        
        var counter = 0
        
        for imageURL in imageURLs {
            let url = URL(string: imageURL)
            counter += 1
            if let data = try? Data(contentsOf: url!){
                let imageFile = PFFile(name: "photo.img", data: data)
                let user = PFUser()
                user["photo"] = imageFile
                switch counter {
                case 0:
                    user.username = "Alyssa Reid"
                case 1:
                    user.username = "Paget Brewster"
                case 2:
                    user.username = "Liv Tyler"
                case 3:
                    user.username = "Hayden Panettiere"
                default:
                    user.username = "#meThree"
                }
                user.password = "password"
                user["isFemale"] = true
                user["isInterestedInWomen "] = false
                user.signUpInBackground(block: {(success, error) in
                    if success {
                        print("Women user created")
                    }
                })
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createWomen()
        if let isFemale = PFUser.current()?["isFemale"] as? Bool {
            userGenderSwitch.setOn(isFemale, animated: false)
        }
        
        if let isInterestedInWomen = PFUser.current()?["isInterestedInWomen"] as? Bool {
            interestedInGenderSwitch.setOn(isInterestedInWomen, animated: false)
        }
        
        if let photo = PFUser.current()?["photo"] as? PFFile {
            photo.getDataInBackground(block: {(data, error) in
                if let imageData = data {
                    if let image = UIImage(data: imageData){
                        self.profileImageView.image = image
                    }
                }
            })
        }
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
}
