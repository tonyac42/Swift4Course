//
//  ViewController.swift
//  downloadingWebContent
//
//  Created by Tony Coniglio on 11/28/17.
//  Copyright © 2017 Resin. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet var webView: UIWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let url = URL(string: "https://www.stackoverflow.com")!
        webView.loadRequest(URLRequest(url:url))
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

