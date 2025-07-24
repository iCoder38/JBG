//
//  HelpViewController.swift
//  Nailz
//
//  Created by Nitin on 5/22/18.
//  Copyright © 2018 EVS. All rights reserved.
//

import UIKit
import MessageUI

class HelpViewController: UIViewController, MFMailComposeViewControllerDelegate {
    
    @IBOutlet var lblPhone : UILabel!
    @IBOutlet var lblPhone1 : UILabel!
    @IBOutlet var lblEmail : UILabel!
    
    @IBOutlet weak var navigationBar:UIView! {
         didSet {
             navigationBar.backgroundColor = NAVIGATION_BACKGROUND_COLOR
         }
     }
    
    @IBOutlet weak var lblNavigationTitle:UILabel! {
         didSet {
             lblNavigationTitle.text = "HELP"
             lblNavigationTitle.textColor = .white
         }
     }
    override func viewDidLoad() {
        super.viewDidLoad()
        // self.navigationController?.setNavigationBarHidden(true, animated: true)
       
        self.navigationController?.setNavigationBarHidden(true, animated: true)
       //  self.helpAPI()
        
        self.setupLabelTap()
       self.setupLabelTap1()
        self.setupLabel1Tap()
        
    }
    
    @IBOutlet weak var btnBack:UIButton! {
        didSet {
             btnBack.tintColor = .white
            self.btnBack.setBackgroundImage(UIImage(systemName: "arrow.left"), for: .normal)
            btnBack.addTarget(self, action: #selector(backClickMethod), for: .touchUpInside)
            
        }
    }
    @objc func backClickMethod()
    {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func labelTapped(_ sender: UITapGestureRecognizer)
    {
        
        if let url = URL(string: "telprompt://5205758623"), UIApplication.shared.canOpenURL(url) {
                          if #available(iOS 10, *) {
                              UIApplication.shared.open(url)
                          } else {
                              UIApplication.shared.openURL(url)
                          }
                      }
    }
    
      @objc func labelTapped1(_ sender: UITapGestureRecognizer)
         {
             
               if let url = URL(string: "telprompt://8885205400"), UIApplication.shared.canOpenURL(url) {
                                if #available(iOS 10, *) {
                                    UIApplication.shared.open(url)
                                } else {
                                    UIApplication.shared.openURL(url)
                                }
                            }
         }
    
    
    func setupLabelTap1()
    {
        let labelTap1 = UITapGestureRecognizer(target: self, action: #selector(self.labelTapped1(_:)))
        self.lblPhone1.isUserInteractionEnabled = true
        self.lblPhone1.addGestureRecognizer(labelTap1)
                   
            
    }
    
    func setupLabelTap() {
        
        let labelTap = UITapGestureRecognizer(target: self, action: #selector(self.labelTapped(_:)))
        self.lblPhone.isUserInteractionEnabled = true
        self.lblPhone.addGestureRecognizer(labelTap)
      
    }
    
    @objc func label1Tapped(_ sender: UITapGestureRecognizer) {
        print("labelTapped")
        let mailComposeViewController = configuredMailComposeViewController()
        if MFMailComposeViewController.canSendMail() {
            self.present(mailComposeViewController, animated: true, completion: nil)
        } else {
            self.showSendMailErrorAlert()
        }
        
    }
    
    func configuredMailComposeViewController() -> MFMailComposeViewController {
        let mailComposerVC = MFMailComposeViewController()
        mailComposerVC.mailComposeDelegate = self // Extremely important to set the --mailComposeDelegate-- property, NOT the --delegate-- property
        
        mailComposerVC.setToRecipients(["intake@jorgensenbrooks.com"])
        //                    mailComposerVC.setSubject("")
        //                    mailComposerVC.setMessageBody("", isHTML: false)
        return mailComposerVC
    }
    func showSendMailErrorAlert()
    {
        let alert = UIAlertController(title:"Could Not Send Email", message: String("Your device could not send e-mail.  Please check e-mail configuration and try again."), preferredStyle: UIAlertController.Style.alert)
                   alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                     
                   }))
                   
                   self.present(alert, animated: true, completion: nil)
            
    }
    
    // MARK: MFMailComposeViewControllerDelegate Method
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
    func setupLabel1Tap() {
        
        let labelTap = UITapGestureRecognizer(target: self, action: #selector(self.label1Tapped(_:)))
        self.lblEmail.isUserInteractionEnabled = true
        self.lblEmail.addGestureRecognizer(labelTap)
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    
}
