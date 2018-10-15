

//
import UIKit
import SystemConfiguration
typealias ServiceComplitionClouser = (Dictionary<String,AnyObject>?, UInt16?, Error?) -> Void

// Local URL
let stagingURL = "http://othtest.com/splitt_sdk_admin/public/api/v2/"
//let stagingURL = "http://wonderpillars.in/coreapp/public/api/"
// Staging URL
//let stagingURL = "http://ec2-52-74-218-145.ap-southeast-1.compute.amazonaws.com:3001/"
// Production URL
//let stagingURL = "http://ec2-35-171-79-65.compute-1.amazonaws.com:8000/"
let timeoutInterval:Double = 45

enum loadingIndicatorType: CGFloat {
    
    case `default`  = 0 // showing indicator & text by disable UI
    case simple  = 1 // // showing indicator only by disable UI
    case noProgress  = 2 // without indicator by disable UI
    case smoothProgress  = 3 // without indicator by enable UI i.e No hud
}

enum MethodType: CGFloat {
    case get  = 0
    case post  = 1
    case put  = 2
    case delete  = 3
    case patch  = 4
    
}


class CAServiceHelper: NSObject {
    var completionClouser :ServiceComplitionClouser?
    let bgView = UIView()
    
    let animationView = RPLoadingAnimationView(
        frame: CGRect(origin: CGPoint(x: UIScreen.main.bounds.size.width*0.4,y: UIScreen.main.bounds.size.height*0.5), size: CGSize(width: 80, height: 80)),
        type: .lineScale,
        colors: [UIColor.orange, UIColor.yellow, UIColor.white],
        size: CGSize(width: 80, height: 80)
    )
    
    class var sharedServiceHelper: CAServiceHelper {
        struct Static {
            static let serviceInstance: CAServiceHelper = CAServiceHelper()
        }
        return Static.serviceInstance
    }

    //MARK:- Public Functions >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
    
     func request(_ parameterDict: [String: Any], method: MethodType, apiName: String, hudType: loadingIndicatorType, completionBlock: @escaping (AnyObject?, Error?, Int) -> Void) ->Void {
        
        print("\n\n Request Parameters >>>>>>\n\(parameterDict.toJsonString())")
        
        if !(self.checkReachablility()) {
            _ =   AlertController.alert("Connection Error!", message: "Internet connection appears to be offline. Please check your internet connection.")
            return
        }

        //>>>>>>>>>>> create request
        let url = CAServiceHelper.requestURL(method, apiName: apiName, parameterDict: parameterDict)
        
        var request = URLRequest(url: url)
        request.httpMethod = CAServiceHelper.methodName(method)
        request.timeoutInterval = timeoutInterval
        
        let jsonData = CAServiceHelper.body(method, parameterDict: parameterDict)
        request.httpBody = jsonData
        
        if method == .post  || method == .put || method == .patch || method == .delete {
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        } else {
            request.setValue("application/json", forHTTPHeaderField: "Accept")
            request.httpBody = nil
        }
        
        //  request.setValue("application/pricise.com; version=1", forHTTPHeaderField: "Accept")
        if UserDefaults.standard.value(forKey: "token") != nil {
            
            let additionString = "Bearer \(UserDefaults.standard.value(forKey: "token") ?? "")"
            request.setValue(additionString, forHTTPHeaderField: "Authorization")
            
        }
        
        request.perform(hudType: hudType) { (responseObject: AnyObject?, error: Error?, httpResponse: HTTPURLResponse) in
            
            DispatchQueue.main.async(execute: {
                
                if let response = responseObject as? Dictionary<String, AnyObject> {
                    print("\n\n Response >>>>>>\n\(response.toJsonString())")
                }
                
                if(httpResponse.statusCode == 500)
                {
                    completionBlock(nil, error, httpResponse.statusCode)
                   // NSUSERDEFAULT.removeObject(forKey: "token")
                    _ =  AlertController.alert("500", message:"Unauthorized request. Please try again.", controller: (UIApplication.shared.keyWindow?.rootViewController)!, buttons: ["Ok"]) { (action, index) in
                        if(index == 0){
                        }
                    }
                    
                }else{
                    completionBlock(responseObject, error, httpResponse.statusCode)
                }
                
            })
        }
    }
    
    
    //MARK: - multipart body creation methods for multiple type data or string
    func createRequestToUploadMultipleData(dataArray : Array<Dictionary<String,Any>>,methodType:String,apiName:String, clouser:@escaping ServiceComplitionClouser)  -> Void {
        
        if self.checkReachablility() {
            DispatchQueue.main.async(execute: {
              _ = AlertController.alert("", message: "No internet connection.")
            })
            clouser(nil, UInt16(0),NSError.init(domain: "Deepak.CoreApp", code: 0, userInfo: nil))
            return
        }
        self.showHud()
        
        var stringURL = stagingURL
        stringURL.append(apiName)
       // logInfo("Request URL =\(stringURL)")
        let request = NSMutableURLRequest(url:URL(string: stringURL)!)
        request.httpMethod = methodType
        
        //        if let devToken = UserDefaults.standard.value(forKey: kDeviceToken) as? String  {
        //            request.addValue(devToken , forHTTPHeaderField: "devicetoken")
        //        }
        
        if UserDefaults.standard.value(forKey: "token") != nil {
            let additionString = "Bearer \(UserDefaults.standard.value(forKey: "token") ?? "")"
            request.setValue(additionString, forHTTPHeaderField: "Authorization")
            
        }
        
        let boundary = "Boundary-\(UUID().uuidString)"
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        request.httpBody = createMultipleBody(arrValue: dataArray, boundary: boundary)
        
        // Excute HTTP Request
        let task = URLSession.shared.dataTask(with: request as URLRequest) {
            data, response, error in
            
            if response != nil {
                self.stopHudAnimation()

                let code =  response as!  HTTPURLResponse
                // Check for error
                if error != nil {
                    clouser(nil, UInt16(code.statusCode),error!)
                    return
                }
                // Print out response string
                let dataString = String(data: data!, encoding: .utf8)
           //     logInfo("responseString = \(dataString!)  === \(String(describing: data))")
                // Convert server json response to NSDictionary
                do {
                    if let convertedJsonIntoDict = try JSONSerialization.jsonObject(with: data!, options: []) as? Dictionary<String, AnyObject> {
                        clouser(convertedJsonIntoDict, UInt16(code.statusCode),error)
                    }
                } catch let error as NSError {
                    clouser(nil, UInt16(code.statusCode),error)
                //    logInfo(error.localizedDescription)
                }
            } else {
                self.stopHudAnimation()
                clouser(nil, UInt16(0),NSError.init(domain: "Deepak.CoreApp", code: 0, userInfo: nil))
            }
        }
        task.resume()
    }
    
    func createMultipleBody(arrValue : Array<Dictionary<String,Any>>,boundary : String) -> Data{
        
        let body = NSMutableData()
        for (_, item) in arrValue.enumerated() {
            for (key, value) in item {
                if (value is String || value is NSString){
                    body.appendString("--\(boundary)\r\n")
                    body.appendString("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n")
                    body.appendString("\(value)\r\n")
                } else if (value is UIImage){
                    
                    body.appendString("--\(boundary)\r\n")
                    let mimetype = "image/jpg"
                    let data = UIImageJPEGRepresentation(value as! UIImage,0.1)
                    body.appendString("Content-Disposition: form-data; name=\"\(key)\"; filename=\"\(key)_\(Int(Date().timeIntervalSince1970))\"\r\n")
                    body.appendString("Content-Type: \(mimetype)\r\n\r\n")
                    body.append(data!)
                    body.appendString("\r\n")
                } else if (value is Data) {
                    if value as? Data != nil {
                        body.appendString("--\(boundary)\r\n")
                        let mimetype = "audio/m4a"
                        body.appendString("Content-Disposition: form-data; name=\"\(key)\"; filename=\"\(key).mp3\"\r\n")
                        body.appendString("Content-Type: \(mimetype)\r\n\r\n")
                        body.append(value as! Data)
                        body.appendString("\r\n")
                    }
                }
            }
        }
        body.appendString("--\(boundary)--\r\n")
        return body as Data
    }
    
    
    class private func showErrorAlert(errorDict: Dictionary<String, AnyObject>) {
        
        // go to login screen
        
        var errorTitle = "Authentication Error!"
        let message = "Please login and try again."
        
        if let title = errorDict["error"] as? String {
            errorTitle = title
        }
        
        DispatchQueue.main.async(execute: {
            let alertController = UIAlertController(title: errorTitle, message: message, preferredStyle: .alert)
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .default) { (action) -> Void in}
            
            let loginAction = UIAlertAction(title: "Login", style: .default) { (action) -> Void in
                //WARNING:- Commented
                //                APPDELEGATE.logOut()
            }
            alertController.addAction(cancelAction)
            alertController.addAction(loginAction)
            UIApplication.shared.keyWindow?.rootViewController?.present(alertController, animated: true, completion: nil)
        })
    }
    
    //MARK:- Private Functions >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
    
    class fileprivate func methodName(_ method: MethodType)-> String {
        
        switch method {
        case .get: return "GET"
        case .post: return "POST"
        case .delete: return "DELETE"
        case .put: return "PUT"
        case .patch: return "PATCH"
            
        }
    }
    
    class fileprivate func body(_ method: MethodType, parameterDict: [String: Any]) -> Data {
        
        // Create json with your parameters
        switch method {
        case .post: fallthrough
        case .patch: fallthrough
        case .put: return parameterDict.toData()
        case .get: fallthrough
        case .delete: return parameterDict.toData()
            
            //   default: return Data()
        }
    }
    
    class fileprivate func requestURL(_ method: MethodType, apiName: String, parameterDict: [String: Any]) -> URL {
        var urlString = String()
        
        //        if apiName == kApiSearch {
        //            urlString = kApiSearch
        //        }
        //        else {
        //            urlString = stagingURL + apiName
        //        }
        
        urlString = stagingURL + apiName
        
        
        
        switch method {
        case .get:
            return getURL(apiName, parameterDict: parameterDict)
            
        case .post: fallthrough
        case .put: fallthrough
        case .patch: fallthrough
        case .delete: fallthrough
            
        default: return URL(string: urlString)!
        }
    }
    
    class fileprivate func getURL(_ apiName: String, parameterDict: [String: Any]) -> URL {
        
        var urlString = String()
        
        //        if apiName == kApiSearch {
        //            urlString = kApiSearch
        //        }
        //        else {
        //
        //            urlString = stagingURL + apiName
        //        }
        
        urlString = stagingURL + apiName
        
        if (apiName.contains("InstagrmApi") ){
            urlString = "https://api.instagram.com/v1/users/self"
        }else if(apiName.contains("https://api.instagram.com/v1/users/")){
            urlString = apiName
        }
        var isFirst = true
        
        for key in parameterDict.keys {
            
            let object = parameterDict[key]
            
            if object is NSArray {
                
                let array = object as! NSArray
                for eachObject in array {
                    var appendedStr = "&"
                    if (isFirst == true) {
                        appendedStr = "?"
                    }
                    urlString += appendedStr + (key) + "=" + (eachObject as! String)
                    isFirst = false
                }
                
            } else {
                var appendedStr = "&"
                if (isFirst == true) {
                    appendedStr = "?"
                }
                let parameterStr = parameterDict[key] as! String
                urlString += appendedStr + (key) + "=" + parameterStr
            }
            
            isFirst = false
        }
        
        //        let strUrl = urlString.addingPercentEscapes(using: String.Encoding.utf8)
        let strUrl = urlString.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
        
        return URL(string:strUrl!)!
    }
    
    
    //Mark :- To Check Reachability
    func checkReachablility() -> Bool {
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
                SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
            }
        }
        
        var flags = SCNetworkReachabilityFlags()
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) {
            return false
        }
        let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
        let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
        return (isReachable && !needsConnection)
    }
    
    func showHud() {
        //Show hud
        UIApplication.shared.keyWindow?.addSubview(animationView)
        animationView.setupAnimation()
    }
    
    func stopHudAnimation() {
        DispatchQueue.main.async {
            self.animationView.removeFromSuperview()
        }
    }
}

extension URLRequest  {
    //WARNING:- Commented
    //    mutating func addBasicAuth() {
    //
    //        let basicAuthUserName = "admin"
    //        let basicAuthPassword = "12345";
    //        let authStr = basicAuthUserName + ":" + basicAuthPassword
    //
    //        let authData = authStr.data(using: .ascii)
    //        let authValue = "Basic " + (authData?.base64EncodedString(options: .lineLength64Characters))!
    //        self.setValue(authValue, forHTTPHeaderField: "Authorization")
    //    }
    //
    //    mutating func addAccessParameters(_ apiName: String) {
    //
    //        if let customerKeyValue = defaults.object(forKey: pXCUSTOMERKEY) as? String {
    //            self.setValue(customerKeyValue, forHTTPHeaderField: pXCUSTOMERKEY)
    //        }
    //
    //        if let eKinCareKeyValue = defaults.object(forKey: pXEKINCAREKEY) as? String {
    //            self.setValue(eKinCareKeyValue, forHTTPHeaderField: pXEKINCAREKEY)
    //        }
    //
    //        if let deviceKeyValue = defaults.object(forKey: pXDEVICEID) as? String {
    //            self.setValue(deviceKeyValue, forHTTPHeaderField: pXDEVICEID)
    //        }
    //
    //        if let familyKeyValue = defaults.object(forKey: pXFAMILYMEMBERKEY) as? String {
    //            self.setValue(familyKeyValue, forHTTPHeaderField: pXFAMILYMEMBERKEY)
    //        }
    //    }
    
    func perform(hudType: loadingIndicatorType, completionBlock: @escaping (AnyObject?, Error?, HTTPURLResponse) -> Void) -> Void {
        
        //hud_type = hudType
        
        CAServiceHelper.sharedServiceHelper.showHud()
        
        let config = URLSessionConfiguration.default // Session Configuration
        let session = URLSession(configuration: config) // Load configuration into Session
        //var session = URLSession(configuration: configuration, delegate: nil, delegateQueue: nil)
        
        let task = session.dataTask(with: self, completionHandler: {
            (data, response, error) in
            
            CAServiceHelper.sharedServiceHelper.stopHudAnimation()

            if let response = response {
                
                let httpResponse = response as! HTTPURLResponse
                let responseCode = httpResponse.statusCode
                
                _ = httpResponse.allHeaderFields
                //    print("\n\n Response Header >>>>>> \n\(responseHeaderDict.debugDescription)")
                // print("Response Code : \(responseCode))")
                
                if let error = error {
                    //    print("\n\n error  >>>>>>\n\(error)")
                    completionBlock(nil, error, httpResponse)
                } else {
                    
                    if let responseString = NSString.init(data: data!, encoding: String.Encoding.utf8.rawValue) {
                        //   print("Response String : \n \(responseString)")
                    }
                    
                    do {
                        let result = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers)
                        
                        completionBlock(result as AnyObject?, nil, httpResponse)
                    } catch {
                        
                        //   print("\n\n error in JSONSerialization")
                        //   print("\n\n error  >>>>>>\n\(error)")
                        
                        if responseCode == 200 {
                            let result = ["response_code":"200"]
                            completionBlock(result as AnyObject?, nil, httpResponse)
                        }
                    }
                }
            } else {
                _ = AlertController.alert("Request Timeout!", message: "Please check your internet connection and try again.")
            }
        })
        
        task.resume()
    }
}

extension NSDictionary {
    func toData() -> Data {
        return try! JSONSerialization.data(withJSONObject: self, options: [])
    }
    
    func toJsonString() -> String {
        let jsonData = try! JSONSerialization.data(withJSONObject: self, options: JSONSerialization.WritingOptions.prettyPrinted)
        let jsonString = NSString(data: jsonData, encoding: String.Encoding.utf8.rawValue)! as String
        return jsonString
    }
}

extension Dictionary {
    
    func toData() -> Data {
        return try! JSONSerialization.data(withJSONObject: self, options: [])
    }
    
    func toJsonString() -> String {
        let jsonData = try! JSONSerialization.data(withJSONObject: self, options: JSONSerialization.WritingOptions.prettyPrinted)
        let jsonString = NSString(data: jsonData, encoding: String.Encoding.utf8.rawValue)! as String
        return jsonString
    }
}

func resolutionScale() -> CGFloat {
    
    return UIScreen.main.scale
}

//@@@@@@@@@@@@@@@@@@@@@ Standard response code @@@@@@@@@@@@@@@@@@@@@@@@@@
//@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
/* http://www.iana.org/assignments/http-status-codes/http-status-codes.xhtml
 
 if status == 400 { description = "Bad Request" }
 
 if status == 401 { description = "Unauthorized" }
 
 if status == 402 { description = "Payment Required" }
 
 if status == 403 { description = "Forbidden" }
 
 if status == 404 { description = "Not Found" }
 
 if status == 405 { description = "Method Not Allowed" }
 
 if status == 406 { description = "Not Acceptable" }
 
 if status == 407 { description = "Proxy Authentication Required" }
 
 if status == 408 { description = "Request Timeout" }
 
 if status == 409 { description = "Conflict" }
 
 if status == 410 { description = "Gone" }
 
 if status == 411 { description = "Length Required" }
 
 if status == 412 { description = "Precondition Failed" }
 
 if status == 413 { description = "Payload Too Large" }
 
 if status == 414 { description = "URI Too Long" }
 
 if status == 415 { description = "Unsupported Media Type" }
 
 if status == 416 { description = "Requested Range Not Satisfiable" }
 
 if status == 417 { description = "Expectation Failed" }
 
 if status == 422 { description = "Unprocessable Entity" }
 
 if status == 423 { description = "Locked" }
 
 if status == 424 { description = "Failed Dependency" }
 
 if status == 425 { description = "Unassigned" }
 
 if status == 426 { description = "Upgrade Required" }
 
 if status == 427 { description = "Unassigned" }
 
 if status == 428 { description = "Precondition Required" }
 
 if status == 429 { description = "Too Many Requests" }
 
 if status == 430 { description = "Unassigned" }
 
 if status == 431 { description = "Request Header Fields Too Large" }
 
 if status == 432 { description = "Unassigned" }
 
 if status == 500 { description = "Internal Server Error" }
 
 if status == 501 { description = "Not Implemented" }
 
 if status == 502 { description = "Bad Gateway" }
 
 if status == 503 { description = "Service Unavailable" }
 
 if status == 504 { description = "Gateway Timeout" }
 
 if status == 505 { description = "HTTP Version Not Supported" }
 
 if status == 506 { description = "Variant Also Negotiates" }
 
 if status == 507 { description = "Insufficient Storage" }
 
 if status == 508 { description = "Loop Detected" }
 
 if status == 509 { description = "Unassigned" }
 
 if status == 510 { description = "Not Extended" }
 
 if status == 511 { description = "Network Authentication Required" }
 
 */

extension NSMutableData {
    
    func appendString(_ string: String) {
        let data = string.data(using: String.Encoding.utf8, allowLossyConversion: true)
        append(data!)
    }
}
