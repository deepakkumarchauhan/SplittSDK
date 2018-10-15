//
//  AbcViewController.swift
//  FrameworkDemo
//
//  Created by Vishal Mandhyan on 06/08/18.
//  Copyright © 2018 Deepak. All rights reserved.
//

import UIKit
import SplittBusiness

class AbcViewController: UIViewController {
    

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func moveToFrameworkButtonAction(_ sender: Any) {
        let s = UIStoryboard (
            name: "Main", bundle: Bundle(for: HomeViewController.self)
        )
        let vc = s.instantiateInitialViewController() as! HomeViewController
        vc.userId = "5"
        vc.emailId = "deepak@gmail.com"
        vc.userName = "Deepak"
        vc.countryCode = "+91"
        vc.mobile = "9716063040"
        vc.businessKey = "BUSIN1234DB88B59"
        vc.navigateToHome(controller: self.navigationController!)
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
