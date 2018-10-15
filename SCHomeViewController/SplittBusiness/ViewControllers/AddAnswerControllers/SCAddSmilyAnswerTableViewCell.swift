//
//  SCAddSmilyAnswerTableViewCell.swift
//  SplittConsumer
//
//  Created by Vishal Mandhyan on 24/08/18.
//  Copyright © 2018 Deepak. All rights reserved.
//

import UIKit

class SCAddSmilyAnswerTableViewCell: UITableViewCell {

    @IBOutlet weak var stronglyDisagreeButton: SCCustomButton!
    @IBOutlet weak var disagreeButtton: SCCustomButton!
    @IBOutlet weak var neutralButton: SCCustomButton!
    @IBOutlet weak var agreeButton: SCCustomButton!
    @IBOutlet weak var stronglyAgreeButton: SCCustomButton!
    
    @IBOutlet weak var stronglyDisagreeImageView: UIImageView!
    @IBOutlet weak var disAgreeImageView: UIImageView!
    @IBOutlet weak var neutralImageView: UIImageView!
    @IBOutlet weak var agreeImageView: UIImageView!
    @IBOutlet weak var stronglyAgreeImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.stronglyDisagreeImageView.layer.cornerRadius = self.stronglyDisagreeImageView.layer.frame.size.width/2
        self.disAgreeImageView.layer.cornerRadius = self.disAgreeImageView.layer.frame.size.width/2
        self.neutralImageView.layer.cornerRadius = self.neutralImageView.layer.frame.size.width/2
        self.agreeImageView.layer.cornerRadius = self.agreeImageView.layer.frame.size.width/2
        self.stronglyAgreeImageView.layer.cornerRadius = self.stronglyAgreeImageView.layer.frame.size.width/2
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
