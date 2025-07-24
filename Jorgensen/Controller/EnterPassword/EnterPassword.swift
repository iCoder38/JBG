//
//  EnterPassword.swift
//  Jorgensen
//
//  Created by Apple on 03/09/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import UIKit

class EnterPassword: UIViewController, UITextFieldDelegate {

    // MARK:- CUSTOM NAVIGATION BAR -
    @IBOutlet weak var navigationBar:UIView! {
        didSet {
            navigationBar.backgroundColor = NAVIGATION_BACKGROUND_COLOR
        }
    }

    // MARK:- CUSTOM NAVIGATION TITLE -
    @IBOutlet weak var lblNavigationTitle:UILabel! {
        didSet {
            lblNavigationTitle.text = "ENTER PASSWORD"
        }
    }
    @IBOutlet weak var btnBack:UIButton! {
        didSet {
            btnBack.tintColor = .white
        }
    }
    
    @IBOutlet var btnAccessNow:UIButton! {
        didSet {
            btnAccessNow.layer.cornerRadius = 4
            btnAccessNow.clipsToBounds = true
            btnAccessNow.backgroundColor = APP_BUTTON_COLOR
            btnAccessNow.setTitleColor(.white, for: .normal)
            btnAccessNow.setTitle("Access Now", for: .normal)
        }
    }
    
    @IBOutlet weak var txtEnterPassword:UITextField! {
        didSet {
            txtEnterPassword.placeholder = "Enter Password"
            txtEnterPassword.textAlignment = .center
            txtEnterPassword.layer.cornerRadius = 4
            txtEnterPassword.clipsToBounds = true
            txtEnterPassword.backgroundColor = UIColor.init(red: 237.0/255.0, green: 237.0/255.0, blue: 237.0/255.0, alpha: 1)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        
        self.txtEnterPassword.delegate = self
        btnBack.addTarget(self, action: #selector(backClickMethod), for: .touchUpInside)
        btnAccessNow.addTarget(self, action: #selector(btnGetStartedNowClickMethod), for: .touchUpInside)
        
        // MARK:- VIEW UP WHEN CLICK ON TEXT FIELD -
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        // MARK:- DISMISS KEYBOARD WHEN CLICK OUTSIDE -
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    // MARK:- BACK -
    @objc func backClickMethod() {
        self.navigationController?.popViewController(animated: true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    // MARK:- KEYBOARD WILL SHOW -
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0 {
                self.view.frame.origin.y -= keyboardSize.height
            }
        }
    }
    
    // MARK:- KEYBOARD WILL HIDE -
    @objc func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }
    
    // MARK:- PUSH ( DASHBOARD ) -
    @objc func btnGetStartedNowClickMethod()
    {
        
        let valueExpected = "JBG"
       
        let valueProvided: String  = self.txtEnterPassword.text!

        
        
        
         // let defaults = UserDefaults.standard
         // defaults.setValue(dict, forKey: "keyLoginFullData")
        
        
        if (valueExpected.caseInsensitiveCompare(valueProvided) == .orderedSame)
        {
            UserDefaults.standard.set(valueProvided, forKey:USER.kUSER_PWD)
            UserDefaults.standard.synchronize()
            
            
            let myString = "yesRememberMe"
            UserDefaults.standard.set(myString, forKey: "keyRememberMe")

            print("Strings are equal")
            let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "DashbaordId") as? Dashbaord
                   self.navigationController?.pushViewController(push!, animated: true)
        }
        else
        {
            
        }
       
    }
    
}
