//
//  ViewController.swift
//  weatherApp
//
//  Created by Tony Coniglio on 11/29/17.
//  Copyright © 2017 Resin. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet var resultLabel: UILabel!
    @IBOutlet var cityTextField: UITextField!
    @IBAction func getWeather(_ sender: Any) {
        if let url = URL(string: "https://www.weather-forecast.com/locations/" + cityTextField.text!.replacingOccurrences(of: " ", with: "-") + "/forecasts/latest") {
            let request = NSMutableURLRequest(url: url)
            let task = URLSession.shared.dataTask(with: request as URLRequest){
                data, response, error in
                var message = ""
                if error != nil{
                    print(error as Any)
                } else {
                    if let unwrappedData = data {
                        let dataString = NSString(data: unwrappedData, encoding: String.Encoding.utf8.rawValue)
                        var stringSeperator = "Weather Forecast Summary:</b><span class=\"read-more-small\"><span class=\"read-more-content\"> <span class=\"phrase\">"
                        if let contentArray =  dataString?.components(separatedBy: stringSeperator){
                            if contentArray.count > 1 {
                                stringSeperator = "</span>"
                                
                                let newContentArray = contentArray[1].components(separatedBy: stringSeperator)
                                if newContentArray.count > 1 {
                                    print(message)
                                    message = newContentArray[0].replacingOccurrences(of: "&deg:", with: "°")
                                }
                                
                            }
                        }
                    }
                    if message == "" {
                        message = "The weather there couldn't be found, please try again."
                        
                        DispatchQueue.main.sync(execute: {
                            self.resultLabel.text = message
                        })
                    } else {
                        self.resultLabel.text = "The weather is not available for this city."
                    }
                }
            }
            task.resume()
        }
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
