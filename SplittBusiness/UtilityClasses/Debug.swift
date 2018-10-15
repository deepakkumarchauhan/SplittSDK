//
//  Splitt
//
//  Created by Deepali Gupta on 20/02/18.
//  Copyright © 2018 Mobiloitte. All rights reserved.
//

import UIKit

// Logger for debug

final class Debug {
    
    static var isEnabled = true
    
    static func log(_ msg: @autoclosure () -> String = "", _ file: @autoclosure () -> String = #file, _ line: @autoclosure () -> Int = #line, _ function: @autoclosure () -> String = #function) {
        if isEnabled {
            let fileName = file().components(separatedBy: "/").last ?? ""
            print("[Debug] [\(fileName):\(line())]🍀🍀🍀: \(function()) \(msg())")
        }
    }
}
