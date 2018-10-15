//
//  SCAnswerTableViewCell.swift
//  SplittConsumer
//
//  Created by Vishal Mandhyan on 28/07/18.
//  Copyright © 2018 Deepak. All rights reserved.
//

import UIKit

class SCAnswerTableViewCell: UITableViewCell {

    @IBOutlet weak var radioButton: UIButton!
    
    @IBOutlet weak var optionLabel: UILabel!
    @IBOutlet weak var cellTitleLabel: UILabel!
    
    @IBOutlet weak var cellImageView: UIImageView!
    
    
    @IBOutlet weak var detailRadioButton: UIButton!
    
    @IBOutlet weak var detailOptionLabel: UILabel!
    
    @IBOutlet weak var detailImageView: UIImageView!
    
    @IBOutlet weak var detailTitleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
