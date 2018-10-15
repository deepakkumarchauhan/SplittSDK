//
//  CAUserInfo.swift
//  CoreApplication
//
//  Created by apple on 4/19/18.
//  Copyright © 2018 WonderPillars. All rights reserved.
//

import UIKit

class SCUserInfo: NSObject {
    
    var userName = ""
    var confirmPassword = ""
    var otp = ""
    var userId = ""
    var password = ""
    var oldPassword = ""
    var country = ""
    var mobileCode = ""
    var dob = ""
    var gender = ""
    var selectedIndexForImage = ""
    var question = ""
    var address = ""
    var addressIndex = Int()
    var storeImageArray = [SCUserInfo]()
    var addressArray = [SCUserInfo]()
    var facebookAddress = ""
    var twitterAddress = ""
    var instagramAddress = ""
    var linkedinAddress = ""
    var websiteAddress = ""
    var bio = ""
    var fax = ""
    var operationHours = [SCUserInfo]()
    var operationHoursCount = ""
    var splittCount = ""
    var followerCount = ""
    var followingCount = ""
    var groupCount = ""
    var rewardCount = ""
    var businessCategory = ""
    var userImageString = ""
    var backgroundImageString = ""
    var imageId = ""
    var storeImage = UIImage()
    var referenceAddress = ""
    var miles = ""
    var storeImageIndex = Int()
    var categoryArray = [SCUserInfo]()
    var rewardArray = [SCUserInfo]()
    var timelineArray = [SCUserInfo]()
    var referalArray = [String]()
    
    var surveyYesNoArray = [SCHomeInfo]()
    var surveyArray = [SCHomeInfo]()
    var ratingArray = [SCHomeInfo]()
    
    //Post
    var publicPrivate = ""
    var timeline = ""
    var timelineId = ""
    var isYesPost = ""
    
    var category = ""
    var individualGroup = ""
    var categoryName = ""
    var categoryId = ""
    var thumbnailImageString = ""
    
    var review = ""
    var rating = ""
    
    
    
    //Notification
    var notificationID = ""
    var notificationTitle = ""
    var notificationUserImage = ""
    
    //Filter
    var filterID = ""
    var filterTitle = ""
    var isInternational = Bool()
    var isOnlyConnection = Bool()
    
    
    //Create Splitt
    var isFuture = Bool()
    var isPro = Bool()
    var isVideo = Bool()
    var isMultipleQuestion = Bool()
    var isPhotoOption = Bool()
    var isPublic = Bool()
    var isSurvey = Bool()
    var isNearBy = Bool()
    var isProSurvey = Bool()
    var selectedDate = ""
    var textOrVideo = ""
    var expireDate = ""
    var proTitle = ""
    
    var cityName = ""
    var addressCount = Int()
    
    
    //Common  Variables (Invite Friend)
    var fullName = ""
    var emailID = ""
    var mobile = ""
    var redeemed = ""
    var birthDay = ""
    var imageUrl:URL? = nil
    var socialId = ""
    
    var isSelect = Bool()
    var userImage = UIImage()
    var isAnonymous = Bool()
    
    var yesStatus = Bool()
    var noStatus = Bool()
    var splittAnswerType = ""
    var splittAnswerA = ""
    var splittAnswerB = ""
    var splittAnswerC = ""
    var splittAnswerD = ""
    var splittAnswerE = ""
    var saveStatus = ""
    var answerType = ""
    
    var answer = ""
    var redeem = ""
    
    var groupId = ""
    var groupImage = ""
    var groupName = ""
    var isFollow = Bool()
    var isBlock = Bool()
    var isSelectWhenCreate = Bool()
    var day = ""
    var openTime = ""
    var closeTime = ""
    
    //Pro Splitt
    var proSplittCategoryName = ""
    var proSplittId = ""
    
    var selectionType = "sent"
    
    
    var ansYA = ""
    var ansYB = ""
    var ansYC = ""
    var ansYD = ""
    var ansNA = ""
    var ansNB = ""
    var ansNC = ""
    var ansND = ""
    var locationCount = Int()
    
    var yesQuestion = ""
    var noQuestion = ""
    
    var maleCount = Int()
    var femaleCount = Int()
    var otherCount = Int()
    var totalGenderCount = Int()
    
    var eighteenToTwentyFive = Int()
    var twentyFiveToFourtyFive = Int()
    var greaterThanFourtyFive = Int()
    var totalAgeCount = Int()
    
    var avgResponseTime = ""
    var avgRedemptionTime = ""
    
    //Reward List
    var rewardTitle = ""
    var rewardId = ""
    var radius = ""
    var selectedFollowersId = ""
    var selectedCategorysId = ""
    
    var userType = ""
    
    var followers = ""
    var typeSplitt = ""
    var splittType = ""
    var splittTextOrVideo = ""
    var splittCategoryType = ""
    var followerArray = [String]()
    
    var roleType = ""
    var rewardTerms = ""
    var imageCount = Int()
    
    
    //Splitt Category List
    var questionId = ""
    var questionNameYes = ""
    var questionNameNo = ""
    var questionTitle = ""
    var questionTitleName = ""
    var answerAn = ""
    var answerBn = ""
    var answerCn = ""
    var answerDn = ""
    
    //Upload Video
    var videoUrl:URL? = nil
    var imageArray = dummyPlaceHolderArray
    var imageDataArray = [SCImageModal]()
    var videoImage:UIImage? = nil
    
    var reviewDataArray = [SCUserInfo]()
    
    //Analytics Filter List
    var statusArray = [SCUserInfo]()
    var compaignArray = [SCUserInfo]()
    
    var dataArray = [SCUserInfo]()
    var filterArray = [SCUserInfo]()
    
    var fromDate = ""
    var toDate = ""
    var lat = ""
    var lng = ""
    var location = ""
    var addressId = ""
    
    
    //MARK:- Business Profile
    class func modelFromBusinessProfileDict(_ infoDict:Dictionary<String, AnyObject>) -> SCUserInfo {
        let obj = SCUserInfo()
        obj.fullName = "\(infoDict.validatedValue(cBusinessName, expected: "" as AnyObject)as! String)"
        obj.userName = "\(infoDict.validatedValue(cUserName, expected: "" as AnyObject)as! String)"
        obj.fax = "\(infoDict.validatedValue(cFax, expected: "" as AnyObject)as! String)"
        obj.emailID = "\(infoDict.validatedValue(cEmail, expected: "" as AnyObject)as! String)"
        obj.dob = "\(infoDict.validatedValue(cDob, expected: "" as AnyObject)as! String)"
        obj.mobileCode = "\(infoDict.validatedValue(cCountryCode, expected: "" as AnyObject)as! String)"
        obj.mobile = "\(infoDict.validatedValue(cMobile, expected: "" as AnyObject)as! String)"
        obj.gender = "\(infoDict.validatedValue(cGender, expected: "" as AnyObject)as! String)"
        obj.userImageString = "\(infoDict.validatedValue("business_logo", expected: "" as AnyObject)as! String)"
        obj.backgroundImageString = "\(infoDict.validatedValue(cBackGroundImage, expected: "" as AnyObject)as! String)"
        obj.splittCount = "\(infoDict.validatedValue(cSplittCount, expected: "" as AnyObject)as! String)"
        obj.followerCount = "\(infoDict.validatedValue(cFollowerCount, expected: "" as AnyObject)as! String)"
        obj.followingCount = "\(infoDict.validatedValue(cFollowingCount, expected: "" as AnyObject)as! String)"
        obj.groupCount = "\(infoDict.validatedValue(cGroupCount, expected: "" as AnyObject)as! String)"
        obj.rewardCount = "\(infoDict.validatedValue(cUserRewards, expected: "" as AnyObject)as! String)"
        obj.isFollow = "\(infoDict.validatedValue(cFollowerStatus, expected: "" as AnyObject)as! String)" == "1" ? true : false
        obj.bio = "\(infoDict.validatedValue(cBioData, expected: "" as AnyObject)as! String)"
        obj.businessCategory = "\(infoDict.validatedValue(cBusinessCategory, expected: "" as AnyObject)as! String)"
        obj.websiteAddress = "\(infoDict.validatedValue(cWebsiteInfo, expected: "" as AnyObject)as! String)"
        obj.facebookAddress = "\(infoDict.validatedValue(cFbLink, expected: "" as AnyObject)as! String)"
        obj.instagramAddress = "\(infoDict.validatedValue(cInstaLink, expected: "" as AnyObject)as! String)"
        obj.linkedinAddress = "\(infoDict.validatedValue(cLinkedinLink, expected: "" as AnyObject)as! String)"
        obj.twitterAddress = "\(infoDict.validatedValue(cTwitterLink, expected: "" as AnyObject)as! String)"
        obj.referenceAddress = "\(infoDict.validatedValue(cReferalType, expected: "" as AnyObject)as! String)"
        let operationArray = infoDict.validatedValue(cOperationDays, expected: NSArray())as! [Dictionary<String,AnyObject>]
        let imageArray = infoDict.validatedValue(cBusinessImages, expected: NSArray())as! [Dictionary<String,AnyObject>]
        let locationArray = infoDict.validatedValue(cAddress, expected: NSArray())as! [Dictionary<String,AnyObject>]
        
        obj.addressArray = parseAddress(locationArray)
        
        let reviewArray = infoDict.validatedValue("reviewData", expected: NSArray())as! [Dictionary<String,AnyObject>]
        
        for dict in reviewArray {
            let tempObj = SCUserInfo()
            tempObj.userName = "\(dict.validatedValue(cUserName, expected: "" as AnyObject)as! String)"
            tempObj.userImageString = "\(dict.validatedValue(pUserImage, expected: "" as AnyObject)as! String)"
            tempObj.review = "\(dict.validatedValue("review", expected: "" as AnyObject)as! String)"
            tempObj.rating = "\(dict.validatedValue("rating", expected: "" as AnyObject)as! String)" == "" ? "0" : "\(dict.validatedValue("rating", expected: "" as AnyObject)as! String)"
            tempObj.fullName = "\(dict.validatedValue("fullname", expected: "" as AnyObject)as! String)"
            
            obj.reviewDataArray.append(tempObj)
        }
        
        for dict in imageArray {
            let tempObj = SCUserInfo()
            tempObj.userImageString = "\(dict.validatedValue(cImages, expected: "" as AnyObject)as! String)"
            tempObj.imageId = "\(dict.validatedValue(cImageId, expected: "" as AnyObject)as! String)"
            obj.storeImageArray.append(tempObj)
        }
        obj.operationHours = parseOperationDay(operationArray)
        
        return obj
    }
    
    
    //MARK:- User Profile
    class func modelFromAnalyticsAddress(_ infoDict:Dictionary<String, AnyObject>) -> SCUserInfo {
        let obj = SCUserInfo()
        obj.cityName = "\(infoDict.validatedValue(cCity, expected: "" as AnyObject)as! String)"
        obj.addressCount = infoDict.validatedValue(cCount, expected: 0 as AnyObject) as! Int
        return obj
    }
    
    
    
    //MARK:- User Profile
    class func modelFromUserProfileDict(_ infoDict:Dictionary<String, AnyObject>) -> SCUserInfo {
        let obj = SCUserInfo()
        obj.fullName = "\(infoDict.validatedValue(cFullName, expected: "" as AnyObject)as! String)"
        obj.userName = "\(infoDict.validatedValue(cUserName, expected: "" as AnyObject)as! String)"
        obj.emailID = "\(infoDict.validatedValue(cEmail, expected: "" as AnyObject)as! String)"
        obj.dob = "\(infoDict.validatedValue(cDob, expected: "" as AnyObject)as! String)"
        obj.mobileCode = "\(infoDict.validatedValue(cCountryCode, expected: "" as AnyObject)as! String)"
        obj.mobile = "\(infoDict.validatedValue(cMobile, expected: "" as AnyObject)as! String)"
        obj.gender = "\(infoDict.validatedValue(cGender, expected: "" as AnyObject)as! String)"
        obj.userImageString = "\(infoDict.validatedValue(cUserImage, expected: "" as AnyObject)as! String)"
        obj.backgroundImageString = "\(infoDict.validatedValue(cBackGroundImage, expected: "" as AnyObject)as! String)"
        obj.splittCount = "\(infoDict.validatedValue(cSplittCount, expected: "" as AnyObject)as! String)"
        obj.followerCount = "\(infoDict.validatedValue(cFollowerCount, expected: "" as AnyObject)as! String)"
        obj.followingCount = "\(infoDict.validatedValue(cFollowingCount, expected: "" as AnyObject)as! String)"
        obj.groupCount = "\(infoDict.validatedValue(cGroupCount, expected: "" as AnyObject)as! String)"
        obj.rewardCount = "\(infoDict.validatedValue(cUserRewardCount, expected: "" as AnyObject)as! String)"
        obj.isFollow = "\(infoDict.validatedValue(cFollowerStatus, expected: "" as AnyObject)as! String)" == "1" ? true : false
        
        return obj
    }
    
    
    class func parseOperationDay(_ infoArray:[Dictionary<String, AnyObject>]) -> [SCUserInfo] {
        var operationArray = [SCUserInfo]()
        for dict in infoArray {
            let obj = SCUserInfo()
            obj.day = "\(dict.validatedValue(cDay, expected: "" as AnyObject)as! String)"
            obj.openTime = "\(dict.validatedValue(cStartTime, expected: "" as AnyObject)as! String)"
            obj.closeTime = "\(dict.validatedValue(cEndTime, expected: "" as AnyObject)as! String)"
            obj.isSelect = "\(dict.validatedValue(cIsSelect, expected: "" as AnyObject)as! String)" == "true" ? true : false
            operationArray.append(obj)
        }
        return operationArray
    }
    
    
    class func parseAddress(_ infoArray:[Dictionary<String, AnyObject>]) -> [SCUserInfo] {
        var addressArray = [SCUserInfo]()
        for dict in infoArray {
            let obj = SCUserInfo()
            obj.userId = "\(dict.validatedValue(cUserId, expected: "" as AnyObject)as! String)"
            obj.lat = "\(dict.validatedValue(cLatitude, expected: "" as AnyObject)as! String)" == "" ? "0" : "\(dict.validatedValue(cLatitude, expected: "" as AnyObject)as! String)"
            obj.lng = "\(dict.validatedValue(cLongitude, expected: "" as AnyObject)as! String)" == "" ? "0" : "\(dict.validatedValue(cLongitude, expected: "" as AnyObject)as! String)"
            obj.location = "\(dict.validatedValue(cLocation, expected: "" as AnyObject)as! String)"
            obj.addressId = "\(dict.validatedValue(cId, expected: "" as AnyObject)as! String)"
            addressArray.append(obj)
        }
        return addressArray
    }
    
    
    //MARK:- Get Business Location
    class func modelFromBusinessLocationArray(_ infoArray:[Dictionary<String, AnyObject>]) -> [SCUserInfo] {
        
        var locationArray = [SCUserInfo]()
        
        for dict in infoArray {
            let obj = SCUserInfo()
            obj.location = "\(dict.validatedValue(cLocationName, expected: "" as AnyObject))"
            obj.addressId = "\(dict.validatedValue(cLocationID, expected: "" as AnyObject))"
            locationArray.append(obj)
        }
        return locationArray
    }
    
    
    
    //MARK:- Get Business Category
    class func modelFromBusinessCategoryDict(_ infoDict:Dictionary<String, AnyObject>) -> SCUserInfo {
        let obj = SCUserInfo()
        obj.categoryName = "\(infoDict.validatedValue(cCategoryName, expected: "" as AnyObject))"
        obj.categoryId = "\(infoDict.validatedValue(cCategoryId, expected: "" as AnyObject))"
        obj.saveStatus = "\(infoDict.validatedValue(cSaveStatus, expected: "" as AnyObject))"
        obj.isSelect = "\(infoDict.validatedValue(cSaveStatus, expected: "" as AnyObject))" == "1" ? true : false
        
        obj.isSelectWhenCreate = false
        
        obj.answerType = "\(infoDict.validatedValue(cQuestionDetail, expected: "" as AnyObject))"
        let detailDict = infoDict.validatedValue(cQuestionDetail, expected: NSDictionary()) as! Dictionary<String,AnyObject>
        obj.questionId = "\(detailDict.validatedValue(cQuestionId, expected: "" as AnyObject))"
        obj.userId = "\(detailDict.validatedValue(cUserID, expected: "" as AnyObject))"
        obj.questionNameYes = "\(detailDict.validatedValue(cQuestionNameYes, expected: "" as AnyObject))"
        obj.questionNameNo = "\(detailDict.validatedValue(cQuestionNameNo, expected: "" as AnyObject))"
        obj.questionTitle = "\(detailDict.validatedValue(cTitleQuestion, expected: "" as AnyObject))"
        obj.questionTitleName = "\(detailDict.validatedValue(cTitleName, expected: "" as AnyObject))"
        obj.splittAnswerA = "\(detailDict.validatedValue(cQuestionOne, expected: "" as AnyObject))"
        obj.splittAnswerB = "\(detailDict.validatedValue(cQuestionTwo, expected: "" as AnyObject))"
        obj.splittAnswerC = "\(detailDict.validatedValue(cQuestionThree, expected: "" as AnyObject))"
        obj.splittAnswerD = "\(detailDict.validatedValue(cQuestionFour, expected: "" as AnyObject))"
        obj.splittAnswerE = "\(detailDict.validatedValue(cQuestionFive, expected: "" as AnyObject))"
        obj.answerAn = "\(detailDict.validatedValue(cAnswerAn, expected: "" as AnyObject))"
        obj.answerBn = "\(detailDict.validatedValue(cAnswerBn, expected: "" as AnyObject))"
        obj.answerCn = "\(detailDict.validatedValue(cAnswerCn, expected: "" as AnyObject))"
        obj.answerDn = "\(detailDict.validatedValue(cAnswerDn, expected: "" as AnyObject))"
        
        if Int(obj.categoryId)! <= 3 {
            obj.splittAnswerA = "\(detailDict.validatedValue(cAnswerAy, expected: "" as AnyObject))"
            obj.splittAnswerB = "\(detailDict.validatedValue(cAnswerBy, expected: "" as AnyObject))"
            obj.splittAnswerC = "\(detailDict.validatedValue(cAnswerCy, expected: "" as AnyObject))"
            obj.splittAnswerD = "\(detailDict.validatedValue(cAnswerDy, expected: "" as AnyObject))"
        }
        
        obj.timeline = "\(detailDict.validatedValue(cTimeline, expected: "" as AnyObject))"
        
        obj.isAnonymous = "\(detailDict.validatedValue(cIsProAnonymous, expected: "" as AnyObject))" == "1" ? true : false
        
        return obj
    }
    
    
    
    
    //
    class func modelFromCustomAnalyticsDict(_ infoDict:Dictionary<String, AnyObject>) -> SCUserInfo {
        let obj = SCUserInfo()
        
        obj.fullName = "\(infoDict.validatedValue(cFullName, expected: "" as AnyObject))"
        obj.userId = "\(infoDict.validatedValue(cUserId, expected: "" as AnyObject))"
        obj.userName = "\(infoDict.validatedValue(cUserName, expected: "" as AnyObject))"
        obj.userImageString = "\(infoDict.validatedValue(pUserImage, expected: "" as AnyObject))"
        obj.isSelect = false
        obj.emailID = "\(infoDict.validatedValue(cEmail, expected: "" as AnyObject))"
        obj.facebookAddress = "\(infoDict.validatedValue(cFbLink, expected: "" as AnyObject))"
        obj.instagramAddress = "\(infoDict.validatedValue(cInstaLink, expected: "" as AnyObject))"
        obj.linkedinAddress = "\(infoDict.validatedValue(cLinkedinLink, expected: "" as AnyObject))"
        obj.twitterAddress = "\(infoDict.validatedValue(cTwitterLink, expected: "" as AnyObject))"
        obj.websiteAddress = "\(infoDict.validatedValue(cWebsiteInfo, expected: "" as AnyObject))"
        obj.dob = "\(infoDict.validatedValue(cDob, expected: "" as AnyObject))"
        obj.mobileCode = "\(infoDict.validatedValue(cCountryCode, expected: "" as AnyObject))"
        obj.mobile = "\(infoDict.validatedValue(cMobile, expected: "" as AnyObject))"
        obj.answer = "\(infoDict.validatedValue(cAnswer, expected: "" as AnyObject))"
        obj.redeem = "\(infoDict.validatedValue(cRedeem, expected: "" as AnyObject))"
        return obj
    }
    
    
    //MARK:- Followers List
    class func modelFromFollowersDict(_ infoDict:Dictionary<String, AnyObject>) -> SCUserInfo {
        let obj = SCUserInfo()
        obj.fullName = "\(infoDict.validatedValue(cFollowerName, expected: "" as AnyObject))"
        obj.userId = "\(infoDict.validatedValue(cFollowerId, expected: "" as AnyObject))"
        obj.roleType = "\(infoDict.validatedValue(cFollowerRole, expected: "" as AnyObject))"
        obj.userImageString = "\(infoDict.validatedValue(cFollowerImage, expected: "" as AnyObject))"
        obj.isSelect = false
        return obj
    }
    
    
    class func modelFromFollowerUserDict(_ infoDict:Dictionary<String, AnyObject>) -> SCUserInfo {
        let obj = SCUserInfo()
        obj.fullName = "\(infoDict.validatedValue(cFullName, expected: "" as AnyObject))"
        obj.userId = "\(infoDict.validatedValue(cUserId, expected: "" as AnyObject))"
        obj.roleType = "\(infoDict.validatedValue(cRoleType, expected: "" as AnyObject))"
        obj.userImageString = "\(infoDict.validatedValue("userimage", expected: "" as AnyObject))"
        obj.isSelect = false
        return obj
    }
    
    //MARK:- Following List
    class func modelFromFollowingDict(_ infoDict:Dictionary<String, AnyObject>) -> SCUserInfo {
        let obj = SCUserInfo()
        obj.fullName = "\(infoDict.validatedValue(cFollowingName, expected: "" as AnyObject))"
        obj.userId = "\(infoDict.validatedValue(cFollowingId, expected: "" as AnyObject))"
        obj.roleType = "\(infoDict.validatedValue(cFollowingRole, expected: "" as AnyObject))"
        obj.userImageString = "\(infoDict.validatedValue(cFollowingImage, expected: "" as AnyObject))"
        return obj
    }
    
    //MARK:- Group List
    class func modelFromGroupDict(_ infoDict:Dictionary<String, AnyObject>) -> SCUserInfo {
        let obj = SCUserInfo()
        obj.fullName = "\(infoDict.validatedValue(cGroupName, expected: "" as AnyObject))"
        obj.userId = "\(infoDict.validatedValue(cGroupCreatedBy, expected: "" as AnyObject))"
        obj.groupId = "\(infoDict.validatedValue(cGroupId, expected: "" as AnyObject))"
        obj.userImageString = "\(infoDict.validatedValue(cGroupImage, expected: "" as AnyObject))"
        return obj
    }
    
    //MARK:- Reward List
    class func modelFromRewardDict(_ infoDict:Dictionary<String, AnyObject>) -> SCUserInfo {
        let obj = SCUserInfo()
        obj.rewardId = "\(infoDict.validatedValue(cId, expected: "" as AnyObject))"
        obj.rewardTitle = "\(infoDict.validatedValue(cRewardName, expected: "" as AnyObject))"
        return obj
    }
    
    
    class func modelSplittDetailDict(_ infoDict:Dictionary<String, AnyObject>) -> SCUserInfo {
        
        let obj = SCUserInfo()
        obj.proSplittId = "\(infoDict.validatedValue(cCategoryId, expected: "" as AnyObject))"
        obj.typeSplitt = "\(infoDict.validatedValue(pSplittDescription, expected: "" as AnyObject))"
        
        obj.textOrVideo = "\(infoDict.validatedValue(pSplittType, expected: "" as AnyObject))"
        obj.isPublic = "\(infoDict.validatedValue(cSplittVisibility, expected: "" as AnyObject))" == "0" ? true : false
        obj.radius = "\(infoDict.validatedValue(cSplittRadius, expected: "" as AnyObject))"
        obj.selectedFollowersId = "\(infoDict.validatedValue(cBusinessVisibilityType, expected: "" as AnyObject))"
        obj.timelineId = "\(infoDict.validatedValue(cTimelineId, expected: "" as AnyObject))"
        obj.timeline = "\(infoDict.validatedValue("timeline_value", expected: "" as AnyObject))"
        
        obj.splittAnswerType = "\(infoDict.validatedValue(pAnswerType, expected: "" as AnyObject))"
        obj.splittAnswerA = "\(infoDict.validatedValue(pAnswerA, expected: "" as AnyObject))"
        obj.splittAnswerB = "\(infoDict.validatedValue(pAnswerB, expected: "" as AnyObject))"
        obj.splittAnswerC = "\(infoDict.validatedValue(pAnswerC, expected: "" as AnyObject))"
        obj.splittAnswerD = "\(infoDict.validatedValue(pAnswerD, expected: "" as AnyObject))"
        obj.selectedFollowersId = "\(infoDict.validatedValue(cSplittVisibilityId, expected: "" as AnyObject))"
        obj.addressId = "\(infoDict.validatedValue(cLocationID, expected: "" as AnyObject))"
        obj.isFuture = "\(infoDict.validatedValue(cFutureSplitt, expected: "" as AnyObject))" == "1" ? true : false
        obj.isPhotoOption = "\(infoDict.validatedValue(pPhotoAnswerType, expected: "" as AnyObject))" == "1" ? true : false
        obj.selectedDate = "\(infoDict.validatedValue(cFutureDate, expected: "" as AnyObject))"
        obj.rewardId = "\(infoDict.validatedValue(cRewardType, expected: "" as AnyObject))"
        obj.expireDate = "\(infoDict.validatedValue(cRewardExpireTime, expected: "" as AnyObject))"
        obj.selectedFollowersId = "\(infoDict.validatedValue(cSplittVisibilityId, expected: "" as AnyObject))"
        
        let splittMediaone = infoDict.validatedValue(cSplittMediaOne, expected: "" as AnyObject) as! String
        let splittMediatwo = infoDict.validatedValue(cSplittMediaTwo, expected: "" as AnyObject) as! String
        let splittMediathree = infoDict.validatedValue(cSplittMediaThree, expected: "" as AnyObject) as! String
        let splittMediaFour = infoDict.validatedValue(cSplittMediaFour, expected: "" as AnyObject) as! String
        
        obj.rewardTerms = "\(infoDict.validatedValue(cRewardCondition, expected: "" as AnyObject))"
        
        return obj
    }
    
    
    class func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
    
    
    
    //MARK:- Reward List
    class func modelFromUserListDict(_ infoDict:Dictionary<String, AnyObject>) -> SCUserInfo {
        let obj = SCUserInfo()
        obj.fullName = "\(infoDict.validatedValue(cFullName, expected: "" as AnyObject))"
        obj.userId = "\(infoDict.validatedValue(cUserId, expected: "" as AnyObject))"
        obj.roleType = "\(infoDict.validatedValue(cRoleType, expected: "" as AnyObject))"
        obj.userImageString = "\(infoDict.validatedValue(cUserImage, expected: "" as AnyObject))"
        obj.isBlock = "\(infoDict.validatedValue(cIsBlock, expected: "" as AnyObject))" == "0" ? false : true
        obj.isFollow = "\(infoDict.validatedValue(cIsFollow, expected: "" as AnyObject))" == "1" ? true : false
        return obj
    }
    
    //MARK:- Timeline List
    class func modelFromTimelineDict(_ infoDict:Dictionary<String, AnyObject>) -> SCUserInfo {
        let obj = SCUserInfo()
        obj.timeline = "\(infoDict.validatedValue(cTimelineName, expected: "" as AnyObject))"
        obj.timelineId = "\(infoDict.validatedValue(cTimelineId, expected: "" as AnyObject))"
        return obj
    }
    
    
    
    //MARK:- Filter Category
    class func modelFromFilterDict(_ infoDict:Dictionary<String, AnyObject>) -> SCUserInfo {
        
        let obj = SCUserInfo()
        
        obj.filterTitle = "Relationship"
        obj.isSelect = true
        obj.filterID = "1"
        
        return obj
    }
    
    //MARK:- Category
    class func modelFromCategoryDict(_ infoDict:Dictionary<String, AnyObject>) -> SCUserInfo {
        let obj = SCUserInfo()
        
        obj.proSplittCategoryName = "\(infoDict.validatedValue(cCategoryName, expected: "" as AnyObject))"
        obj.isSelect = true
        obj.categoryId = "\(infoDict.validatedValue(cCategoryId, expected: "" as AnyObject))"
        obj.roleType = "\(infoDict.validatedValue(cType, expected: "" as AnyObject))"
        
        return obj
    }
    
    
    
    //MARK:- Analytics Filter List
    class func modelFromAnalyticsFilterDict(_ infoDict:Dictionary<String, AnyObject>) -> SCUserInfo {
        let obj = SCUserInfo()
        let statusArray = infoDict.validatedValue("statusArray", expected: [Dictionary<String, AnyObject>]() as AnyObject) as! [Dictionary<String, AnyObject>]
        
        for dict in statusArray {
            let tempObj = SCUserInfo()
            tempObj.categoryName = "\(dict.validatedValue("title", expected: "" as AnyObject))"
            tempObj.categoryId = "\(dict.validatedValue("id", expected: "" as AnyObject))"
            tempObj.isSelectWhenCreate = false
            obj.statusArray.append(tempObj)
        }
        return obj
    }
}

