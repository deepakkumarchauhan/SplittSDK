//
//  SCCommentsTableViewCell.swift
//  SplittConsumer
//
//  Created by Vishal Mandhyan on 26/07/18.
//  Copyright © 2018 Deepak. All rights reserved.
//

import UIKit

class SCCommentsTableViewCell: UITableViewCell {

    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
