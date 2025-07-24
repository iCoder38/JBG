//
//  LegalFormDetails.swift
//  Jorgensen
//
//  Created by Apple on 04/09/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import UIKit

class LegalFormDetails: UIViewController {

    // MARK:- CUSTOM NAVIGATION BAR -
    @IBOutlet weak var navigationBar:UIView! {
        didSet {
            navigationBar.backgroundColor = NAVIGATION_BACKGROUND_COLOR
        }
    }

    @IBOutlet weak var viewUnderNavigation:UIView! {
        didSet {
            viewUnderNavigation.backgroundColor = APP_BUTTON_COLOR
        }
    }
    @IBOutlet weak var viewBottom:UIView! {
        didSet {
            viewBottom.backgroundColor = APP_BUTTON_COLOR
        }
    }
    
    @IBOutlet weak var btnStarOne:UIButton! {
        didSet {
            btnStarOne.layer.cornerRadius = 15
            btnStarOne.clipsToBounds = true
        }
    }
    @IBOutlet weak var btnStarTwo:UIButton! {
        didSet {
            btnStarTwo.layer.cornerRadius = 15
            btnStarTwo.clipsToBounds = true
        }
    }
    @IBOutlet weak var btnStarThree:UIButton! {
        didSet {
            btnStarThree.layer.cornerRadius = 15
            btnStarThree.clipsToBounds = true
        }
    }
    @IBOutlet weak var btnStarFour:UIButton! {
        didSet {
            btnStarFour.layer.cornerRadius = 15
            btnStarFour.clipsToBounds = true
        }
    }
    @IBOutlet weak var btnStarFive:UIButton! {
        didSet {
            btnStarFive.layer.cornerRadius = 15
            btnStarFive.clipsToBounds = true
        }
    }
    
    // MARK:- CUSTOM NAVIGATION TITLE -
    @IBOutlet weak var lblNavigationTitle:UILabel! {
        didSet {
            lblNavigationTitle.text = "LEGAL FORM DETAILS"
            lblNavigationTitle.textColor = .white
        }
    }
    
    @IBOutlet weak var btnBack:UIButton! {
        didSet {
            btnBack.tintColor = .white
        }
    }
    
    @IBOutlet weak var lblTitle:UILabel! {
        didSet {
            lblTitle.text = "Children's Carpool Agreement"
        }
    }
    
    @IBOutlet weak var txtView:UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        
        //MARK:- BACK OR MENU -
        let userDefault = UserDefaults.standard
        if let theGreeting = userDefault.string(forKey: "keySidebarOrBack") {
            if theGreeting == "sideBar" {
                self.btnBack.setBackgroundImage(UIImage(named: "menu"), for: .normal)
                self.sideBarMenuClick()
            } else {
                self.btnBack.setBackgroundImage(UIImage(systemName: "arrow.left"), for: .normal)
                btnBack.addTarget(self, action: #selector(backClickMethod), for: .touchUpInside)
            }
        } else {
            self.btnBack.setBackgroundImage(UIImage(systemName: "arrow.left"), for: .normal)
            btnBack.addTarget(self, action: #selector(backClickMethod), for: .touchUpInside)
        }
    }
    
    @objc func sideBarMenuClick() {
        let userDefault = UserDefaults.standard
        userDefault.set("", forKey: "keySidebarOrBack")
        userDefault.set(nil, forKey: "keySidebarOrBack")
        
        if revealViewController() != nil {
            btnBack.addTarget(self.revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)), for: .touchUpInside)
               
            revealViewController().rearViewRevealWidth = 300
            view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
    }
    
    // MARK:- BACK -
    @objc func backClickMethod() {
        self.navigationController?.popViewController(animated: true)
    }
}
