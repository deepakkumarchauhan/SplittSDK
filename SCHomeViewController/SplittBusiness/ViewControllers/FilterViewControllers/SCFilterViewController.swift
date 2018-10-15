//
//  SCFilterViewController.swift
//  SplittConsumer
//
//  Created by Vishal Mandhyan on 25/07/18.
//  Copyright © 2018 Deepak. All rights reserved.
//

import UIKit
protocol FilterHomeProtocol {
    func callHomeApiAfterFilter(filterInfo: SCUserInfo)
}

class SCFilterViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    static var collectionCellIdentifier = "FilterCellID"
    public var businessKey = String()

    var filterInfo = SCUserInfo()
    var delegate: FilterHomeProtocol?
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var timelineTextField: CustomTextField!
    
    @IBOutlet weak var consumerButton: UIButton!
    @IBOutlet weak var businessButton: UIButton!
    
    @IBOutlet weak var switchButton: UISwitch!
    
    //MARK: UIView Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        if filterInfo.filterArray.count == 0 {
            callApiToGetCategoryList()
        } else {
            switchButton.isOn = filterInfo.isOnlyConnection
            self.timelineTextField.text = filterInfo.timeline
        }
    }
    
    //MARK: UICollectionView Datasource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filterInfo.filterArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SCFilterViewController.collectionCellIdentifier, for: indexPath) as! SCFilterCollectionViewCell
        cell.checkButton.tag = indexPath.row+100
        
        let obj = filterInfo.filterArray[indexPath.row]
        cell.checkButton.setTitle(obj.proSplittCategoryName, for: .normal)
        cell.checkButton.isSelected = obj.isSelect
        cell.checkButton.addTarget(self, action: #selector(self.checkButtonAction(_:)), for: UIControlEvents.touchUpInside)

        return cell
    }
    
    //MARK: UICollectionView Delegate
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (collectionView.frame.size.width-10)/2, height: 45)
    }
    
    
    //MARK: UIButton Action
    @IBAction func consumerSplittButtonAction(_ sender: UIButton) {
        self.businessButton.backgroundColor = UIColor.white
        self.businessButton.setTitleColor(kSelectedButtonColor, for: .normal)
        sender.backgroundColor = kSelectedButtonColor
        sender.setTitleColor(UIColor.white, for: .normal)
        
        self.filterInfo.filterArray.removeAll()
        self.filterInfo.filterArray = self.filterInfo.dataArray.filter{$0.roleType == "consumer"}
        let obj = SCUserInfo()
        obj.proSplittCategoryName = "All"
        self.filterInfo.filterArray.insert(obj, at: 0)

        self.collectionView.reloadData()
    }
    
    @IBAction func businessSplittButtonAction(_ sender: UIButton) {
        self.consumerButton.backgroundColor = UIColor.white
        self.consumerButton.setTitleColor(kSelectedButtonColor, for: .normal)
        sender.backgroundColor = kSelectedButtonColor
        sender.setTitleColor(UIColor.white, for: .normal)
        
        self.filterInfo.filterArray.removeAll()
        self.filterInfo.filterArray = self.filterInfo.dataArray.filter{$0.roleType == "business"}
        let obj = SCUserInfo()
        obj.proSplittCategoryName = "All"
        self.filterInfo.filterArray.insert(obj, at: 0)
        
        self.collectionView.reloadData()
    }
    
    @IBAction func cancelButtonAction(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func applyButtonAction(_ sender: UIButton) {
        let selectedArray = filterInfo.filterArray.filter{$0.isSelect == true}
        
        if selectedArray.count == 0 {
            _ = AlertController.alert("", message: "Please select categories.")
        } else {
            self.dismiss(animated: true) {
                self.delegate?.callHomeApiAfterFilter(filterInfo: self.filterInfo)
            }
        }
    }
    
    @IBAction func selectTimelineButtonAction(_ sender: Any) {
        let timelineArray = self.filterInfo.timelineArray.map{$0.timeline}

        DPPickerManager.shared.showPicker(title: "Select Timeline", selected: self.filterInfo.timeline, strings: timelineArray) { (title, index, status) in
            if !status {
                self.filterInfo.timeline = title!
                self.filterInfo.timelineId = self.filterInfo.timelineArray[index].timelineId
                self.timelineTextField.text = title
            }
        }
    }
    
    //MARK: UISwitch Action
    @IBAction func onlyConnectionAction(_ sender: UISwitch) {
        filterInfo.isOnlyConnection = sender.isOn
    }
    
    @IBAction func internationalAction(_ sender: UISwitch) {
        filterInfo.isInternational = sender.isOn
    }
    
    
    //MARK: Selector Method
    @objc func checkButtonAction(_ sender: UIButton) {
        //WARNING: Use map method
        
        if sender.tag == 100 {
            let obj = filterInfo.filterArray.first
            obj?.isSelect = !(obj?.isSelect)!
            if (obj?.isSelect)! {
                for obj in filterInfo.filterArray {
                    obj.isSelect = true
                }
            } else {
                for obj in filterInfo.filterArray {
                    obj.isSelect = false
                }
            }
        } else {
            let obj = filterInfo.filterArray[sender.tag-100]
            
            obj.isSelect = !obj.isSelect
            var checkAllArray = filterInfo.filterArray
            checkAllArray.remove(at: 0)
            let selectedArray = checkAllArray.filter{$0.isSelect == true}
            
            if filterInfo.filterArray.count == selectedArray.count+1 {
                for obj in filterInfo.filterArray {
                    obj.isSelect = true
                }
            } else {
                let obj = filterInfo.filterArray.first
                obj?.isSelect = false
            }
        }
        self.collectionView.reloadData()
    }

    
    //MARK: Call API
    func callApiToGetCategoryList()
    {
        //Show hud
        let animationView = RPLoadingAnimationView(
            frame: CGRect(origin: CGPoint(x: UIScreen.main.bounds.size.width*0.4,y: UIScreen.main.bounds.size.height*0.5), size: CGSize(width: 80, height: 80)),
            type: .lineScale,
            colors: [UIColor.orange, UIColor.yellow, UIColor.white],
            size: CGSize(width: 80, height: 80)
        )
        self.view.addSubview(animationView)
        animationView.setupAnimation()

        let dict = NSMutableDictionary()
        dict[cUserId] = NSUSERDEFAULT.value(forKey: cUserId)
        
        CAServiceHelper.sharedServiceHelper.request(dict as! Dictionary<String, AnyObject>, method: .post, apiName: "\(GetBothCategory)?businessKey=\(businessKey)", hudType: .simple) { (result, error, status) in
            animationView.removeFromSuperview()
            
            if (error == nil) {
                if let response = result as? Dictionary<String, AnyObject> {
                    if(status == 200) {
                        
                        let dataArray = response.validatedValue(cData, expected: NSArray() as AnyObject)as! [Dictionary<String,AnyObject>]
                        self.filterInfo.dataArray.removeAll()

                        for dict in dataArray {
                            self.filterInfo.dataArray.append(SCUserInfo.modelFromCategoryDict(dict))
                        }
                        
                        self.filterInfo.filterArray = self.filterInfo.dataArray.filter{$0.roleType == "business"}
                        let obj = SCUserInfo()
                        obj.isSelect = true
                        obj.proSplittCategoryName = "All"
                        self.filterInfo.filterArray.insert(obj, at: 0)

                        self.collectionView.reloadData()
                        self.callApiToGetTimelines()
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

    
    func callApiToGetTimelines()
    {
        let dict = NSMutableDictionary()
        dict[cUserId] = NSUSERDEFAULT.value(forKey: cUserId)
        
        CAServiceHelper.sharedServiceHelper.request(dict as! Dictionary<String, AnyObject>, method: .post, apiName: "\(GetTimeline)?businessKey=\(businessKey)", hudType: .simple) { (result, error, status) in
            if (error == nil) {
                if let response = result as? Dictionary<String, AnyObject> {
                    if(status == 200) {
                        let dataArray = response.validatedValue(cData, expected: NSArray()) as! [Dictionary<String,AnyObject>]
                        
                        //Data Parsing
                        for dict in dataArray {
                            self.filterInfo.timelineArray.append(SCUserInfo.modelFromTimelineDict(dict))
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
