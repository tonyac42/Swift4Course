//
//  fieldTableViewCell.swift
//  Instagram
//
//  Created by Tony Coniglio on 1/7/18.
//  Copyright © 2018 Resin. All rights reserved.
//

import UIKit

class fieldTableViewCell: UITableViewCell {
    
    @IBOutlet weak var postedImage: UIImageView!
    @IBOutlet weak var comment: UILabel!
    @IBOutlet weak var userInfo: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func textFieldShouldReturn(_ comment: UITextField) -> Bool {
        comment.resignFirstResponder()
        return true
    }
}
