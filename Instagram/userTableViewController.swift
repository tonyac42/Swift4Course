//
//  userTableViewController.swift
//  Instagram
//
//  Created by Tony Coniglio on 1/6/18.
//  Copyright © 2018 Resin. All rights reserved.
//

import UIKit
import Parse
import ObjectiveC

class userTableViewController: UITableViewController {
    
    var usernames = [""]
    var objectIDs = [""]
    var isFollowing = ["" : false]
    var refresher:UIRefreshControl = UIRefreshControl()
    
    @IBAction func logoutUser(_ sender: Any) {
        PFUser.logOut()
        performSegue(withIdentifier: "logoutSegue", sender: self)
    }
    
    @objc func updateTable(){
        self.usernames.removeAll()
        self.objectIDs.removeAll()
        self.isFollowing.removeAll()
        let query = PFUser.query()
        query?.whereKey("username", notEqualTo: PFUser.current()?.username! as Any)
        query?.findObjectsInBackground(block: {(users, Error) in
            if Error != nil {
                print(Error!)
            } else if let users = users {
                for object in users {
                    if let user = object as? PFUser {
                        if let username = user.username {
                            if let objectID = user.objectId{
                                let usernameArray = username.components(separatedBy: "@")
                                self.usernames.append(usernameArray[0])
                                self.objectIDs.append(objectID)
                                let query = PFQuery(className: "Following")
                                query.whereKey("Follower", equalTo: PFUser.current()?.objectId as Any)
                                query.whereKey("Following", equalTo: objectID)
                                query.findObjectsInBackground(block: {(objects, error) in
                                    if let objects = objects {
                                        if objects.count > 0 {
                                            self.isFollowing[objectID] = true
                                        } else {
                                            self.isFollowing[objectID] = false
                                        }
                                        
                                        if self.usernames.count == self.isFollowing.count {
                                            self.tableView.reloadData()
                                            self.refresher.endRefreshing()
                                        }
                                    }
                                })
                            }
                        }
                    }
                }
            }
        })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateTable()
        refresher.attributedTitle = NSAttributedString(string: "Pull to Refresh")
        refresher.addTarget(self, action: #selector(userTableViewController.updateTable), for: UIControlEvents.valueChanged)
        tableView.addSubview(refresher)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return usernames.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
        cell.textLabel?.text = usernames[indexPath.row]
        if let followsBoolean = isFollowing[objectIDs[indexPath.row]]{
            if followsBoolean {
                cell.accessoryType = UITableViewCellAccessoryType.checkmark
            }
            return cell
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let cell = tableView.cellForRow(at: indexPath)
        if let followsBoolean = isFollowing[objectIDs[indexPath.row]]{
            if followsBoolean {
                isFollowing[objectIDs[indexPath.row]] = false
                cell?.accessoryType = UITableViewCellAccessoryType.none
                let query = PFQuery(className: "Following")
                query.whereKey("Follower", equalTo: PFUser.current()?.objectId as Any)
                query.whereKey("Following", equalTo: objectIDs[indexPath.row])
                query.findObjectsInBackground(block: {(objects, error) in
                    if let objects = objects {
                        for object in objects {
                            object.deleteInBackground()
                        }
                        self.tableView.reloadData()
                    }
                })
            } else {
                isFollowing[objectIDs[indexPath.row]] = true
                cell?.accessoryType = UITableViewCellAccessoryType.checkmark
                let following = PFObject(className: "Following")
                following["Follower"] = PFUser.current()?.objectId
                following["Following"] = objectIDs[indexPath.row]
                following.saveInBackground()
            }
        }
    }
}
/*
 // Override to support conditional editing of the table view.
 override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
 // Return false if you do not want the specified item to be editable.
 return true
 }
 */

/*
 // Override to support editing the table view.
 override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
 if editingStyle == .delete {
 // Delete the row from the data source
 tableView.deleteRows(at: [indexPath], with: .fade)
 } else if editingStyle == .insert {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }
 }
 */

/*
 // Override to support rearranging the table view.
 override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
 
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
 // Return false if you do not want the item to be re-orderable.
 return true
 }
 */

/*
 // MARK: - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
 // Get the new view controller using segue.destinationViewController.
 // Pass the selected object to the new view controller.
 }
 */
