
//
//  matchesViewController.swift
//  Tinder-Clone
//
//  Created by Tony Coniglio on 1/9/18.
//  Copyright © 2018 Resin. All rights reserved.
//

import UIKit
import Parse

class matchesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBAction func backTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBOutlet weak var tableView: UITableView!
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return images.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "matchCell", for: indexPath) as? matchTableViewCell {
            cell.messageLabel.text = messages[indexPath.row]
            cell.imageProfile.image = images[indexPath.row]
            cell.recipientObjectId = userIDs[indexPath.row]
            return cell
        }
        return UITableViewCell()
    }
    
    var images : [UIImage] = []
    var userIDs : [String] = []
    var messages : [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        if let query = PFUser.query() {
            query.whereKey("accepted", contains: PFUser.current()?.objectId)
            if let acceptedSwoops =  PFUser.current()?["accepted"] as? [String] {
                query.whereKey("objectId", containedIn: acceptedSwoops)
                query.findObjectsInBackground(block: { (objects, error) in
                    if let users = objects {
                        for user in users {
                            if let theUser = user as? PFUser {
                                if let imageFile = theUser["photo"] as? PFFile {
                                    imageFile.getDataInBackground(block: { (data, error) in
                                        if let imageData = data {
                                            if let image = (UIImage(data: imageData)) {
                                                if let objectId = theUser.objectId {
                                                    let messagesQuery = PFQuery(className: "Messages")
                                                    messagesQuery.whereKey("recipient", equalTo: PFUser.current()?.objectId as Any)
                                                    messagesQuery.whereKey("sender", equalTo: PFUser.current()?.objectId as Any)
                                                    messagesQuery.findObjectsInBackground(block: { (objects, error) in
                                                        var messageText = "Nobody Loves You - Tom from Myspace"
                                                        if let objects = objects {
                                                            for message in objects {
                                                                if let content = message["content"] as? String {
                                                                    messageText = content
                                                                }
                                                            }
                                                        }
                                                        self.userIDs.append(objectId)
                                                        self.images.append(image)
                                                        self.messages.append(messageText)
                                                        self.tableView.reloadData()
                                                    })
                                                }
                                            }
                                        }
                                    })
                                }
                            }
                        }
                    }
                })
            }
        }
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
