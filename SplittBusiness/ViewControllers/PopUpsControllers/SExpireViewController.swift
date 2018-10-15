//
//  SExpireViewController.swift
//  Splitt
//
//  Created by Vishal Mandhyan on 12/07/18.
//  Copyright © 2018 Mobiloitte. All rights reserved.
//

import UIKit
protocol GiveAnswerProtocol {
    func backToVC(isView: Bool)
}

class SExpireViewController: UIViewController {
    var isFromAnswerQuestion = Bool()
    var delegate: GiveAnswerProtocol!
    var titleText = String()

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var yesButton: UIButton!
    @IBOutlet weak var noButton: UIButton!
    
    //MARK:- UIViewController LifeCycle Method
    override func viewDidLoad() {
        super.viewDidLoad()
        initialMethod()
    }
    
    //MARK:- Custom Method
    func initialMethod() {
        if isFromAnswerQuestion {
            self.yesButton.setTitle("Cancel", for: .normal)
            self.noButton.setTitle("View", for: .normal)
        }
        self.titleLabel.text = titleText
    }
    
    //MARK:- UIButton Action Methods
    @IBAction func yesButtonAction(_ sender: Any) {
        if !isFromAnswerQuestion {
            self.dismiss(animated: false) {
                self.delegate.backToVC(isView: false)
            }
        } else {
            self.dismiss(animated: false, completion: nil)
        }
    }
    
    @IBAction func noButtonAction(_ sender: Any) {
        if isFromAnswerQuestion {
            self.dismiss(animated: false) {
                self.delegate.backToVC(isView: true)
            }
        } else {
            self.dismiss(animated: false, completion: nil)
        }
    }
    
    
    @IBAction func crossButtonAction(_ sender: Any) {
        self.dismiss(animated: false, completion: nil)
    }
    
    //MARK:- Memory Management Methods
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
