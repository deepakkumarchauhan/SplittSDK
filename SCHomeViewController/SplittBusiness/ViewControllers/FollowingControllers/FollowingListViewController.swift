//
//  FollowingListViewController.swift
//  SCHomeViewController
//
//  Created by Vishal Mandhyan on 08/10/18.
//  Copyright © 2018 Deepak. All rights reserved.
//

import UIKit

class FollowingListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {

    static var cellIdentifier = "FollowerCellID"
    var dataArray = [SCUserInfo]()
    var filterArray = [SCUserInfo]()
    var paginationInfo = CAPaginationInfo()
    
    var fromIndexToChangeView = Int()
    var otherUserId = String()
    //    var backIndex = Int()
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var navTitleLabel: UILabel!
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var noDataFoundLabel: UILabel!
    @IBOutlet weak var addMemberButton: UIButton!

    //MARK: UIView Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        initialMethod()
    }
    
    //MARK: Custom Method
    func initialMethod() {
        
        paginationInfo.pageNumber = "1"
        
        if fromIndexToChangeView == 0 {
            self.navTitleLabel.text = "Followers"
            self.callApiForFollowersList(pageNumber: paginationInfo.pageNumber, serachText: self.searchTextField.text!)
        } else if fromIndexToChangeView == 1 {
            self.navTitleLabel.text = "Following"
            self.callApiForFollowersList(pageNumber: paginationInfo.pageNumber, serachText: self.searchTextField.text!)
        } else if fromIndexToChangeView == 2 {
            self.navTitleLabel.text = "Groups"
            self.callApiForFollowersList(pageNumber: paginationInfo.pageNumber, serachText: self.searchTextField.text!)
        } else {
            self.navTitleLabel.text = "User List"
            callApiForUserList(pageNumber: paginationInfo.pageNumber, serachText: self.searchTextField.text!)
        }
        self.tableView.estimatedRowHeight = 100.0
    }
    
    
    func filterContent(searchText:String)  {
        filterArray.removeAll()
        for obj in self.dataArray {
            if obj.fullName.lowercased().contains(searchText.lowercased()) || obj.fullName.uppercased().contains(searchText.uppercased()) {
                filterArray.append(obj)
            }
        }
        tableView.reloadData()
    }
    
    
    //MARK: - Scroll view delegate for calling pagination
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        let currentOffset = scrollView.contentOffset.y;
        let maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height;
        
        if (maximumOffset - currentOffset <= 10.0) && self.dataArray.count > 0 {
            
            if  (Int(paginationInfo.pageNumber)! < Int(paginationInfo.totalPages)!  && paginationInfo.isLoadMoreExecuting) {
                paginationInfo.pageNumber = String(Int(paginationInfo.pageNumber)! + 1)
                if fromIndexToChangeView == 4 {
                    callApiForUserList(pageNumber: paginationInfo.pageNumber, serachText: self.searchTextField.text!)
                } else {
                    self.callApiForFollowersList(pageNumber: paginationInfo.pageNumber, serachText: self.searchTextField.text!)
                }
            }
        }
    }
    
    
    //MARK: UITableView Datasource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filterArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : FollowingTableViewCell = tableView.dequeueReusableCell(withIdentifier: FollowingListViewController.cellIdentifier) as! FollowingTableViewCell
        cell.followButton.tag = indexPath.row+100
        cell.unfollowButton.tag = indexPath.row+100
        cell.blockButton.tag = indexPath.row+100
        cell.userImageView.tag = indexPath.row+100
        
        cell.followButton.isHidden = true
        cell.blockButton.isHidden = true
        cell.unfollowButton.isHidden = true
        cell.userImageView.isHidden = false
        
        let obj = filterArray[indexPath.row]
        cell.userNameLabel.text = obj.fullName
        
        let bundle = Bundle(for: HomeViewController.self)
        guard let image = UIImage(named: "profile_img", in: bundle, compatibleWith: nil)?.withRenderingMode(.alwaysOriginal) else {
            fatalError("Missing MyImage...")
        }
        cell.userImageView.downloadedFrom(link: obj.userImageString, contentMode: .scaleToFill, placeholderImage: image)

        if fromIndexToChangeView == 0 || fromIndexToChangeView == 2 {
            cell.titleRightConstraint.constant = 20
        } else if fromIndexToChangeView == 1 {
            cell.unfollowButton.isHidden = otherUserId == "" ? false : true
            cell.unfollowButton.setTitle(obj.isFollow ? "+Unfollow" : "+Follow", for: .normal)
        } else if fromIndexToChangeView == 4 {
            cell.followButton.isHidden = false
            cell.blockButton.isHidden = false
            cell.followButton.setTitle(obj.isFollow ? "+Unfollow" : "+Follow", for: .normal)
            cell.blockButton.setTitle(obj.isBlock ? "Unblock" : "Block", for: .normal)
        } else if fromIndexToChangeView == 3 {
            cell.titleLeftConstraint.constant = 20
            cell.titleRightConstraint.constant = 20
            cell.seperatorLeftConstraint.constant = 0
            cell.userImageView.isHidden = true
            cell.userNameLabel.text = "10 Off"
        }
        
        //Add TapGesture
        cell.userImageView.isUserInteractionEnabled = true
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        cell.userImageView.addGestureRecognizer(tap)
        
        cell.followButton.addTarget(self, action: #selector(self.followButtonAction(_:)), for: UIControlEvents.touchUpInside)
        cell.unfollowButton.addTarget(self, action: #selector(self.unfollowButtonAction(_:)), for: UIControlEvents.touchUpInside)
        cell.blockButton.addTarget(self, action: #selector(self.blockButtonAction(_:)), for: UIControlEvents.touchUpInside)
        
        return cell
    }
    
    //MARK: UITableView Delegate
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        if fromIndexToChangeView == 2 {
//            dataArray.removeAll()
//            filterArray.removeAll()
//            //Add Dumy Data
//            for _ in 0...15 {
//                dataArray.append(SCUserInfo.modelFromGroupDict(Dictionary()))
//            }
//            filterArray = dataArray
//            self.addMemberButton.isHidden = false
//            self.navTitleLabel.text = "Group Members"
//        }
    }
    
    
    //MARK: - UITextField Delegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        var str:NSString = textField.text! as NSString
        str = str.replacingCharacters(in: range, with: string) as NSString
        
        if fromIndexToChangeView == 4 {
            self.callApiForUserList(pageNumber: "1", serachText: str as String)
        } else {
            self.callApiForFollowersList(pageNumber: "1", serachText: str as String)
        }
        return true
    }
    
    
    //MARK: UIButton Action Method
    @IBAction func backButtonAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    
    //MARK: Selector Method
    @objc func followButtonAction(_ sender: UIButton) {
        let obj = self.filterArray[sender.tag-100]
        _ = AlertController.alert("", message: "Are you sure you want to follow/unfollow \(obj.fullName)?", controller: self, buttons: ["Yes", "No"], tapBlock: { (action, index) in
            if index == 0 {
                self.callApiForFollowUnfollowUser(userObj: obj)
            }
        })
    }
    
    @objc func unfollowButtonAction(_ sender: UIButton) {
        let obj = filterArray[sender.tag-100]
        callApiForFollowUnfollowUser(userObj: obj)
    }
    
    @objc func blockButtonAction(_ sender: UIButton) {
        let obj = filterArray[sender.tag-100]
        _ = AlertController.alert("", message: "Are you sure you want to block/unblock \(obj.fullName)?", controller: self, buttons: ["Yes", "No"], tapBlock: { (action, index) in
            if index == 0 {
                self.callApiForBlockUnblockUser(userObj: obj)
            }
        })
    }
    
    
    @objc func handleTap(_ sender: UITapGestureRecognizer) {
//        if fromIndexToChangeView == 0 || fromIndexToChangeView == 1 || fromIndexToChangeView == 4 {
//            let obj = filterArray[(sender.view?.tag)!-100]
//            if obj.roleType == "2" {
//                let profileVC = SCProfileViewController()
//                profileVC.otherProfileId = obj.userId
//                self.navigationController?.pushViewController(profileVC, animated: true)
//            } else {
//                let profileVC = SCBusinessProfileViewController()
//                profileVC.otherProfileId = obj.userId
//                self.navigationController?.pushViewController(profileVC, animated: true)
//            }
//        }
    }
    
    
    //MARK: Call API
    func callApiForFollowersList(pageNumber: String, serachText: String)
    {
        let dict = NSMutableDictionary()
        var apiName = String()
        if fromIndexToChangeView == 0 {
            apiName = FollowersList
        } else if fromIndexToChangeView == 1 {
            apiName = FolloweringList
        } else if fromIndexToChangeView == 2 {
            apiName = MyGroupList
            dict[cType] = "business"
        }
        dict[cPageNumber] = pageNumber
        dict[cPageSize] = "10"
        dict[cSearch] = serachText
        dict[cUserId] = otherUserId == "" ? NSUSERDEFAULT.value(forKey: cUserId) : otherUserId
        
        CAServiceHelper.sharedServiceHelper.request(dict as! Dictionary<String, AnyObject>, method: .post, apiName: apiName, hudType: .simple) { (result, error, status) in
            if (error == nil) {
                if let response = result as? Dictionary<String, AnyObject> {
                    if(status == 200) {
                        //Pagination Data
                        let paginationInfo :Dictionary<String,AnyObject> = response.validatedValue(cPagination, expected: Dictionary<String,AnyObject>() as AnyObject) as! Dictionary<String, AnyObject>
                        self.paginationInfo = CAPaginationInfo.getPaginationData(paginationInfo)
                        if self.paginationInfo.pageNumber == "1" {
                            self.dataArray.removeAll()
                            self.filterArray.removeAll()
                        }
                        
                        var dataArray = [Dictionary<String,AnyObject>]()
                        let dataDict = response.validatedValue(cData, expected: Dictionary<String,AnyObject>() as AnyObject)as! Dictionary<String,AnyObject>
                        if self.fromIndexToChangeView == 0 {
                            dataArray = dataDict.validatedValue(cFollowerData, expected: NSArray()) as! [Dictionary<String,AnyObject>]
                        } else if self.fromIndexToChangeView == 1 {
                            dataArray = dataDict.validatedValue(cFollowingData, expected: NSArray()) as! [Dictionary<String,AnyObject>]
                        } else if self.fromIndexToChangeView == 2 {
                            dataArray = dataDict.validatedValue(cGroupData, expected: NSArray()) as! [Dictionary<String,AnyObject>]
                        }
                        
                        //Data Parsing
                        for dict in dataArray {
                            if self.fromIndexToChangeView == 0 {
                                self.dataArray.append(SCUserInfo.modelFromFollowersDict(dict))
                            } else if self.fromIndexToChangeView == 1 {
                                self.dataArray.append(SCUserInfo.modelFromFollowingDict(dict))
                            } else if self.fromIndexToChangeView == 2 {
                                self.dataArray.append(SCUserInfo.modelFromGroupDict(dict))
                            }
                        }
                        
                        self.filterArray = self.dataArray
                        self.noDataFoundLabel.isHidden = (self.filterArray.count <= 0) ? false : true
                        self.paginationInfo.isLoadMoreExecuting = true
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
    
    func callApiForUserList(pageNumber: String, serachText: String)
    {
//        let dict = NSMutableDictionary()
//        dict[cUserId] = otherUserId == "" ? NSUSERDEFAULT.value(forKey: cUserId) : otherUserId
//        dict[cPageNumber] = pageNumber
//        dict[cPageSize] = "10"
//        dict[cSearch] = serachText
//
//        CAServiceHelper.sharedServiceHelper.request(dict as! Dictionary<String, AnyObject>, method: .post, apiName: UserList, hudType: .simple) { (result, error, status) in
//            if (error == nil) {
//                if let response = result as? Dictionary<String, AnyObject> {
//                    if(status == 200) {
//                        let dataArray = response.validatedValue(cData, expected: NSArray()) as! [Dictionary<String,AnyObject>]
//
//                        let paginationInfo :Dictionary<String,AnyObject> = response.validatedValue(cPagination, expected: Dictionary<String,AnyObject>() as AnyObject) as! Dictionary<String, AnyObject>
//                        self.paginationInfo = CAPaginationInfo.getPaginationData(paginationInfo)
//                        if self.paginationInfo.pageNumber == "1" {
//                            self.dataArray.removeAll()
//                            self.filterArray.removeAll()
//                        }
//
//                        //Data Parsing
//                        for dict in dataArray {
//                            self.dataArray.append(SCUserInfo.modelFromUserListDict(dict))
//                        }
//                        self.filterArray = self.dataArray
//                        self.paginationInfo.isLoadMoreExecuting = true
//                        self.noDataFoundLabel.isHidden = self.filterArray.count == 0 ? false : true
//                        self.tableView.reloadData()
//                    }
//                    else {
//                        _ = AlertController.alert("", message: response.validatedValue(pResponseMessage, expected: "" as AnyObject) as! String)
//                    }
//                }
//            }
//            else {
//                _ = AlertController.alert("", message: "\(error!.localizedDescription)")
//            }
//        }
    }
    
    
    func callApiForBlockUnblockUser(userObj: SCUserInfo)
    {
        let dict = NSMutableDictionary()
        dict[cUserId] = NSUSERDEFAULT.value(forKey: cUserId)
        dict[cBlockId] = userObj.userId
        
        CAServiceHelper.sharedServiceHelper.request(dict as! Dictionary<String, AnyObject>, method: .post, apiName: BlockUnblockUser, hudType: .simple) { (result, error, status) in
            if (error == nil) {
                if let response = result as? Dictionary<String, AnyObject> {
                    if(status == 200) {
                        userObj.isBlock = !userObj.isBlock
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
    
    
    func callApiForFollowUnfollowUser(userObj: SCUserInfo)
    {
        let dict = NSMutableDictionary()
        dict[cFollowBy] = NSUSERDEFAULT.value(forKey: cUserId)
        dict[cFollowTo] = userObj.userId
        
        CAServiceHelper.sharedServiceHelper.request(dict as! Dictionary<String, AnyObject>, method: .post, apiName: FollowUnfollow, hudType: .simple) { (result, error, status) in
            if (error == nil) {
                if let response = result as? Dictionary<String, AnyObject> {
                    if(status == 200) {
                        userObj.isFollow = !userObj.isFollow
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

}
