//
//  SCHomeViewController.swift
//  SplittConsumer
//
//  Created by Vishal Mandhyan on 24/07/18.
//  Copyright © 2018 Deepak. All rights reserved.
//

import UIKit
import AVFoundation
import GoogleMaps

 public class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, FilterHomeProtocol, GiveAnswerProtocol, PopUpProtocol, RewardPopUpProtocol {
    static var cellIdentifier = "HomeTableCellID"
    static var collectionCellIdentifier = "HomeCollectionCellID"
    var homeArray = [SCHomeInfo]()
    var filterInfo = SCUserInfo()

    var SplittsViewType : SplittsViewTypeEnum?
    var paginationInfo = CAPaginationInfo()
    var selectedTabIndex = Int()

    public var userId = String()
    public var userName = String()
    public var emailId = String()
    public var countryCode = String()
    public var mobile = String()
    public var businessKey = String()

    var timeLeft : Timer = Timer()
    var selectedIndex : Int = 0
    var avPlayer = AVPlayer()
    var storedOffsets = [Int: CGFloat]()
    var currentIndex = [Int: CGFloat]()
    
    enum SplittsViewTypeEnum {
        case AllType, TrendingType, LocalType, GroupType, DirectType
    }
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var allButton: UIButton!
    @IBOutlet weak var notificationCountLabel: UILabel!
    
    @IBOutlet weak var groupButton: UIButton!
    @IBOutlet weak var createGroupButton: UIButton!
    
    @IBOutlet weak var noDataFoundLabel: UILabel!
    
    //MARK: UIView Life Cycle
    override public func viewDidLoad() {
        super.viewDidLoad()

        //Google API Key
        GMSServices.provideAPIKey("AIzaSyAXypWVpP7-OrJd0AqLBpGbqjCCFKqrJHM")
        
        loadMyFonts()
        pullToRefresh()
        initialMethod()
    }
    
    override public func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        refreshData()
    }
    

    override public func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // Pause the player on view disappear
        for i in 0..<homeArray.count {
            if let cell = tableView.cellForRow(at: IndexPath(row: i, section: 0)) as? SCHomeTableViewCell {
                let collectionCell =  cell.collectionView.cellForItem(at: IndexPath(item: 0, section: 0) ) as? SCHomeCollectionViewCell
                collectionCell?.playerView.player?.pause()
            }
        }
        // invalidate the timer
        self.timeLeft.invalidate()
    }

    //MARK: Custom Method
   public func initialMethod() {

        setSelectedButton(sender: self.allButton, type: SplittsViewTypeEnum.AllType)

        //Start Timer
        self.timeLeft = Timer.scheduledTimer(timeInterval: 1, target: self,   selector: (#selector(self.updateData)), userInfo: nil, repeats: true)

        callApiForCreateNewUser()
    }
    
    public func navigateToHome(controller: UINavigationController) {
        controller.pushViewController(self, animated: false)
    }
    
    func pauseVideo() {
        // Pause all video player
        for i in 0..<homeArray.count {
            if let cell = tableView.cellForRow(at: IndexPath(row: i, section: 0)) as? SCHomeTableViewCell {
                let collectionCell =  cell.collectionView.cellForItem(at: IndexPath(item: 0, section: 0) ) as? SCHomeCollectionViewCell
                collectionCell?.playerView.player?.pause()
            }
        }
    }

    func setSelectedButton(sender: UIButton, type: SplittsViewTypeEnum) {
        for tag in 100...104{
            let tmpButton = self.view.viewWithTag(tag) as? UIButton
            tmpButton?.isSelected = false
            tmpButton?.layer.borderWidth = 0.0
            tmpButton?.titleLabel?.font = KAppButtonNormalFont
        }
        homeArray.removeAll()
        filterInfo.timeline = ""
        filterInfo.timelineId = ""
        filterInfo.isOnlyConnection = true
        filterInfo.filterArray.removeAll()
        self.createGroupButton.isHidden = true
        
        // Pause all video player
        pauseVideo()

        SplittsViewType = type
        sender.isSelected = true
        sender.layer.borderWidth = 2.0
        sender.layer.borderColor = kHomeButtonBorderColor.cgColor
        sender.setTitleColor(UIColor.white, for: .selected)
        sender.titleLabel?.font = KAppButtonBoldFont
        self.tableView.reloadData()
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
    
    func refreshData() {
        if selectedTabIndex == 0 {
            callApiForHomeSplittList(pageNumber: "1", apiName: AllSplittFeeds)
        } else if selectedTabIndex == 1 {
            callApiForHomeSplittList(pageNumber: "1", apiName: TrendingSplittFeeds)
        } else if selectedTabIndex == 2 {
            callApiForHomeSplittList(pageNumber: "1", apiName: LocalSplittFeeds)
        } else if selectedTabIndex == 3 {
            callApiForHomeSplittList(pageNumber: "1", apiName: GroupSplittFeeds)
        } else if selectedTabIndex == 4 {
            callApiForHomeSplittList(pageNumber: "1", apiName: DirectSplittFeeds)
        }
    }
    
    
    func pullToRefresh() {
        let loadingView = DGElasticPullToRefreshLoadingViewCircle()
        loadingView.tintColor = UIColor(red: 78/255.0, green: 221/255.0, blue: 200/255.0, alpha: 1.0)
        tableView.dg_addPullToRefreshWithActionHandler({ [weak self] () -> Void in
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64(0.2 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: {
                self?.refreshData()
                self?.tableView.dg_stopLoading()
            })
            }, loadingView: loadingView)
        tableView.dg_setPullToRefreshFillColor(UIColor(red: 57/255.0, green: 67/255.0, blue: 89/255.0, alpha: 1.0))
        tableView.dg_setPullToRefreshBackgroundColor(tableView.backgroundColor!)
    }
    
    
    //MARK: - Check the timer seconds
    @objc func updateData() {
        // update the left secs on cell
        let splittTempArray = BTAppUtility.getTimerData(splittArray: self.homeArray)
        self.homeArray = splittTempArray
        for i in 0..<self.homeArray.count {
            if let cell = tableView.cellForRow(at: IndexPath(row: i, section: 0)) as? SCHomeTableViewCell {
                cell.timeLeftLabel.text = homeArray[i].remainingTime
                
                //                cell.cellTimeLeftLabel.text = "60 secs left"
                if cell.timeLeftLabel.text!.contains("secs left") {
                    let stringArray = cell.timeLeftLabel.text!.components(separatedBy: CharacterSet.decimalDigits.inverted)
                    
                    if Int(stringArray.first!)! <= 60 {
                        DispatchQueue.main.async {
                            cell.timeLeftLabel.alpha = 1.0
                            UIView.animate(withDuration: 1, delay: 0, options: .repeat, animations: {
                                cell.timeLeftLabel.alpha = 0.2
                            }, completion: nil)
                        }
                    }
                }
                
                if homeArray[i].isTimerPopUpShown {
                    //Show Alert When Splitt Expire
                    homeArray[i].isTimerPopUpShown = false
                    let expireVC = self.storyboard?.instantiateViewController(withIdentifier: "ExpireVC") as! SExpireViewController
                    expireVC.modalPresentationStyle = .overCurrentContext
                    expireVC.titleText = "Your \(homeArray[i].splitt_description) Splitt just expired.\nWould you like to view the result?"
                    expireVC.delegate = self
                    self.selectedIndex = i
                    self.present(expireVC, animated: false, completion: nil)
                }
                
                //                [UIView animateWithDuration:1.5 delay:0.5 options:UIViewAnimationOptionRepeat | UIViewAnimationOptionAutoreverse animations:^{
                //                    self.yourLabel.alpha = 0;
                //                    } completion:nil];
            }
        }
    }

    
    
    //MARK: UIScrollView Delegate
    public func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        let currentOffset = scrollView.contentOffset.y;
        let maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height;
        
        if (maximumOffset - currentOffset <= 10.0) && self.homeArray.count > 0 {
            
            if  (Int(paginationInfo.pageNumber)! < Int(paginationInfo.totalPages)!  && paginationInfo.isLoadMoreExecuting) {
                paginationInfo.pageNumber = String(Int(paginationInfo.pageNumber)! + 1)
                if selectedTabIndex == 0 {
                    callApiForHomeSplittList(pageNumber: paginationInfo.pageNumber, apiName: AllSplittFeeds)
                } else if selectedTabIndex == 1 {
                    callApiForHomeSplittList(pageNumber: paginationInfo.pageNumber, apiName: TrendingSplittFeeds)
                } else if selectedTabIndex == 2 {
                    callApiForHomeSplittList(pageNumber: paginationInfo.pageNumber, apiName: LocalSplittFeeds)
                } else if selectedTabIndex == 3 {
                    callApiForHomeSplittList(pageNumber: paginationInfo.pageNumber, apiName: GroupSplittFeeds)
                } else if selectedTabIndex == 4 {
                    callApiForHomeSplittList(pageNumber: paginationInfo.pageNumber, apiName: DirectSplittFeeds)
                }
            }
        }
    }

    
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if let _ = scrollView as? UICollectionView {
            let cell = tableView.cellForRow(at: IndexPath(row: scrollView.tag, section: 0) ) as? SCHomeTableViewCell
            print("Tag:-\(scrollView.tag)")
            cell?.pageController.currentPage = Int(cell!.collectionView.contentOffset.x / cell!.collectionView.frame.size.width)
        }
    }

    
    //MARK: UITableView Datasource
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return homeArray.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell : SCHomeTableViewCell = tableView.dequeueReusableCell(withIdentifier: HomeViewController.cellIdentifier) as! SCHomeTableViewCell
        
        let obj = homeArray[indexPath.row]
        cell.collectionView.delegate = self
        cell.collectionView.dataSource = self
        cell.collectionView.reloadData()
        
        cell.collectionView.tag = indexPath.row
        cell.viewButton.tag = indexPath.row+100
        cell.likeButton.tag = indexPath.row+100
        cell.commentButton.tag = indexPath.row+100
        cell.answerButton.tag = indexPath.row+100
        cell.moreButton.tag = indexPath.row+100
        cell.likeListButton.tag = indexPath.row+100
        cell.userImageView.tag = indexPath.row+100
        cell.addButton.tag = indexPath.row+100

        cell.analyticsView.isHidden = true
        cell.pageController.numberOfPages = obj.answerAnalyticsArray.count+1
        
        if obj.getType == "survey" {
            cell.pageController.numberOfPages = 0
            cell.addButton.isHidden = false
        } else {
            cell.addButton.isHidden = true
        }

        cell.userNameLabel.text = obj.username
        cell.categoryNameLabel.text = obj.category_name
        cell.daysAgoLabel.text = obj.splitt_created_at
        cell.timeLeftLabel.text = obj.remainingTime
        cell.offerLabel.text = obj.reward
        cell.viewButton.setTitle(obj.view_count, for: .normal)
        cell.likeButton.setTitle(obj.like_count, for: .normal)
        cell.commentButton.setTitle(obj.comment_count, for: .normal)
        cell.answerButton.setTitle(obj.answerCount, for: .normal)
        
        let bundle = Bundle(for: HomeViewController.self)
        guard let image = UIImage(named: "profile_img", in: bundle, compatibleWith: nil)?.withRenderingMode(.alwaysOriginal) else {
            fatalError("Missing MyImage...")
        }
        cell.userImageView.downloadedFrom(link: obj.userimage, contentMode: .scaleToFill, placeholderImage: image)

        if obj.is_anonymous {
            cell.userImageView.image = image
            cell.userNameLabel.text = "Anonymous"
        }

        cell.viewButton.isSelected = obj.is_view
        cell.likeButton.isSelected = obj.is_like
        cell.answerButton.isSelected = obj.is_answer
        
        cell.viewButton.addTarget(self, action: #selector(self.viewButtonAction(_:)), for: UIControlEvents.touchUpInside)
        cell.likeButton.addTarget(self, action: #selector(self.likeButtonAction(_:)), for: UIControlEvents.touchUpInside)
        cell.commentButton.addTarget(self, action: #selector(self.commentButtonAction(_:)), for: UIControlEvents.touchUpInside)
        cell.answerButton.addTarget(self, action: #selector(self.answerButtonAction(_:)), for: UIControlEvents.touchUpInside)
        cell.moreButton.addTarget(self, action: #selector(self.moreButtonAction(_:)), for: UIControlEvents.touchUpInside)
        cell.likeListButton.addTarget(self, action: #selector(self.likeListButtonAction(_:)), for: UIControlEvents.touchUpInside)
        cell.addButton.addTarget(self, action: #selector(self.addAnswerButtonAction(_:)), for: UIControlEvents.touchUpInside)

        cell.userImageView.isUserInteractionEnabled = true
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        cell.userImageView.addGestureRecognizer(tap)
        
        let answerDoubleTap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.handleSplittDoubleTap(_:)))
        answerDoubleTap.numberOfTapsRequired = 2
        cell.collectionView.addGestureRecognizer(answerDoubleTap)

        return cell
    }
    
    //MARK: UITableView Delegate
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 371.0
    }
    
    public func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let cell = cell as? SCHomeTableViewCell else { return }
        if homeArray.count == 0 {
        } else{
            storedOffsets[indexPath.row] = cell.collectionViewOffset
            currentIndex[indexPath.row]  = cell.collectionViewOffset / cell.collectionView.frame.size.width
        }
        let collectionCell =  cell.collectionView.cellForItem(at: IndexPath(item: 0, section: 0) ) as? SCHomeCollectionViewCell
        collectionCell?.playerView.player?.pause()
    }

    public func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let cell = (cell as? SCHomeTableViewCell) else { return }
        cell.collectionViewOffset = storedOffsets[indexPath.row] ?? 0
        cell.pageController.currentPage = Int(currentIndex[indexPath.row] ?? 0)
        
        let objSplittModel = homeArray[indexPath.row]
        objSplittModel.currentIndex = Int(currentIndex[indexPath.row] ?? 0)
    }

    
    //MARK: UICollectionView Datasource
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let obj = homeArray[collectionView.tag]
        
        if obj.getType == "survey" {
            return 1
        }
        if(obj.getType == "pro"){
            if(obj.isYesQuestionSelected){
                return obj.splitYesAnswerArray.count + 1
            }else if(obj.isNoQuestionSelected){
                return obj.splitNoAnswerArray.count + 1
            }else{
                return obj.proSplittAnswarType.count + 1
            }
        } else {
            return obj.answerAnalyticsArray.count+1
        }
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeViewController.collectionCellIdentifier, for: indexPath) as! SCHomeCollectionViewCell
        let obj = homeArray[collectionView.tag]
        cell.cellTitleLabel.isHidden = false
        cell.cellTitleLabel.text = ""
        cell.playerView.isHidden = true

        if obj.getType == "survey" {
            cell.cellTitleLabel.textColor = UIColor.white
            cell.cellMaineView.backgroundColor = KAppRedColor
            
            cell.cellImageView.isHidden = true
            cell.playerView.isHidden = true
            cell.cellTitleLabel.isHidden = false
            
            if obj.isYesNo == "5" {
                let tempObj = obj.surveyZeroArray[obj.selectedIndex]
                cell.cellTitleLabel.text = tempObj.survey_question
                
                switch indexPath.item {
                case 1:
                    cell.cellTitleLabel.text = obj.strStronglyDisAgree
                case 2:
                    cell.cellTitleLabel.text = obj.strDisagree
                case 3:
                    cell.cellTitleLabel.text = obj.strNuetral
                case 4:
                    cell.cellTitleLabel.text = obj.strAgree
                case 5:
                    cell.cellTitleLabel.text = obj.strStronglyAgree
                    
                default:
                    break
                }
                
            } else if obj.isYesNo == "4" {
                let tempObj = obj.surveyOneArray[obj.selectedIndex]
                cell.cellTitleLabel.text = tempObj.survey_question
                
                switch indexPath.item {
                case 1:
                    cell.cellTitleLabel.text = obj.strYes
                case 2:
                    cell.cellTitleLabel.text = obj.strNo
                    
                default:
                    break
                }
            } else {
                let tempObj = obj.answerTwoArray[obj.selectedIndex]
                cell.cellTitleLabel.text = tempObj.survey_question
                
                switch indexPath.item {
                case 1:
                    cell.cellTitleLabel.text = obj.star_one
                case 2:
                    cell.cellTitleLabel.text = obj.star_two
                case 3:
                    cell.cellTitleLabel.text = obj.star_three
                case 4:
                    cell.cellTitleLabel.text = obj.star_four
                case 5:
                    cell.cellTitleLabel.text = obj.star_five
                    
                default:
                    break
                }
            }
        } else {
            if(obj.getType == "other") {
                cell.playerView.isHidden = true
                cell.cellImageView.isHidden = true
                cell.cellImageView.image = UIImage(named: "")
                
                if indexPath.item == 0 {
                    cell.cellMaineView.backgroundColor = KAppRedColor
                    cell.cellTitleLabel.textColor = UIColor.white
                    cell.cellTitleLabel.text = obj.questionTitle
                } else {
                    let answerString = homeArray[collectionView.tag].answerAnalyticsArray[indexPath.item-1]
                    cell.cellMaineView.backgroundColor = UIColor.white
                    cell.cellTitleLabel.textColor = UIColor.black
                    cell.cellTitleLabel.text = answerString
                }
            } else {
                if indexPath.item == 0 {
                    if(obj.splitt_type == "Video") {
                        let Extension = NSURL(fileURLWithPath: obj.banner_media).pathExtension
                        if Extension == "mp4"{
                            cell.cellTitleLabel.isHidden = true
                            cell.cellMaineView.isHidden = false
                            cell.cellImageView.isHidden = false
                            cell.playerView.isHidden = false
                            cell.cellMaineView.backgroundColor = UIColor.white

                            let bundle = Bundle(for: HomeViewController.self)
                            guard let image = UIImage(named: "img", in: bundle, compatibleWith: nil)?.withRenderingMode(.alwaysOriginal) else {
                                fatalError("Missing MyImage...")
                            }
                            cell.cellImageView.downloadedFrom(link: obj.thumbnail, contentMode: .scaleToFill, placeholderImage: image)

                            let url = NSURL(string: obj.banner_media)
                            avPlayer = AVPlayer(url: url! as URL)
                            cell.playerView?.playerLayer.player = avPlayer
                            cell.playerView.player?.play()
                        } } else {
                        if (obj.answerAnalyticsArray.count > 0) {
                            cell.cellMaineView.backgroundColor = KAppRedColor

                            cell.cellTitleLabel.isHidden = false
                            cell.cellImageView.isHidden = true
                            cell.cellTitleLabel.textColor = UIColor.white
                            cell.cellTitleLabel.text = obj.splitt_description
                        }
                    }
                } else {
                    cell.cellTitleLabel.textColor = KAppRedColor

                    if(obj.answerType == "") {
                        cell.cellImageView.isHidden = false
                        cell.cellTitleLabel.isHidden = true
                        cell.playerView.isHidden = true
                        cell.cellMaineView.backgroundColor = UIColor.white

                        let bundle = Bundle(for: HomeViewController.self)
                        guard let image = UIImage(named: "image_placeholder", in: bundle, compatibleWith: nil)?.withRenderingMode(.alwaysOriginal) else {
                            fatalError("Missing MyImage...")
                        }
                       
                        cell.cellImageView.downloadedFrom(link: obj.answerAnalyticsArray[indexPath.item - 1], contentMode: .scaleToFill, placeholderImage: image)
                    }else{
                        let answerString = homeArray[collectionView.tag].answerAnalyticsArray[indexPath.item-1]
                        cell.cellMaineView.backgroundColor = UIColor.white
                        cell.cellTitleLabel.text = answerString
                        cell.cellImageView.isHidden = true
                        cell.playerView.isHidden = true
                        cell.cellTitleLabel.isHidden = false
                    }
                }
            }
        }
        return cell
    }
    
    
    //MARK: UICollectionView Delegate
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return collectionView.frame.size
    }

    
    //MARK: UIButton Action Method
    @IBAction func backButtonAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func allButtonAction(_ sender: UIButton) {
        selectedTabIndex = 0
        setSelectedButton(sender: sender, type: SplittsViewTypeEnum.AllType)
        callApiForHomeSplittList(pageNumber: "1", apiName: AllSplittFeeds)
    }
    
    @IBAction func trendingButtonAction(_ sender: UIButton) {
        selectedTabIndex = 1
        setSelectedButton(sender: sender, type: SplittsViewTypeEnum.TrendingType)
        callApiForHomeSplittList(pageNumber: "1", apiName: TrendingSplittFeeds)
    }
    
    @IBAction func localButtonAction(_ sender: UIButton) {
        selectedTabIndex = 2
        setSelectedButton(sender: sender, type: SplittsViewTypeEnum.LocalType)
        callApiForHomeSplittList(pageNumber: "1", apiName: LocalSplittFeeds)
    }
    
    @IBAction func groupButtonAction(_ sender: UIButton) {
        selectedTabIndex = 3
        setSelectedButton(sender: sender, type: SplittsViewTypeEnum.GroupType)
        callApiForHomeSplittList(pageNumber: "1", apiName: GroupSplittFeeds)
    }
    
    @IBAction func directButtonAction(_ sender: UIButton) {
        selectedTabIndex = 4
        setSelectedButton(sender: sender, type: SplittsViewTypeEnum.DirectType)
        callApiForHomeSplittList(pageNumber: "1", apiName: DirectSplittFeeds)
    }
    
    
    @IBAction func filterButtonAction(_ sender: Any) {
        //Pause Video
        pauseVideo()

        let filterVC = self.storyboard?.instantiateViewController(withIdentifier: "FilterVC") as! SCFilterViewController
        filterVC.delegate = self
        filterVC.businessKey = businessKey
        filterVC.filterInfo = filterInfo
        filterVC.modalPresentationStyle = .overCurrentContext
        filterVC.modalTransitionStyle = .crossDissolve
        self.present(filterVC, animated: false, completion: nil)
    }
    
    @IBAction func notificationButtonAction(_ sender: Any) {
//        let notiVC = SCNotificationViewController()
//        self.navigationController?.pushViewController(notiVC, animated: true)
    }
    
    @IBAction func createGroupButtonAction(_ sender: Any) {
//        let createGroupVC = SCCreateGroupViewController()
//        self.navigationController?.pushViewController(createGroupVC, animated: true)
    }
    
    
    //MARK: Selector Method
    @objc func handleTap(_ sender: UITapGestureRecognizer) {
        self.view.endEditing(true)
        if(homeArray.count > 0) {
            let obj = homeArray[((sender.view?.tag)!-100)]
            if(!obj.is_anonymous) {
                if(obj.role_type == "2" || obj.role_type == "4"){
                    let businessProfile = self.storyboard?.instantiateViewController(withIdentifier: "BusinessProfileVC") as! BusinessProfileViewController
                    businessProfile.businessKey = businessKey
                    businessProfile.otherProfileId = obj.user_id
                    self.navigationController?.pushViewController(businessProfile, animated: true)
                } else {
                    let userProfile = self.storyboard?.instantiateViewController(withIdentifier: "ProfileVC") as! ProfileViewController
//                    userProfile.businessKey = businessKey
                    userProfile.otherProfileId = obj.user_id
                    self.navigationController?.pushViewController(userProfile, animated: true)
                }
            }
        }
    }
    
    @objc func handleSplittDoubleTap(_ sender: UITapGestureRecognizer) {
        self.view.endEditing(true)
        
        if(homeArray.count > 0 ) {
            let obj = homeArray[((sender.view?.tag)!)]
            
            if obj.remainingTime == "No time left" {
                _ = AlertController.alert("", message: "Sorry, You can not answer this Splitt.")
            } else {
                
                let cell = self.tableView.cellForRow(at: IndexPath(row: ((sender.view?.tag)!), section: 0) ) as! SCHomeTableViewCell
                let currentIndex = cell.pageController.currentPage
                if currentIndex > 0 {
                    if obj.getType == "survey" {
                        if obj.is_yes_no == "5" {
                            
                            if obj.is_anonymous_pro == "1" && obj.selectedIndex == 0 {
                                _ = AlertController.alert("", message: "Are you sure you want to answer this Splitt as anonymous?", controller: self, buttons: ["Yes", "No"], tapBlock: { (action, index) in
                                    if index == 0 {
                                        if obj.selectedIndex < obj.surveyZeroArray.count {
                                            let tempObj = obj.surveyZeroArray[obj.selectedIndex]
                                            
                                            let params : Dictionary<String, AnyObject> = [
                                                cSplittId : obj.splitt_id as AnyObject,
                                                "proSplittType" : "survey" as AnyObject,
                                                "survey_type" : "5" as AnyObject,
                                                "survey_type_answer" : "\(currentIndex)" as AnyObject,
                                                "question_type" : tempObj.questionId as AnyObject,
                                                "pro_is_anonymous" : "1" as AnyObject,
                                                cUserId  : NSUSERDEFAULT.value(forKey: cUserId) as AnyObject ]
                                            
                                            self.callApiForAddAnswer(params: params, cell: cell, obj: tempObj)
                                        }
                                    } else {
                                        if obj.selectedIndex < obj.surveyZeroArray.count {
                                            let tempObj = obj.surveyZeroArray[obj.selectedIndex]
                                            
                                            let params : Dictionary<String, AnyObject> = [
                                                cSplittId : obj.splitt_id as AnyObject,
                                                "proSplittType" : "survey" as AnyObject,
                                                "survey_type" : "5" as AnyObject,
                                                "survey_type_answer" : "\(currentIndex)" as AnyObject,
                                                "question_type" : tempObj.questionId as AnyObject,
                                                "pro_is_anonymous" : "0" as AnyObject,
                                                cUserId  : NSUSERDEFAULT.value(forKey: cUserId) as AnyObject ]

                                            self.callApiForAddAnswer(params: params, cell: cell, obj: tempObj)
                                        }
                                        
                                    }
                                })
                            } else {
                                if obj.selectedIndex < obj.surveyZeroArray.count {
                                    let tempObj = obj.surveyZeroArray[obj.selectedIndex]
                                    let params : Dictionary<String, AnyObject> = [
                                        cSplittId : obj.splitt_id as AnyObject,
                                        "proSplittType" : "survey" as AnyObject,
                                        "survey_type" : "5" as AnyObject,
                                        "survey_type_answer" : "\(currentIndex)" as AnyObject,
                                        "question_type" : tempObj.questionId as AnyObject,
                                        "pro_is_anonymous" : "1" as AnyObject,
                                        cUserId  : NSUSERDEFAULT.value(forKey: cUserId) as AnyObject ]
                                    self.callApiForAddAnswer(params: params, cell: cell, obj: tempObj)
                                }
                            }
                            
                        } else if obj.is_yes_no == "6" {
                            
                            if obj.is_anonymous_pro == "1" && obj.selectedIndex == 0 {
                                _ = AlertController.alert("", message: "Are you sure you want to answer this Splitt as anonymous?", controller: self, buttons: ["Yes", "No"], tapBlock: { (action, index) in
                                    if index == 0 {
                                        if obj.selectedIndex < obj.answerTwoArray.count {
                                            let tempObj = obj.answerTwoArray[obj.selectedIndex]
                                            
                                            let params : Dictionary<String, AnyObject> = [
                                                cSplittId : obj.splitt_id as AnyObject,
                                                "proSplittType" : "survey" as AnyObject,
                                                "survey_type" : "6" as AnyObject,
                                                "survey_type_answer" : "\(currentIndex)" as AnyObject,
                                                "question_type" : tempObj.questionId as AnyObject,
                                                "pro_is_anonymous" : "1" as AnyObject,
                                                cUserId  : NSUSERDEFAULT.value(forKey: cUserId) as AnyObject ]
                                            
                                            self.callApiForAddAnswer(params: params, cell: cell, obj: tempObj)
                                        }
                                    } else {
                                        if obj.selectedIndex < obj.answerTwoArray.count {
                                            let tempObj = obj.answerTwoArray[obj.selectedIndex]
                                            
                                            let params : Dictionary<String, AnyObject> = [
                                                cSplittId : obj.splitt_id as AnyObject,
                                                "proSplittType" : "survey" as AnyObject,
                                                "survey_type" : "6" as AnyObject,
                                                "survey_type_answer" : "\(currentIndex)" as AnyObject,
                                                "question_type" : tempObj.questionId as AnyObject,
                                                "pro_is_anonymous" : "0" as AnyObject,
                                                cUserId  : NSUSERDEFAULT.value(forKey: cUserId) as AnyObject ]
                                            
                                            self.callApiForAddAnswer(params: params, cell: cell, obj: tempObj)
                                        }
                                        
                                    }
                                })
                            } else {
                                if obj.selectedIndex < obj.answerTwoArray.count {
                                    let tempObj = obj.answerTwoArray[obj.selectedIndex]
                                    let params : Dictionary<String, AnyObject> = [
                                        cSplittId : obj.splitt_id as AnyObject,
                                        "proSplittType" : "survey" as AnyObject,
                                        "survey_type" : "6" as AnyObject,
                                        "survey_type_answer" : "\(currentIndex)" as AnyObject,
                                        "question_type" : tempObj.questionId as AnyObject,
                                        "pro_is_anonymous" : "1" as AnyObject,
                                        cUserId  : NSUSERDEFAULT.value(forKey: cUserId) as AnyObject ]
                                    self.callApiForAddAnswer(params: params, cell: cell, obj: tempObj)
                                }
                            }
                            
                        } else {
                            if obj.is_anonymous_pro == "1" && obj.selectedIndex == 0 {
                                
                                _ = AlertController.alert("", message: "Are you sure you want to answer this Splitt as anonymous?", controller: self, buttons: ["Yes", "No"], tapBlock: { (action, index) in
                                    if index == 0 {
                                        if obj.selectedIndex < obj.surveyOneArray.count {
                                            //Call API
                                            let tempObj = obj.surveyOneArray[obj.selectedIndex]
                                            let params : Dictionary<String, AnyObject> = [
                                                cSplittId : obj.splitt_id as AnyObject,
                                                "proSplittType" : "survey" as AnyObject,
                                                "survey_type" : "4" as AnyObject,
                                                "survey_type_answer" : "\(currentIndex)" as AnyObject,
                                                "question_type" : tempObj.questionId as AnyObject,
                                                "pro_is_anonymous" : "1" as AnyObject,
                                                cUserId  : NSUSERDEFAULT.value(forKey: cUserId) as AnyObject ]
                                            self.callApiForAddAnswer(params: params, cell: cell, obj: tempObj)
                                        }
                                        
                                    } else {
                                        if obj.selectedIndex < obj.surveyOneArray.count {
                                            //Call API
                                            let tempObj = obj.surveyOneArray[obj.selectedIndex]
                                            
                                            let params : Dictionary<String, AnyObject> = [
                                                cSplittId : obj.splitt_id as AnyObject,
                                                "proSplittType" : "survey" as AnyObject,
                                                "survey_type" : "4" as AnyObject,
                                                "survey_type_answer" : "\(currentIndex)" as AnyObject,
                                                "question_type" : tempObj.questionId as AnyObject,
                                                "pro_is_anonymous" : "0" as AnyObject,
                                                cUserId  : NSUSERDEFAULT.value(forKey: cUserId) as AnyObject ]
                                            self.callApiForAddAnswer(params: params, cell: cell, obj: tempObj)
                                        }
                                    }
                                })
                            } else {
                                if obj.selectedIndex < obj.surveyOneArray.count {
                                    //Call API
                                    let tempObj = obj.surveyOneArray[obj.selectedIndex]
                                    let params : Dictionary<String, AnyObject> = [
                                        cSplittId : obj.splitt_id as AnyObject,
                                        "proSplittType" : "survey" as AnyObject,
                                        "survey_type" : "4" as AnyObject,
                                        "survey_type_answer" : "\(currentIndex)" as AnyObject,
                                        "question_type" : tempObj.questionId as AnyObject,
                                        "pro_is_anonymous" : "" as AnyObject,
                                        cUserId  : NSUSERDEFAULT.value(forKey: cUserId) as AnyObject ]
                                    self.callApiForAddAnswer(params: params, cell: cell, obj: tempObj)
                                }
                            }
                        }
                    } else {
                        if(currentIndex > 0) {
                            if(obj.getType == "pro"){
                                tapprdOnProSplitt(currentIndex: currentIndex, splittObj: obj, cell: cell)
                            }else{
                                callApiForAnswer(currentIndex: currentIndex, splittObj: obj, cell: cell)
                            }
                        }
                    }
                }
            }
        }
    }
    
    
    func tapprdOnProSplitt(currentIndex :Int, splittObj : SCHomeInfo, cell: SCHomeTableViewCell){
        if(!splittObj.isYesQuestionSelected && !splittObj.isNoQuestionSelected){
            if(currentIndex == 1){
                splittObj.isYesQuestionSelected = true
                splittObj.isNoQuestionSelected = false
            }else if(currentIndex == 2){
                splittObj.isYesQuestionSelected = false
                splittObj.isNoQuestionSelected = true
            }
            let params : Dictionary<String, AnyObject> = [
                cSplittId : splittObj.splitt_id as AnyObject,
                "user_id"  : UserDefaults.standard.value(forKey: cUserId) as AnyObject
                
            ]
            self.callApiForCalculateSplittTime(params: params, cell: cell)
            
        }else if(splittObj.isYesQuestionSelected){
            
            let ee = splittObj.splitYesAnswerArray[currentIndex - 1]
            print(ee)
            var ansTitle = ""
            switch currentIndex{
            case 1:
                ansTitle = "A"
                break
            case 2:
                ansTitle = "B"
                break
            case 3:
                ansTitle = "C"
                break
            case 4:
                ansTitle = "D"
                break
            default :
                ansTitle = ""
                break
            }
            
            
            let params : Dictionary<String, AnyObject> = [
                cSplittId : splittObj.splitt_id as AnyObject,
                "user_id"  : UserDefaults.standard.value(forKey: cUserId) as AnyObject,
                "splitt_option" : "Yes" as AnyObject,
                "answer" : ansTitle  as AnyObject
            ]
            self.callApiForProSplitt(params: params, cell: cell)
        }else if(splittObj.isNoQuestionSelected){
            let ee = splittObj.splitNoAnswerArray[currentIndex - 1]
            print(ee)
            var ansTitle = ""
            switch currentIndex{
            case 1:
                ansTitle = "A"
                break
            case 2:
                ansTitle = "B"
                break
            case 3:
                ansTitle = "C"
                break
            case 4:
                ansTitle = "D"
                break
            default :
                ansTitle = ""
                break
            }
            let params : Dictionary<String, AnyObject> = [
                cSplittId : splittObj.splitt_id as AnyObject,
                "user_id"  : UserDefaults.standard.value(forKey: cUserId) as AnyObject,
                "splitt_option" : "No" as AnyObject,
                "answer" : ansTitle  as AnyObject
            ]
            self.callApiForProSplitt(params: params, cell: cell)
        }else {
            return
        }
        
        self.tableView.reloadData()
    }

    
    @objc func viewButtonAction(_ sender: UIButton) {
        let obj = homeArray[sender.tag-100]
        let viewVC = self.storyboard?.instantiateViewController(withIdentifier: "SplittDetailVC") as! SCSplittDetailViewController
        viewVC.splittDetailObj = obj
        viewVC.businessKey = businessKey
        self.navigationController?.pushViewController(viewVC, animated: true)
    }
    
    @objc func likeButtonAction(_ sender: UIButton) {
        let obj = homeArray[sender.tag-100]
        callApiForLikeDislikeSplitt(userObj: obj)
    }
    
    @objc func commentButtonAction(_ sender: UIButton) {
        let obj = homeArray[sender.tag-100]
        let commentVC = self.storyboard?.instantiateViewController(withIdentifier: "CommentVC") as! SCCommentsViewController
        commentVC.homeInfo = obj
        commentVC.businessKey = businessKey
        self.navigationController?.pushViewController(commentVC, animated: true)
    }
    
    @objc func answerButtonAction(_ sender: UIButton) {
        let obj = self.homeArray[sender.tag-100]
        if obj.getType == "survey" {
            let obj = homeArray[sender.tag-100]
            let allAnswerVC = self.storyboard?.instantiateViewController(withIdentifier: "AddAnswerCellID") as! SCAddAllAnswerViewController
            allAnswerVC.questionObj = obj
            allAnswerVC.businessKey = businessKey
            allAnswerVC.modalPresentationStyle = .overCurrentContext
            allAnswerVC.modalTransitionStyle = .crossDissolve
            self.present(allAnswerVC, animated: true, completion: nil)
        } else {
            DispatchQueue.main.async(execute: {
                let answerVC = self.storyboard?.instantiateViewController(withIdentifier: "AnswerVC") as! SCAnswerViewController
                answerVC.modalPresentationStyle = .overCurrentContext
                answerVC.modalTransitionStyle = .crossDissolve
                answerVC.splittDetailObj = obj
                answerVC.businessKey = self.businessKey

                if(obj.answerType == "Multiple Choice  (A,B,C,D)" || obj.answerType == "Multiple Choice (A,B,C,D)"){
                    answerVC.contentType = AnswerTypeEnum.multipleChoiceAnswer
                }else if(obj.answerType == "Yes/No"){
                    answerVC.contentType = AnswerTypeEnum.yesNoAnswer
                }else if(obj.answerType == ""){
                    answerVC.contentType = AnswerTypeEnum.ImageAnswer
                }
                self.present(answerVC, animated: false, completion: nil)
            })
        }
    }
    
    //AddAnswerCellID
    @objc func addAnswerButtonAction(_ sender: UIButton) {
        let obj = homeArray[sender.tag-100]
        let allAnswerVC = self.storyboard?.instantiateViewController(withIdentifier: "AddAnswerCellID") as! SCAddAllAnswerViewController
        allAnswerVC.businessKey = businessKey
        allAnswerVC.questionObj = obj
        allAnswerVC.modalPresentationStyle = .overCurrentContext
        allAnswerVC.modalTransitionStyle = .crossDissolve
        self.present(allAnswerVC, animated: true, completion: nil)
    }
    
    
    @objc func likeListButtonAction(_ sender: UIButton) {
        let obj = homeArray[sender.tag-100]
        let likeListVC = self.storyboard?.instantiateViewController(withIdentifier: "LikeListVC") as! LikeListViewController
        likeListVC.splittInfo = obj
        likeListVC.businessKey = businessKey
        self.navigationController?.pushViewController(likeListVC, animated: true)
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
    
    
    //Custom Delegate
    func callHomeApiAfterFilter(filterInfo: SCUserInfo) {
        self.filterInfo = filterInfo
        if selectedTabIndex == 0 {
            callApiForHomeSplittList(pageNumber: "1", apiName: AllSplittFeeds)
        } else if selectedTabIndex == 1 {
            callApiForHomeSplittList(pageNumber: "1", apiName: TrendingSplittFeeds)
        } else if selectedTabIndex == 2 {
            callApiForHomeSplittList(pageNumber: "1", apiName: LocalSplittFeeds)
        } else if selectedTabIndex == 3 {
            callApiForHomeSplittList(pageNumber: "1", apiName: GroupSplittFeeds)
        } else if selectedTabIndex == 4 {
            callApiForHomeSplittList(pageNumber: "1", apiName: DirectSplittFeeds)
        }
    }

    
    func backToVC(businessName: String){
        let expireVC = SExpireViewController()
        expireVC.modalPresentationStyle = .overCurrentContext
        expireVC.delegate = self
        expireVC.isFromAnswerQuestion = true
        expireVC.titleText = "You just earned a Splitt point for answering\n\n"+"\""+businessName+" Splitt!\"\n\nKeep it up!!!"
        self.present(expireVC, animated: false, completion: nil)
    }
    
    func backToVC(isView: Bool) {
        if isView {
            NotificationCenter.default.post(name: Notification.Name("redirectProfile"), object: nil)
        } else {
            
        }
    }

    
    func backToView(isView: Bool) {
        //PRO EARNED 5%
    }


    
    //MARK: Call API
    func callApiForHomeSplittList(pageNumber: String, apiName: String)
    {

//        var categoryArray = [Dictionary<String, AnyObject>]()
        var selectedArray = filterInfo.filterArray.filter{$0.isSelect == true}
        
        //If contain ALL then remove first from array
        let selectedWithoutAllArray = selectedArray.filter{$0.proSplittCategoryName == "All"}
        if selectedWithoutAllArray.count > 0 {
            selectedArray.removeFirst()
        }

//        //Make Category ID Dict
//        for obj in selectedArray {
//            var categoryDict = Dictionary<String, AnyObject>()
//            categoryDict[cType] = obj.roleType as AnyObject
//            categoryDict[cId] = obj.categoryId as AnyObject
//            categoryArray.append(categoryDict)
//        }

        let idArray = selectedArray.map { "'\($0.categoryId)'" }

        let dict = NSMutableDictionary()
        dict[cPageNumber] = pageNumber
        dict[cPageSize] = "10"
        dict[cTimelineId] = filterInfo.timelineId
        dict["typeData"] = ""
        dict[cUserId] = NSUSERDEFAULT.value(forKey: cUserId)
        dict[cCategoryId] = (idArray as NSArray).componentsJoined(by: ",")
        dict[cInternationalFilter] = filterInfo.isInternational ? 1 : 0
        dict[cOnlyConnection] = filterInfo.isOnlyConnection ? 1 : 0

        CAServiceHelper.sharedServiceHelper.request(dict as! Dictionary<String, AnyObject>, method: .post, apiName: "\(apiName)?businessKey=\(businessKey)", hudType: .simple) { (result, error, status) in

            if (error == nil) {
//                animationView.removeFromSuperview()
//                self.view.isUserInteractionEnabled = true

                if let response = result as? Dictionary<String, AnyObject> {
                    if(status == 200) {
                        
                        let dataDict = response.validatedValue(cData, expected: NSDictionary())as! Dictionary<String,AnyObject>
                        
                        //Pagination Parsing
                        let paginationDict = response.validatedValue(Pagination, expected:Dictionary<String,AnyObject>() as AnyObject) as! Dictionary<String, Any>
                        self.paginationInfo = CAPaginationInfo.getPaginationData(paginationDict as Dictionary<String, AnyObject>)
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
        
        CAServiceHelper.sharedServiceHelper.request(dict as! Dictionary<String, AnyObject>, method: .post, apiName: "\(LikeSplitt)?businessKey=\(businessKey)", hudType: .simple) { (result, error, status) in
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
        
        CAServiceHelper.sharedServiceHelper.request(dict as! Dictionary<String, AnyObject>, method: .post, apiName: "\(ReportSplittApi)?businessKey=\(businessKey)", hudType: .simple) { (result, error, status) in
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
   
    
    func callApiForAddAnswer(params : Dictionary<String, AnyObject>, cell: SCHomeTableViewCell, obj: SCHomeInfo)
    {
        CAServiceHelper.sharedServiceHelper.request(params , method: .post, apiName: "\(AddAnswer)?businessKey=\(businessKey)", hudType: .simple) { (result, error, status) in
            if (error == nil) {
                if let response = result as? Dictionary<String, AnyObject> {
                    if(status == 200) {
                        
                        if obj.selectedIndex != ((obj.isYesNo == "0") ? obj.surveyZeroArray
                            .count-1 : obj.surveyOneArray
                                .count-1) {
                            obj.selectedIndex = obj.selectedIndex+1
                            DispatchQueue.main.async {
                                cell.collectionView.reloadData()
                                cell.collectionView.scrollToItem(at: IndexPath(row: 0, section: 0), at: .left, animated: true)
                            }
                        }else {
                            DispatchQueue.main.async(execute: {
                                _ = AlertController.alert("", message: response.validatedValue(pResponseMessage, expected: "" as AnyObject) as! String)
                            })
                        }
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

    
    func callApiForCalculateSplittTime(params : Dictionary<String, AnyObject>, cell: SCHomeTableViewCell)
    {
        CAServiceHelper.sharedServiceHelper.request(params , method: .post, apiName: "\(UpdateOptionTime)?businessKey=\(businessKey)", hudType: .simple) { (result, error, status) in
            if (error == nil) {
                if let response = result as? Dictionary<String, AnyObject> {
                    if(status == 200) {
                        DispatchQueue.main.async {
                            cell.collectionView.scrollToItem(at: IndexPath(row: 0, section: 0), at: .left, animated: true)
                        }
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

    
    func callApiForProSplitt(params : Dictionary<String, AnyObject>, cell: SCHomeTableViewCell)
    {
        CAServiceHelper.sharedServiceHelper.request(params , method: .post, apiName: "\(AddAnswer)?businessKey=\(businessKey)", hudType: .simple) { (result, error, status) in
            if (error == nil) {
                if let response = result as? Dictionary<String, AnyObject> {
                    if(status == 200) {
                        let dataDict = response.validatedValue(cData, expected:Dictionary<String,AnyObject>() as AnyObject) as! Dictionary<String, Any>
                        let splittType = dataDict.validatedValue(cUserType, expected: "" as AnyObject) as! String
                        let reward = dataDict.validatedValue(cReward, expected: "" as AnyObject) as! String
                        let businessName = dataDict.validatedValue(cBusinessname, expected: "" as AnyObject) as! String
                        
                        if  splittType == "business" && reward != "" {
                            DispatchQueue.main.async(execute: {
                                cell.collectionView.scrollToItem(at: IndexPath(row: 0, section: 0), at: .left, animated: true)
                                
                                let earnedVC = self.storyboard?.instantiateViewController(withIdentifier: "EarnedOffVC") as! SEarnedOffViewController
                                earnedVC.delegate = self
                                earnedVC.titleText = "You just earned \(reward) from\n\n"+"\""+businessName.capitalized+" Splitt\"\n\nKeep up the great work!"
                                earnedVC.modalPresentationStyle = .overCurrentContext
                                earnedVC.modalTransitionStyle = .crossDissolve
                                self.present(earnedVC, animated: false, completion: nil)
                            })
                        }else{
                            DispatchQueue.main.async(execute: {
                                
                                let earnedVC = self.storyboard?.instantiateViewController(withIdentifier: "EarnedOffVC") as! SEarnedOffViewController
                                earnedVC.delegate = self
                                earnedVC.titleText = "You just earned \(reward) from\n\n"+"\""+businessName.capitalized+" Splitt\"\n\nKeep up the great work!"
                                earnedVC.modalTransitionStyle = .crossDissolve
                                earnedVC.modalPresentationStyle = .overCurrentContext
                                self.present(earnedVC, animated: false, completion: nil)
                            })
                        }
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

    
    func callApiForAnswer(currentIndex :Int, splittObj : SCHomeInfo, cell: SCHomeTableViewCell)
    {
        var params : Dictionary<String, AnyObject> = [
            cSplittId : splittObj.splitt_id as AnyObject,
            cUserId  : UserDefaults.standard.value(forKey: cUserId) as AnyObject
        ]
        var dataArray = [String]()
        if (splittObj.answerType == "Yes/No"){
            dataArray = ["Yes","No"]
        }else if splittObj.answerType == "Multiple Choice  (A,B,C,D)" {
            dataArray = ["A","B","C","D"]
        }else if (splittObj.answerType == ""){
            dataArray = ["A","B","C","D"]
        }
        
        params[cAnswer] = dataArray[currentIndex - 1] as AnyObject
        params[cSplittOption] = dataArray[currentIndex - 1] as AnyObject

        CAServiceHelper.sharedServiceHelper.request(params , method: .post, apiName: "\(cAnswerSplitt)?businessKey=\(businessKey)", hudType: .simple) { (result, error, status) in
            CAServiceHelper.sharedServiceHelper.stopHudAnimation()
            if (error == nil) {
                if let response = result as? Dictionary<String, AnyObject> {
                    if(status == 200) {
                        let dataDict = response.validatedValue(cData, expected:Dictionary<String,AnyObject>() as AnyObject) as! Dictionary<String, Any>
                        let splittType = dataDict.validatedValue(cUserType, expected: "" as AnyObject) as! String
                        let reward = dataDict.validatedValue(cReward, expected: "" as AnyObject) as! String
                        let businessName = dataDict.validatedValue(cBusinessname, expected: "" as AnyObject) as! String
                        if  splittType == "business" && reward != "" {
                            DispatchQueue.main.async(execute: {
                                
                                cell.collectionView.scrollToItem(at: IndexPath(row: 0, section: 0), at: .left, animated: true)
                                let earnedVC = self.storyboard?.instantiateViewController(withIdentifier: "EarnedVC") as! SEarnedViewController
                                earnedVC.modalPresentationStyle = .overCurrentContext
                                earnedVC.delegate = self
                                earnedVC.isFromSplitt = true
                                earnedVC.businessName = "\(businessName.capitalized)"
                                earnedVC.titleText = "Thanks for answering\n\n"+"\""+businessName.capitalized+" Splitt\"\n\nKeep up the great work!"
                                self.present(earnedVC, animated: false, completion: nil)
                            })
                        }else{
                            DispatchQueue.main.async(execute: {
                                _ = AlertController.alert("", message: response.validatedValue(pResponseMessage, expected: "" as AnyObject) as! String, controller: self, buttons: ["OK"], tapBlock: { (action, index) in
                                    DispatchQueue.main.async {
                                        cell.collectionView.scrollToItem(at: IndexPath(row: 0, section: 0), at: .left, animated: true)
                                    }
                                })
                            })
                        }
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
    
    
    func callApiForNotficationCount()
    {
        let dict = NSMutableDictionary()
        dict[cUserId] = NSUSERDEFAULT.value(forKey: cUserId)
        
        CAServiceHelper.sharedServiceHelper.request(dict as! Dictionary<String, AnyObject>, method: .post, apiName: "\(NotificationCount)?businessKey=\(businessKey)", hudType: .simple) { (result, error, status) in
            if (error == nil) {
                if let response = result as? Dictionary<String, AnyObject> {
                    if(status == 200) {
                        self.notificationCountLabel.text = "\(response.validatedValue(cData, expected: "" as AnyObject))"
                        if "\(response.validatedValue(cData, expected: "" as AnyObject))" == "0" {
                            self.notificationCountLabel.isHidden = true
                        } else {
                            self.notificationCountLabel.isHidden = false
                        }
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
    

    func callApiForCreateNewUser()
    {
        let dict = NSMutableDictionary()
        dict[cUserId] = userId
        dict[cUserName] = userName
        dict[pEmail] = emailId
        dict[cMobile] = mobile
        dict[cCountryCode] = countryCode
        
        CAServiceHelper.sharedServiceHelper.request(dict as! Dictionary<String, AnyObject>, method: .post, apiName: "\(CreateUser)?businessKey=\(businessKey)", hudType: .simple) { (result, error, status) in
            if (error == nil) {
                if let response = result as? Dictionary<String, AnyObject> {
                    if(status == 200) {
                        let dataDict = response.validatedValue(cData, expected: Dictionary<String, Any>() as AnyObject) as! Dictionary<String, Any>
                        
                        let newUserId = "\(dataDict.validatedValue("user_id", expected: "" as AnyObject))"

                        NSUSERDEFAULT.set(newUserId, forKey: cUserId)
                        
                        self.callApiForNotficationCount()
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
    override public func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
