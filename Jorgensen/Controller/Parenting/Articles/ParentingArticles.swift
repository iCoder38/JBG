//
//  ParentingArticles.swift
//  Jorgensen
//
//  Created by Apple on 04/09/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import UIKit
import IHProgressHUD

class ParentingArticles: UIViewController, UITextFieldDelegate {
    
    let cellReuseIdentifier = "parentingArticlesTableCell"
    @IBOutlet weak var categoryScrollView: UIScrollView!
    var buttonColors = [UIColor.green, UIColor.blue, UIColor.black, UIColor.cyan, UIColor.magenta]
    var currIndex = 0
    let kPadding:CGFloat = 10
    var categoryArr = NSArray()
    var searchArray : NSArray! = []
    var searchArrRes = [[String:Any]]()
    var originalArr = [[String:Any]]();
    var devesionIdCategory:String!
    var matchTitleShowSelect:String!
    var searching:Bool = false
    var dictevent = Dictionary<String , Any>()
    var matchIdSelect:String!
    var matchTitleSelect:String!
    var matchCategory:String!
    var matchSubCategory:String!
    @IBOutlet weak var feeTextField: UITextField!
    @IBOutlet weak var leftButton: UIButton!
    @IBOutlet weak var rightButton: UIButton!
    
    var arrTitle = NSMutableArray()
    var sipagingEnable = true
    var dictDetailEvent = Dictionary<String , Any>()
    
    
    
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
                            
                            // let msg = parseJSON["message"] as! String
                            
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
                            
                            //                            if(tempArr.count == 0)
                            //                            {
                            //                                self.sipagingEnable = false
                            //                            }
                            //                            else
                            //                            {
                            //                                //self.arrTitle .addObjects(from: tempArr as! [Any]) as? NSMutableArray
                            //
                            //                            }
                            
                            
                            
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
    
    func loadMessages()
    {
        IHProgressHUD.show(withStatus: "Please wait...")
        
        let url = URL(string: "https://www.powerflexweb.com/api_content/common/read_mod.php")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        var body: Any!
        
        if self.matchTitleSelect == "Parenting"
        {
            body = "id_language=en-US&id_module=m002,m003,m004,m006,m005,m001&token=eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpZF9lYXAiOiIxNjUxIiwiaWRfY29tcGFueSI6MTY1MTI2NTY3fQ.FznzxAPBbFF9kI2Vd6G39P6kO431dztk8TN9VYir-jY&api_id=1651"
            
        }
        if self.matchTitleSelect == "Aging"
        {
            body = "id_language=en-US&id_module=m007,m008,m009,m010,m011,m012,m013,m014,m015,&token=eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpZF9lYXAiOiIxNjUxIiwiaWRfY29tcGFueSI6MTY1MTI2NTY3fQ.FznzxAPBbFF9kI2Vd6G39P6kO431dztk8TN9VYir-jY&api_id=1651"
            
        }
        if self.matchTitleSelect == "Balancing"
        {
            body = "id_language=en-US&id_module=m022,m017,m018,m020,m021,m016,m019&token=eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpZF9lYXAiOiIxNjUxIiwiaWRfY29tcGFueSI6MTY1MTI2NTY3fQ.FznzxAPBbFF9kI2Vd6G39P6kO431dztk8TN9VYir-jY&api_id=1651"
            
        }
        if self.matchTitleSelect == "Thriving"
        {
            body = "id_language=en-US&id_module=m029,m028,m033,m025,m027,m024,m026,m031,m032,m030&token=eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpZF9lYXAiOiIxNjUxIiwiaWRfY29tcGFueSI6MTY1MTI2NTY3fQ.FznzxAPBbFF9kI2Vd6G39P6kO431dztk8TN9VYir-jY&api_id=1651"
            
        }
        if self.matchTitleSelect == "Working"
        {
            body = "id_language=en-US&id_module=m034,m036,m455,m035,m037,m038,m039,m324&token=eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpZF9lYXAiOiIxNjUxIiwiaWRfY29tcGFueSI6MTY1MTI2NTY3fQ.FznzxAPBbFF9kI2Vd6G39P6kO431dztk8TN9VYir-jY&api_id=1651"
            
        }
        if self.matchTitleSelect == "Living"
        {
            body = "id_language=en-US&id_module=m312,m319,m316,m323,m451,m314,m313,m317,m318,m315,m321,m320,m322&token=eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpZF9lYXAiOiIxNjUxIiwiaWRfY29tcGFueSI6MTY1MTI2NTY3fQ.FznzxAPBbFF9kI2Vd6G39P6kO431dztk8TN9VYir-jY&api_id=1651"
            
        }
        if self.matchTitleSelect == "International"
        {
            body = "id_language=en-US&id_module=m301,m305,m300,m303,m302,m306,m304&token=eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpZF9lYXAiOiIxNjUxIiwiaWRfY29tcGFueSI6MTY1MTI2NTY3fQ.FznzxAPBbFF9kI2Vd6G39P6kO431dztk8TN9VYir-jY&api_id=1651"
            
        }
        
        
        request.httpBody = (body as AnyObject).data(using: String.Encoding.utf8.rawValue)
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            
            DispatchQueue.main.async(execute: {
                
                if error == nil {
                    IHProgressHUD.dismiss()
                    do {
                        
                        let json : NSDictionary? = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? NSDictionary
                        
                        guard let parseJSON = json else {
                            IHProgressHUD.dismiss()
                            Alert.showTostMessage(message:"Error while parsing" as String, delay: 3.0, controller: self)
                            
                            return
                        }
                        
                        DispatchQueue.main.async() {
                            
                            self.categoryArr = (parseJSON["content"] as? NSArray)!
                            
                            let buttonSize = CGSize(width:self.self.categoryScrollView.bounds.size.width-10, height: self.categoryScrollView.bounds.size.height)//hal
                            
                            let scrollingView = self.colorButtonsView(buttonSize: buttonSize, buttonCount: self.categoryArr.count)
                            self.categoryScrollView.contentSize = scrollingView.frame.size
                            self.categoryScrollView.addSubview(scrollingView)
                            self.categoryScrollView.showsVerticalScrollIndicator = false
                            self.categoryScrollView.delegate = self
                            self.categoryScrollView.isPagingEnabled = true
                            self.categoryScrollView.indicatorStyle = .default
                            self.categoryScrollView.contentOffset = CGPoint(x: 0, y: 0)
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
    
    @IBAction func morebuttonClick(_ sender : Any)
    {
        let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "AudioId") as? Audio
        push?.matchTitleSelect = self.matchTitleSelect
        push?.matchCategory = self.matchCategory
        push?.matchSubCategory = self.matchSubCategory
        push?.matchIdSelect = self.matchIdSelect
        push?.devesionIdCategory = self.devesionIdCategory
        push?.matchTitleShowSelect = self.matchTitleShowSelect
        
        self.navigationController?.pushViewController(push!, animated: true)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        leftButton.addTarget(self, action: #selector(leftButtonTapped), for: .touchUpInside)
        rightButton.addTarget(self, action: #selector(rightButtonTapped), for: .touchUpInside)  // add those two lines right after buttons' initialization.
        
        
        self.categoryScrollView.layer.cornerRadius = 5
        self.categoryScrollView.clipsToBounds = true
        
        arrTitle = NSMutableArray()
        self.loadListMessages()
        
        
        
        self.loadMessages()
        
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        
        self.tbleView.separatorColor = UIColor.init(red: 235.0/255.0, green: 235.0/255.0, blue: 235.0/255.0, alpha: 1)
        
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
    
    
    func colorButtonsView(buttonSize:CGSize, buttonCount:Int) -> UIView {
        let buttonView = UIView()
        buttonView.frame.origin = CGPoint(x: 0,y: 0)
        let padding = CGSize(width: 10, height: 0)
        buttonView.frame.size.width = (buttonSize.width + padding.width) * CGFloat(buttonCount)
        var buttonPosition = CGPoint(x: padding.width * 0.5, y: padding.height)
        let buttonIncrement = buttonSize.width + padding.width
        for i in 0...(buttonCount-1)
        {
            var button = UIButton(type: .custom)
            button.frame.size = buttonSize
            button.frame.origin = buttonPosition
            // button.backgroundColor = buttonColors[i]
            buttonPosition.x = buttonPosition.x + buttonIncrement
            dictevent = categoryArr[i] as? Dictionary<String, Any> ?? Dictionary<String, Any> ()
            button.titleLabel?.numberOfLines = 2
            button.setTitle(dictevent["native_term"] as? String, for: UIControl.State.normal)
            buttonView.addSubview(button)
        }
        return buttonView
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
    @objc func leftButtonTapped() {
        if categoryScrollView.contentOffset.x > 0 {
            categoryScrollView.contentOffset.x -=  (self.categoryScrollView.bounds.width - 20)
        }
    }
    
    @objc func rightButtonTapped() {
        
        if categoryScrollView.contentOffset.x < self.categoryScrollView.bounds.width * CGFloat(categoryArr.count-1) {
            categoryScrollView.contentOffset.x +=  (self.categoryScrollView.bounds.width + 20)
        }
    }
    
}



extension ParentingArticles: UITableViewDataSource {
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
        let cell:ParentingArticlesTableCell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier) as! ParentingArticlesTableCell
        
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
            
            cell.lblName.text =  dictevent["title"] as? String ?? ""
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
        return UITableView.automaticDimension
    }
}


extension ParentingArticles: UITableViewDelegate
{
    
}

extension ParentingArticles:UIScrollViewDelegate
{
   func scrollViewDidEndDecelerating(scrollView: UIScrollView)
   {
        let index = round(scrollView.contentOffset.x / scrollView.frame.size.width)
        print(index)
    }
    
}
