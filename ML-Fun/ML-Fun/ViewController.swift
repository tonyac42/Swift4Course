//
//  ViewController.swift
//  ML-Fun
//
//  Created by Tony Coniglio on 2/3/18.
//  Copyright © 2018 Resin. All rights reserved.
//

import UIKit
import CoreML
import Vision

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var confidenceLabel: UILabel!
    
    @IBAction func photosTapped(_ sender: Any) {
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func cameraTapped(_ sender: Any) {
        imagePicker.sourceType = .camera
        present(imagePicker, animated: true, completion: nil)
    }
    
    let resNetModel = Resnet50()
    var imagePicker = UIImagePickerController()
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let selectedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            imageView.image = selectedImage
            picker.dismiss(animated: true, completion: nil)
            processImage(image: selectedImage)
        }
    }
    
    func processImage(image:UIImage) {
        if let model = try? VNCoreMLModel(for: self.resNetModel.model) {
            let request = VNCoreMLRequest(model: model, completionHandler: { (request, error) in
                if let results = request.results as? [VNClassificationObservation] {
                    for classification in results { // loops through all results of the model
                        print("ID: \(classification.identifier), Confidence: \(classification.confidence)")
                    }
                    if let confidence = results.first?.confidence  {
                        self.confidenceLabel.text = "\(100 * confidence)%"
                    }
                    if let result = results.first?.identifier {
                        self.descriptionLabel.text = result
                    }
                }
            })
            if let imageData = UIImagePNGRepresentation(image) {
                let handler = VNImageRequestHandler(data: imageData, options: [:])
                try? handler.perform([request])
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imagePicker.delegate = self
        
        if let image = imageView.image {
            processImage(image: image)
        }
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
