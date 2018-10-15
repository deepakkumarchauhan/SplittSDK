//
//  CAPaginationInfo.swift
//  CoreApp
//
//  Created by apple on 5/14/18.
//  Copyright © 2018 WonderPillars. All rights reserved.
//

import UIKit

class CAPaginationInfo: NSObject {
    var pageNumber = String()
    var totalPages = String()
    var isLoadMoreExecuting = Bool()

    class func getPaginationData(_ infoDict:Dictionary<String, AnyObject>?) -> CAPaginationInfo {
        let obj = CAPaginationInfo()
        
        obj.pageNumber = "\((infoDict?.validatedValue(PageNumber, expected: "" as AnyObject))!)"
        obj.totalPages = "\((infoDict?.validatedValue(MaxSize, expected: "" as AnyObject))!)"
        return obj
    }
}
