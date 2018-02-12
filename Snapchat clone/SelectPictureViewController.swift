//
//  SelectPictureViewController.swift
//  GoogleToolboxForMac
//
//  Created by Tony Coniglio on 2/5/18.
//

import UIKit
import FirebaseStorage

class SelectPictureViewController: UIViewController, UIImagePickerControllerDelegate {
    
    var imagePicker : UIImagePickerController?
    var imageAdded = false
    var imageName = "\(NSUUID().uuidString).jpg"
    
    @IBAction func cameraTapped(_ sender: Any) {
        if imagePicker != nil {
            imagePicker?.sourceType = .camera
            present(imagePicker!, animated: true, completion: nil)
        }
    }
    
    @IBAction func photoTapped(_ sender: Any) {
        if imagePicker != nil {
            imagePicker?.sourceType = .photoLibrary
            present(imagePicker!, animated: true, completion: nil)
        }
    }
    
    @IBAction func nextTapped(_ sender: Any) {
        if let message = message.text {
            if message != "" && imageAdded == true {
                //Store
                let imagesFolder = Storage.storage().reference().child("images")
                if let image = imageView.image {
                    if let imageData = UIImageJPEGRepresentation(image, 0.1) {
                        imagesFolder.child(imageName).putData(imageData, metadata: nil, completion: { (metadata, error) in
                            if let error = error {
                                let alertVC = UIAlertController.init(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
                                let okAction = UIAlertAction(title: "OK", style: .default) { (action) in
                                    alertVC.dismiss(animated: true, completion: nil)
                                }
                                alertVC.addAction(okAction)
                                self.present(alertVC, animated: true, completion: nil)
                                
                            } else {
                                if let downloadURL = metadata?.downloadURL()?.absoluteString {
                                    self.performSegue(withIdentifier: "selectReceiver", sender: downloadURL)
                                }
                            }
                        })
                    }
                }
            } else {
                let alertVC = UIAlertController.init(title: "Error", message: "Must provide both image and msg", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK", style: .default) { (action) in
                    alertVC.dismiss(animated: true, completion: nil)
                }
                alertVC.addAction(okAction)
                present(alertVC, animated: true, completion: nil)
            }
        }
    }
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var message: UITextField!
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info [UIImagePickerControllerOriginalImage] as? UIImage {
            imageView.image = image
            imageAdded = true
        }
        dismiss(animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let downloadURL = sender as? String {
            if let selectVC = segue.destination as? SelectRecipientTableViewController {
                selectVC.downloadURL = downloadURL
                selectVC.snapDescription = message.text!
                selectVC.imageName = imageName
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker = UIImagePickerController()
        imagePicker?.delegate = self as? UIImagePickerControllerDelegate & UINavigationControllerDelegate
        
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
