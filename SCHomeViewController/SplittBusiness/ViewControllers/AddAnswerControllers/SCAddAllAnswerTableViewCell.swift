//
//  SCAddAllAnswerTableViewCell.swift
//  SplittBusinesses
//
//  Created by Vishal Mandhyan on 21/08/18.
//  Copyright © 2018 Deepak. All rights reserved.
//

import UIKit

class SCAddAllAnswerTableViewCell: UITableViewCell {


    @IBOutlet weak var noImageView: UIImageView!
    @IBOutlet weak var yesImageView: UIImageView!

    @IBOutlet weak var noButton: SCCustomButton!
    @IBOutlet weak var yesButton: SCCustomButton!
    
    @IBOutlet weak var noView: UIView!
    @IBOutlet weak var yesView: UIView!
    
    @IBOutlet weak var rateView: FloatRatingView!
    
    @IBOutlet weak var outerView: UIView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
