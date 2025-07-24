//
//  MenuControllerVC.swift
//  SidebarMenu
//
//  Created by Apple  on 16/10/19.
//  Copyright © 2019 AppCoda. All rights reserved.
//

import UIKit
// import Alamofire

class MenuControllerVC: UIViewController {
    @IBOutlet weak var navigationBar:UIView! {
        didSet {
            navigationBar.backgroundColor = NAVIGATION_BACKGROUND_COLOR
        }
    }
    @IBOutlet weak var viewUnderNavigation:UIView! {
        didSet {
            viewUnderNavigation.backgroundColor = .white
        }
    }
    @IBOutlet weak var lblNavigationTitle:UILabel! {
        didSet {
            lblNavigationTitle.text = "DASHBOARD"
            lblNavigationTitle.textColor = .white
        }
    }
    @IBOutlet weak var imgSidebarMenuImage:UIImageView! {
        didSet {
            imgSidebarMenuImage.backgroundColor = .white
            imgSidebarMenuImage.layer.cornerRadius = 5
            imgSidebarMenuImage.clipsToBounds = true
        }
    }
    
    @IBAction func callClickMethod(_ sender : UIButton)
       {
        
             if let url = URL(string: "telprompt://5205758623"), UIApplication.shared.canOpenURL(url) {
                 if #available(iOS 10, *) {
                     UIApplication.shared.open(url)
                 } else {
                     UIApplication.shared.openURL(url)
                 }
             }
         }
    
    @IBAction func callNewClickMethod(_ sender : UIButton)
    {
           
                if let url = URL(string: "telprompt://8885205400"), UIApplication.shared.canOpenURL(url) {
                    if #available(iOS 10, *) {
                        UIApplication.shared.open(url)
                    } else {
                        UIApplication.shared.openURL(url)
                    }
                }
            }
       
    
    @IBOutlet weak var lblUserName:UILabel! {
        didSet {
            lblUserName.text = "JBG Clinical Care"
        }
    }
    @IBOutlet weak var lblPhoneNumber:UILabel!
    @IBOutlet var menuButton:UIButton!
    @IBOutlet weak var tbleView: UITableView! {
        didSet {
            tbleView.delegate = self
            tbleView.dataSource = self
            tbleView.tableFooterView = UIView.init()
            tbleView.backgroundColor = .clear
            // tbleView.separatorInset = UIEdgeInsets(top: 0, left: 50, bottom: 0, right: 50)
            tbleView.separatorColor = .white
        }
    }
    @IBOutlet weak var lblMainTitle:UILabel!
    @IBOutlet weak var lblAddress:UILabel!
    let cellReuseIdentifier = "menuControllerVCTableCell"
    var bgImage: UIImageView?
    var roleIs:String!
    //var arrSidebarMenuTitle = ["Home","Parenting", "Aging","Balancing","Thriving","Working","Living","International","Help","Privacy Policy","Terms of Use","Logout"]
    //var arrSidebarMenuImage = ["home","parenting","aging","balancing","thriving","working","living","living","password1","help","logout","logout","logout"]
    
    var arrSidebarMenuTitle:[MenuOptionInfo] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        //self.sideBarMenuClick()
        self.tbleView.separatorColor = UIColor.init(red: 60.0/255.0, green: 110.0/255.0, blue: 160.0/255.0, alpha: 1)
        //self.view.backgroundColor = NAVIGATION_BACKGROUND_COLOR
        self.tbleView.backgroundColor = NAVIGATION_BACKGROUND_COLOR
        self.view.backgroundColor = NAVIGATION_BACKGROUND_COLOR
        self.setUpLsitData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        if let person = UserDefaults.standard.value(forKey: "keyLoginFullData") as? [String:Any] {
            // print(person as Any)
            
            // member
            /*
             ["BusinessAddress": , "drivingLicenseFront": , "deviceToken": , "CompanyName": , "DealIn": , "drivingLicenseBack": , "BusinessPhone": , "role": Member, "contactNumber": 2322523641, "socialId": , "employerId": 197, "department": Virtual Department, "website": , "email": kiwi@mailinator.com, "userId": 201, "socialType": , "image": http://demo2.evirtualservices.com/auto-genius/site/img/uploads/users/1584707412IMG_20191127_095409.jpg, "zipCode": , "documents": , "CompanyStrength": , "BusinessCategory": , "lastName": , "experence": 2, "device": , "designation": new, "firebaseId": , "fullName": kiwi, "address": sector11, "totalEmployee": 0]
             (lldb)
             */
            
            
            /*
             vendor
             
             ["designation": , "fullName": dishant rajput, "address": New Delhi, "website": all.com, "employerId": , "BusinessCategory": all category, "device": , "lastName": , "CompanyStrength": 1000000, "deviceToken": , "zipCode": , "email": dishantrajput@gmail.com, "BusinessPhone": 1234567890, "drivingLicenseBack": , "userId": 211, "CompanyName": lm, "contactNumber": 1234567890, "socialType": , "socialId": , "totalEmployee": 1, "image": , "documents": , "BusinessAddress": lm address, "experence": , "department": , "drivingLicenseFront": , "role": Vendor, "DealIn": all deals, "firebaseId": ]
             (lldb)
             
             */
            
            if person["role"] as! String == "Member" {
                self.lblUserName.text = (person["fullName"] as! String)
                self.lblPhoneNumber.text = (person["contactNumber"] as! String)
            } else {
                self.lblUserName.text = (person["fullName"] as! String)
                self.lblPhoneNumber.text = (person["contactNumber"] as! String)
            }
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    @objc func sideBarMenuClick() {
        if revealViewController() != nil {
            menuButton.addTarget(self.revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)), for: .touchUpInside)
            
            revealViewController().rearViewRevealWidth = 300
            view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
    }
    
    //MARK: - Helper
    
    func setUpLsitData(){
        self.arrSidebarMenuTitle.insert(MenuOptionInfo.init(name: "Home", icon: "home", index: 0), at: 0)
        self.arrSidebarMenuTitle.append(MenuOptionInfo.init(name: "Parenting", icon: "parenting", index: 1))
        self.arrSidebarMenuTitle.append(MenuOptionInfo.init(name: "Aging", icon: "aging", index: 2))
        self.arrSidebarMenuTitle.append(MenuOptionInfo.init(name: "Balancing", icon: "balancing", index: 3))
        self.arrSidebarMenuTitle.append(MenuOptionInfo.init(name: "Thriving", icon: "thriving", index: 4))
        self.arrSidebarMenuTitle.append(MenuOptionInfo.init(name: "Working", icon: "working", index: 5))
        self.arrSidebarMenuTitle.append(MenuOptionInfo.init(name: "Living", icon: "living", index: 6))
        self.arrSidebarMenuTitle.append(MenuOptionInfo.init(name: "International", icon: "International", index: 7))
        self.arrSidebarMenuTitle.append(MenuOptionInfo.init(name: "Help", icon: "help", index: 8))
        self.arrSidebarMenuTitle.append(MenuOptionInfo.init(name: "Privacy Policy", icon: "help", index: 9))
        self.arrSidebarMenuTitle.append(MenuOptionInfo.init(name: "Terms Of Use", icon: "help", index: 10))
        self.arrSidebarMenuTitle.append(MenuOptionInfo.init(name: "Logout", icon: "logout", index: 11))
    }
    
    @IBAction func facebookActions(_ sender : Any)
      {
          if let url = URL(string: "https://www.facebook.com/JorgensenBrooks/") {
              UIApplication.shared.open(url)
          }
      }
      
      @IBAction func twitterActions(_ sender : Any)
      {
          if let url = URL(string: "https://twitter.com/JBGEAP") {
              UIApplication.shared.open(url)
          }
      }
      
      @IBAction func instaActions(_ sender : Any){
          
          if let url = URL(string: "https://www.instagram.com/jorgensenbrooksgroup/") {
              UIApplication.shared.open(url)
          }
      }
      
      @IBAction func linkinActions(_ sender : Any){
          
          if let url = URL(string: "https://www.linkedin.com/company/68260057/") {
              UIApplication.shared.open(url)
          }
      }
    //MARK: - IBAction
    
    @IBAction func tapDismisMenuVc(_ sender : UIButton){
        self.dismiss(animated: true, completion: nil)
    }
}

extension MenuControllerVC: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrSidebarMenuTitle.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:MenuControllerVCTableCell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier) as! MenuControllerVCTableCell
        cell.backgroundColor = .clear
        cell.separatorInset = UIEdgeInsets.zero
        cell.layoutMargins = UIEdgeInsets.zero
        cell.lblName.text = arrSidebarMenuTitle[indexPath.row].name
        cell.imgProfile.image = UIImage(named: arrSidebarMenuTitle[indexPath.row].icon)
        cell.imgProfile.backgroundColor = .clear
        cell.lblName.textColor = .white
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        self.loadViewWithCurrentIndex(selectedIndex: indexPath.row)
    }
    
    func loadViewWithCurrentIndex(selectedIndex: Int) {
        let menuOption = arrSidebarMenuTitle[selectedIndex]
        switch menuOption.index {
        case 0:
            self.dismiss(animated: true, completion: nil)
            
        case 1:
            let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ParentingId") as? Parenting
            self.navigationController?.pushViewController(push!, animated: true)
            break
        case 2:
            let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "AgingDashboard") as? AgingDashboard
            self.navigationController?.pushViewController(push!, animated: true)
            break
        case 3:
            let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "BalancingListViewController") as? BalancingListViewController
            self.navigationController?.pushViewController(push!, animated: true)
            break
        case 4:
            let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ThrivingListViewController") as? ThrivingListViewController
            self.navigationController?.pushViewController(push!, animated: true)
            break
        case 5:
            let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "WorkingListViewController") as? WorkingListViewController
            self.navigationController?.pushViewController(push!, animated: true)
            break
        case 6:
            let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "LivingListViewController") as? LivingListViewController
            self.navigationController?.pushViewController(push!, animated: true)
            break
        case 7:
            let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "InternationalListViewController") as? InternationalListViewController
            self.navigationController?.pushViewController(push!, animated: true)
            break
        case 8:
            let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "HelpViewController") as? HelpViewController
            self.navigationController?.pushViewController(push!, animated: true)
            break
        case 9:
            let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "TermsViewController") as? TermsViewController
            push?.matchSelect = "privacy"
            self.navigationController?.pushViewController(push!, animated: true)
            break
        case 10:
            let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "TermsViewController") as? TermsViewController
          
            self.navigationController?.pushViewController(push!, animated: true)
            break
        default:
            
            
            let alert = UIAlertController(title: String("Logout"), message: String("Are you sure you want to logout?"), preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Yes, Logout", style: .default, handler: { action in
                
                let defaults = UserDefaults.standard
                defaults.setValue("Match", forKey: "keyRememberMe")
              //  defaults.setValue(nil, forKey: "keyRememberMe")
                
                let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "EnterPasswordId") as? EnterPassword
                self.navigationController?.pushViewController(push!, animated: true)
          
            }))
            alert.addAction(UIAlertAction(title: "Dismiss", style: .destructive, handler: { action in
             }))
            self.present(alert, animated: true, completion: nil)
      
            break
        }
    }
    
}

extension MenuControllerVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
}
