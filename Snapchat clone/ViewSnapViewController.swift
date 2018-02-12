//
//  ViewSnapViewController.swift
//  GoogleToolboxForMac
//
//  Created by Tony Coniglio on 2/5/18.
//
//

import UIKit
import Firebase
import SDWebImage

class ViewSnapViewController: UIViewController {
    
    var snap : DataSnapshot?
    var imageName = ""
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var messageLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let snapDictionary = snap?.value as? NSDictionary {
            if let description = snapDictionary["description"] as? String {
                if let imageURL = snapDictionary["imageURL"] as? String {
                    messageLabel.text = description
                    if let URL = URL(string: imageURL){
                        imageView.sd_setImage(with: URL)
                    }
                    if let imageName = snapDictionary["imageName"] {
                        self.imageName = imageName
                    }
                }
            }
        }
    }
}
