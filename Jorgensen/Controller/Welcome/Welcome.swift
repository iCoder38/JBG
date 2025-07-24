//
//  Welcome.swift
//  Jorgensen
//
//  Created by Apple on 03/09/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import UIKit

class Welcome: UIViewController {
    
    // MARK:- CUSTOM NAVIGATION BAR -
    
    @IBOutlet weak var navigationBar:UIView! {
        didSet {
            navigationBar.backgroundColor = NAVIGATION_BACKGROUND_COLOR
        }
    }
    
    // MARK:- CUSTOM NAVIGATION TITLE -
    
    @IBOutlet weak var lblNavigationTitle:UILabel! {
        didSet {
            lblNavigationTitle.text = "WELCOME"
        }
    }
    
    @IBOutlet weak var btnBack:UIButton! {
        didSet {
            btnBack.addTarget(self, action: #selector(backClickMethod), for: .touchUpInside)
        }
    }
    @objc func backClickMethod() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBOutlet var btnGetStartedNow:UIButton! {
        didSet {
            btnGetStartedNow.layer.cornerRadius = 4
            btnGetStartedNow.clipsToBounds = true
            btnGetStartedNow.backgroundColor = APP_BUTTON_COLOR
            btnGetStartedNow.setTitleColor(.white, for: .normal)
            btnGetStartedNow.setTitle("Get Started Now!", for: .normal)
        }
    }
    
    @IBOutlet var lblWelcome:UILabel! {
        didSet {
            lblWelcome.text = "Welcome to\n Jorgensen Brooks Group"
            lblWelcome.textColor = .black
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        
        btnGetStartedNow.addTarget(self, action: #selector(btnGetStartedNowClickMethod), for: .touchUpInside)
        
        /*
         if UserDefaults.standard.object(forKey: USER.kUSER_PWD) != nil {
         
         print("default")
         print(USER.kUSER_PWD)
         
         let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "DashbaordId") as? Dashbaord
         self.navigationController?.pushViewController(push!, animated: true)
         
         } else {
         print("logout")
         }
         */
        
        if let myLoadedString = UserDefaults.standard.string(forKey: "keyRememberMe") {
            print(myLoadedString)
            
            if myLoadedString == "yesRememberMe" {
                
                let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "DashbaordId") as? Dashbaord
                self.navigationController?.pushViewController(push!, animated: true)
                
            }
            if myLoadedString == "Match" {
                
                let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "EnterPasswordId") as? EnterPassword
                self.navigationController?.pushViewController(push!, animated: true)
                
            }
            
            
            
            
        } else {
            
        }
        
        
        
        
    }
    
    // MARK:- PUSH ( ENTER PASSWORD ) -
    @objc func btnGetStartedNowClickMethod()
    {
        let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "EmpolyeViewController") as? EmpolyeViewController
        self.navigationController?.pushViewController(push!, animated: true)
    }
}
