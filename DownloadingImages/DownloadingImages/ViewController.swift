//
//  ViewController.swift
//  DownloadingImages
//
//  Created by Tony Coniglio on 12/18/17.
//  Copyright © 2017 Resin. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet var imageView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let url = URL(string: "https://fthmb.tqn.com/ykBuHuD2tqPGEXFN-HSIieS5v2Q=/768x0/filters:no_upscale()/Mona_Lisa-copy-56a6e6d95f9b58b7d0e56987.jpg")!
        let request = NSMutableURLRequest(url: url)
        let task = URLSession.shared.dataTask(with: request as URLRequest){
            data, response, error in
            if error != nil {
                print(error!)
            } else {
                if let data = data {
                    if let monaImage = UIImage(data: data) {
                        self.imageView.image = monaImage
                    }
                }
            }
        }
        task.resume()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
