//
//  SCSplittDetailViewController.swift
//  SplittConsumer
//
//  Created by Vishal Mandhyan on 28/07/18.
//  Copyright © 2018 Deepak. All rights reserved.
//

import UIKit
import AVFoundation

class SCSplittDetailViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UITableViewDelegate, UITableViewDataSource, PopUpProtocol, GiveAnswerProtocol {
    static var collectionCellIdentifier = "HomeCollectionCellID"
    static var cellIdentifier = "AnswerTableCellID"
    static var detailCollectionCellIdentifier = "SplittDetailCollectionCellID"
    public var businessKey = String()

    var splittDetailObj = SCHomeInfo()
    var avPlayer = AVPlayer()
    var dataArray = Array<SCHomeInfo>()
    var selectedIndex = 0

    @IBOutlet weak var discountLabel: UILabel!
    @IBOutlet weak var splittImageView: UIImageView!
    
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var commentButton: UIButton!
    
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var timeLeftLabel: UILabel!
    @IBOutlet weak var answerForRewardLabel: UILabel!
    @IBOutlet weak var rewardExpirationLabel: UILabel!
    
    @IBOutlet weak var finalSplittLabel: UILabel!
    
    @IBOutlet weak var pageController: UIPageControl!
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var questionCollectionView: UICollectionView!

    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var finalSplittImageView: UIImageView!
    
    
    //MARK: UIView Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        initialMethod()
    }
    
    
    //MARK: Custom Method
    func initialMethod() {
        self.pageController.numberOfPages = splittDetailObj.answerAnalyticsArray.count+1
        self.tableView.estimatedRowHeight = 48.0
        
        //Set Title
        self.discountLabel.text = splittDetailObj.reward == "" ? "\(splittDetailObj.point) Splitt Points" : splittDetailObj.reward
        self.categoryLabel.text = splittDetailObj.category_name
        self.timeLeftLabel.text = splittDetailObj.remainingTime
        self.answerForRewardLabel.text = splittDetailObj.reward
        
        //Convert Expire Date
        if(splittDetailObj.splittCreatedAt.length > 0){
            let rewardDate = NSDate(timeIntervalSince1970: Double(splittDetailObj.splittCreatedAt)!)
            self.rewardExpirationLabel.text = BTAppUtility.getTimeAndDateStringFromDate(date: rewardDate as Date)
        } else {
            self.rewardExpirationLabel.text = ""
        }
        
        //Set Submit Button Title
        if splittDetailObj.getType == "survey" {
            self.submitButton.setTitle("ADD ANSWER", for: .normal)
        }

        self.commentButton.setTitle(splittDetailObj.comment_count, for: .normal)
        setUIAccordingToSplittType()
    }
    
    
    func setUIAccordingToSplittType() {
        collectionView.borderWidth = 3.0
        collectionView.borderColor = KAppRedColor
        collectionView.backgroundColor = KAppRedColor
        
        if splittDetailObj.answerType == "" {
            self.questionCollectionView.isHidden = false
            finalSplittImageView.isHidden = false
            finalSplittLabel.isHidden = true
            if(self.splittDetailObj.final_splitt_decision ==  "A"){
                if splittDetailObj.finalSplittDecision == "A" {
                    let bundle = Bundle(for: HomeViewController.self)
                    guard let image = UIImage(named: "image_placeholder", in: bundle, compatibleWith: nil)?.withRenderingMode(.alwaysOriginal) else {
                        fatalError("Missing MyImage...")
                    }
                    
                    self.finalSplittImageView.downloadedFrom(link: splittDetailObj.splitt_media_one, contentMode: .scaleToFill, placeholderImage: image)

                } else if splittDetailObj.finalSplittDecision == "B" {
                    let bundle = Bundle(for: HomeViewController.self)
                    guard let image = UIImage(named: "image_placeholder", in: bundle, compatibleWith: nil)?.withRenderingMode(.alwaysOriginal) else {
                        fatalError("Missing MyImage...")
                    }
                    self.finalSplittImageView.downloadedFrom(link: splittDetailObj.splitt_media_two, contentMode: .scaleToFill, placeholderImage: image)

                } else if splittDetailObj.finalSplittDecision == "C" {
                    let bundle = Bundle(for: HomeViewController.self)
                    guard let image = UIImage(named: "image_placeholder", in: bundle, compatibleWith: nil)?.withRenderingMode(.alwaysOriginal) else {
                        fatalError("Missing MyImage...")
                    }
                    self.finalSplittImageView.downloadedFrom(link: splittDetailObj.splitt_media_three, contentMode: .scaleToFill, placeholderImage: image)

                } else {
                    let bundle = Bundle(for: HomeViewController.self)
                    guard let image = UIImage(named: "image_placeholder", in: bundle, compatibleWith: nil)?.withRenderingMode(.alwaysOriginal) else {
                        fatalError("Missing MyImage...")
                    }
                    self.finalSplittImageView.downloadedFrom(link: splittDetailObj.splitt_media_four, contentMode: .scaleToFill, placeholderImage: image)

                }
            }
            var responseArray = Array<Dictionary<String,Any>>()
            if(self.splittDetailObj.splitt_media_one.length > 0){
                splittDetailObj.splitMediaArray.append(self.splittDetailObj.splitt_media_one)
                let option1 = [
                    "answer" : self.splittDetailObj.splitt_media_one as AnyObject,
                    "status" : false as AnyObject,
                    "option" : "A" as AnyObject
                ]
                responseArray.append(option1)
            }
            if(self.splittDetailObj.splitt_media_two.length > 0){
                splittDetailObj.splitMediaArray.append(self.splittDetailObj.splitt_media_two)
                let option2 = [
                    "answer" : self.splittDetailObj.splitt_media_two as AnyObject,
                    "status" : false as AnyObject,
                    "option" : "B" as AnyObject
                ]
                responseArray.append(option2)
            }
            if(self.splittDetailObj.splitt_media_three.length > 0){
                splittDetailObj.splitMediaArray.append(self.splittDetailObj.splitt_media_three)
                let option3 = [
                    "answer" : self.splittDetailObj.splitt_media_three as AnyObject,
                    "status" : false as AnyObject,
                    "option" : "C" as AnyObject
                ]
                responseArray.append(option3)
            }
            if(self.splittDetailObj.splitt_media_four.length > 0){
                splittDetailObj.splitMediaArray.append(self.splittDetailObj.splitt_media_four)
                let option4 = [
                    "answer" : self.splittDetailObj.splitt_media_four as AnyObject,
                    "status" : false as AnyObject,
                    "option" : "D" as AnyObject
                ]
                responseArray.append(option4)
            }
            let tapDecisionImage: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.handleTapDecisionImage))
            finalSplittImageView.addGestureRecognizer(tapDecisionImage)
            dataArray = SCHomeInfo.getAnswerData(responseArray: responseArray as Array<Dictionary<String, AnyObject>>)
        }
        else if splittDetailObj.answerType == "Multiple Choice  (A,B,C,D)" {
            self.questionCollectionView.isHidden = true
            var responseArray = Array<Dictionary<String,Any>>()
            if(self.splittDetailObj.answer_A.length > 0){
                let option1 = [
                    "answer" : self.splittDetailObj.answer_A as AnyObject,
                    "status" : false as AnyObject,
                    "option" : "A" as AnyObject
                ]
                responseArray.append(option1)
            }
            if(self.splittDetailObj.answer_B.length > 0){
                let option2 = [
                    "answer" : self.splittDetailObj.answer_B as AnyObject,
                    "status" : false as AnyObject,
                    "option" : "B" as AnyObject
                ]
                responseArray.append(option2)
            }
            if(self.splittDetailObj.answer_C.length > 0){
                let option3 = [
                    "answer" : self.splittDetailObj.answer_C as AnyObject,
                    "status" : false as AnyObject,
                    "option" : "C" as AnyObject
                ]
                responseArray.append(option3)
            }
            if(self.splittDetailObj.answer_D.length > 0){
                let option4 = [
                    "answer" : self.splittDetailObj.answer_D as AnyObject,
                    "status" : false as AnyObject,
                    "option" : "D" as AnyObject
                ]
                responseArray.append(option4)
            }
            dataArray = SCHomeInfo.getAnswerData(responseArray: responseArray as Array<Dictionary<String, AnyObject>>)
            finalSplittImageView.isHidden = true
            finalSplittLabel.isHidden = false
            finalSplittLabel.text =  self.splittDetailObj.finalSplittDecision
        }
        else if splittDetailObj.answerType == "Yes/No" {
            self.questionCollectionView.isHidden = false
            let option1 = [
                "answer" : "Yes" as AnyObject,
                "status" : false as AnyObject
            ]
            let option2 = [
                "answer" : "No" as AnyObject,
                "status" : false as AnyObject
            ]
            
            dataArray = SCHomeInfo.getAnswerData(responseArray: [option1,option2])
            finalSplittImageView.isHidden = true
            finalSplittLabel.isHidden = false
            finalSplittLabel.text =  self.splittDetailObj.finalSplittDecision
        }
        
        //Call API
        callApiForSplittDetail()
        
        self.pageController.numberOfPages = self.splittDetailObj.splitMediaArray.count + 1
        self.collectionView.reloadData()
        self.questionCollectionView.reloadData()
        self.tableView.reloadData()
    }

    func validateFields() -> Bool {
        let selectedArray = dataArray.filter{$0.isSelect == true}
        if selectedArray.count == 0 {
            _ = AlertController.alert("", message: "Please select any one option.")
        }
        else {
            return true
        }
        return false
    }

    
    //MARK: UIScrollView Delegate
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if let _ = scrollView as? UICollectionView {
            print("Tag:-\(scrollView.tag)")
            self.pageController.currentPage = Int(self.collectionView.contentOffset.x / self.collectionView.frame.size.width)
        }
    }

    
    //MARK: UITableView Datasource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return splittDetailObj.answerType == "Multiple Choice  (A,B,C,D)" ? dataArray.count : 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : SCAnswerTableViewCell = tableView.dequeueReusableCell(withIdentifier: SCSplittDetailViewController.cellIdentifier) as! SCAnswerTableViewCell
        
        let obj = dataArray[indexPath.row]
        
        cell.detailTitleLabel.text = obj.answerOption
        cell.detailOptionLabel.text = obj.abcdAnswerOption
        cell.detailRadioButton.isSelected = obj.isSelect
        return cell
    }
    
    //MARK: UITableView Delegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let obj = dataArray[indexPath.row]
        for tempObj in dataArray {
            tempObj.isSelect = false
        }
        selectedIndex = indexPath.row
        splittDetailObj.selectedAnswer = obj.answerOption
        obj.isSelect = true
        self.tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }

    
    //MARK: UICollectionView Datasource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (collectionView == questionCollectionView) ? (splittDetailObj.answerType == "") ? splittDetailObj.splitMediaArray.count :  dataArray.count : splittDetailObj.splitMediaArray.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == questionCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SCSplittDetailViewController.detailCollectionCellIdentifier, for: indexPath) as! SCSplittDetailCollectionViewCell
            if(dataArray.count > 0){
                let modalObj = dataArray[indexPath.row]
                cell.cellImageView.isHidden = (splittDetailObj.answerType == "") ? false : true
                cell.cellButton.setTitle((splittDetailObj.answerType == "") ? "" : modalObj.answerOption, for: .normal)
                cell.cellButton.setTitle((splittDetailObj.answerType == "") ? "" : modalObj.answerOption, for: .selected)
                cell.cellButton.tag = 100 + indexPath.row
                cell.cellButton.isSelected = modalObj.isSelect //(tempTag == indexPath.row + 100) ? true : false
                
                let bundle = Bundle(for: HomeViewController.self)
                guard let image = UIImage(named: "image_placeholder", in: bundle, compatibleWith: nil)?.withRenderingMode(.alwaysOriginal) else {
                    fatalError("Missing MyImage...")
                }
                cell.cellImageView.downloadedFrom(link: modalObj.answerOption, contentMode: .scaleToFill, placeholderImage: image)

                cell.cellImageView.tag = indexPath.item
                let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
                cell.cellImageView.addGestureRecognizer(tap)
            }
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SCSplittDetailViewController.collectionCellIdentifier, for: indexPath) as! SCHomeCollectionViewCell
            let obj = splittDetailObj
            cell.detailCellQuestionLabel.isHidden = false
            cell.detailCellQuestionLabel.text = ""
            
            if obj.getType == "survey" {
                cell.detailCellQuestionLabel.textColor = UIColor.white
                cell.detailCellMainView.backgroundColor = KAppRedColor
                
                cell.detailCellImageView.isHidden = true
                cell.detailPlayerView.isHidden = true
                cell.detailCellQuestionLabel.isHidden = false
                
                if obj.isYesNo == "5" {
                    let tempObj = obj.surveyZeroArray[obj.selectedIndex]
                    cell.detailCellQuestionLabel.text = tempObj.survey_question
                    
                    switch indexPath.item {
                    case 1:
                        cell.detailCellQuestionLabel.text = obj.strStronglyDisAgree
                    case 2:
                        cell.detailCellQuestionLabel.text = obj.strDisagree
                    case 3:
                        cell.detailCellQuestionLabel.text = obj.strNuetral
                    case 4:
                        cell.detailCellQuestionLabel.text = obj.strAgree
                    case 5:
                        cell.detailCellQuestionLabel.text = obj.strStronglyAgree
                        
                    default:
                        break
                    }
                    
                } else if obj.isYesNo == "4" {
                    let tempObj = obj.surveyOneArray[obj.selectedIndex]
                    cell.detailCellQuestionLabel.text = tempObj.survey_question
                    
                    switch indexPath.item {
                    case 1:
                        cell.detailCellQuestionLabel.text = obj.strYes
                    case 2:
                        cell.detailCellQuestionLabel.text = obj.strNo
                        
                    default:
                        break
                    }
                } else {
                    let tempObj = obj.answerTwoArray[obj.selectedIndex]
                    cell.detailCellQuestionLabel.text = tempObj.survey_question
                    
                    switch indexPath.item {
                    case 1:
                        cell.detailCellQuestionLabel.text = obj.star_one
                    case 2:
                        cell.detailCellQuestionLabel.text = obj.star_two
                    case 3:
                        cell.detailCellQuestionLabel.text = obj.star_three
                    case 4:
                        cell.detailCellQuestionLabel.text = obj.star_four
                    case 5:
                        cell.detailCellQuestionLabel.text = obj.star_five
                        
                    default:
                        break
                    }
                }
            } else {
                if(obj.getType == "pro") {
                    cell.detailPlayerView.isHidden = true
                    cell.detailCellImageView.isHidden = true
                    cell.detailCellImageView.image = UIImage(named: "")
                    
                    if indexPath.item == 0 {
                        cell.detailCellMainView.backgroundColor = KAppRedColor
                        cell.detailCellQuestionLabel.textColor = UIColor.white
                        cell.detailCellQuestionLabel.text = obj.questionTitle
                    } else {
                        let answerString = splittDetailObj.answerAnalyticsArray[indexPath.item-1]
                        cell.detailCellMainView.backgroundColor = UIColor.white
                        cell.detailCellQuestionLabel.textColor = UIColor.black
                        cell.detailCellQuestionLabel.text = answerString
                    }
                } else {
                    if indexPath.item == 0 {
                        if(obj.splitt_type == "Video") {
                            let Extension = NSURL(fileURLWithPath: obj.banner_media).pathExtension
                            if Extension == "mp4"{
                                cell.detailCellQuestionLabel.isHidden = true
                                cell.detailPlayerView.isHidden = false
                                
                                let bundle = Bundle(for: HomeViewController.self)
                                guard let image = UIImage(named: "img", in: bundle, compatibleWith: nil)?.withRenderingMode(.alwaysOriginal) else {
                                    fatalError("Missing MyImage...")
                                }
                                
                                cell.detailCellImageView.downloadedFrom(link: obj.thumbnail, contentMode: .scaleToFill, placeholderImage: image)

                                let url = NSURL(string: obj.banner_media)
                                avPlayer = AVPlayer(url: url! as URL)
                                cell.detailPlayerView?.playerLayer.player = avPlayer
                                cell.detailPlayerView.player?.play()
                            } } else {
                            if (obj.answerAnalyticsArray.count > 0) {
                                cell.detailCellMainView.backgroundColor = KAppRedColor
                                cell.detailCellImageView.isHidden = true
                                cell.detailCellQuestionLabel.textColor = UIColor.white
                                cell.detailCellQuestionLabel.text = obj.splitt_description
                            }
                        }
                    } else {
                        cell.detailCellQuestionLabel.textColor = KAppRedColor
                        if(obj.answerType == "") {
                            cell.detailCellImageView.isHidden = false
                            cell.detailCellQuestionLabel.isHidden = true
                            cell.detailPlayerView.isHidden = true
                            
                            let bundle = Bundle(for: HomeViewController.self)
                            guard let image = UIImage(named: "image_placeholder", in: bundle, compatibleWith: nil)?.withRenderingMode(.alwaysOriginal) else {
                                fatalError("Missing MyImage...")
                            }
                            cell.detailCellImageView.downloadedFrom(link: obj.answerAnalyticsArray[indexPath.item - 1], contentMode: .scaleToFill, placeholderImage: image)
                        } else {
                            let answerString = splittDetailObj.answerAnalyticsArray[indexPath.item-1]
                            cell.detailCellMainView.backgroundColor = UIColor.white
                            cell.detailCellQuestionLabel.text = answerString
                            cell.detailCellImageView.isHidden = true
                            cell.detailPlayerView.isHidden = true
                            cell.detailCellQuestionLabel.isHidden = false
                        }
                    }
                }
            }
            return cell
        }
    }
    
    //MARK: UICollectionView Delegate
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return (collectionView == questionCollectionView) ? (splittDetailObj.answerType == "Yes/No") ? CGSize.init(width: (questionCollectionView.frame.size.width)/2 - 30, height: 40.0) : CGSize.init(width: (questionCollectionView.frame.size.width)/4, height: 40.0) : collectionView.frame.size
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == questionCollectionView {
            let obj = dataArray[indexPath.row]
            for tempObj in dataArray {
                tempObj.isSelect = false
            }
            selectedIndex = indexPath.row
            splittDetailObj.selectedAnswer = obj.answerOption
            obj.isSelect = true
            self.questionCollectionView.reloadData()
        }
    }
    
    
    //MARK: UIButton Action Methods
    @IBAction func submitButtonAction(_ sender: Any) {
        if splittDetailObj.getType == "survey" {
            let allAnswerVC = self.storyboard?.instantiateViewController(withIdentifier: "AddAnswerCellID") as! SCAddAllAnswerViewController
            allAnswerVC.businessKey = businessKey
            allAnswerVC.questionObj = splittDetailObj
            allAnswerVC.modalPresentationStyle = .overCurrentContext
            allAnswerVC.modalTransitionStyle = .crossDissolve
            self.present(allAnswerVC, animated: true, completion: nil)
        } else {
            if validateFields() {
                callApiForAnswer()
            }
        }
    }
    
    @IBAction func commentButtonAction(_ sender: Any) {
        let commentVC = self.storyboard?.instantiateViewController(withIdentifier: "CommentVC") as! SCCommentsViewController
        commentVC.homeInfo = splittDetailObj
        commentVC.businessKey = businessKey
        self.navigationController?.pushViewController(commentVC, animated: true)
    }
    
    
    @IBAction func shareButtonAction(_ sender: Any) {
        let activityViewController = UIActivityViewController(activityItems: [String.init(format: "Take a look at this Splitt from %@",splittDetailObj.username) as String, "They need your help…" as String, "Click here to help them out!!!" as String, "Link to download https://itunes.apple.com/us/app/splitt-decision/id1358199993?ls=1&mt=8" as String], applicationActivities: nil)
        present(activityViewController, animated: true, completion: {})
    }
    
    @IBAction func backButtonAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    //MARK:- Selector Method
    @objc func handleTapDecisionImage() {
      //  SCAvatarBrowser.show(finalSplittImageView)
    }
    
    // function which is triggered when handleTap is called
    @objc func handleTap(_ sender: UITapGestureRecognizer) {
        let indexPath = IndexPath(item: (sender.view?.tag)!, section: 0)
        let cell: SCSplittDetailCollectionViewCell = questionCollectionView.cellForItem(at: indexPath) as! SCSplittDetailCollectionViewCell
     //   SCAvatarBrowser.show(cell.cellImageView)
    }
    
    //MARK:- Custom delegate
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

    
    //MARK:- Call API
    func callApiForSplittDetail()
    {
        let dict = NSMutableDictionary()
        dict[cUserId] = NSUSERDEFAULT.value(forKey: cUserId)
        dict[cSplittId] = splittDetailObj.splitt_id
        
        CAServiceHelper.sharedServiceHelper.request(dict as! Dictionary<String, AnyObject>, method: .post, apiName: "\(SplittDetail)?businessKey=\(businessKey)", hudType: .simple) { (result, error, status) in
            if (error == nil) {
                if let response = result as? Dictionary<String, AnyObject> {
                    if(status == 200) {
                        let dataDict = response.validatedValue(cData, expected:Dictionary<String,AnyObject>() as AnyObject) as! Dictionary<String, Any>
                        let reward = dataDict.validatedValue(cReward, expected: "" as AnyObject) as! String
                        
                        //Set Title
                        self.discountLabel.text = reward == "" ? "\(self.splittDetailObj.point) Splitt Points" : reward
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

    
    func callApiForAnswer() {
        var params : Dictionary<String, AnyObject> = [
            cSplittId : splittDetailObj.splitt_id as AnyObject,
            cUserId  : UserDefaults.standard.value(forKey: cUserId) as AnyObject
        ]
        var selectedImageOption = ""
        if(splittDetailObj.answerType == ""){
            let modalObj = dataArray[selectedIndex]
            selectedImageOption = modalObj.abcdAnswerOption
            params[cAnswer] =  selectedImageOption as AnyObject
            params[cSplittOption] = selectedImageOption as AnyObject
        }else if(splittDetailObj.answerType == "Multiple Choice  (A,B,C,D)"){
            let modalObj = dataArray[selectedIndex]
            selectedImageOption = modalObj.abcdAnswerOption
            params[cAnswer] =  selectedImageOption as AnyObject
            params[cSplittOption] = selectedImageOption as AnyObject
        }else{
            params[cAnswer] = splittDetailObj.selectedAnswer as AnyObject
            params[cSplittOption] = splittDetailObj.selectedAnswer as AnyObject
        }

        CAServiceHelper.sharedServiceHelper.request(params , method: .post, apiName: "\(cAnswerSplitt)?businessKey=\(businessKey)", hudType: .simple) { (result, error, status) in
            if (error == nil) {
                if let response = result as? Dictionary<String, AnyObject> {
                    if(status == 200) {
                        let dataDict = response.validatedValue(cData, expected:Dictionary<String,AnyObject>() as AnyObject) as! Dictionary<String, Any>
                        let splittType = dataDict.validatedValue(cUserType, expected: "" as AnyObject) as! String
                        let reward = dataDict.validatedValue(cReward, expected: "" as AnyObject) as! String
                        let businessName = dataDict.validatedValue(cBusinessname, expected: "" as AnyObject) as! String
                        if  splittType == "business" && reward != "" {
                            DispatchQueue.main.async(execute: {
                                let earnedVC = SEarnedViewController()
                                earnedVC.modalPresentationStyle = .overCurrentContext
                                earnedVC.delegate = self
                                earnedVC.isFromSplitt = true
                                earnedVC.businessName = "\(businessName.capitalized)"
                                earnedVC.titleText = "Thanks for answering\n\n"+"\""+businessName.capitalized+" Splitt\"\n\nKeep up the great work!"
                                self.present(earnedVC, animated: false, completion: nil)
                            })
                        }else{
                            DispatchQueue.main.async(execute: {
                                _ = AlertController.alert("", message: "Great Choice! Splitt Answered Successfully!", controller: self, buttons: ["OK"], tapBlock: { (action, index) in
                                    self.navigationController?.popViewController(animated: true)
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

    
    //MARK: Memory Management Mathod
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
