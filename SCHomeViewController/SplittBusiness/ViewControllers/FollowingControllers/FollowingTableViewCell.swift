//
//  FollowingTableViewCell.swift
//  SCHomeViewController
//
//  Created by Vishal Mandhyan on 08/10/18.
//  Copyright © 2018 Deepak. All rights reserved.
//

import UIKit

class FollowingTableViewCell: UITableViewCell {
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var followButton: UIButton!
    @IBOutlet weak var blockButton: UIButton!
    @IBOutlet weak var unfollowButton: UIButton!
    
    @IBOutlet weak var titleRightConstraint: NSLayoutConstraint!
    @IBOutlet weak var titleLeftConstraint: NSLayoutConstraint!
    @IBOutlet weak var seperatorLeftConstraint: NSLayoutConstraint!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
