//
//  SEarnedOffViewController.swift
//  Splitt
//
//  Created by Vishal Mandhyan on 12/07/18.
//  Copyright © 2018 Mobiloitte. All rights reserved.
//

import UIKit
protocol RewardPopUpProtocol {
    func backToView(isView: Bool)
}

class SEarnedOffViewController: UIViewController {
    var delegate: RewardPopUpProtocol!
    var titleText = String()

    @IBOutlet weak var offTitleLabel: UILabel!
    @IBOutlet weak var descLabel: UILabel!
    
    //MARK:- UIViewController LifeCycle Method
    override func viewDidLoad() {
        super.viewDidLoad()
        self.offTitleLabel.text = titleText
    }
    
    //MARK:- UIButton Action Methods
    @IBAction func crossButtonAction(_ sender: Any) {
        self.dismiss(animated: false) {
            self.delegate.backToView(isView: false)
        }
    }
    
    //MARK:- Memory Management Methods
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
