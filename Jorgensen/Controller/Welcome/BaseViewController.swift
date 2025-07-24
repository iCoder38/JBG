//
//  BaseViewController.swift
//  Jorgensen
//
//  Created by Shyam on 27/10/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    // MARK: - Helper
    
    func showProgress(titleStr: String = "Please wait...") {
        CustomProgressViewController.showCustomProgressHud(loaderStr: titleStr)
    }
    
    func hideProgress() {
        CustomProgressViewController.hideCustomProgressHud()
    }
    
    @IBAction func tapBackVc(_ sender : UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
}
