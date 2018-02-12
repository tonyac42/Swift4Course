
//
//  matchTableViewCell.swift
//  Tinder-Clone
//
//  Created by Tony Coniglio on 1/9/18.
//  Copyright © 2018 Resin. All rights reserved.
//

import UIKit
import Parse

class matchTableViewCell: UITableViewCell {
    
    var recipientObjectId = ""
    
    @IBOutlet weak var messageText: UITextField!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var imageProfile: UIImageView!
    @IBAction func sendButton(_ sender: Any) {
        let message = PFObject(className: "Message")
        message["sender"] = PFUser.current()?.objectId
        message["recipient"] = recipientObjectId
        message["content"] = messageText.text
        message.saveInBackground()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
