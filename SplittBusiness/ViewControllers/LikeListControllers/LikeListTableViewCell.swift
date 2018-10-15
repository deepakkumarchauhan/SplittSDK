//
//  LikeListTableViewCell.swift
//  SCHomeViewController
//
//  Created by Vishal Mandhyan on 04/10/18.
//  Copyright © 2018 Deepak. All rights reserved.
//

import UIKit

class LikeListTableViewCell: UITableViewCell {
    
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
