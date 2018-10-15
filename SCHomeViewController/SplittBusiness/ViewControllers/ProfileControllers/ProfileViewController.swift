//
//  ProfileViewController.swift
//  SCHomeViewController
//
//  Created by Vishal Mandhyan on 01/10/18.
//  Copyright © 2018 Deepak. All rights reserved.
//

import UIKit
import AVFoundation

class ProfileViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    static var cellIdentifier = "ProfileHomecellID"
    static var collectionCellIdentifier = "ProfileHomeCollectionCellID"
    var homeArray = [SCHomeInfo]()
    var userInfo = SCUserInfo()
    var otherProfileId = String()
    
    var paginationInfo = CAPaginationInfo()
    var timeLeft : Timer = Timer()
    var selectedIndex : Int = 0
    var avPlayer = AVPlayer()
    var storedOffsets = [Int: CGFloat]()
    var currentIndex = [Int: CGFloat]()
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var userImageButton: UIButton!
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var followButton: UIButton!
    @IBOutlet weak var editButton: UIButton!
    
    @IBOutlet weak var bgImageView: UIImageView!
    
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var splittCountLabel: UILabel!
    @IBOutlet weak var followersCountLabel: UILabel!
    @IBOutlet weak var followingCountLabel: UILabel!
    @IBOutlet weak var groupCountLabel: UILabel!
    @IBOutlet weak var rewardCountLabel: UILabel!
    @IBOutlet weak var noDataFoundLabel: UILabel!

    
    //MARK: UIView Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        initialMethod()
    }
    
    
    //MARK: Custom Method
    func initialMethod() {
        if otherProfileId != "" {
            self.searchButton.setImage(UIImage(named: "back_icon"), for: .normal)
            self.searchButton.setImage(UIImage(named: "back_icon"), for: .highlighted)
            self.followButton.isHidden = false
            self.editButton.isHidden = true
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        callApiForUserProfile(pageNumber: "1")
    }
    
    
    func displayShareSheet(splittObj:SCHomeInfo) {
        // Share Splitt Title and description , it will be change at the time of functionality
        let activityViewController = UIActivityViewController(activityItems: [String.init(format: "Take a look at this Splitt from %@",splittObj.name) as String, "They need your help…" as String, "Click here to help them out!!!" as String, "Link to download https://itunes.apple.com/us/app/splitt-decision/id1358199993?ls=1&mt=8" as String], applicationActivities: nil)
        
        if let popoverController = activityViewController.popoverPresentationController {
            popoverController.sourceRect = CGRect(x: view.center.x, y: view.center.y, width: 0, height: 0)
            popoverController.sourceView = view
            popoverController.permittedArrowDirections = UIPopoverArrowDirection(rawValue: 0)
        }
        
        present(activityViewController, animated: true, completion: {})
    }
    
    
    //MARK:- ScrollView Delegate
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if let _ = scrollView as? UICollectionView {
            let cell = tableView.cellForRow(at: IndexPath(row: scrollView.tag, section: 0) ) as? SCHomeTableViewCell
            cell?.profilePageController.currentPage = Int(cell!.profileCollectionView.contentOffset.x / cell!.profileCollectionView.frame.size.width)
            
            if cell != nil {
                let objSplittModel = homeArray[scrollView.tag]
                objSplittModel.currentIndex = Int(cell!.profileCollectionView.contentOffset.x / cell!.profileCollectionView.frame.size.width)
                print("Current Index\(objSplittModel.currentIndex)")
                if objSplittModel.getType == "survey" {
                    cell?.profileCollectionView.reloadData()
                }
            }
        }
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        let currentOffset = scrollView.contentOffset.y;
        let maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height;
        
        if (maximumOffset - currentOffset <= 10.0) && self.homeArray.count > 0 {
            
            if  (Int(paginationInfo.pageNumber)! < Int(paginationInfo.totalPages)!  && paginationInfo.isLoadMoreExecuting) {
                paginationInfo.pageNumber = String(Int(paginationInfo.pageNumber)! + 1)
                callApiForUserProfile(pageNumber: paginationInfo.pageNumber)
            }
        }
    }
    
    
    //MARK: UITableView Datasource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return homeArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell : SCHomeTableViewCell = tableView.dequeueReusableCell(withIdentifier: ProfileViewController.cellIdentifier) as! SCHomeTableViewCell
        
        let obj = homeArray[indexPath.row]
        cell.profileCollectionView.delegate = self
        cell.profileCollectionView.dataSource = self
        cell.profileCollectionView.reloadData()
        
        cell.profileCollectionView.tag = indexPath.row
        cell.profileViewButton.tag = indexPath.row+100
        cell.profileLikeButton.tag = indexPath.row+100
        cell.profileCommentButton.tag = indexPath.row+100
        cell.profileAnswerButton.tag = indexPath.row+100
        cell.profileMoreButton.tag = indexPath.row+100
        cell.profileLikeListButton.tag = indexPath.row+100
        cell.profileUserImageView.tag = indexPath.row+100
        cell.profileCommentSwitch.tag = indexPath.row+100
        
        cell.profilePageController.numberOfPages = obj.answerAnalyticsArray.count+1
        
        cell.profileUserNameLabel.text = obj.username
        cell.profileCategoryNameLabel.text = obj.category_name
        cell.profileDaysAgoLabel.text = obj.splitt_created_at
        cell.profileTimeLeftLabel.text = obj.remainingTime
        cell.profileOfferLabel.text = obj.reward
        cell.profileViewButton.setTitle(obj.view_count, for: .normal)
        cell.profileLikeButton.setTitle(obj.like_count, for: .normal)
        cell.profileCommentButton.setTitle(obj.comment_count, for: .normal)
        cell.profileAnswerButton.setTitle(obj.answerCount, for: .normal)
        
        let bundle = Bundle(for: HomeViewController.self)
        guard let image = UIImage(named: "profile_img", in: bundle, compatibleWith: nil)?.withRenderingMode(.alwaysOriginal) else {
            fatalError("Missing MyImage...")
        }
        cell.profileUserImageView.imageFromServerURL(obj.userimage, placeHolder: image)

        if obj.is_anonymous {
            let bundle = Bundle(for: HomeViewController.self)
            guard let image = UIImage(named: "profile_img", in: bundle, compatibleWith: nil)?.withRenderingMode(.alwaysOriginal) else {
                fatalError("Missing MyImage...")
            }
            cell.profileUserImageView.image = image
            cell.profileUserNameLabel.text = "Anonymous"
        }
        cell.profileCommentSwitch.isHidden = otherProfileId == "" ? false : true
        cell.profileCommentSwitch.isOn = obj.comment_status == "0" ? false : true
        
        cell.profileViewButton.isSelected = obj.is_view
        cell.profileLikeButton.isSelected = obj.is_like
        cell.profileAnswerButton.isSelected = obj.is_answer
        
        cell.profileViewButton.addTarget(self, action: #selector(self.viewButtonAction(_:)), for: UIControlEvents.touchUpInside)
        cell.profileLikeButton.addTarget(self, action: #selector(self.likeButtonAction(_:)), for: UIControlEvents.touchUpInside)
        cell.profileCommentButton.addTarget(self, action: #selector(self.commentButtonAction(_:)), for: UIControlEvents.touchUpInside)
        cell.profileMoreButton.addTarget(self, action: #selector(self.moreButtonAction(_:)), for: UIControlEvents.touchUpInside)
        cell.profileLikeListButton.addTarget(self, action: #selector(self.likeListButtonAction(_:)), for: UIControlEvents.touchUpInside)
        cell.profileCommentSwitch.addTarget(self, action: #selector(self.commentSwitchAction(_:)), for: UIControlEvents.valueChanged)
        
        return cell
    }
    
    //MARK: UITableView Delegate
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 371.0
    }
    
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let cell = cell as? SCHomeTableViewCell else { return }
        if homeArray.count == 0 {
        } else{
            storedOffsets[indexPath.row] = cell.collectionViewOffset
            currentIndex[indexPath.row]  = cell.collectionViewOffset / cell.collectionView.frame.size.width
        }
        let collectionCell =  cell.profileCollectionView.cellForItem(at: IndexPath(item: 0, section: 0) ) as? SCHomeCollectionViewCell
        collectionCell?.profilePlayerView.player?.pause()
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let cell = (cell as? SCHomeTableViewCell) else { return }
        cell.collectionViewOffset = storedOffsets[indexPath.row] ?? 0
        cell.profilePageController.currentPage = Int(currentIndex[indexPath.row] ?? 0)
        
        let objSplittModel = homeArray[indexPath.row]
        objSplittModel.currentIndex = Int(currentIndex[indexPath.row] ?? 0)
    }
    
    
    //MARK: UICollectionView Datasource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let obj = homeArray[collectionView.tag]
        
        if obj.getType == "survey" {
            return 5
        }
        return obj.answerAnalyticsArray.count+1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProfileViewController.collectionCellIdentifier, for: indexPath) as! SCHomeCollectionViewCell
        
        let obj = homeArray[collectionView.tag]
        cell.profileCellTitleLabel.isHidden = false
        cell.profileCellTitleLabel.text = ""
        
        if obj.getType == "survey" {
            var tempObj = SCHomeInfo()
            //Is Yes/No Survey Splitt
            if obj.is_yes_no == "4" {
                tempObj = obj.surveyOneArray[obj.currentIndex]
            } else if obj.is_yes_no == "5" {
                //Is Likert
                tempObj = obj.surveyZeroArray[obj.currentIndex]
            } else {
                //Is Rating
                tempObj = obj.answerTwoArray[obj.currentIndex]
            }
            if (tempObj.survey_question.length > 0) {
                cell.profileCellImageView.isHidden = true
                cell.profilePlayerView.isHidden = true
                cell.profileCellTitleLabel.isHidden = false
                
                cell.profileCellMainView.backgroundColor = KAppRedColor
                cell.profileCellTitleLabel.textColor = UIColor.white
                cell.profileCellTitleLabel.text = tempObj.survey_question
            }
            return cell
        }
        
        if(obj.getType == "other") {
            cell.profilePlayerView.isHidden = true
            cell.profileCellImageView.isHidden = true
            cell.profileCellImageView.image = UIImage(named: "")
            
            if indexPath.item == 0 {
                cell.profileCellMainView.backgroundColor = KAppRedColor
                cell.profileCellTitleLabel.textColor = UIColor.white
                cell.profileCellTitleLabel.text = obj.questionTitle
            } else {
                let answerString = homeArray[collectionView.tag].answerAnalyticsArray[indexPath.item-1]
                cell.profileCellTitleLabel.textColor = KAppRedColor
                cell.profileCellImageView.backgroundColor = UIColor.white
                cell.profileCellTitleLabel.textColor = UIColor.black
                cell.profileCellTitleLabel.text = answerString
            }
        } else {
            if indexPath.item == 0 {
                if(obj.splitt_type == "Video") {
                    let Extension = NSURL(fileURLWithPath: obj.banner_media).pathExtension
                    if Extension == "mp4"{
                        cell.profileCellTitleLabel.isHidden = true
                        cell.profileCellMainView.isHidden = false
                        cell.profilePlayerView.isHidden = false
                        
                        
                        let bundle = Bundle(for: HomeViewController.self)
                        guard let image = UIImage(named: "img", in: bundle, compatibleWith: nil)?.withRenderingMode(.alwaysOriginal) else {
                            fatalError("Missing MyImage...")
                        }
                        cell.profileCellImageView.imageFromServerURL(obj.thumbnail, placeHolder: image)

                        let url = NSURL(string: obj.banner_media)
                        avPlayer = AVPlayer(url: url! as URL)
                        cell.profilePlayerView?.playerLayer.player = avPlayer
                        cell.profilePlayerView.player?.play()
                    } } else {
                    if (obj.answerAnalyticsArray.count > 0) {
                        if obj.role_type == "2" || obj.role_type == "4" {
                            cell.profileCellMainView.backgroundColor = KAppRedColor
                        } else {
                            cell.profileCellMainView.backgroundColor = KAppBlueColor
                        }
                        cell.profileCellImageView.isHidden = true
                        cell.profileCellTitleLabel.textColor = UIColor.white
                        cell.profileCellTitleLabel.text = obj.splitt_description
                    }
                }
            } else {
                if(obj.role_type == "2" || obj.role_type == "4"){
                    cell.profileCellTitleLabel.textColor = KAppRedColor
                }else {
                    cell.profileCellTitleLabel.textColor = KAppBlueColor
                }
                if(obj.answerType == "") {
                    cell.profileCellImageView.isHidden = false
                    cell.profileCellTitleLabel.isHidden = true
                    cell.profilePlayerView.isHidden = true
                    let bundle = Bundle(for: HomeViewController.self)
                    guard let image = UIImage(named: "image_placeholder", in: bundle, compatibleWith: nil)?.withRenderingMode(.alwaysOriginal) else {
                        fatalError("Missing MyImage...")
                    }
                    cell.profileCellImageView.imageFromServerURL(obj.answerAnalyticsArray[indexPath.item - 1], placeHolder: image)

                } else {
                    let answerString = homeArray[collectionView.tag].answerAnalyticsArray[indexPath.item-1]
                    cell.profileCellMainView.backgroundColor = UIColor.white
                    cell.profileCellTitleLabel.text = answerString
                    cell.profileCellImageView.isHidden = true
                    cell.profilePlayerView.isHidden = true
                    cell.profileCellTitleLabel.isHidden = false
                }
            }
        }
        return cell
    }
    
    //MARK: UICollectionView Delegate
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return collectionView.frame.size
    }

    
    //MARK: UIButton Action Methods
    @IBAction func searchButtonAction(_ sender: Any) {
//        if otherProfileId != "" {
//            self.navigationController?.popViewController(animated: true)
//        } else {
//            let groupVC = SCFollowersControllerViewController()
//            groupVC.fromIndexToChangeView = 4
//            self.navigationController?.pushViewController(groupVC, animated: true)
//        }
    }
    
    @IBAction func editButtonAction(_ sender: Any) {
//        let editVC = SCEditProfileViewController()
//        editVC.userInfo = self.userInfo
//        self.navigationController?.pushViewController(editVC, animated: true)
    }
    
    @IBAction func splittButtonAction(_ sender: Any) {
    }
    
    @IBAction func followerButtonAction(_ sender: Any) {
//        if userInfo.followerCount != "0" {
//            let followerVC = SCFollowersControllerViewController()
//            followerVC.fromIndexToChangeView = 0
//            followerVC.otherUserId = self.otherProfileId
//            self.navigationController?.pushViewController(followerVC, animated: true)
//        }
    }
    
    @IBAction func followingButtonAction(_ sender: Any) {
//        if userInfo.followingCount != "0" {
//            let followingVC = SCFollowersControllerViewController()
//            followingVC.fromIndexToChangeView = 1
//            followingVC.otherUserId = self.otherProfileId
//            self.navigationController?.pushViewController(followingVC, animated: true)
//        }
    }
    
    @IBAction func groupButtonAction(_ sender: Any) {
//        if userInfo.groupCount != "0" {
//            let groupVC = SCFollowersControllerViewController()
//            groupVC.fromIndexToChangeView = 2
//            groupVC.otherUserId = self.otherProfileId
//            self.navigationController?.pushViewController(groupVC, animated: true)
//        }
    }
    
    @IBAction func rewardButtonAction(_ sender: Any) {
//        if userInfo.rewardCount != "0" {
//            let rewardVC = SCRewardListViewController()
//            self.navigationController?.pushViewController(rewardVC, animated: true)
//        }
    }
    
    
    @IBAction func followButtonAction(_ sender: Any) {
        _ = AlertController.alert("", message: "Are you sure you want to follow/unfollow \(self.userNameLabel.text!)?", controller: self, buttons: ["Yes", "No"], tapBlock: { (action, index) in
            if index == 0 {
                self.callApiForFollowUnfollowUser()
            }
        })
    }
    
    
    //MARK: Selector Method
    @objc func likeButtonAction(_ sender: UIButton) {
        let obj = homeArray[sender.tag-100]
        callApiForLikeDislikeSplitt(userObj: obj)
    }
    
    @objc func commentButtonAction(_ sender: UIButton) {
        let obj = homeArray[sender.tag-100]
        let commentVC = SCCommentsViewController()
        commentVC.homeInfo = obj
        self.navigationController?.pushViewController(commentVC, animated: true)
    }
    
    @objc func viewButtonAction(_ sender: UIButton) {
        let obj = homeArray[sender.tag-100]
        let viewVC = SCSplittDetailViewController()
        viewVC.splittDetailObj = obj
        self.navigationController?.pushViewController(viewVC, animated: true)
    }
    
    @objc func likeListButtonAction(_ sender: UIButton) {
//        let obj = homeArray[sender.tag-100]
//        let likeListVC = SCLikeUserListViewController()
//        likeListVC.splittInfo = obj
//        self.navigationController?.pushViewController(likeListVC, animated: true)
    }
    
    
    @objc func commentSwitchAction(_ sender: UISwitch) {
        let obj = homeArray[sender.tag-100]
        callApiForCommentToggleOnOff(pendingObj: obj, toggleStatus: sender.isOn ? "1" : "0")
    }
    
    
    @objc func moreButtonAction(_ sender: UIButton) {
        self.view.endEditing(true)
        if(homeArray.count > 0){
            let obj = homeArray[sender.tag-100]
            let alert = UIAlertController(title: "", message: nil, preferredStyle: .actionSheet)
            alert.addAction(UIAlertAction(title: "Share", style: .default, handler: { _ in
                self.displayShareSheet(splittObj: obj)
            }))
            alert.addAction(UIAlertAction(title: "Report as inappropriate", style: .default, handler: { _ in
                self.callApiForReportSplitt(userObj: obj)
            }))
            alert.addAction(UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil))
            
            if let popoverController = alert.popoverPresentationController {
                popoverController.permittedArrowDirections = UIPopoverArrowDirection.up
                popoverController.sourceView = sender
                popoverController.sourceRect = sender.bounds
            }
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    
    //MARK: Call API
    func callApiForUserProfile(pageNumber: String)
    {
        let dict = NSMutableDictionary()
        dict[cPageNumber] = pageNumber
        dict[cPageSize] = "10"
        dict[cOtherUserId] = NSUSERDEFAULT.value(forKey: cUserId)
        dict[cUserId] = otherProfileId 
        
         CAServiceHelper.sharedServiceHelper.request(dict as! Dictionary<String, AnyObject>, method: .post, apiName: MyProfile, hudType: .simple) { (result, error, status) in
            if (error == nil) {
                if let response = result as? Dictionary<String, AnyObject> {
                    if(status == 200) {
                        let dataDict = response.validatedValue(cData, expected: NSDictionary())as! Dictionary<String,AnyObject>
                        
                        self.userInfo = SCUserInfo.modelFromUserProfileDict(dataDict)
                        
                        let bundle = Bundle(for: HomeViewController.self)
                        guard let image = UIImage(named: "profile_img", in: bundle, compatibleWith: nil)?.withRenderingMode(.alwaysOriginal) else {
                            fatalError("Missing MyImage...")
                        }
                        self.bgImageView.imageFromServerURL(self.userInfo.backgroundImageString, placeHolder: UIImage(named: ""))
                        //self.userImageButton.imageFromServerURL(self.userInfo.userImageString, placeHolder: image)
                        
                        self.splittCountLabel.text = self.userInfo.splittCount
                        self.followersCountLabel.text = self.userInfo.followerCount
                        self.followingCountLabel.text = self.userInfo.followingCount
                        self.groupCountLabel.text = self.userInfo.groupCount
                        self.rewardCountLabel.text = self.userInfo.rewardCount
                        self.userNameLabel.text = self.userInfo.fullName
                        
                        self.followButton.setTitle(self.userInfo.isFollow ? "+Unfollow" : "+Follow", for: .normal)
                        
                        let paginationInfo :Dictionary<String,AnyObject> = response.validatedValue(cPagination, expected: Dictionary<String,AnyObject>() as AnyObject) as! Dictionary<String, AnyObject>
                        
                        self.paginationInfo = CAPaginationInfo.getPaginationData(paginationInfo)
                        if self.paginationInfo.pageNumber == "1" {
                            self.homeArray.removeAll()
                        }
                        
                        let dataArray = dataDict.validatedValue(cSplittData, expected: NSArray()) as! [Dictionary<String,AnyObject>]
                        
                        //Data Parsing
                        for dict in dataArray {
                            self.homeArray.append(SCHomeInfo.modelFromAnalyticsDict(dict))
                        }
                        let tempArray = BTAppUtility.getTimerData(splittArray: self.homeArray)
                        self.homeArray = tempArray
                        
                        self.noDataFoundLabel.isHidden = self.homeArray.count == 0 ? false : true
                        
                        self.tableView.reloadData()
                    }
                    else {
                        _ = AlertController.alert("", message: response.validatedValue(pResponseMessage, expected: "" as AnyObject) as! String)
                    }
                }
            }
            else {
                _ = AlertController.alert("", message: "\(error!.localizedDescription)")
            }
        }
    }
    
    func callApiForLikeDislikeSplitt(userObj: SCHomeInfo)
    {
        let dict = NSMutableDictionary()
        dict[cUserId] = NSUSERDEFAULT.value(forKey: cUserId)
        dict[cSplittId] = userObj.splitt_id
        
         CAServiceHelper.sharedServiceHelper.request(dict as! Dictionary<String, AnyObject>, method: .post, apiName: LikeSplitt, hudType: .simple) { (result, error, status) in
            if (error == nil) {
                if let response = result as? Dictionary<String, AnyObject> {
                    if(status == 200) {
                        userObj.is_like = !userObj.is_like
                        userObj.like_count = userObj.is_like ? "\(Int(userObj.like_count)! + 1)" : "\(Int(userObj.like_count)! - 1)"
                        self.tableView.reloadData()
                    }
                    else {
                        _ = AlertController.alert("", message: response.validatedValue(pResponseMessage, expected: "" as AnyObject) as! String)
                    }
                }
            }
            else {
                _ = AlertController.alert("", message: "\(error!.localizedDescription)")
            }
        }
    }
    
    
    func callApiForReportSplitt(userObj: SCHomeInfo)
    {
        let dict = NSMutableDictionary()
        dict[cUserId] = NSUSERDEFAULT.value(forKey: cUserId)
        dict[cSplittId] = userObj.splitt_id
        
         CAServiceHelper.sharedServiceHelper.request(dict as! Dictionary<String, AnyObject>, method: .post, apiName: ReportSplittApi, hudType: .simple) { (result, error, status) in
            if (error == nil) {
                if let response = result as? Dictionary<String, AnyObject> {
                    if(status == 200) {
                        _ = AlertController.alert("", message: response.validatedValue(pResponseMessage, expected: "" as AnyObject) as! String)
                        self.tableView.reloadData()
                    }
                    else {
                        _ = AlertController.alert("", message: response.validatedValue(pResponseMessage, expected: "" as AnyObject) as! String)
                    }
                }
            }
            else {
                _ = AlertController.alert("", message: "\(error!.localizedDescription)")
            }
        }
    }
    
    
    func callApiForFollowUnfollowUser()
    {
        let dict = NSMutableDictionary()
        dict[cFollowBy] = NSUSERDEFAULT.value(forKey: cUserId)
        dict[cFollowTo] = otherProfileId
        
         CAServiceHelper.sharedServiceHelper.request(dict as! Dictionary<String, AnyObject>, method: .post, apiName: FollowUnfollow, hudType: .simple) { (result, error, status) in
            if (error == nil) {
                if let response = result as? Dictionary<String, AnyObject> {
                    if(status == 200) {
                        self.followButton.setTitle(self.followButton.titleLabel?.text == "+Follow" ? "+Unfollow" : "+Follow", for: .normal)
                    }
                    else {
                        _ = AlertController.alert("", message: response.validatedValue(pResponseMessage, expected: "" as AnyObject) as! String)
                    }
                }
            }
            else {
                _ = AlertController.alert("", message: "\(error!.localizedDescription)")
            }
        }
    }
    
    func callApiForCommentToggleOnOff(pendingObj: SCHomeInfo, toggleStatus: String)
    {
        let dict = NSMutableDictionary()
        dict[cUserId] = NSUSERDEFAULT.value(forKey: cUserId)
        dict[cSplittId] = pendingObj.splitt_id
        dict[cSplittCommentType] = toggleStatus
        
         CAServiceHelper.sharedServiceHelper.request(dict as! Dictionary<String, AnyObject>, method: .post, apiName: kCommentToggleApi, hudType: .simple) { (result, error, status) in
            if (error == nil) {
                if let response = result as? Dictionary<String, AnyObject> {
                    if(status == 200) {
                        pendingObj.comment_status = pendingObj.comment_status == "0" ? "1" : "0"
                        self.tableView.reloadData()
                    }
                    else {
                        _ = AlertController.alert("", message: response.validatedValue(pResponseMessage, expected: "" as AnyObject) as! String)
                    }
                }
            }
            else {
                _ = AlertController.alert("", message: "\(error!.localizedDescription)")
            }
        }
    }


    
    //MARK: Memory Management Mathod
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
