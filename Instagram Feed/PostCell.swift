//
//  PostCell.swift
//  Instagram Feed
//
//  Created by Darrell Shi on 1/21/16.
//  Copyright © 2016 iOS Development. All rights reserved.
//

import UIKit

class PostCell: UITableViewCell {
    
    @IBOutlet weak var postImageView: UIImageView!
  @IBOutlet weak var profilePictureView: UIImageView!
  @IBOutlet weak var usernameLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
