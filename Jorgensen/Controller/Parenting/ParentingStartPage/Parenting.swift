//
//  Parenting.swift
//  Jorgensen
//
//  Created by Apple on 04/09/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import UIKit
import IHProgressHUD

class Parenting: BaseViewController {

    let cellReuseIdentifier = "parentingTableCell"
    var msg:String? = nil
    var arrTitle = NSMutableArray()
    var sipagingEnable = true
    var dictevent = Dictionary<String , Any>()
       
   // var arrTitle = ["Parenting","Adoption","Child Care"]
    
    // MARK:- CUSTOM NAVIGATION BAR -
    @IBOutlet weak var navigationBar:UIView! {
        didSet {
            navigationBar.backgroundColor = NAVIGATION_BACKGROUND_COLOR
        }
    }

    // MARK:- CUSTOM NAVIGATION TITLE -
    @IBOutlet weak var lblNavigationTitle:UILabel! {
        didSet {
            lblNavigationTitle.text = "PARENTING"
            lblNavigationTitle.textColor = .white
        }
    }
    
    @IBOutlet weak var iconImageview:UIImageView! {
           didSet {
            iconImageview.image = UIImage(named: "parenting")

              
           }
       }
    
    @IBOutlet weak var btnBack:UIButton! {
        didSet {
            btnBack.tintColor = .white
        }
    }
    
    func loadMessages()
    {
        IHProgressHUD.show(withStatus: "Please wait...")
           
        let url = URL(string: "https://www.powerflexweb.com/api_content/common/read_mod.php")!
         var request = URLRequest(url: url)

        request.httpMethod = "POST"
        
        let body = "id_language=en-US&id_module=m002,m003,m004,m006,m005,m001&token=eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpZF9lYXAiOiIxNjUxIiwiaWRfY29tcGFueSI6MTY1MTI2NTY3fQ.FznzxAPBbFF9kI2Vd6G39P6kO431dztk8TN9VYir-jY&api_id=1651"
        request.httpBody = body.data(using: String.Encoding.utf8)

        URLSession.shared.dataTask(with: request) { data, response, error in

            DispatchQueue.main.async(execute: {

                if error == nil {
                   IHProgressHUD.dismiss()
                    do {

                        let json : NSDictionary? = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? NSDictionary
                        
                        print(json)

                       
                        guard let parseJSON = json else {
                             IHProgressHUD.dismiss()
                                  Alert.showTostMessage(message:"Error while parsing" as String, delay: 3.0, controller: self)

                            return
                        }
                        
                        DispatchQueue.main.async() {
                            
                            let tempArr = parseJSON["content"] as? NSArray
                            if(tempArr!.count == 0) {
                                self.sipagingEnable = false
                            } else {
                                self.arrTitle .addObjects(from: tempArr as! [Any]) as? NSMutableArray
                                
                            }
                            self.tbleView.reloadData()
                        }

                    } catch
                    {
                         print(error)
                         IHProgressHUD.dismiss()
                        Alert.showTostMessage(message:error.localizedDescription as String, delay: 3.0, controller: self)
                        return
                    }

                } else {
                }

            })

            }.resume()

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
       
                arrTitle = NSMutableArray()
                self.loadMessages()
        
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        
        self.tbleView.separatorColor = .clear
        
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

extension Parenting: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrTitle.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:ParentingTableCell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier) as! ParentingTableCell
    
        let backgroundView = UIView()
        backgroundView.backgroundColor = .clear
        cell.selectedBackgroundView = backgroundView
        
        dictevent = arrTitle[indexPath.row] as? Dictionary<String, Any> ?? Dictionary<String, Any> ()
        
        cell.lblName.text =  dictevent["native_term"] as? String ?? ""
       
        cell.imgImage.backgroundColor = .orange
        
        return cell
    }

    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView .deselectRow(at: indexPath, animated: true)
      
        dictevent = arrTitle[indexPath.row] as? Dictionary<String, Any> ?? Dictionary<String, Any> ()
      
        let str = dictevent["name_division"] as? String ?? ""
        
        if str == "Parenting"
        {
           
            let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "CategoryViewController") as? CategoryViewController
            push!.dictdetail =  dictevent as NSDictionary
            push!.matchTitleSelect = str
            push!.matchSelect =  dictevent["id_module"] as? String ?? ""
            self.navigationController?.pushViewController(push!, animated: true)
      
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
}

extension Parenting: UITableViewDelegate {
    
}

