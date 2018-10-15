//
//  BTAppUtility.swift
//  BeanThere
//
//  Created by Neha Chhabra on 11/11/16.
//  Copyright © 2016 Neha Chhabra. All rights reserved.
//

import UIKit
import Contacts

// MARK: - Short Terms
let KAppWhiteColor = UIColor.white
let kAppDarkGrayColor = RGBA(29, g: 35, b: 34, a: 0.2)
let KAppTintColor = RGBA(255, g: 220, b: 65, a: 1)
let dummyPlaceHolderArray = [UIImage.init(named: "image_placeholder"),UIImage.init(named: "image_placeholder"),UIImage.init(named: "image_placeholder"),UIImage.init(named: "image_placeholder")]


let kHomeTabTitleColorColor = RGBA(97, g: 208, b: 224, a: 1)
let kViewErrorBorderColor = RGBA(255, g: 0, b: 0, a: 1)
let kViewBorderColor = RGBA(0, g: 183, b: 201, a: 1)
let kHomeButtonBorderColor = RGBA(68, g: 215, b: 251, a: 1)
let kSelectedButtonColor = RGBA(57, g: 143, b: 162, a: 1)

let KAppBlueColor = RGBA(61, g: 178, b: 198, a: 1)
let KAppRedColor = RGBA(226, g: 37, b: 44, a: 1)

let KAppButtonBoldFont = UIFont(name:"ITCKabelStd-Bold", size:18)!
let KAppButtonNormalFont = UIFont(name:"ITCKabelStd-Book", size:18)!

let showLog = true

let Window_Width = UIScreen.main.bounds.size.width
let Window_Height = UIScreen.main.bounds.size.height

let NSUSERDEFAULT = UserDefaults.standard


// MARK: - Helper functions

func loadFontWith(name: String) {
    let frameworkBundle = Bundle(for: HomeViewController.self)
    let pathForResourceString = frameworkBundle.path(forResource: name, ofType: "otf")
    let fontData = NSData(contentsOfFile: pathForResourceString!)
    let dataProvider = CGDataProvider(data: fontData!)
    let fontRef = CGFont(dataProvider!)
    var errorRef: Unmanaged<CFError>? = nil
    
    if (CTFontManagerRegisterGraphicsFont(fontRef!, &errorRef) == false) {
        NSLog("Failed to register font - register graphics font failed - this font may have already been registered in the main bundle.")
    }
}

public func loadMyFonts() {
    loadFontWith(name: "ITCKabelStd-Bold")
    loadFontWith(name: "ITCKabelStd-Book")
}


func dropShadow(objView: UIView) {
    
    objView.layer.masksToBounds = false
    objView.layer.shadowColor = UIColor.lightGray.cgColor
    objView.layer.shadowOpacity = 0.5
    objView.layer.shadowOffset = CGSize(width: 1, height: 1)
    objView.layer.shadowRadius = 1
    
    objView.layer.shadowPath = UIBezierPath(rect: objView.bounds).cgPath
    objView.layer.shouldRasterize = true
}

func dropShadowOnTop(objView: UIView) {
    
    objView.layer.masksToBounds = false
    objView.layer.shadowColor = UIColor.lightGray.cgColor
    objView.layer.shadowOpacity = 0.5
    objView.layer.shadowOffset = CGSize.zero
    objView.layer.shadowRadius = 2
    objView.layer.shadowPath = UIBezierPath(rect: objView.bounds).cgPath
    objView.layer.shouldRasterize = true
}

func dropShadowForAllCorners(objView: UIView) {
    
    objView.layer.masksToBounds = false
    objView.layer.shadowColor = UIColor.darkGray.cgColor
    objView.layer.shadowOpacity = 0.5
    objView.layer.shadowOffset = CGSize.zero
    objView.layer.shadowRadius = 1
    
    objView.layer.shadowPath = UIBezierPath(rect: objView.bounds).cgPath
    objView.layer.shouldRasterize = true
}


func RGBA(_ r:CGFloat, g:CGFloat, b:CGFloat, a:CGFloat) -> UIColor {
    return UIColor(red: (r/255.0), green: (g/255.0), blue: (b/255.0), alpha: a)
}

func getRoundRect(_ obj : UIButton){
    obj.layer.cornerRadius = obj.frame.size.height/2
    obj.layer.borderColor = KAppWhiteColor.cgColor
    obj.layer.borderWidth = obj.frame.size.width/2
    obj.clipsToBounds = true
}

func getRoundImage(_ obj : UIImageView){
    obj.layer.cornerRadius = obj.frame.size.height/2
    obj.layer.borderColor = KAppWhiteColor.cgColor
    obj.layer.borderWidth = 5
    obj.layer.masksToBounds = true
}

func getViewWithTag(_ tag:NSInteger, view:UIView) -> UIView {
    return view.viewWithTag(tag)!
}

// custom log
func logInfo(_ message: String, file: String = #file, function: String = #function, line: Int = #line, column: Int = #column) {
    if (showLog) {
        print("\(function): \(line): \(message)")
    }
}

func trimWhiteSpace (_ str: String) -> String {
    let trimmedString = str.trimmingCharacters(in: CharacterSet.whitespaces)
    return trimmedString
}


class BTAppUtility: NSObject {
   class func convertDateString(dateString : String!, fromFormat sourceFormat : String!, toFormat desFormat : String!) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = sourceFormat
        let date = dateFormatter.date(from: dateString)
        dateFormatter.dateFormat = desFormat
        return dateFormatter.string(from: date!)
    }
    
    class func getStringFromDate(date : Date) -> String {
        
        let dateFormat = DateFormatter.init()
        dateFormat.timeZone = NSTimeZone.local
        dateFormat.dateFormat = "dd MMMM, YYYY"
        return dateFormat.string(from: date)
    }
    
    class func getTimeAndDateStringFromDate(date : Date) -> String {
        
        let dateFormat = DateFormatter.init()
        dateFormat.timeZone = NSTimeZone.local
        dateFormat.dateFormat = "YYYY-MM-dd HH:mm:ss"
        return dateFormat.string(from: date)
    }

    
    class func getTimerData(splittArray : [SCHomeInfo]) -> [SCHomeInfo] {
        for item in splittArray {
            if Int(item.time_left) != 0  && item.time_left.length != 0 {
                var sec = Int(item.time_left)!
                var minute = 0
                var hour = 0
                var day = 0
                var week = 0
                if (sec > 59) {
                    minute = sec / 60
                    sec = sec % 60
                    if (minute > 59) {
                        hour = minute / 60
                        minute = minute % 60
                        if (hour > 23) {
                            day = hour / 24
                            if (day > 6) {
                                week = day / 7
                                item.remainingTime = "\(week) weeks left"
                            }else{
                                item.remainingTime = "\(day) days left"
                            }
                        }else{
                            item.remainingTime = "\(hour):\(minute):\(sec) hours left"
                        }
                    }else{
                        item.remainingTime = "\(minute):\(sec) mins left"
                    }
                } else {
                    if sec == 0 {
                        item.remainingTime = "No time left"
                    } else {
                        item.remainingTime = "\(sec) secs left"
                    }
                }
                item.time_left = "\(Int(item.time_left)! - 1)"
            } else {
                item.remainingTime = "No time left"
                //item.isTimerPopUpShown = false
            }
        }
        
        return splittArray
    }

    class func getTimeStringFromDate(date : Date) -> String {
        let dateFormat = DateFormatter.init()
        dateFormat.timeZone = NSTimeZone.local
        dateFormat.dateFormat = "HH:mm a"
        return dateFormat.string(from: date)
    }


    
   class func countryName(countryCode: String) -> String? {
        let current = Locale(identifier: Locale.current.identifier)
        return current.localizedString(forRegionCode: countryCode) ?? nil
    }

    class  func leftBarButton(_ imageName : NSString,controller : UIViewController) -> UIBarButtonItem {
        let button:UIButton = UIButton.init(type: UIButtonType.custom)
        button.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        button.setImage(UIImage(named: imageName as String), for: UIControlState())
        button.addTarget(controller, action: #selector(leftBarButtonAction(_:)), for: UIControlEvents.touchUpInside)
        let leftBarButtonItem:UIBarButtonItem = UIBarButtonItem(customView: button)
        
        return leftBarButtonItem
    }
    class  func rightBarButton(_ imageName : NSString,controller : UIViewController) -> UIBarButtonItem {
        let button:UIButton = UIButton.init(type: UIButtonType.custom)
        button.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        button.setImage(UIImage(named: imageName as String), for: UIControlState())
        button.addTarget(controller, action: #selector(rightBarButtonAction(_:)), for: UIControlEvents.touchUpInside)
        let leftBarButtonItem:UIBarButtonItem = UIBarButtonItem(customView: button)
        
        return leftBarButtonItem
    }
    
    @objc   func leftBarButtonAction(_ button : UIButton) {
        
    }
    
    @objc   func rightBarButtonAction(_ button : UIButton) {
        
    }
    
    
    //MARK: - Fetch Contacts Method
    class func fetchContactList(completionBlock: @escaping ([SCUserInfo]) -> Void)->Void {
        var dataArray = [SCUserInfo]()
        
        let store = CNContactStore()
        store.requestAccess(for: .contacts, completionHandler: {
            granted, error in
            
            guard granted else {
                return
            }
            let keysToFetch = [CNContactFormatter.descriptorForRequiredKeys(for: .fullName), CNContactPhoneNumbersKey,CNContactEmailAddressesKey,CNContactImageDataKey] as [Any]
            let request = CNContactFetchRequest(keysToFetch: keysToFetch as! [CNKeyDescriptor])
            var cnContacts = [CNContact]()
            
            do {
                try store.enumerateContacts(with: request){
                    (contact, cursor) -> Void in
                    cnContacts.append(contact)
                }
            } catch let error {
                Debug.log("Fetch contact error: \(error)")
            }
            
            for contact in cnContacts {
                let usernameName = CNContactFormatter.string(from: contact, style: .fullName) ?? "No Name"
                let contactNumber = contact.phoneNumbers.first?.value
                let contactEmail  = contact.emailAddresses.first?.value
                let Image  = contact.imageData
                let contactImage = (Image == nil) ? UIImage(named: "profile_img") : UIImage.init(data: Image!)
                let objTemp = SCUserInfo()
                objTemp.fullName = (usernameName.length == 0) ? "" : usernameName
                objTemp.mobile = (contactNumber == nil) ? "" : (contactNumber?.stringValue)!
                objTemp.emailID = (contactEmail == nil) ? "" : contactEmail! as String
                objTemp.userImage = contactImage!
                objTemp.isSelect = false
                if (contactNumber != nil) || (contactEmail != nil) {
                    dataArray.append(objTemp)
                }
            }
            completionBlock(dataArray)
        })
    }

    
    class func addToolBarOnView(_ controller: UIViewController)->UIToolbar {
        
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: Window_Width, height: 50))
        doneToolbar.barStyle       = UIBarStyle.default
        let flexSpace              = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem  = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.done, target: controller, action: #selector(doneButtonAction))
        
        var items = [UIBarButtonItem]()
        items.append(flexSpace)
        items.append(done)
        
        doneToolbar.items = items
        doneToolbar.sizeToFit()
        
        return doneToolbar
    }
    
    @objc func doneButtonAction() {
        
    }


}

