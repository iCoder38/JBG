//
//  TermsViewController.swift
//  Verteus
//
//  Created by IOSdev on 12/31/18.
//  Copyright © 2018 EVS. All rights reserved.
//

import UIKit
import WebKit

class TermsViewController: UIViewController  {
    
    @IBOutlet weak var webView: WKWebView!
    @IBOutlet var txtTerms : UITextView!
    @IBOutlet var buttonCheck : UIButton!
    var matchSelect:String!
    
    @IBOutlet weak var navigationBar:UIView! {
        didSet {
            navigationBar.backgroundColor = NAVIGATION_BACKGROUND_COLOR
        }
    }
    
    @IBOutlet weak var lblNavigationTitle:UILabel! {
        didSet {
            if self.matchSelect == "privacy"
            {
                lblNavigationTitle.text = "PRIVACY POLICY"
                lblNavigationTitle.textColor = .white
            }
            else{
                lblNavigationTitle.text = "TERMS OF USE"
                lblNavigationTitle.textColor = .white
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if self.matchSelect == "privacy"
        {
            let url = URL(string: "https://www.workplaceoptions.com/privacy-policy/")
            webView.load(URLRequest(url: url!))
        }
        else
        {
            let url = URL(string: "https://www.workplaceoptions.com/terms-of-use/")
            webView.load(URLRequest(url: url!))
        }
        
         self.loadNavBar()
      
    }
    
    
    func loadNavBar()
    {
        self.navigationController?.isNavigationBarHidden = false
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        
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
    
    
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
