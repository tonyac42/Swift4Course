//
//  ViewController.swift
//  Push Notifications
//
//  Created by Tony Coniglio on 2/6/18.
//  Copyright © 2018 Resin. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let url = URL(string: "https://fcm.googleapis.com/fcm/send") {
            var request = URLRequest(url: url)
            request.allHTTPHeaderFields = ["Content-Type":"application/json","Authorization":"AAAABNF4lZw:APA91bHSxWZKqyAmVxFZhkldUq7gU3dNo4MU3Wel0E9QKtjPosbxn8E8By3hNy6dLgvymSVCYAPZ1Z8PF0zeEtyZLGW4ucoahGkdNuxErliwUv1F_YePMlegMS1nxng12spoyRyORPE0"]
            request.httpMethod = "POST"
            request.httpBody = "{\"to\":\"token\", \"notification\":{\"title\":\"This is from HTTP!\"}}".data(using: .utf8)
            URLSession.shared.dataTask(with: request, completionHandler: { (data, urlresponse, error) in
                if error != nil {
                    print(error!)
                } else {
                    
                }
            }).resume()
        }
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
