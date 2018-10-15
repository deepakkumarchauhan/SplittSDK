//
//  SCCommentsViewController.swift
//  SplittConsumer
//
//  Created by Vishal Mandhyan on 26/07/18.
//  Copyright © 2018 Deepak. All rights reserved.
//

import UIKit

class SCCommentsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextViewDelegate {
    static var cellIdentifier = "CommentCellID"
    var dataArray = [SCHomeInfo]()
    var homeInfo = SCHomeInfo()
    var paginationInfo = CAPaginationInfo()
    public var businessKey = String()

    @IBOutlet weak var viewBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var textView: ABSCustomTextView!
    @IBOutlet weak var bottomViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var noDataFoundLabel: UILabel!
    
    //MARK: UIView Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        initialMethod()
    }

    //MARK: Custom Method
    func initialMethod() {
        
        tableView.estimatedRowHeight = 91.0
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.keyboardWillShow(sender:)),
                                               name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.keyboardWillHide(sender:)),
                                               name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyBoard))
        view.addGestureRecognizer(tap)
        
        paginationInfo.pageNumber = "1"
        callApiForGetCommentList(pageNumber: paginationInfo.pageNumber)
    }
    
    @objc func dismissKeyBoard() {
        self.view.endEditing(true)
    }
    
    @objc func scrollToBottom() {
        if dataArray.count > 0 {
            tableView.scrollToRow(at: IndexPath(item:dataArray.count-1, section: 0), at: .bottom, animated: false)
        }
    }
    
    
    //MARK: UIScrollView Delegate
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        let currentOffset = scrollView.contentOffset.y;
        let maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height;
        
        if (maximumOffset - currentOffset <= 10.0) && self.dataArray.count > 0 {
            
            if  (Int(paginationInfo.pageNumber)! < Int(paginationInfo.totalPages)!  && paginationInfo.isLoadMoreExecuting) {
                paginationInfo.pageNumber = String(Int(paginationInfo.pageNumber)! + 1)
                callApiForGetCommentList(pageNumber: paginationInfo.pageNumber)
            }
        }
    }

    
    //MARK:- Keyboard Methods
    @objc func keyboardWillShow(sender: NSNotification) {
        if let userInfo = sender.userInfo {
            if let keyboardHeight = (userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.size.height {
                viewBottomConstraint.constant = -keyboardHeight
                UIView.animate(withDuration: 0.25, animations: { () -> Void in
                    self.view.layoutIfNeeded()
                })
                self.perform(#selector(scrollToBottom), with: nil, afterDelay: 0.2)
            }
        }
    }
    
    @objc func keyboardWillHide(sender: NSNotification) {
        viewBottomConstraint.constant = 0.0
        UIView.animate(withDuration: 0.25, animations: { () -> Void in self.view.layoutIfNeeded()
        })
        self.perform(#selector(scrollToBottom), with: nil, afterDelay: 0.2)
    }
    
    
    //MARK: UITableView Datasource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell : SCCommentsTableViewCell = tableView.dequeueReusableCell(withIdentifier: SCCommentsViewController.cellIdentifier) as! SCCommentsTableViewCell
        let obj = dataArray[indexPath.row]
        cell.nameLabel.text = obj.name
        cell.descriptionLabel.text = obj.commentDescription
        cell.timeLabel.text = obj.time_left
        let bundle = Bundle(for: HomeViewController.self)
        guard let image = UIImage(named: "profile_img", in: bundle, compatibleWith: nil)?.withRenderingMode(.alwaysOriginal) else {
            fatalError("Missing MyImage...")
        }
        cell.userImageView.downloadedFrom(link: obj.userimage, contentMode: .scaleToFill, placeholderImage: image)
        return cell
    }
    
    //MARK: UITableView Delegate
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }

    
    //MARK: UITextView Delegate
    @available(iOS 10.0, *)
    func textView(_ textView: UITextView, shouldInteractWith textAttachment: NSTextAttachment, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        return true
    }
    
    public func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        var str:NSString = textView.text! as NSString
        str = str.replacingCharacters(in: range, with: text) as NSString
        
        let fixedWidth = Window_Width - 91
        let newSize = textView.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude))
        if str.length > 1000 {
            return false
        }
        if(str.length > 0){
            if newSize.height > 100 {
                self.bottomViewHeightConstraint.constant = 100 + 30
            } else {
                self.bottomViewHeightConstraint.constant = newSize.height + 31
            }
        }else{
            self.bottomViewHeightConstraint.constant = 60        }
        self.perform(#selector(scrollToBottom), with: nil, afterDelay: 0.2)
        
        return true
    }

    
    //MARK: UIButton Action Methods
    @IBAction func backButtonAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func sendButtonAction(_ sender: Any) {
        if(self.textView.text.trimWhiteSpace().length == 0) {
            _ = AlertController.alert("", message: "Please enter comment.")
        } else {
            
            callApiForAddCommentSplitt()
        }
    }
    
    //MARK: Call API
    func callApiForAddCommentSplitt()
    {
        let dict = NSMutableDictionary()
        dict[cUserId] = NSUSERDEFAULT.value(forKey: cUserId)
        dict[cSplittId] = homeInfo.splitt_id
        dict[cComment] = self.textView.text.trimWhiteSpace()

        CAServiceHelper.sharedServiceHelper.request(dict as! Dictionary<String, AnyObject>, method: .post, apiName: "\(CommentSplitt)?businessKey=\(businessKey)", hudType: .simple) { (result, error, status) in
            if (error == nil) {
                if let response = result as? Dictionary<String, AnyObject> {
                    if(status == 200) {
                        let dataDict = response.validatedValue(cData, expected: Dictionary<String,AnyObject>() as AnyObject) as! Dictionary<String,AnyObject>
                        let obj = SCHomeInfo.modelFromAddCommentDict(dataDict)
                        obj.commentDescription = self.textView.text.trimWhiteSpace()
                        
                        self.dataArray.append(obj)
                        
                        self.textView.text = ""
                        self.bottomViewHeightConstraint.constant = 60
                        self.perform(#selector(self.scrollToBottom), with: nil, afterDelay: 0.2)
                        self.tableView.reloadData()
                        
                        if self.dataArray.count > 0 {
                            self.tableView.scrollToRow(at: IndexPath(item: self.dataArray.count-1, section: 0), at: .bottom, animated: false)
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

    
    func callApiForGetCommentList(pageNumber: String)
    {
        let dict = NSMutableDictionary()
        dict[cUserId] = NSUSERDEFAULT.value(forKey: cUserId)
        dict[cSplittId] = homeInfo.splitt_id
        dict[cPageSize] = "10"
        dict[cPageNumber] = pageNumber

        CAServiceHelper.sharedServiceHelper.request(dict as! Dictionary<String, AnyObject>, method: .post, apiName: "\(CommentListSplitt)?businessKey=\(businessKey)", hudType: .simple) { (result, error, status) in
            if (error == nil) {
                if let response = result as? Dictionary<String, AnyObject> {
                    if(status == 200) {
                        
                        let paginationInfo :Dictionary<String,AnyObject> = response.validatedValue(cPagination, expected: Dictionary<String,AnyObject>() as AnyObject) as! Dictionary<String, AnyObject>
                        self.paginationInfo = CAPaginationInfo.getPaginationData(paginationInfo)
                        if self.paginationInfo.pageNumber == "1" {
                            self.dataArray.removeAll()
                        }

                       let dataArray = response.validatedValue(cData, expected: NSArray()) as! [Dictionary<String,AnyObject>]
                        for dict in dataArray {
                            self.dataArray.append(SCHomeInfo.modelFromCommentDict(dict))
                        }
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
