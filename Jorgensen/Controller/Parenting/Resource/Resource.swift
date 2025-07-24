//
//  Resource.swift
//  Jorgensen
//
//  Created by Apple on 04/09/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import UIKit

class Resource: UIViewController {

    let cellReuseIdentifier = "resourceTableCell"
    
    // MARK:- CUSTOM NAVIGATION BAR -
    @IBOutlet weak var navigationBar:UIView! {
        didSet {
            navigationBar.backgroundColor = NAVIGATION_BACKGROUND_COLOR
        }
    }

    // MARK:- CUSTOM NAVIGATION TITLE -
    @IBOutlet weak var lblNavigationTitle:UILabel! {
        didSet {
            lblNavigationTitle.text = "RESOURCES"
            lblNavigationTitle.textColor = .white
        }
    }
    
    @IBOutlet weak var btnBack:UIButton! {
        didSet {
            btnBack.tintColor = .white
        }
    }
    
    @IBOutlet weak var tbleView: UITableView! {
            didSet {
                self.tbleView.delegate = self
                self.tbleView.dataSource = self
                self.tbleView.backgroundColor = .clear
                self.tbleView.tableFooterView = UIView.init(frame: CGRect(origin: .zero, size: .zero))
            }
        }
        
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(true, animated: true)
            
        self.tbleView.separatorColor = .black // UIColor.init(red: 235.0/255.0, green: 235.0/255.0, blue: 235.0/255.0, alpha: 1)
            
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


extension Resource: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
        
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 20
    }
        
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:ResourceTableCell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier) as! ResourceTableCell
        
        let backgroundView = UIView()
        backgroundView.backgroundColor = .clear
        cell.selectedBackgroundView = backgroundView
            
        cell.separatorInset = UIEdgeInsets.zero
        cell.layoutMargins = UIEdgeInsets.zero
        cell.accessoryType = .disclosureIndicator
        
        cell.lblName.text = "Family history research questions to ask your relatives"
            
        return cell
    }
  
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView .deselectRow(at: indexPath, animated: true)
            
         let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ResourceDetailsqId") as? ResourceDetails
         self.navigationController?.pushViewController(push!, animated: true)
            
    }
        
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

extension Resource: UITableViewDelegate {
        
}

