//
//  ReviewTableViewCell.swift
//  SCHomeViewController
//
//  Created by Vishal Mandhyan on 04/10/18.
//  Copyright © 2018 Deepak. All rights reserved.
//

import UIKit

class ReviewTableViewCell: UITableViewCell {

    @IBOutlet weak var reviewTitleLabel: UILabel!
    @IBOutlet weak var reviewDescriptionLabel: UILabel!
    
    @IBOutlet weak var reviewRateView: FloatRatingView!
    
    @IBOutlet weak var reviewImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
