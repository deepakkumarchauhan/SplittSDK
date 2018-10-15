//
//  SCHomeCollectionViewCell.swift
//  SplittConsumer
//
//  Created by Vishal Mandhyan on 24/07/18.
//  Copyright © 2018 Deepak. All rights reserved.
//

import UIKit

class SCHomeCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var yesNoView: UIView!
    @IBOutlet weak var starRatingView: UIView!
    @IBOutlet weak var multipleView: UIView!
    @IBOutlet weak var cellMaineView: UIView!
    @IBOutlet weak var playerView: PlayerView!

    @IBOutlet weak var cellTitleLabel: UILabel!
    @IBOutlet weak var cellImageView: UIImageView!
    
    @IBOutlet weak var detailCellQuestionLabel: UILabel!
    @IBOutlet weak var detailCellImageView: UIImageView!
    
    @IBOutlet weak var detailPlayerView: PlayerView!
    @IBOutlet weak var detailCellMainView: UIView!
    
    
    //Profile
    @IBOutlet weak var profileCellMainView: UIView!
    @IBOutlet weak var profilePlayerView: PlayerView!
    @IBOutlet weak var profileCellTitleLabel: UILabel!
    @IBOutlet weak var profileCellImageView: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
}
