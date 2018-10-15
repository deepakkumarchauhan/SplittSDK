//
//  LikeListViewController.swift
//  SCHomeViewController
//
//  Created by Vishal Mandhyan on 04/10/18.
//  Copyright © 2018 Deepak. All rights reserved.
//

import UIKit

class LikeListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    static var cellIdentifier = "LikeListCellID"
    var dataArray = [SCHomeInfo]()
    var splittInfo = SCHomeInfo()
    var paginationInfo = CAPaginationInfo()
    public var businessKey = String()

    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var noDataFoundLabel: UILabel!

    //MARK: UIView Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.estimatedRowHeight = 90.0
        
        callApiForLikeList(pageNumber: "1")
    }
    
    
    //MARK: - Scroll view delegate for calling pagination
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        let currentOffset = scrollView.contentOffset.y;
        let maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height;
        
        if (maximumOffset - currentOffset <= 10.0) && self.dataArray.count > 0 {
            
            if  (Int(paginationInfo.pageNumber)! < Int(paginationInfo.totalPages)!  && paginationInfo.isLoadMoreExecuting) {
                paginationInfo.pageNumber = String(Int(paginationInfo.pageNumber)! + 1)
                callApiForLikeList(pageNumber: paginationInfo.pageNumber)
            }
        }
    }
    
    
    
    //MARK: UITableView Datasource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell : LikeListTableViewCell = tableView.dequeueReusableCell(withIdentifier: LikeListViewController.cellIdentifier) as! LikeListTableViewCell
        
        let obj = dataArray[indexPath.row]
        cell.usernameLabel.text = obj.name
        
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
    
    
    //MARK: UIButton Action Method
    @IBAction func backButtonAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    //MARK: Call API
    func callApiForLikeList(pageNumber: String)
    {
        let dict = NSMutableDictionary()
        dict[cUserId] = NSUSERDEFAULT.value(forKey: cUserId)
        dict[cPageNumber] = pageNumber
        dict[cPageSize] = "10"
        dict[cSplittId] = splittInfo.splitt_id
        
        CAServiceHelper.sharedServiceHelper.request(dict as! Dictionary<String, AnyObject>, method: .post, apiName: "\(LikeListSplitt)?businessKey=\(businessKey)", hudType: .simple) { (result, error, status) in
            if (error == nil) {
                if let response = result as? Dictionary<String, AnyObject> {
                    if(status == 200) {
                        let dataArray = response.validatedValue(cData, expected: NSArray()) as! [Dictionary<String,AnyObject>]
                        
                        let paginationInfo :Dictionary<String,AnyObject> = response.validatedValue(cPagination, expected: Dictionary<String,AnyObject>() as AnyObject) as! Dictionary<String, AnyObject>
                        self.paginationInfo = CAPaginationInfo.getPaginationData(paginationInfo)
                        if self.paginationInfo.pageNumber == "1" {
                            self.dataArray.removeAll()
                        }
                        
                        //Data Parsing
                        for dict in dataArray {
                            self.dataArray.append(SCHomeInfo.modelFromLikeUserDict(dict))
                        }
                        self.paginationInfo.isLoadMoreExecuting = true
                        self.noDataFoundLabel.isHidden = self.dataArray.count == 0 ? false : true
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


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
