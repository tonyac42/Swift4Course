//
//  SecondViewController.swift
//  toDoList
//
//  Created by Tony Coniglio on 11/27/17.
//  Copyright © 2017 Resin. All rights reserved.
//
import UIKit
class SecondViewController: UIViewController, UITextFieldDelegate {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    @IBOutlet var itemField: UITextField!
    @IBAction func addAnItem(_ sender: Any) {
        let itemsObject = UserDefaults.standard.object(forKey: "items")
        var items:[String]
        if let tempItems = itemsObject as? [String]{
            items = tempItems
            items.append(itemField.text!)
        }
        else {
            items = [itemField.text!]
        }
        UserDefaults.standard.set(items, forKey: "items")
        itemField.text = ""
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
