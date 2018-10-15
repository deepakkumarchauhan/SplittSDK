//
//  SCReviewViewController.swift
//  SplittBusiness
//
//  Created by Vishal Mandhyan on 12/10/18.
//  Copyright © 2018 Deepak. All rights reserved.
//

import UIKit
protocol RatingProtocol {
    func callApiAfterRating()
}

class SCReviewViewController: UIViewController, UITextViewDelegate {
    public var businessKey = String()
    var delegate: RatingProtocol?

    @IBOutlet weak var textView: UITextView!
    
    @IBOutlet weak var ratingView: FloatRatingView!
    
    @IBOutlet weak var viewTopConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var feedbackPlaceholderLabel: UILabel!
    
    //MARK: UIview Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    //MARK: UITextView Delegate
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        if Window_Width <= 320 {
            self.viewTopConstraint.constant = -30
            UIView.animate(withDuration: 0.2) {
                self.view.layoutIfNeeded()
            }
        }
        return true
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if Window_Width <= 320 {
            self.viewTopConstraint.constant = 18
            UIView.animate(withDuration: 0.2) {
                self.view.layoutIfNeeded()
            }
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if textView.isFirstResponder {
            if textView.textInputMode?.primaryLanguage == nil || textView.textInputMode?.primaryLanguage == "emoji" {
                return false
            }
        }
        var str:NSString = textView.text! as NSString
        str = str.replacingCharacters(in: range, with: text) as NSString
        self.feedbackPlaceholderLabel.isHidden = str.length == 0 ? false : true

        if str.length > 500 {
            return false
        }
        return true
    }
    
    
    //MARK: UIButton Action
    @IBAction func submitButtonAction(_ sender: Any) {
        self.view.endEditing(true)
        if self.textView.text.trimWhiteSpace() == "" {
            _ = AlertController.alert("", message: "Please enter feedback.")
        } else {
            callApiToAddReview()
        }
    }
    
    @IBAction func backButtonAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    //MARK: Touch Method
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    //MARK: Call APi
    func callApiToAddReview()
    {
        let dict = NSMutableDictionary()
        dict[cUserId] = NSUSERDEFAULT.value(forKey: cUserId)
        dict[cComment] = self.textView.text.trimWhiteSpace()
        dict[cRating] = "\(Int(ratingView.rating))"

        CAServiceHelper.sharedServiceHelper.request(dict as! Dictionary<String, AnyObject>, method: .post, apiName: "\(UserReview)?businessKey=\(businessKey)", hudType: .simple) { (result, error, status) in
            if (error == nil) {
                if let response = result as? Dictionary<String, AnyObject> {
                    if(status == 200) {
                        _ = AlertController.alert("", message: response.validatedValue(pResponseMessage, expected: "" as AnyObject) as! String, controller: self, buttons: ["OK"], tapBlock: { (action, index) in
                            self.delegate?.callApiAfterRating()
                            self.navigationController?.popViewController(animated: true)
                        })
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
}
