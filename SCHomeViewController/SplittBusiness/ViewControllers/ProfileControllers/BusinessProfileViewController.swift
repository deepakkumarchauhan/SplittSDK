//
//  SCProfileViewController.swift
//  SplittConsumer
//
//  Created by Vishal Mandhyan on 26/07/18.
//  Copyright © 2018 Deepak. All rights reserved.
//

import UIKit
import MessageUI
import GoogleMaps
import CoreLocation

class BusinessProfileViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, MFMailComposeViewControllerDelegate, CLLocationManagerDelegate, RatingProtocol {
    static var cellIdentifier = "ReviewCellID"
    static var collectionCellIdentifier = "ImageCollectionCellID"
    var reviewArray = [SCHomeInfo]()
    var userInfo = SCUserInfo()
    var locationManager: CLLocationManager!
    var lat = String()
    var lng = String()
    public var businessKey = String()

    var isMyprofile = Bool()
    var otherProfileId = String()
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var splittCountLabel: UILabel!
    @IBOutlet weak var followersCountLabel: UILabel!
    @IBOutlet weak var followingCountLabel: UILabel!
    @IBOutlet weak var groupCountLabel: UILabel!
    @IBOutlet weak var rewardCountLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var noPhotoLabel: UILabel!
    
    @IBOutlet weak var bioTextView: UITextView!
    
    @IBOutlet weak var phoneButton: UIButton!
    @IBOutlet weak var emailButton: UIButton!
    @IBOutlet weak var websiteButton: UIButton!
    @IBOutlet weak var locationButton: UIButton!
    @IBOutlet weak var numberOfHoursButton: UIButton!
    @IBOutlet weak var userImageButton: UIButton!
    @IBOutlet weak var followButton: UIButton!
    
    @IBOutlet weak var bgImageView: UIImageView!
    
    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    
    //MARK: UIView Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        initialMethod()
    }
    
    //MARK: Custom Method
    func initialMethod() {
        self.tableView.estimatedRowHeight = 118.0

        initLocationManager()
        callApiForBusinessUserProfile()
    }
    
    // Method for default location services
    func initLocationManager() {
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.distanceFilter = 30
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    func loadMapView() {

        if userInfo.addressArray.count > 0 {
            let addressObj = userInfo.addressArray[0]
            let lat = addressObj.lat == "" ? "0" : addressObj.lat
            let lng = addressObj.lng == "" ? "0" : addressObj.lng

            let intLatFromString = Float(lat)
            let dobleLatFromInt = Double(intLatFromString!)

            let intLngFromString = Float(lng)
            let dobleLngFromInt = Double(intLngFromString!)

            let camera = GMSCameraPosition.camera(withLatitude: dobleLatFromInt, longitude: dobleLngFromInt, zoom: 12.0)

            mapView.camera = camera
            mapView.settings.myLocationButton = true
            mapView.isMyLocationEnabled = true
            // add marker
            let status = CLLocationManager.authorizationStatus()
            if status == .notDetermined || status == .denied || status == .authorizedWhenInUse {
                self.locationManager.requestAlwaysAuthorization()
                self.locationManager.requestWhenInUseAuthorization()
                self.locationManager.startUpdatingLocation()
            }
            self.multipleMarker()
        }
    }
    
    func multipleMarker() {

        let bundle = Bundle(for: HomeViewController.self)
        guard let image = UIImage(named: "marker", in: bundle, compatibleWith: nil)?.withRenderingMode(.alwaysOriginal) else {
            fatalError("Missing MyImage...")
        }

        for companyObject in userInfo.addressArray {
            let marker = GMSMarker()

            let markerImage = image
            //creating a marker view
            let markerView = UIImageView(image: markerImage)
            marker.iconView = markerView
            marker.isTappable = true

            marker.position = CLLocationCoordinate2D(latitude: Double(Float((companyObject.lat))!) , longitude: Double(Float((companyObject.lng))!))
            marker.snippet = companyObject.location

            DispatchQueue.main.async {
                marker.map = self.mapView
            }
        }
        let marker = GMSMarker()
        let lat = Double(Float((self.lat == "" ? "0.0" : self.lat))!)
        let long = Double(Float((self.lng == "" ? "0.0" : self.lng))!)
        let markerImage = image
        //creating a marker view
        let markerView = UIImageView(image: markerImage)
        marker.iconView = markerView
        marker.isTappable = true
        marker.position = CLLocationCoordinate2D(latitude: lat, longitude: long)
        marker.snippet = "Current Location"
        DispatchQueue.main.async {
            marker.map = self.mapView
        }
    }
    
    
    func sendEmail(emailText: String) {
        if MFMailComposeViewController.canSendMail() {
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self
            mail.setToRecipients([emailText])
            mail.setMessageBody("<p>You're so awesome!</p>", isHTML: true)
            
            present(mail, animated: true)
        } else {
            // show failure alert
        }
    }
    
    
    //MARK: UITableView Datasource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userInfo.reviewDataArray.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : ReviewTableViewCell = tableView.dequeueReusableCell(withIdentifier: BusinessProfileViewController.cellIdentifier) as! ReviewTableViewCell
        let obj = userInfo.reviewDataArray[indexPath.row]
        cell.reviewTitleLabel.text = obj.userName
        cell.reviewDescriptionLabel.text = obj.review
        cell.reviewRateView.rating = Double(Int(obj.rating)!)
        
        let bundle = Bundle(for: HomeViewController.self)
        guard let image = UIImage(named: "profile_img", in: bundle, compatibleWith: nil)?.withRenderingMode(.alwaysOriginal) else {
            fatalError("Missing MyImage...")
        }
        cell.reviewImageView.downloadedFrom(link: obj.userImageString, contentMode: .scaleToFill, placeholderImage: image)

        return cell
    }

    //MARK: UITableView Delegate
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    
    //MARK: UICollectionView Datasource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return userInfo.storeImageArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BusinessProfileViewController.collectionCellIdentifier, for: indexPath) as! BusinessImagesCollectionViewCell
        let obj = userInfo.storeImageArray[indexPath.item]
        
        let bundle = Bundle(for: HomeViewController.self)
        guard let image = UIImage(named: "image_placeholder", in: bundle, compatibleWith: nil)?.withRenderingMode(.alwaysOriginal) else {
            fatalError("Missing MyImage...")
        }
        
        cell.cellImageView.downloadedFrom(link: obj.userImageString, contentMode: .scaleToFill, placeholderImage: image)
        
        return cell
    }
    
    
    
    //MARK: UICollectionView Delegate
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.size.width/3, height: collectionView.frame.size.height)
    }
    
    
    //MARK: UIMessage Composer Delegate
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true)
    }
    
    
    //MARK: UIButton Action Methods
    @IBAction func addReviewButtonAction(_ sender: Any) {
        let addReviewVC = self.storyboard?.instantiateViewController(withIdentifier: "AddReviewVC") as! SCReviewViewController
        addReviewVC.businessKey = businessKey
        addReviewVC.delegate = self
        self.navigationController?.pushViewController(addReviewVC, animated: true)
    }
    
    
    @IBAction func facebookButtonAction(_ sender: Any) {
        if userInfo.facebookAddress.length != 0 {
            let first4 = userInfo.facebookAddress.prefix(4) // Hell
            if first4.uppercased() != "HTTP" {
                userInfo.facebookAddress = "http://" + userInfo.facebookAddress
            }
            UIApplication.shared.open(URL(string : userInfo.facebookAddress)!, options: [:], completionHandler: nil)
        } else {
            _ = AlertController.alert("", message: "No URL found. Please update your profile.")
        }
    }
    
    @IBAction func twitterButtonAction(_ sender: Any) {
        if userInfo.twitterAddress.length != 0 {
            let first4 = userInfo.twitterAddress.prefix(4) // Hell
            if first4.uppercased() != "HTTP" {
                userInfo.twitterAddress = "http://" + userInfo.twitterAddress
            }
            UIApplication.shared.open(URL(string : userInfo.twitterAddress)!, options: [:], completionHandler: nil)
        } else {
            _ = AlertController.alert("", message: "No URL found. Please update your profile.")
        }
    }
    
    @IBAction func linkedinButtonAction(_ sender: Any) {
        if userInfo.linkedinAddress.length != 0 {
            let first4 = userInfo.linkedinAddress.prefix(4) // Hell
            if first4.uppercased() != "HTTP" {
                userInfo.linkedinAddress = "http://" + userInfo.linkedinAddress
            }
            UIApplication.shared.open(URL(string : userInfo.linkedinAddress)!, options: [:], completionHandler: nil)
        } else {
            _ = AlertController.alert("", message: "No URL found. Please update your profile.")
        }
    }
    
    @IBAction func instagramButtonAction(_ sender: Any) {
        if userInfo.instagramAddress.length != 0 {
            let first4 = userInfo.instagramAddress.prefix(4) // Hell
            if first4.uppercased() != "HTTP" {
                userInfo.instagramAddress = "http://" + userInfo.instagramAddress
            }
            UIApplication.shared.open(URL(string : userInfo.instagramAddress)!, options: [:], completionHandler: nil)
        } else {
            _ = AlertController.alert("", message: "No URL found. Please update your profile.")
        }
    }
    
    @IBAction func phoneButtonAction(_ sender: UIButton) {
        
        if sender.titleLabel?.text != "" {
            let mobile = (sender.titleLabel?.text)!
            
            if let url = URL(string: "tel://\(mobile)"), UIApplication.shared.canOpenURL(url) {
                if #available(iOS 10, *) {
                    UIApplication.shared.open(url)
                } else {
                    UIApplication.shared.openURL(url)
                }
            }
        }
    }
    
    @IBAction func emailButtonAction(_ sender: UIButton) {
        if sender.titleLabel?.text != "" {
            self.sendEmail(emailText: (sender.titleLabel?.text)!)
        }
    }
    
    
    @IBAction func websiteButtonAction(_ sender: Any) {
        if userInfo.websiteAddress.length != 0 {
            let first4 = userInfo.websiteAddress.prefix(4) // Hell
            if first4.uppercased() != "HTTP" {
                userInfo.websiteAddress = "http://" + userInfo.websiteAddress
            }
            UIApplication.shared.open(URL(string : userInfo.websiteAddress)!, options: [:], completionHandler: nil)
        } else {
            _ = AlertController.alert("", message: "No URL found. Please update your profile.")
        }
    }
    
    @IBAction func locationButtonAction(_ sender: UIButton) {
        let filterArray = userInfo.addressArray.map{$0.location}
        
        DPPickerManager.shared.showPicker(title: "Location", selected: "", strings: filterArray) { (title, index, status) in
            if !status {
                self.locationButton.setTitle(title!, for: .normal)
                self.tableView.reloadData()
            }
        }
    }
    
    @IBAction func hoursButtonAction(_ sender: UIButton) {
        
        let filterArray = userInfo.operationHours.filter{$0.isSelect == true}
        var operationArray = [String]()
        for obj in filterArray {
            operationArray.append("\(obj.day) \(obj.openTime)-\(obj.closeTime)")
        }
        
        DPPickerManager.shared.showPicker(title: "Operation Hours", selected: "", strings: operationArray) { (title, index, status) in
            if !status {
                self.numberOfHoursButton.setTitle(title!, for: .normal)
                self.tableView.reloadData()
            }
        }
    }
    
    
    @IBAction func followButtonAction(_ sender: Any) {
        _ = AlertController.alert("", message: "Are you sure you want to follow/unfollow \(self.nameLabel.text!)?", controller: self, buttons: ["Yes", "No"], tapBlock: { (action, index) in
            if index == 0 {
                self.callApiForFollowUnfollowUser()
            }
        })
    }
    
    
    @IBAction func followerButtonAction(_ sender: Any) {
//        if userInfo.followerCount != "0" {
//            let followerVC = self.storyboard?.instantiateViewController(withIdentifier: "FollowingVC") as! FollowingListViewController
//            followerVC.fromIndexToChangeView = 0
//            followerVC.otherUserId = self.otherProfileId
//            self.navigationController?.pushViewController(followerVC, animated: true)
//        }
    }
    
    @IBAction func followingButtonAction(_ sender: Any) {
//        if userInfo.followingCount != "0" {
//            let followingVC = self.storyboard?.instantiateViewController(withIdentifier: "FollowingVC") as! FollowingListViewController
//            followingVC.fromIndexToChangeView = 1
//            followingVC.otherUserId = self.otherProfileId
//            self.navigationController?.pushViewController(followingVC, animated: true)
//        }
    }
    
    @IBAction func groupButtonAction(_ sender: Any) {
//        if userInfo.groupCount != "0" {
//            let groupVC = self.storyboard?.instantiateViewController(withIdentifier: "FollowingVC") as! FollowingListViewController
//            groupVC.fromIndexToChangeView = 2
//            groupVC.otherUserId = self.otherProfileId
//            self.navigationController?.pushViewController(groupVC, animated: true)
//        }
    }

    
    @IBAction func backButtonAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    //MARK: Custom Delegate
    func callApiAfterRating() {
        callApiForBusinessUserProfile()
    }
    
    
    //MARK: CLLocation Manager Delegate
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let locationArray = locations as NSArray
        let location = locationArray.lastObject as! CLLocation
        
        /* you can use these values*/
        lat = "\(location.coordinate.latitude)"
        lng = "\(location.coordinate.longitude)"
        
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error){
        print("locations error = \(error.localizedDescription)")
    }

    
    //MARK: Call API
    func callApiForBusinessUserProfile()
    {

        let dict = NSMutableDictionary()
        dict[cPageNumber] = "1"
        dict[cPageSize] = "10"
        dict[cOtherUserId] = NSUSERDEFAULT.value(forKey: cUserId)
        dict[cUserId] = otherProfileId
        
        CAServiceHelper.sharedServiceHelper.request(dict as! Dictionary<String, AnyObject>, method: .post, apiName: "\(BusinessProfile)?businessKey=\(businessKey)", hudType: .simple) { (result, error, status) in

            if (error == nil) {
                if let response = result as? Dictionary<String, AnyObject> {
                    if(status == 200) {
                        let dataDict = response.validatedValue(cData, expected: NSDictionary())as! Dictionary<String,AnyObject>
                        self.userInfo = SCUserInfo.modelFromBusinessProfileDict(dataDict)
                        
                        let bundle = Bundle(for: HomeViewController.self)
                        guard let image = UIImage(named: "image_placeholder", in: bundle, compatibleWith: nil)?.withRenderingMode(.alwaysOriginal) else {
                            fatalError("Missing MyImage...")
                        }
                        self.bgImageView.downloadedFrom(link: self.userInfo.backgroundImageString, contentMode: .scaleToFill, placeholderImage: UIImage())
                        
                        self.userImageButton.downloadedFrom2(link: self.userInfo.userImageString,  contentMode: .scaleAspectFit, placeholderImage: image)
                        
                        self.splittCountLabel.text = self.userInfo.splittCount
                        self.followersCountLabel.text = self.userInfo.followerCount
                        self.followingCountLabel.text = self.userInfo.followingCount
                        self.groupCountLabel.text = self.userInfo.groupCount
                        self.rewardCountLabel.text = self.userInfo.rewardCount
                        self.nameLabel.text = self.userInfo.fullName
                        self.followButton.setTitle(self.userInfo.isFollow ? "+Unfollow" : "+Follow", for: .normal)
                        self.bioTextView.text = self.userInfo.bio
                        self.categoryLabel.text = self.userInfo.businessCategory
                        self.emailButton.setTitle(self.userInfo.emailID, for: .normal)
                        self.phoneButton.setTitle(self.userInfo.mobile, for: .normal)
                        self.websiteButton.setTitle(self.userInfo.websiteAddress, for: .normal)
                        
                        if self.userInfo.storeImageArray.count == 0 {
                            self.noPhotoLabel.isHidden = false
                        }
                        
                        self.loadMapView()
                        self.collectionView.reloadData()
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
    
    func callApiForFollowUnfollowUser()
    {
        let dict = NSMutableDictionary()
        dict[cFollowBy] = NSUSERDEFAULT.value(forKey: cUserId)
        dict[cFollowTo] = otherProfileId
        
        CAServiceHelper.sharedServiceHelper.request(dict as! Dictionary<String, AnyObject>, method: .post, apiName: "\(FollowUnfollow)?businessKey=\(businessKey)", hudType: .simple) { (result, error, status) in
            if (error == nil) {
                if let response = result as? Dictionary<String, AnyObject> {
                    if(status == 200) {
                        self.followButton.setTitle(self.followButton.titleLabel?.text == "+Follow" ? "+Unfollow" : "+Follow", for: .normal)
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

