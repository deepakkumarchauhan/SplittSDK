//
//  SImageModal.swift
//  Splitt
//
//

import UIKit

class SCImageModal: NSObject {
    
    var indexNumber = "999"
    var image = UIImage()
    var imageURL = ""
    
    // Make Dummy Data for image answer type splitt.
    class func addDummyImages() -> [SCImageModal] {
        
        var tempArray = [SCImageModal]()
        
        for _ in 0...3 {
            let object = SCImageModal()
            
            object.indexNumber = "999"
            object.image = UIImage.init(named: "image_placeholder")!
            object.imageURL = ""
            tempArray.append(object)
        }
        return tempArray
    }
    
}

