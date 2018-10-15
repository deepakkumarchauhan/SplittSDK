//
//  SCHomeTableViewCell.swift
//  SplittConsumer
//
//  Created by Vishal Mandhyan on 24/07/18.
//  Copyright © 2018 Deepak. All rights reserved.
//

import UIKit

class SCHomeTableViewCell: UITableViewCell {

    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var categoryNameLabel: UILabel!
    
    @IBOutlet weak var daysAgoLabel: UILabel!
    @IBOutlet weak var timeLeftLabel: UILabel!
    @IBOutlet weak var offerLabel: UILabel!
    
    @IBOutlet weak var viewButton: UIButton!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var commentButton: UIButton!
    @IBOutlet weak var answerButton: UIButton!
    @IBOutlet weak var moreButton: UIButton!
    @IBOutlet weak var likeListButton: UIButton!
    
    @IBOutlet weak var pageController: UIPageControl!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var commentLabel: UILabel!
    @IBOutlet weak var commentSwitch: UISwitch!
    
    
    @IBOutlet weak var analyticsView: UIView!
    @IBOutlet weak var analyticsViewButton: UIButton!
    @IBOutlet weak var analyticsLikeButton: UIButton!
    @IBOutlet weak var analyticsCommentButton: UIButton!
    @IBOutlet weak var analyticsViewAnswerButton: UIButton!
    @IBOutlet weak var graphButton: UIButton!
    @IBOutlet weak var analyticsMoreButton: UIButton!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var analyticsLikeListButton: UIButton!
    
    var currentPage = 0
    var currentIndex = 0
    
    
    //Profile
    @IBOutlet weak var profileUserImageView: UIImageView!
    @IBOutlet weak var profileUserNameLabel: UILabel!
    @IBOutlet weak var profileCategoryNameLabel: UILabel!
    
    @IBOutlet weak var profileDaysAgoLabel: UILabel!
    @IBOutlet weak var profileTimeLeftLabel: UILabel!
    @IBOutlet weak var profileOfferLabel: UILabel!
    
    @IBOutlet weak var profileViewButton: UIButton!
    @IBOutlet weak var profileLikeButton: UIButton!
    @IBOutlet weak var profileCommentButton: UIButton!
    @IBOutlet weak var profileAnswerButton: UIButton!
    @IBOutlet weak var profileMoreButton: UIButton!
    @IBOutlet weak var profileLikeListButton: UIButton!
    
    @IBOutlet weak var profilePageController: UIPageControl!
    @IBOutlet weak var profileCollectionView: UICollectionView!
    @IBOutlet weak var profileCommentLabel: UILabel!
    @IBOutlet weak var profileCommentSwitch: UISwitch!
    
    

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    var collectionViewOffset: CGFloat {
        get {
            return collectionView.contentOffset.x
        }
        set {
            collectionView.contentOffset.x = newValue
        }
    }
    
    var CurrentPage: Int {
        get {
            return Int(collectionView.contentOffset.x / collectionView.frame.size.width)
        }
        set {
            currentPage = newValue
        }
    }

}
