//
//  EmpolyeViewController.swift
//  Jorgensen
//
//  Created by santosh kumar singh on 03/11/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import UIKit
import Alamofire
import IHProgressHUD

class EmpolyeViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var employerNumberTextField: UITextField!
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    
    
    @IBOutlet weak var navigationBar:UIView! {
        didSet {
            navigationBar.backgroundColor = NAVIGATION_BACKGROUND_COLOR
        }
    }
    
    // MARK:- CUSTOM NAVIGATION TITLE -
    @IBOutlet weak var lblNavigationTitle:UILabel! {
        didSet
        {
            lblNavigationTitle.text = "EMPLOYEE INFORMATION"
        }
    }
    
    @IBOutlet weak var btnBack:UIButton! {
        didSet
        {
            btnBack.tintColor = .white
        }
    }
    
    
    @IBOutlet var btnGetStartedNow:UIButton!
        {
        didSet
        {
            btnGetStartedNow.layer.cornerRadius = 4
            btnGetStartedNow.clipsToBounds = true
            btnGetStartedNow.backgroundColor = APP_BUTTON_COLOR
            btnGetStartedNow.setTitleColor(.white, for: .normal)
            btnGetStartedNow.setTitle("Submit", for: .normal)
        }
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
    
    
    @objc func backClickMethod() {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        
        self.btnBack.setBackgroundImage(UIImage(systemName: "arrow.left"), for: .normal)
        self.btnBack.addTarget(self, action: #selector(backClickMethod), for: .touchUpInside)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        // MARK:- DISMISS KEYBOARD WHEN CLICK OUTSIDE -
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        btnGetStartedNow.addTarget(self, action: #selector(btnGetStartedNowClickMethod), for: .touchUpInside)
        
        
        self.firstNameTextField.addPadding(.left(10))
        self.lastNameTextField.addPadding(.left(10))
        self.emailTextField.addPadding(.left(10))
        self.phoneTextField.addPadding(.left(10))
        self.employerNumberTextField.addPadding(.left(10))
        
        
        self.firstNameTextField.delegate = self
        firstNameTextField.layer.borderColor = UIColor.gray.cgColor
        firstNameTextField.layer.borderWidth = 1
        
        self.lastNameTextField.delegate = self
        lastNameTextField.layer.borderColor = UIColor.gray.cgColor
        lastNameTextField.layer.borderWidth = 1
        
        
        self.emailTextField.delegate = self
        emailTextField.layer.borderColor = UIColor.gray.cgColor
        emailTextField.layer.borderWidth = 1
        
        self.phoneTextField.delegate = self
        phoneTextField.layer.borderColor = UIColor.gray.cgColor
        phoneTextField.layer.borderWidth = 1
        
        self.employerNumberTextField.delegate = self
        employerNumberTextField.layer.borderColor = UIColor.gray.cgColor
        employerNumberTextField.layer.borderWidth = 1
        
        // Do any additional setup after loading the view.
    }
 
    func validate(value: String) -> Bool {
        let PHONE_REGEX = "^\\d{3}-\\d{3}-\\d{4}$"
        
        let phoneTest = NSPredicate(format: "SELF MATCHES %@", PHONE_REGEX)
        let result =  phoneTest.evaluate(with: value)
        return result
    }
    
    func validate(YourEMailAddress: String) -> Bool {
        let REGEX: String
        REGEX = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,6}"
        return NSPredicate(format: "SELF MATCHES %@", REGEX).evaluate(with: YourEMailAddress)
    }
    
    @objc func btnGetStartedNowClickMethod()
    {
        if (firstNameTextField.text?.count)!>0 &&
            (lastNameTextField.text?.count)!>0 &&
            (emailTextField.text?.count)!>0 &&
            (phoneTextField.text?.count)!>0 &&
            (employerNumberTextField.text?.count)!>0
        {
            
            if validate(YourEMailAddress: emailTextField.text!)
            {
                
//                if validate(value: phoneTextField.text!)
//                {
//                    self.loadMessages()
//                }
//                else
//                {
//                    Alert .showTostMessage(message:"Phone number should be in correct format!" as String, delay: 3.0, controller: self)
//                }
                
                self.loadMessages()
                
            }
            else{
                Alert .showTostMessage(message:"Please add valid email address!" as String, delay: 3.0, controller: self)
            }
            
            
        }
        else
        {
            Alert .showTostMessage(message:"Fields can't be blank!" as String, delay: 3.0, controller: self)
            
        }
    }
    
    
    func loadMessages()
    {
        IHProgressHUD.show(withStatus: "Please wait...")
        let url = URL(string: "https://script.google.com/macros/s/AKfycbyAz8p2wjn4IR7kF7-WAZdFYumXxSOOWrvCdxB7LknLyjkaeiVk/exec")!
        
        let headers: HTTPHeaders = [
            "Authorization": "Info XXX",
            "Accept": "application/json",
            "Content-Type" :"application/json"
        ]
        
        let body: [String: Any] = [
            "action": "saveItem",
            "FirstName": self.firstNameTextField.text!,
            "LastName": self.lastNameTextField.text!,
            "Email": self.emailTextField.text!,
            "Employer": self.employerNumberTextField.text!,
            "Phone": self.phoneTextField.text!
        ]
        
        AF.request(url,method: .post, parameters: body,encoding:URLEncoding.queryString, headers: headers).responseJSON { response in
            debugPrint(response)
            IHProgressHUD.dismiss()
            let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "EnterPasswordId") as? EnterPassword
            self.navigationController?.pushViewController(push!, animated: true)
        }
        
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}

extension UITextField {
    
    enum PaddingSide {
        case left(CGFloat)
        case right(CGFloat)
        case both(CGFloat)
    }
    
    func addPadding(_ padding: PaddingSide) {
        
        self.leftViewMode = .always
        self.layer.masksToBounds = true
        
        
        switch padding {
            
        case .left(let spacing):
            let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: spacing, height: self.frame.height))
            self.leftView = paddingView
            self.rightViewMode = .always
            
        case .right(let spacing):
            let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: spacing, height: self.frame.height))
            self.rightView = paddingView
            self.rightViewMode = .always
            
        case .both(let spacing):
            let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: spacing, height: self.frame.height))
            // left
            self.leftView = paddingView
            self.leftViewMode = .always
            // right
            self.rightView = paddingView
            self.rightViewMode = .always
        }
    }
}
