//
//  SCAddAllAnswerViewController.swift
//  SplittBusinesses
//
//  Created by Vishal Mandhyan on 21/08/18.
//  Copyright © 2018 Deepak. All rights reserved.
//

import UIKit

class SCAddAllAnswerViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, FloatRatingViewDelegate {
    static var cellIdentifier = "AddAllAnswerMainCell"
    static var sectionCellIdentifier = "AllQuestionCellID"
    static var emojiCellIdentifier = "EmojiCellID"
    
    var questionsArray = [SCHomeInfo]()
    var questionObj = SCHomeInfo()
    public var businessKey = String()

    var isRatingQuestions = Bool()
    var isRatingQuestionType = Int()
    
    @IBOutlet weak var tableView: UITableView!
    
    //MARK: UIView Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        initialMethod()
    }
    
    //MARK: Custom Method
    func initialMethod() {
        
        //self.tableView.estimatedRowHeight = 40.0
        self.tableView.sectionHeaderHeight = UITableViewAutomaticDimension
        self.tableView.estimatedSectionHeaderHeight = 45
        
        if questionObj.is_yes_no == "4" {
            questionsArray = questionObj.surveyOneArray
            for obj in questionsArray {
                obj.isSelectNo = false
                obj.isSelectYes = false
                obj.isSelect = false
                obj.yesNoIndex = 0
            }
        } else if questionObj.is_yes_no == "5" {
            questionsArray = questionObj.surveyZeroArray
            for obj in questionsArray {
                obj.isStronglyDisagree = false
                obj.isDisagree = false
                obj.isSelect = false
                obj.isNeutral = false
                obj.isAgree = false
                obj.isStronglyAgree = false
                obj.likertIndex = 0
            }
        } else {
            questionsArray = questionObj.answerTwoArray
            for obj in questionsArray {
                obj.starCount = 0
                obj.isSelect = false
            }
        }
        
        callApiForCalculateSplittTime()
    }
    
    
    //MARK: UITableView Datasource
    func numberOfSections(in tableView: UITableView) -> Int {
        return questionsArray.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
        //let obj = questionsArray[section]
        //        return obj.isSelect ? 1 : 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : SCAddAllAnswerTableViewCell = tableView.dequeueReusableCell(withIdentifier: SCAddAllAnswerViewController.cellIdentifier) as! SCAddAllAnswerTableViewCell
        cell.outerView.borderWidth = 1.0
        
        if questionObj.is_yes_no == "4" {
            let obj = questionsArray[indexPath.section]
            cell.outerView.borderWidth = 0.0
            cell.yesView.isHidden = false
            cell.noView.isHidden = false
            cell.yesButton.indexPath = indexPath
            cell.noButton.indexPath = indexPath
            let bundle = Bundle(for: HomeViewController.self)
            guard let yesSelectedImage = UIImage(named: "radio_icon_small_sel", in: bundle, compatibleWith: nil)?.withRenderingMode(.alwaysOriginal) else {
                fatalError("Missing MyImage...")
            }
            guard let yesUnselectedImage = UIImage(named: "radio_icon_small", in: bundle, compatibleWith: nil)?.withRenderingMode(.alwaysOriginal) else {
                fatalError("Missing MyImage...")
            }
            cell.yesImageView.image = obj.isSelectYes ? yesSelectedImage : yesUnselectedImage
            
            
            guard let noSelectedImage = UIImage(named: "radio_icon_small_sel", in: bundle, compatibleWith: nil)?.withRenderingMode(.alwaysOriginal) else {
                fatalError("Missing MyImage...")
            }
            guard let noUnselectedImage = UIImage(named: "radio_icon_small", in: bundle, compatibleWith: nil)?.withRenderingMode(.alwaysOriginal) else {
                fatalError("Missing MyImage...")
            }
            cell.noImageView.image = obj.isSelectNo ? noSelectedImage : noUnselectedImage

            cell.noButton.addTarget(self, action: #selector(self.noButtonAction(_:)), for: UIControlEvents.touchUpInside)
            cell.yesButton.addTarget(self, action: #selector(self.yesButtonAction(_:)), for: UIControlEvents.touchUpInside)
        } else if questionObj.is_yes_no == "5" {
            let smilyCell : SCAddSmilyAnswerTableViewCell = tableView.dequeueReusableCell(withIdentifier: SCAddAllAnswerViewController.emojiCellIdentifier) as! SCAddSmilyAnswerTableViewCell
            let obj = questionsArray[indexPath.section]
            
            smilyCell.stronglyDisagreeButton.indexPath = indexPath
            smilyCell.disagreeButtton.indexPath = indexPath
            smilyCell.neutralButton.indexPath = indexPath
            smilyCell.agreeButton.indexPath = indexPath
            smilyCell.stronglyAgreeButton.indexPath = indexPath
            
            smilyCell.stronglyDisagreeImageView.borderWidth = obj.isStronglyDisagree ? 1 : 0
            smilyCell.disAgreeImageView.borderWidth = obj.isDisagree ? 1 : 0
            smilyCell.stronglyAgreeImageView.borderWidth = obj.isStronglyAgree ? 1 : 0
            smilyCell.neutralImageView.borderWidth = obj.isNeutral ? 1 : 0
            smilyCell.agreeImageView.borderWidth = obj.isAgree ? 1 : 0
            
            smilyCell.stronglyDisagreeButton.addTarget(self, action: #selector(self.stronglyDisagreeButtonAction(_:)), for: UIControlEvents.touchUpInside)
            smilyCell.disagreeButtton.addTarget(self, action: #selector(self.disagreeButtonAction(_:)), for: UIControlEvents.touchUpInside)
            smilyCell.neutralButton.addTarget(self, action: #selector(self.neutralButtonAction(_:)), for: UIControlEvents.touchUpInside)
            smilyCell.agreeButton.addTarget(self, action: #selector(self.agreeButtonAction(_:)), for: UIControlEvents.touchUpInside)
            smilyCell.stronglyAgreeButton.addTarget(self, action: #selector(self.stronglyAgreeButtonAction(_:)), for: UIControlEvents.touchUpInside)
            
            return smilyCell
        } else {
            cell.yesView.isHidden = true
            cell.noView.isHidden = true
            cell.rateView.tag = indexPath.section+100
            cell.rateView.isHidden = false
            cell.rateView.delegate = self
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cell : SCAddAllAnswerSectionTableViewCell = tableView.dequeueReusableCell(withIdentifier: SCAddAllAnswerViewController.sectionCellIdentifier) as! SCAddAllAnswerSectionTableViewCell
        cell.cellButton.tag = section
        
        let obj = questionsArray[section]
        cell.questionLabel.text = obj.survey_question
        
        cell.cellButton.addTarget(self, action: #selector(self.expandButtonAction(_:)), for: UIControlEvents.touchUpInside)
        return cell
    }
    
    //MARK: UITableView Delegate
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if isRatingQuestionType == 2 {
            return 47.0
        }
        return 50.0
    }
    
    
    
    //MARK: UIButton Action Method
    @IBAction func cancelButtonAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func submitButtonAction(_ sender: Any) {
        
        let isSelectArray = questionsArray.filter { $0.isSelect == true }
        if isSelectArray.count != questionsArray.count {
            _ = AlertController.alert("", message: "Please select answer.")
            return
        }
        
        if questionObj.remainingTime == "No time left" {
            _ = AlertController.alert("", message: "Sorry, You can not answer this Splitt.")
            return
        }

        var surveyTypeString = String()
        var questionTypeString = String()
        
        if questionObj.is_yes_no == "4" {
            let surveyTypeArray = questionsArray.map { $0.yesNoIndex }
            let questionTypeArray = questionsArray.map { $0.question_type }
            surveyTypeString = (surveyTypeArray as NSArray).componentsJoined(by: ",")
            questionTypeString = (questionTypeArray as NSArray).componentsJoined(by: ",")
        } else if questionObj.is_yes_no == "5" {
            let surveyTypeArray = questionsArray.map { $0.likertIndex }
            let questionTypeArray = questionsArray.map { $0.question_type }
            surveyTypeString = (surveyTypeArray as NSArray).componentsJoined(by: ",")
            questionTypeString = (questionTypeArray as NSArray).componentsJoined(by: ",")
        } else {
            let surveyTypeArray = questionsArray.map { $0.starCount }
            let questionTypeArray = questionsArray.map { $0.question_type }
            surveyTypeString = (surveyTypeArray as NSArray).componentsJoined(by: ",")
            questionTypeString = (questionTypeArray as NSArray).componentsJoined(by: ",")
        }
        
        var isAnonymous : String = "0"
        if questionObj.is_anonymous_pro == "1" {
            _ = AlertController.alert("", message: "Are you sure you want to answer this Splitt as anonymous?", controller: self, buttons: ["Yes", "No"], tapBlock: { (action, index) in
                if index == 0 {
                    isAnonymous = "1"
                } else {
                    isAnonymous = "0"
                }
            })
        }
        
        let params : Dictionary<String, AnyObject> = [
            cSplittId : self.questionObj.splitt_id as AnyObject,
            "proSplittType" : "survey" as AnyObject,
            "survey_type" : questionObj.is_yes_no as AnyObject,
            "survey_type_answer" : surveyTypeString as AnyObject,
            "question_type" : questionTypeString as AnyObject,
            "pro_is_anonymous" : isAnonymous as AnyObject,
            cUserId  : NSUSERDEFAULT.value(forKey: cUserId) as AnyObject ]
        
        callApiForAddAnswer(params: params)
    }
    
    
    //MARK: Selector Method
    @objc func noButtonAction(_ sender: SCCustomButton) {
        let obj = questionsArray[sender.indexPath.section]
        obj.isSelectNo = true
        obj.isSelect = true
        obj.isSelectYes = false
        obj.yesNoIndex = 2
        self.tableView.reloadData()
    }
    
    @objc func yesButtonAction(_ sender: SCCustomButton) {
        let obj = questionsArray[sender.indexPath.section]
        obj.isSelectNo = false
        obj.isSelectYes = true
        obj.isSelect = true
        obj.yesNoIndex = 1
        self.tableView.reloadData()
    }
    
    @objc func stronglyDisagreeButtonAction(_ sender: SCCustomButton) {
        let obj = questionsArray[sender.indexPath.section]
        obj.isStronglyDisagree = true
        obj.isDisagree = false
        obj.isNeutral = false
        obj.isSelect = true
        obj.isAgree = false
        obj.isStronglyAgree = false
        obj.likertIndex = 1
        self.tableView.reloadData()
    }
    
    @objc func disagreeButtonAction(_ sender: SCCustomButton) {
        let obj = questionsArray[sender.indexPath.section]
        obj.isStronglyDisagree = false
        obj.isDisagree = true
        obj.isNeutral = false
        obj.isSelect = true
        obj.isAgree = false
        obj.isStronglyAgree = false
        obj.likertIndex = 2
        self.tableView.reloadData()
    }
    
    @objc func neutralButtonAction(_ sender: SCCustomButton) {
        let obj = questionsArray[sender.indexPath.section]
        obj.isStronglyDisagree = false
        obj.isDisagree = false
        obj.isNeutral = true
        obj.isSelect = true
        obj.isAgree = false
        obj.isStronglyAgree = false
        obj.likertIndex = 3
        self.tableView.reloadData()
    }
    
    @objc func agreeButtonAction(_ sender: SCCustomButton) {
        let obj = questionsArray[sender.indexPath.section]
        obj.isStronglyDisagree = false
        obj.isDisagree = false
        obj.isNeutral = false
        obj.isAgree = true
        obj.isSelect = true
        obj.isStronglyAgree = false
        obj.likertIndex = 4
        self.tableView.reloadData()
    }
    
    @objc func stronglyAgreeButtonAction(_ sender: SCCustomButton) {
        let obj = questionsArray[sender.indexPath.section]
        obj.isStronglyDisagree = false
        obj.isDisagree = false
        obj.isNeutral = false
        obj.isSelect = true
        obj.isAgree = false
        obj.isStronglyAgree = true
        obj.likertIndex = 5
        self.tableView.reloadData()
    }
    
    
    @objc func expandButtonAction(_ sender: UIButton) {
    }
    
    
    //MARK: Rating Delegate
    func floatRatingView(_ ratingView: FloatRatingView, didUpdate rating: Double) {
        let obj = questionsArray[ratingView.tag-100]
        obj.starCount = Int(rating)
        obj.isSelect = obj.starCount == 0 ? false : true
        self.tableView.reloadData()
    }
    
    
    func callApiForAddAnswer(params : Dictionary<String, AnyObject>)
    {
        CAServiceHelper.sharedServiceHelper.request(params , method: .post, apiName: "\(AddAnswer)?businessKey=\(businessKey)", hudType: .simple) { (result, error, status) in
            if (error == nil) {
                if let response = result as? Dictionary<String, AnyObject> {
                    if(status == 200) {
                        _ = AlertController.alert("", message: response.validatedValue(pResponseMessage, expected: "" as AnyObject) as! String, controller: self, buttons: ["OK"], tapBlock: { (action, index) in
                            self.dismiss(animated: true, completion: nil)
                        })
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
    
    
    func callApiForCalculateSplittTime()
    {
        let params : Dictionary<String, AnyObject> = [
            cSplittId : questionObj.splitt_id as AnyObject,
            cUserId  : UserDefaults.standard.value(forKey: cUserId) as AnyObject
        ]
        
        CAServiceHelper.sharedServiceHelper.request(params , method: .post, apiName: "\(UpdateOptionTime)?businessKey=\(businessKey)", hudType: .simple) { (result, error, status) in
            if (error == nil) {
                if let response = result as? Dictionary<String, AnyObject> {
                    if(status == 200) {
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

