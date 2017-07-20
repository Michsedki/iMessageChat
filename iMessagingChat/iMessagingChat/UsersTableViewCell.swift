//
//  UsersTableViewCell.swift
//  iMessagingChat
//
//  Created by Michael Tanious on 7/20/17.
//  Copyright © 2017 WMWiOS. All rights reserved.
//

import UIKit

class UsersTableViewCell: UITableViewCell {
    
    //MARK: - IBOutlets
    
    @IBOutlet weak var profilePicture: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    
    
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
