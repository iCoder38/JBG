//
//  Audio.swift
//  Jorgensen
//
//  Created by Apple on 04/09/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import UIKit
import IHProgressHUD

class Audio: UIViewController,UITextFieldDelegate {
    
    let cellReuseIdentifier = "audioTableCell"
    var matchIdSelect:String!
    var matchTitleSelect:String!
    var matchCategory:String!
    var matchSubCategory:String!
    var dictevent = Dictionary<String , Any>()
    var searchArray : NSArray! = []
    var searchArrRes = [[String:Any]]()
    var originalArr = [[String:Any]]();
    var arrTitle = NSMutableArray()
    var sipagingEnable = true
    var dictDetailEvent = Dictionary<String , Any>()
    var searching:Bool = false
    var devesionIdCategory:String!
    var matchTitleShowSelect:String!
    
    
    @IBOutlet weak var feeTextField: UITextField!
    // MARK:- CUSTOM NAVIGATION BAR -
    @IBOutlet weak var navigationBar:UIView! {
        didSet {
            navigationBar.backgroundColor = NAVIGATION_BACKGROUND_COLOR
        }
    }
    
    // MARK:- CUSTOM NAVIGATION TITLE -
    @IBOutlet weak var lblNavigationTitle:UILabel! {
        didSet {
           
            lblNavigationTitle.text = self.matchTitleShowSelect.uppercased()
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
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        self.tbleView.reloadData();
        return true
    }
    
    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool{
        //input text
        let searchText  = textField.text! + string
        searchArrRes = self.originalArr.filter({(($0["title"] as! String).localizedCaseInsensitiveContains(searchText))})
        
        if(searchArrRes.count == 0){
            searching = false
        }else{
            searching = true
        }
        
        self.tbleView.reloadData();
        
        return true
    }
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        arrTitle = NSMutableArray()
        self.loadListMessages()
        
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
    
    
    func loadListMessages()
    {
        IHProgressHUD.show(withStatus: "Please wait...")
        
        let url = URL(string: "https://www.powerflexweb.com/api_content/common/read.php")!
        var request = URLRequest(url: url)
        
        request.httpMethod = "POST"
        
        let bodydd = "id_language=en-US&token=eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpZF9lYXAiOiIxNjUxIiwiaWRfY29tcGFueSI6MTY1MTI2NTY3fQ.FznzxAPBbFF9kI2Vd6G39P6kO431dztk8TN9VYir-jY&api_id=1651&id_module=\(self.matchCategory!)&id-category=\(self.matchSubCategory!)&id_element=\(self.matchIdSelect!)&id_division=\(self.devesionIdCategory!)&columns=id_cr,title,id_element,body_combine&order_by=title&order_direction=asc&top_content="
        
        request.httpBody = bodydd.data(using: String.Encoding.utf8)
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            
            DispatchQueue.main.async(execute: {
                
                if error == nil {
                    
                    do {
                        
                        let json : NSDictionary? = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? NSDictionary
                        
                        
                        guard let parseJSON = json else {
                            IHProgressHUD.dismiss()
                            Alert.showTostMessage(message:"Error while parsing" as String, delay: 3.0, controller: self)
                            
                            return
                        }
                        
                        DispatchQueue.main.async() {
                            IHProgressHUD.dismiss()
                            
                             if(parseJSON["message"] == nil)
                                                       {
                                                         self.originalArr = parseJSON["content"] as! [[String : Any]]
                                                         self.tbleView.reloadData()
                                                       }
                                                       else
                                                       {
                                                         let msg = parseJSON["message"] as! String
                                                           Alert.showTostMessage(message:msg as String, delay: 3.0, controller: self)
                                                           
                                                       }
                            
                            
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
   
    // MARK:- BACK -
    @objc func backClickMethod() {
        self.navigationController?.popViewController(animated: true)
    }
}

extension Audio: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if( searching == true)
        {
            return searchArrRes.count
        }else
        {
            if originalArr.count == 0 {
                return 0
            }
            else  if originalArr.count <= 10
            {
                return originalArr.count
            }
            else
            {
                return 10
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell:AudioTableCell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier) as! AudioTableCell
        
        let backgroundView = UIView()
        backgroundView.backgroundColor = .clear
        cell.selectedBackgroundView = backgroundView
        
        cell.separatorInset = UIEdgeInsets.zero
        cell.layoutMargins = UIEdgeInsets.zero
        cell.accessoryType = .disclosureIndicator
        
        if(searching == true)
        {
            dictevent = searchArrRes[indexPath.row] as? Dictionary<String, Any> ?? Dictionary<String, Any> ()
            cell.lblName.text =  dictevent["title"] as? String ?? ""
        }
        else
        {
            
            dictevent = originalArr[indexPath.row] as? Dictionary<String, Any> ?? Dictionary<String, Any> ()
           
            let htmlString = dictevent["title"] as? String ?? ""
            let attr = try? NSAttributedString(htmlString: htmlString, font: UIFont.systemFont(ofSize: 34, weight: .regular))
            
            cell.lblName.text = htmlString
            
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView .deselectRow(at: indexPath, animated: true)
        
        if(searching == true)
        {
            dictevent = searchArrRes[indexPath.row] as? Dictionary<String, Any> ?? Dictionary<String, Any> ()
            
        }
        else
        {
            dictevent = originalArr[indexPath.row] as? Dictionary<String, Any> ?? Dictionary<String, Any> ()
        }
        
        
        let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ArticleDetailsId") as? ArticleDetails
        push?.dictdetail = dictevent as NSDictionary
        self.navigationController?.pushViewController(push!, animated: true)
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
}

extension Audio: UITableViewDelegate {
    
}
