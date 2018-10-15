
//
//  SCHomeInfo.swift
//  SplittConsumer
//
//  Created by Vishal Mandhyan on 24/07/18.
//  Copyright © 2018 Deepak. All rights reserved.
//

import UIKit

class SCHomeInfo: NSObject {
    
    //HomeVC
    var splittCategory = ""
    var questionArray = [SCHomeInfo]()
    var question = ""
    var answerType = ""
    var daysLeft = ""
    var time = ""
    var offer = ""
    var viewCount = ""
    var likeCount = ""
    var isLike = Bool()
    var isSurvey = Bool()
    var commentCount = ""
    var answerCount = ""
    var name = ""
    var reviewDescription = ""
    var headingLabel = ""
    var isSelect = Bool()
    var isAnswered = Bool()
    var currentIndex = 0
    
    var strNo = ""
    var strYes = ""
    var selectedAnswer = ""
    
    var yesCount = ""
    var noCount = ""
    var isSelectYes = Bool()
    var isSelectNo = Bool()
    
    var isStronglyDisagree = Bool()
    var isDisagree = Bool()
    var isNeutral = Bool()
    var isAgree = Bool()
    var isStronglyAgree = Bool()
    var starCount = Int()
    
    var yesNoIndex = Int()
    var likertIndex = Int()
    
    
    var strDisagree = ""
    var strNuetral = ""
    var strAgree = ""
    var strStronglyAgree = ""
    var strStronglyDisAgree = ""
    
    
    var title = ""
    var commentDescription = ""
    
    var surveyZeroArray = [SCHomeInfo]()
    var surveyOneArray = [SCHomeInfo]()
    
    //Splitt List Variables
    var rewardID = ""
    var questionTitle = ""
    var timeLineName = ""
    var surveyOne = ""
    var getType = ""
    var finalSplittDecision = ""
    var isAnswerComplete = ""
    var rewardNameAnalytics = ""
    var splittCreatedAt = ""
    var yourAnswer = ""
    var isComment = ""
    var isAnonymousPro = ""
    var surveyZero = ""
    var point = ""
    var isYesNo = ""
    var rewardStatus = ""
    var isView = ""
    var isAnswer = ""
    var time_line_name = ""
    var userimage = ""
    var questionNameNo = ""
    var answer_cn = ""
    var user_id = ""
    var answer_A = ""
    var survey_one = ""
    var answer_dn = ""
    var splitt_media_one = ""
    var splitt_type = ""
    var final_splitt_decision = ""
    var thumbnail = ""
    var answer_B = ""
    var answer_C = ""
    var is_answer_complete = ""
    var answer_D = ""
    var username = ""
    var splitt_title = ""
    var reward = ""
    var comment_status = ""
    var answer_ay = ""
    var rewardName = ""
    var time_left = ""
    var type = ""
    var splitt_created_at = ""
    var answer_by = ""
    var comment_count = ""
    var splitt_media_two = ""
    var your_answer = ""
    var category_name = ""
    var answer_cy = ""
    var is_comment = Bool()
    var is_anonymous_pro = ""
    var selectedIndex = Int()
    
    var q_title_name = ""
    var splitt_media_three = ""
    var splitt_id = ""
    var splitt_description = ""
    var answer_dy = ""
    var is_anonymous = Bool()
    var is_like = Bool()
    var questionNameYes = ""
    var banner_media = ""
    var like_count = ""
    var role_type = ""
    var splitt_media_four = ""
    var survey_zero = ""
    var view_count = ""
    var answer_an = ""
    var is_yes_no = ""
    var reward_status = Bool()
    var is_view = Bool()
    var is_answer = Bool()
    var answer_bn = ""
    var star_two = ""
    var star_four = ""
    var survey_question = ""
    var star_one = ""
    var star_three = ""
    var question_type = ""
    var star_five = ""
    var remainingTime = ""
    var isTimerPopUpShown = Bool()
    var isYesQuestionSelected = false
    var isNoQuestionSelected = false
    
    
    //Notification
    var notificationID = ""
    var notificationTitle = ""
    var notificationUserImage = ""
    var notificationType = ""
    var notificationApprovedStatus = ""
    var groupId = ""
    
    
    var answerOption = ""
    var abcdAnswerOption = ""
    
    //Pending Splitt
    var startDateTime = ""
    var timelineFoVote = ""
    
    //All Answer
    var questionId = ""
    var answerId = ""
    var answer = ""
    var answerArray = [SCHomeInfo]()
    var answerTwoArray = [SCHomeInfo]()
    var answerAnalyticsArray = [String]()
    var splitYesAnswerArray = [String]()
    var splitNoAnswerArray = [String]()
    var proSplittAnswarType = [String]()
    var splitMediaArray = [String]()
    
    
    
    //MARK:- Home List
    class func modelFromAnalyticsDict(_ infoDict:Dictionary<String, AnyObject>) -> SCHomeInfo {
        let obj = SCHomeInfo()
        obj.remainingTime = ""
        obj.isTimerPopUpShown = false
        
        obj.rewardID = "\(infoDict.validatedValue("rewardID", expected: "" as AnyObject))"
        obj.questionTitle = "\(infoDict.validatedValue("question_title", expected: "" as AnyObject))"
        obj.timeLineName = "\(infoDict.validatedValue("time_line_name", expected: "" as AnyObject))"
        obj.userimage = "\(infoDict.validatedValue("userimage", expected: "" as AnyObject))"
        obj.questionNameNo = "\(infoDict.validatedValue("questionNameNo", expected: "" as AnyObject))"
        obj.answer_cn = "\(infoDict.validatedValue("answer_cn", expected: "" as AnyObject))"
        obj.user_id = "\(infoDict.validatedValue("user_id", expected: "" as AnyObject))"
        obj.answer_A = "\(infoDict.validatedValue("answer_A", expected: "" as AnyObject))"
        obj.surveyOne = "\(infoDict.validatedValue("survey_one", expected: "" as AnyObject))"
        obj.answer_dn = "\(infoDict.validatedValue("answer_dn", expected: "" as AnyObject))"
        obj.getType = "\(infoDict.validatedValue("getType", expected: "" as AnyObject))"
        obj.splitt_media_one = "\(infoDict.validatedValue("splitt_media_one", expected: "" as AnyObject))"
        obj.splitt_type = "\(infoDict.validatedValue("splitt_type", expected: "" as AnyObject))"
        obj.finalSplittDecision = "\(infoDict.validatedValue("final_splitt_decision", expected: "" as AnyObject))"
        obj.answerType = "\(infoDict.validatedValue("answer_type", expected: "" as AnyObject))"
        obj.thumbnail = "\(infoDict.validatedValue("thumbnail", expected: "" as AnyObject))"
        obj.answer_B = "\(infoDict.validatedValue("answer_B", expected: "" as AnyObject))"
        obj.answer_C = "\(infoDict.validatedValue("answer_C", expected: "" as AnyObject))"
        obj.answer_D = "\(infoDict.validatedValue("answer_D", expected: "" as AnyObject))"
        obj.isAnswerComplete = "\(infoDict.validatedValue("is_answer_complete", expected: "" as AnyObject))"
        obj.username = "\(infoDict.validatedValue("username", expected: "" as AnyObject))"
        obj.splitt_title = "\(infoDict.validatedValue("splitt_title", expected: "" as AnyObject))"
        obj.reward = "\(infoDict.validatedValue("reward", expected: "" as AnyObject))"
        obj.comment_status = "\(infoDict.validatedValue("comment_status", expected: "" as AnyObject))"
        obj.answer_ay = "\(infoDict.validatedValue("answer_ay", expected: "" as AnyObject))"
        obj.rewardName = "\(infoDict.validatedValue("rewardName", expected: "" as AnyObject))"
        obj.time_left = "\(infoDict.validatedValue("time_left", expected: "" as AnyObject))"
        obj.type = "\(infoDict.validatedValue("type", expected: "" as AnyObject))"
        let createdTimeStamp = infoDict.validatedValue("splitt_created_at", expected: 0.0 as AnyObject) as! Double
        let createDate = NSDate(timeIntervalSince1970: createdTimeStamp)
        obj.splitt_created_at = Date().offsetPop(date: createDate as Date)
        obj.answer_by = "\(infoDict.validatedValue("answer_by", expected: "" as AnyObject))"
        obj.comment_count = "\(infoDict.validatedValue("comment_count", expected: "" as AnyObject))"
        obj.splitt_media_two = "\(infoDict.validatedValue("splitt_media_two", expected: "" as AnyObject))"
        obj.your_answer = "\(infoDict.validatedValue("your_answer", expected: "" as AnyObject))"
        obj.category_name = "\(infoDict.validatedValue("category_name", expected: "" as AnyObject))"
        obj.answer_cy = "\(infoDict.validatedValue("answer_cy", expected: "" as AnyObject))"
        obj.is_comment = infoDict.validatedValue("is_comment", expected: false as AnyObject) as! Bool
        obj.is_anonymous_pro = "\(infoDict.validatedValue("is_anonymous_pro", expected: "" as AnyObject))"
        obj.q_title_name = "\(infoDict.validatedValue("q_title_name", expected: "" as AnyObject))"
        obj.splitt_media_three = "\(infoDict.validatedValue("splitt_media_three", expected: "" as AnyObject))"
        obj.splitt_id = "\(infoDict.validatedValue("splitt_id", expected: "" as AnyObject))"
        obj.splitt_description = "\(infoDict.validatedValue("splitt_description", expected: "" as AnyObject))"
        obj.answer_dy = "\(infoDict.validatedValue("answer_dy", expected: "" as AnyObject))"
        obj.is_anonymous = infoDict.validatedValue("is_anonymous", expected: false as AnyObject) as! Bool
        obj.is_like = infoDict.validatedValue("is_like", expected: false as AnyObject) as! Bool
        obj.questionNameYes = "\(infoDict.validatedValue("questionNameYes", expected: "" as AnyObject))"
        obj.banner_media = "\(infoDict.validatedValue("banner_media", expected: "" as AnyObject))"
        obj.like_count = "\(infoDict.validatedValue("like_count", expected: "" as AnyObject))"
        obj.role_type = "\(infoDict.validatedValue("role_type", expected: "" as AnyObject))"
        obj.splitt_media_four = "\(infoDict.validatedValue("splitt_media_four", expected: "" as AnyObject))"
        obj.survey_zero = "\(infoDict.validatedValue("survey_zero", expected: "" as AnyObject))"
        obj.view_count = "\(infoDict.validatedValue("view_count", expected: "" as AnyObject))"
        obj.answer_an = "\(infoDict.validatedValue("answer_an", expected: "" as AnyObject))"
        obj.point = "\(infoDict.validatedValue("point", expected: "" as AnyObject))"
        obj.is_yes_no = "\(infoDict.validatedValue("is_yes_no", expected: "" as AnyObject))"
        obj.reward_status = infoDict.validatedValue("reward_status", expected: false as AnyObject) as! Bool
        obj.is_view = infoDict.validatedValue("is_view", expected: false as AnyObject) as! Bool
        obj.is_answer = infoDict.validatedValue("is_answer", expected: false as AnyObject) as! Bool
        obj.answer_bn = "\(infoDict.validatedValue("answer_bn", expected: "" as AnyObject))"
        obj.answerCount = "\(infoDict.validatedValue("answer_count", expected: "" as AnyObject))"
        obj.splittCreatedAt = "\(infoDict.validatedValue("splitt_created_at", expected: "" as AnyObject))"
        obj.yourAnswer = "\(infoDict.validatedValue("your_answer", expected: "" as AnyObject))"
        obj.surveyZero = "\(infoDict.validatedValue("survey_zero", expected: "" as AnyObject))"
        obj.isYesNo = "\(infoDict.validatedValue("is_yes_no", expected: "" as AnyObject))"
        
        let surveyTwoArray = infoDict.validatedValue("survey_two", expected: NSArray()) as! [Dictionary<String,AnyObject>]
        let surveyMultipleArray = infoDict.validatedValue("survey_zero", expected:Array<Dictionary<String, Any>>() as AnyObject) as! Array<Dictionary<String, Any>>
        let surveyYesNoArray = infoDict.validatedValue("survey_one", expected:Array<Dictionary<String, Any>>() as AnyObject) as! Array<Dictionary<String, Any>>
        
        obj.selectedIndex = 0
        
        for dict in surveyMultipleArray {
            let tempObj = SCHomeInfo()
            tempObj.question_type = dict.validatedValue("question_type", expected: "" as AnyObject) as! String
            tempObj.survey_question = dict.validatedValue("survey_question", expected: "" as AnyObject) as! String
            tempObj.strStronglyDisAgree = dict.validatedValue("strongly_disagree", expected: "" as AnyObject) as! String
            tempObj.strDisagree = dict.validatedValue("disagree", expected: "" as AnyObject) as! String
            tempObj.strNuetral = dict.validatedValue("nuetral", expected: "" as AnyObject) as! String
            tempObj.strAgree = dict.validatedValue("agree", expected: "" as AnyObject) as! String
            tempObj.strStronglyAgree = dict.validatedValue("strongly_agree", expected: "" as AnyObject) as! String
            obj.surveyZeroArray.append(tempObj)
        }
        
        for dict in surveyYesNoArray {
            let tempYesObj = SCHomeInfo()
            tempYesObj.question_type = dict.validatedValue("question_type", expected: "" as AnyObject) as! String
            tempYesObj.survey_question = dict.validatedValue("survey_question", expected: "" as AnyObject) as! String
            tempYesObj.strYes = dict.validatedValue("Yes", expected: "" as AnyObject) as! String
            tempYesObj.strNo = dict.validatedValue("No", expected: "" as AnyObject) as! String
            obj.surveyOneArray.append(tempYesObj)
        }
        
        
        if(obj.answer_ay.length > 0){
            obj.splitYesAnswerArray.append(String.init(format: "A : %@", obj.answer_ay))
        }
        if(obj.answer_by.length > 0){
            obj.splitYesAnswerArray.append(String.init(format: "B : %@", obj.answer_by))
        }
        if(obj.answer_cy.length > 0){
            obj.splitYesAnswerArray.append(String.init(format: "C : %@", obj.answer_cy))
        }
        if(obj.answer_dy.length > 0){
            obj.splitYesAnswerArray.append(String.init(format: "D : %@", obj.answer_dy))
        }
        if(obj.answer_an.length > 0){
            obj.splitNoAnswerArray.append(String.init(format: "A : %@", obj.answer_an))
        }
        if(obj.answer_bn.length > 0){
            obj.splitNoAnswerArray.append(String.init(format: "B : %@", obj.answer_bn))
        }
        if(obj.answer_cn.length > 0){
            obj.splitNoAnswerArray.append(String.init(format: "C : %@", obj.answer_cn))
        }
        if(obj.answer_dn.length > 0){
            obj.splitNoAnswerArray.append(String.init(format: "D : %@", obj.answer_dn))
        }
        
        obj.proSplittAnswarType = ["Yes", "No"]
        
        if (obj.answerType == "Yes/No"){
            obj.answerAnalyticsArray = ["Yes","No"]
        }else if (obj.answerType == "Multiple Choice  (A,B,C,D)") {
            if(obj.answer_A.length > 0){
                obj.answerAnalyticsArray.append(String.init(format: "A : %@", obj.answer_A))
            }
            if(obj.answer_B.length > 0){
                obj.answerAnalyticsArray.append(String.init(format: "B : %@", obj.answer_B))
            }
            if(obj.answer_C.length > 0){
                obj.answerAnalyticsArray.append(String.init(format: "C : %@", obj.answer_C))
            }
            if(obj.answer_D.length > 0){
                obj.answerAnalyticsArray.append(String.init(format: "D : %@", obj.answer_D))
            }
        }else if (obj.answerType == "") {
            if(obj.splitt_media_one.length > 0){
                obj.answerAnalyticsArray.append(obj.splitt_media_one)
            }
            if(obj.splitt_media_two.length > 0){
                obj.answerAnalyticsArray.append(obj.splitt_media_two)
            }
            if(obj.splitt_media_three.length > 0){
                obj.answerAnalyticsArray.append(obj.splitt_media_three)
            }
            if(obj.splitt_media_four.length > 0){
                obj.answerAnalyticsArray.append(obj.splitt_media_four)
            }
        }
        
        if (obj.type == "pro"){
            obj.answerAnalyticsArray = ["Yes","No"]
        }
        
        for dict in surveyTwoArray {
            let tempObj = SCHomeInfo()
            tempObj.star_two = "\(dict.validatedValue("star_two", expected: "" as AnyObject))"
            tempObj.star_four = "\(dict.validatedValue("star_four", expected: "" as AnyObject))"
            tempObj.survey_question = "\(dict.validatedValue("survey_question", expected: "" as AnyObject))"
            tempObj.star_one = "\(dict.validatedValue("star_one", expected: "" as AnyObject))"
            tempObj.star_three = "\(dict.validatedValue("star_three", expected: "" as AnyObject))"
            tempObj.question_type = "\(dict.validatedValue("question_type", expected: "" as AnyObject))"
            tempObj.star_five = "\(dict.validatedValue("star_five", expected: "" as AnyObject))"
            
            obj.answerTwoArray.append(tempObj)
        }
        return obj
    }
    
    
    //MARK:- Comment
    class func modelFromCommentDict(_ infoDict:Dictionary<String, AnyObject>) -> SCHomeInfo {
        
        let obj = SCHomeInfo()
        obj.name = "\(infoDict.validatedValue(cFullName, expected: "" as AnyObject))"
        obj.role_type = "\(infoDict.validatedValue(cRoleType, expected: "" as AnyObject))"
        obj.user_id = "\(infoDict.validatedValue(cUserId, expected: "" as AnyObject))"
        obj.userimage = "\(infoDict.validatedValue("userimage", expected: "" as AnyObject))"
        obj.commentDescription = "\(infoDict.validatedValue(cComment, expected: "" as AnyObject))"
        let createDate = NSDate(timeIntervalSince1970: infoDict.validatedValue(cCreatedAt, expected: 0.0 as AnyObject) as! Double)
        obj.time_left = Date().offsetPop(date: createDate as Date)
        obj.splitt_id = "\(infoDict.validatedValue(cSplittId, expected: "" as AnyObject))"
        
        return obj
    }
    
    class func modelFromAddCommentDict(_ infoDict:Dictionary<String, AnyObject>) -> SCHomeInfo {
        
        let obj = SCHomeInfo()
        obj.name = "\(infoDict.validatedValue(cFullName, expected: "" as AnyObject))"
        obj.role_type = "\(infoDict.validatedValue(cRoleType, expected: "" as AnyObject))"
        obj.userimage = "\(infoDict.validatedValue("userimage", expected: "" as AnyObject))"
        obj.time_left = "Just Now"
        return obj
    }
    
    //MArk: Answer Data
    class func getAnswerData(responseArray : Array<Dictionary<String, AnyObject>>) -> Array<SCHomeInfo> {
        var rowDataTempArray = [SCHomeInfo]()
        for filterDict in responseArray {
            let filterObject : SCHomeInfo = SCHomeInfo()
            
            filterObject.answerOption = filterDict.validatedValue("answer", expected: "" as AnyObject) as! String
            filterObject.isSelect =  filterDict.validatedValue("status", expected: false as AnyObject) as! Bool
            filterObject.abcdAnswerOption =  filterDict.validatedValue("option", expected: "" as AnyObject) as! String
            rowDataTempArray.append(filterObject)
        }
        return rowDataTempArray
    }
    
    
    //MARK:- Like User
    class func modelFromLikeUserDict(_ infoDict:Dictionary<String, AnyObject>) -> SCHomeInfo {
        
        let obj = SCHomeInfo()
        obj.user_id = "\(infoDict.validatedValue(cUserId, expected: "" as AnyObject))"
        obj.splitt_id = "\(infoDict.validatedValue(cSplittId, expected: "" as AnyObject))"
        obj.name = "\(infoDict.validatedValue(cFullName, expected: "" as AnyObject))"
        obj.role_type = "\(infoDict.validatedValue(cRoleType, expected: "" as AnyObject))"
        obj.userimage = "\(infoDict.validatedValue("userimage", expected: "" as AnyObject))"
        let createDate = NSDate(timeIntervalSince1970: infoDict.validatedValue(cCreatedAt, expected: 0.0 as AnyObject) as! Double)
        obj.time_left = Date().offsetPop(date: createDate as Date)
        
        return obj
    }
    
    //MARK:- Notification
    class func modelFromNotificationDict(_ infoDict:Dictionary<String, AnyObject>) -> SCHomeInfo {
        let obj = SCHomeInfo()
        obj.name = "\(infoDict.validatedValue(cFullName, expected: "" as AnyObject))"
        obj.notificationID = "\(infoDict.validatedValue(cNotificationId, expected: "" as AnyObject))"
        obj.notificationTitle = "\(infoDict.validatedValue(pResponseMessage, expected: "" as AnyObject))"
        obj.notificationUserImage = "\(infoDict.validatedValue(pUserImage, expected: "" as AnyObject))"
        obj.notificationType = "\(infoDict.validatedValue(cType, expected: "" as AnyObject))"
        obj.notificationApprovedStatus = "\(infoDict.validatedValue("approval_status", expected: "" as AnyObject))"
        obj.groupId = "\(infoDict.validatedValue(cGroupId, expected: "" as AnyObject))"
        obj.splitt_id = "\(infoDict.validatedValue("splitt_id", expected: "" as AnyObject))"
        return obj
    }
    
    class func getSurveyYesNoQuestionsList(responseArray: Array<Dictionary<String, Any>>) -> Array<SCHomeInfo> {
        var resultArray = [SCHomeInfo]()
        
        for dict in responseArray {
            let obj = SCHomeInfo()
            obj.question_type = dict.validatedValue("question_type", expected: "" as AnyObject) as! String
            obj.survey_question = dict.validatedValue(cQuestion, expected: "" as AnyObject) as! String
            obj.yesCount = dict.validatedValue("Yes", expected: "" as AnyObject) as! String
            obj.noCount = dict.validatedValue("No", expected: "" as AnyObject) as! String
            resultArray.append(obj)
        }
        return resultArray
    }
    
    
    class func getSurveyQuestionsList(responseArray: Array<Dictionary<String, Any>>) -> Array<SCHomeInfo> {
        var resultArray = [SCHomeInfo]()
        
        for dict in responseArray {
            let obj = SCHomeInfo()
            obj.question_type = dict.validatedValue("question_type", expected: "" as AnyObject) as! String
            obj.strStronglyDisAgree = dict.validatedValue(cStronglyDisAgree, expected: "" as AnyObject) as! String
            obj.strDisagree = dict.validatedValue(cDisagree, expected: "" as AnyObject) as! String
            obj.strNuetral = dict.validatedValue(cNeutral, expected: "" as AnyObject) as! String
            obj.survey_question = dict.validatedValue(cQuestion, expected: "" as AnyObject) as! String
            obj.strAgree = dict.validatedValue(cAgree, expected: "" as AnyObject) as! String
            obj.strStronglyAgree = dict.validatedValue(cStronglyAgree, expected: "" as AnyObject) as! String
            resultArray.append(obj)
        }
        return resultArray
    }
    
    
    class func getSurveyRatingQuestionsList(responseArray: Array<Dictionary<String, Any>>) -> Array<SCHomeInfo> {
        var resultArray = [SCHomeInfo]()
        
        for dict in responseArray {
            let tempObj = SCHomeInfo()
            tempObj.star_two = "\(dict.validatedValue("star_two", expected: "" as AnyObject))"
            tempObj.star_four = "\(dict.validatedValue("star_four", expected: "" as AnyObject))"
            tempObj.survey_question = "\(dict.validatedValue("survey_question", expected: "" as AnyObject))"
            tempObj.star_one = "\(dict.validatedValue("star_one", expected: "" as AnyObject))"
            tempObj.star_three = "\(dict.validatedValue("star_three", expected: "" as AnyObject))"
            tempObj.question_type = "\(dict.validatedValue("question_type", expected: "" as AnyObject))"
            tempObj.star_five = "\(dict.validatedValue("star_five", expected: "" as AnyObject))"
            resultArray.append(tempObj)
        }
        return resultArray
    }
    
}
