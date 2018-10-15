//
//  SEarnedViewController.swift
//  Splitt
//
//  Created by Vishal Mandhyan on 12/07/18.
//  Copyright © 2018 Mobiloitte. All rights reserved.
//

import UIKit
@objc protocol PopUpProtocol {
    @objc optional func backToVC()
    @objc optional func backToVC(businessName: String)
}

class SEarnedViewController: UIViewController {
    var delegate: PopUpProtocol!
    var isFromSplitt = Bool()
    var titleText = String()
    var businessName = String()

    @IBOutlet weak var titleLabel: UILabel!
    
    //MARK:- UIViewController LifeCycle Method
    override func viewDidLoad() {
        super.viewDidLoad()
        self.titleLabel.text = titleText
    }
    
    //MARK:- UIButton Action Methods
    @IBAction func crossButtonAction(_ sender: Any) {
        self.dismiss(animated: false) {
            if self.isFromSplitt {
                self.delegate.backToVC!(businessName: self.businessName)
            } else {
                self.delegate.backToVC!()
            }
        }
    }
    
    //MARK:- Memory Management Methods
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
