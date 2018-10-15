//
//  SCAnswerViewController.swift
//  SplittConsumer
//
//  Created by Vishal Mandhyan on 28/07/18.
//  Copyright © 2018 Deepak. All rights reserved.
//

import UIKit
enum AnswerTypeEnum: String {
    case ImageAnswer,multipleChoiceAnswer,yesNoAnswer
}

class SCAnswerViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, PopUpProtocol, GiveAnswerProtocol {
    static var cellIdentifier = "AnswerCellID"
    var dataArray = [SCHomeInfo]()
    var splittDetailObj = SCHomeInfo()
    var selectedIndex = 0
    var businessKey = String()

    var contentType: AnswerTypeEnum?

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var splittButton: UIButton!
    
    @IBOutlet weak var finalSplittTitleLabel: UILabel!
    @IBOutlet weak var finalSplittLabel: UILabel!
    
    @IBOutlet weak var viewHeightConstraint: NSLayoutConstraint!
    
    
    //MARK: UIView Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.finalSplittTitleLabel.text = (splittDetailObj.remainingTime == "No time left") ? "Final Splitt Decision:" : "Current Splitt Decision:"

        initialSetup()
    }
    
    
    func initialSetup() {
        let bundle = Bundle(for: HomeViewController.self)

        if splittDetailObj.answerType == "" {
            finalSplittLabel.isHidden = true
            if(self.splittDetailObj.finalSplittDecision ==  "A"){
                if splittDetailObj.finalSplittDecision == "A" {
                    guard let image = UIImage(named: "image_placeholder", in: bundle, compatibleWith: nil)?.withRenderingMode(.alwaysOriginal) else {
                        fatalError("Missing MyImage...")
                    }
                    self.splittButton.downloadedFrom2(link: splittDetailObj.splitt_media_one,  contentMode: .scaleAspectFit, placeholderImage: image)
                } else if splittDetailObj.finalSplittDecision == "B" {
                    guard let image = UIImage(named: "image_placeholder", in: bundle, compatibleWith: nil)?.withRenderingMode(.alwaysOriginal) else {
                        fatalError("Missing MyImage...")
                    }
                    self.splittButton.downloadedFrom2(link: splittDetailObj.splitt_media_two,  contentMode: .scaleAspectFit, placeholderImage: image)
                } else if splittDetailObj.finalSplittDecision == "C" {
                    guard let image = UIImage(named: "image_placeholder", in: bundle, compatibleWith: nil)?.withRenderingMode(.alwaysOriginal) else {
                        fatalError("Missing MyImage...")
                    }
                    self.splittButton.downloadedFrom2(link: splittDetailObj.splitt_media_three,  contentMode: .scaleAspectFit, placeholderImage: image)
                } else {
                    guard let image = UIImage(named: "image_placeholder", in: bundle, compatibleWith: nil)?.withRenderingMode(.alwaysOriginal) else {
                        fatalError("Missing MyImage...")
                    }
                    self.splittButton.downloadedFrom2(link: splittDetailObj.splitt_media_four,  contentMode: .scaleAspectFit, placeholderImage: image)
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
            dataArray = SCHomeInfo.getAnswerData(responseArray: responseArray as Array<Dictionary<String, AnyObject>>)
            if(dataArray.count == 4){
                viewHeightConstraint.constant = 410
            }else if(dataArray.count == 3){
                viewHeightConstraint.constant = 350
            }else if(dataArray.count == 2){
                viewHeightConstraint.constant = 290
            }else if(dataArray.count == 1){
                viewHeightConstraint.constant = 230
            }
        }
        else if splittDetailObj.answerType == "Multiple Choice  (A,B,C,D)" {
            self.splittButton.isHidden = true
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
            splittButton.isHidden = true
            finalSplittLabel.isHidden = false
            finalSplittLabel.text =  self.splittDetailObj.finalSplittDecision
        }
        else if splittDetailObj.answerType == "Yes/No" {
            viewHeightConstraint.constant = 240

            let option1 = [
                "answer" : "Yes" as AnyObject,
                "status" : false as AnyObject
            ]
            let option2 = [
                "answer" : "No" as AnyObject,
                "status" : false as AnyObject
            ]
            
            dataArray = SCHomeInfo.getAnswerData(responseArray: [option1,option2])
            splittButton.isHidden = true
            finalSplittLabel.isHidden = false
            finalSplittLabel.text =  self.splittDetailObj.finalSplittDecision
        }
    }
    
    //MARK: UITableView Datasource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell : SCAnswerTableViewCell = tableView.dequeueReusableCell(withIdentifier: SCAnswerViewController.cellIdentifier) as! SCAnswerTableViewCell
        
        if(dataArray.count > 0){
            let modalObj = dataArray[indexPath.row]
            cell.radioButton.tag = 100 + indexPath.row
            cell.radioButton.isSelected = modalObj.isSelect
            
            if (contentType == .ImageAnswer) {
                
                let bundle = Bundle(for: HomeViewController.self)
                guard let image = UIImage(named: "image_placeholder", in: bundle, compatibleWith: nil)?.withRenderingMode(.alwaysOriginal) else {
                    fatalError("Missing MyImage...")
                }
                cell.cellImageView.downloadedFrom(link: modalObj.answerOption, contentMode: .scaleToFill, placeholderImage: image)

                cell.cellImageView.tag = indexPath.row
                let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
                cell.cellImageView.addGestureRecognizer(tap)
                cell.cellImageView.isHidden = false
                cell.optionLabel.isHidden = true
            }else if (contentType == .multipleChoiceAnswer) {
                cell.radioButton.setTitle(String.init(format: "%@:",modalObj.abcdAnswerOption), for: .normal)
                cell.radioButton.setTitle(String.init(format: "%@:",modalObj.abcdAnswerOption), for: .selected)
                cell.cellTitleLabel.text =  modalObj.answerOption
                cell.cellImageView.isHidden = true
                cell.cellTitleLabel.isHidden = false
                cell.optionLabel.isHidden = false
                
                switch indexPath.row {
                case 0:
                    cell.optionLabel.text = modalObj.abcdAnswerOption
                case 1:
                    cell.optionLabel.text = modalObj.abcdAnswerOption
                case 2:
                    cell.optionLabel.text = modalObj.abcdAnswerOption
                case 3:
                    cell.optionLabel.text = modalObj.abcdAnswerOption
                default:
                    break
                }
                
            }else if (contentType == .yesNoAnswer) {
                cell.optionLabel.isHidden = true
                cell.radioButton.setTitle("", for: .normal)
                cell.radioButton.setTitle("", for: .selected)
                cell.cellTitleLabel.text =  modalObj.answerOption
                cell.cellImageView.isHidden = true
                cell.cellTitleLabel.isHidden = false
            }
        }

        return cell
    }
    
    //MARK: UITableView Delegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let obj = dataArray[indexPath.row]
        for tempObj in dataArray {
            tempObj.isSelect = false
        }
        selectedIndex = indexPath.row
        obj.isSelect = true
        splittDetailObj.selectedAnswer = obj.answerOption
        self.tableView.reloadData()
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }

    
    //MARK: UIButton Action Methods
    @IBAction func cancelButtonAction(_ sender: Any) {
        self.dismiss(animated: false, completion: nil)
    }
    
    @IBAction func submitButtonAction(_ sender: Any) {
        let selectedCount = dataArray.filter({$0.isSelect == true})
        if selectedCount.count == 0 {
            _ = AlertController.alert("", message: "Please select any answer.")
        } else {
            callApiForAnswer()
        }
    }
    
    @IBAction func splittButtonAction(_ sender: UIButton) {
      //  SCAvatarBrowser.show(sender.imageView)
    }
    
    
    //MARK: Selector Method
    @objc func radioButtonAction(_ sender: UIButton) {
        
    }

    
    @objc func handleTap(_ sender: UITapGestureRecognizer) {
        let indexPath = IndexPath(row: (sender.view?.tag)!, section: 0)
        let cell: SCAnswerTableViewCell = tableView.cellForRow(at: indexPath) as! SCAnswerTableViewCell
        //SCAvatarBrowser.show(cell.cellImageView)
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
    
    
    //MARK: API Methods
    func callApiForAnswer() {
        var params : Dictionary<String, AnyObject> = [
            cSplittId : splittDetailObj.splitt_id as AnyObject,
            cUserId  : UserDefaults.standard.value(forKey: cUserId) as AnyObject
        ]
        var selectedImageOption = ""
        if(contentType == .ImageAnswer){
            let modalObj = dataArray[selectedIndex]
            selectedImageOption = modalObj.abcdAnswerOption
            params[cAnswer] =  selectedImageOption as AnyObject
            params[cSplittOption] = selectedImageOption as AnyObject
        }else if(contentType == .multipleChoiceAnswer){
            let modalObj = dataArray[selectedIndex]
            selectedImageOption = modalObj.abcdAnswerOption
            params[cAnswer] =  selectedImageOption as AnyObject
            params[cSplittOption] = selectedImageOption as AnyObject
        } else if (contentType == .yesNoAnswer) {
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
