//
//  SnapsTableViewController.swift
//  Snapchat clone
//
//  Created by Tony Coniglio on 2/5/18.
//  Copyright © 2018 Resin. All rights reserved.
//

import UIKit
import Firebase

class SnapsTableViewController: UITableViewController {
    
    var snaps : [DataSnapshot] = []
    
    @IBAction func logOutTapped(_ sender: Any) {
        try? Auth.auth().signOut()
        dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let currentUseruid = Auth.auth().currentUser?.uid {
            Database.database().reference().child("users").child(currentUseruid).child("snaps").observe(.childAdded, with: { (snapshot) in
                self.snaps.append(snapshot)
                self.tableView.reloadData()
                
            })
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if snaps.count == 0 {
            return 1
        } else {
            return snaps.count
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        let snap = snaps[indexPath.row]
        
        if snaps.count == 0 {
            cell.textLabel?.text = "You have no snaps...🤡"
        } else {
            
            if let snapDictionary = snap.value as? NSDictionary {
                if let fromEmail = snapDictionary["from"] as? String {
                    cell.textLabel?.text = fromEmail
                }
            }
            return cell
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let snap = snaps[indexPath.row]
        performSegue(withIdentifier: "toViewSnap", sender: snap)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toViewSnap" {
            if let viewVC = segue.destination as? ViewSnapViewController {
                if let snap = sender as? DataSnapshot {
                    viewVC.snap = snap
                }
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        if let currentUserUid = Auth.auth().currentUser?.uid{
            if let key = snap.key {
                Database.database().reference().child("users").child(currentUserUid).child("snaps").child(key).removeValue()
                Storage.storage().reference().child("images").child(imageName).delete(completion: nil)
                
                Database.database().reference().child("users").child(currentUserUid).child("snaps").observe(.childRemoved, with: { (snapshot) in
                    var index = 0
                    for snap in self.snaps {
                        if snapshot.key = snap.key {
                            self.snaps.remove(at: index)
                        }
                        index += 1
                    }
                    self.tableView.reloadData()
                })
            }
        }
    }
}
