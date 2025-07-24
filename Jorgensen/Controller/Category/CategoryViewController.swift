//
//  CategoryViewController.swift
//  Jorgensen
//
//  Created by santosh kumar singh on 02/11/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import UIKit
import IHProgressHUD

class CategoryViewController: UIViewController {
    
    let cellReuseIdentifier = "parentingArticlesTableCell"
    var msg:String? = nil
    var dictdetail:NSDictionary?
    var arrTitle = NSMutableArray()
    var sipagingEnable = true
    var dictevent = Dictionary<String , Any>()
    var matchSelect:String!
    var matchTitleSelect:String!
    
    
    
    @IBOutlet weak var navigationBar:UIView! {
        didSet {
            navigationBar.backgroundColor = NAVIGATION_BACKGROUND_COLOR
        }
    }
    @IBOutlet weak var iconImageview:UIImageView! {
        didSet {
            
            if self.matchTitleSelect == "Parenting"
            {
                iconImageview.image = UIImage(named: "parenting")
            }
            if self.matchTitleSelect == "Aging"
            {
                iconImageview.image = UIImage(named: "aging")
            }
            if self.matchTitleSelect == "Balancing"
            {
                iconImageview.image = UIImage(named: "balancing")
            }
            if self.matchTitleSelect == "Thriving"
            {
                iconImageview.image = UIImage(named: "thriving")
            }
            if self.matchTitleSelect == "Working"
            {
                iconImageview.image = UIImage(named: "working")
            }
            if self.matchTitleSelect == "Living"
            {
                iconImageview.image = UIImage(named: "living")
            }
            if self.matchTitleSelect == "International"
            {
                iconImageview.image = UIImage(named: "International")
            }
            
        }
    }
    
    // MARK:- CUSTOM NAVIGATION TITLE -
    @IBOutlet weak var lblNavigationTitle:UILabel! {
        didSet
        {
            let str = dictdetail?["name_module"] as? String ?? ""
            lblNavigationTitle.text = str.uppercased()
            lblNavigationTitle.textColor = .white
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
        
        let url = URL(string: "https://www.powerflexweb.com/api_content/common/read_mod_cat.php")!
        var request = URLRequest(url: url)
        
        request.httpMethod = "POST"
        
        
        let body = "id_language=en-US&token=eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpZF9lYXAiOiIxNjUxIiwiaWRfY29tcGFueSI6MTY1MTI2NTY3fQ.FznzxAPBbFF9kI2Vd6G39P6kO431dztk8TN9VYir-jY&api_id=1651&id_module=\(self.matchSelect!)"
        
        request.httpBody = body.data(using: String.Encoding.utf8)
        
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
                            
                            let tempArr = parseJSON["content"] as? NSArray
                            if(tempArr!.count == 0)
                            {
                                self.sipagingEnable = false
                            }
                            else
                            {
                                self.arrTitle .addObjects(from: tempArr as! [Any]) as? NSMutableArray
                                
                                
                                //trendingArr.addObjects(from: tempArr as! [VideosData])
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
        
        self.tbleView.separatorColor = .gray
        
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

extension CategoryViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrTitle.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell:ParentingArticlesTableCell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier) as! ParentingArticlesTableCell
        
        let backgroundView = UIView()
        backgroundView.backgroundColor = .clear
        cell.selectedBackgroundView = backgroundView
        
        dictevent = arrTitle[indexPath.row] as? Dictionary<String, Any> ?? Dictionary<String, Any> ()
        
        cell.lblName.text =  dictevent["native_term"] as? String ?? ""
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        tableView .deselectRow(at: indexPath, animated: true)
        
        dictevent = arrTitle[indexPath.row] as? Dictionary<String, Any> ?? Dictionary<String, Any> ()
        let str = dictevent["native_term"] as? String ?? ""
        let str1 = dictevent["name_module"] as? String ?? ""
        
        // MARK:- Parenting category Parenting -
        if str1 == "Parenting"
        {
            if str == "Communicating with Young Children" {
                
                let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ParentingDashbaordId") as? ParentingDashbaord
                push?.matchCategory = dictevent["id_module"] as? String ?? ""
                push?.matchSubCategory = dictevent["id_category"] as? String ?? ""
                push?.matchTitleSelect = self.matchTitleSelect
                push?.devesionIdCategory = dictevent["id_division"] as? String ?? ""
                push?.matchTitleShowSelect = str1
                push?.arrParentingDashboardTitle = ["Articles","Online Seminars","Resources"]
                push?.arrParentingDashboardImage = ["note1","study2","care"]
                push?.arrParentingDashboardId = ["001","030","012"]
                
                self.navigationController?.pushViewController(push!, animated: true)
            }
            if str == "Considering Parenthood" {
                
                let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ParentingDashbaordId") as? ParentingDashbaord
                push?.matchCategory = dictevent["id_module"] as? String ?? ""
                push?.matchSubCategory = dictevent["id_category"] as? String ?? ""
                push?.matchTitleSelect = self.matchTitleSelect
                push?.matchTitleShowSelect = str1
                push?.devesionIdCategory = dictevent["id_division"] as? String ?? ""
                push?.arrParentingDashboardTitle = ["Articles","Resources"]
                push?.arrParentingDashboardImage = ["note1","care"]
                push?.arrParentingDashboardId = ["001","012"]
                self.navigationController?.pushViewController(push!, animated: true)
            }
            if str == "Children's Self-Esteem" {
                
                let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ParentingDashbaordId") as? ParentingDashbaord
                push?.matchCategory = dictevent["id_module"] as? String ?? ""
                push?.matchSubCategory = dictevent["id_category"] as? String ?? ""
                push?.matchTitleSelect = self.matchTitleSelect
                push?.matchTitleShowSelect = str1
                push?.devesionIdCategory = dictevent["id_division"] as? String ?? ""
                push?.arrParentingDashboardTitle = ["Articles","Online Seminars","Resources"]
                push?.arrParentingDashboardImage = ["note1","study2","care"]
                push?.arrParentingDashboardId = ["001","030","012"]
                self.navigationController?.pushViewController(push!, animated: true)
            }
            
            if str == "Family Activities and Goals"
            {
                
                let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ParentingDashbaordId") as? ParentingDashbaord
                push?.matchCategory = dictevent["id_module"] as? String ?? ""
                push?.matchSubCategory = dictevent["id_category"] as? String ?? ""
                push?.matchTitleSelect = self.matchTitleSelect
                push?.matchTitleShowSelect = str1
                push?.devesionIdCategory = dictevent["id_division"] as? String ?? ""
                push?.arrParentingDashboardTitle = ["Articles","Online Seminars","Resources","Volunteer services"]
                push?.arrParentingDashboardImage = ["note1","study2","care","Medecine"]
                push?.arrParentingDashboardId = ["001","030","012","018"]
                
                self.navigationController?.pushViewController(push!, animated: true)
            }
            if str == "Foster Care" {
                
                let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ParentingDashbaordId") as? ParentingDashbaord
             
                push?.matchCategory = dictevent["id_module"] as? String ?? ""
                push?.matchSubCategory = dictevent["id_category"] as? String ?? ""
                push?.matchTitleSelect = self.matchTitleSelect
                push?.matchTitleShowSelect = str1
                push?.arrParentingDashboardTitle = ["Articles","Resources"]
                push?.arrParentingDashboardImage = ["note1","care"]
                push?.arrParentingDashboardId = ["001","012"]
                push?.devesionIdCategory = dictevent["id_division"] as? String ?? ""
                self.navigationController?.pushViewController(push!, animated: true)
                
            }
            if str == "Kinship Care" {
                
                let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ParentingDashbaordId") as? ParentingDashbaord
                push?.matchCategory = dictevent["id_module"] as? String ?? ""
                push?.matchSubCategory = dictevent["id_category"] as? String ?? ""
                push?.matchTitleSelect = self.matchTitleSelect
                push?.matchTitleShowSelect = str1
                push?.arrParentingDashboardTitle = ["Articles","legal Forms"]
                push?.arrParentingDashboardImage = ["note1","note2"]
                push?.arrParentingDashboardId = ["001","006"]
                push?.devesionIdCategory = dictevent["id_division"] as? String ?? ""
                self.navigationController?.pushViewController(push!, animated: true)
            }
            if str == "New Parents" {
                
                let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ParentingDashbaordId") as? ParentingDashbaord
                push?.matchCategory = dictevent["id_module"] as? String ?? ""
                push?.matchSubCategory = dictevent["id_category"] as? String ?? ""
                push?.matchTitleSelect = self.matchTitleSelect
                push?.matchTitleShowSelect = str1
                push?.devesionIdCategory = dictevent["id_division"] as? String ?? ""
                push?.arrParentingDashboardTitle = ["Articles","Audio","legal Forms"]
                push?.arrParentingDashboardImage = ["note1","music1","note2"]
                push?.arrParentingDashboardId = ["001","002","006"]
                self.navigationController?.pushViewController(push!, animated: true)
            }
            if str == "Parenting Multiples" {
                
                let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ParentingDashbaordId") as? ParentingDashbaord
                push?.matchCategory = dictevent["id_module"] as? String ?? ""
                push?.matchSubCategory = dictevent["id_category"] as? String ?? ""
                push?.matchTitleSelect = self.matchTitleSelect
                push?.matchTitleShowSelect = str1
                push?.devesionIdCategory = dictevent["id_division"] as? String ?? ""
                push?.arrParentingDashboardTitle = ["Articles","Resources"]
                push?.arrParentingDashboardImage = ["note1","care"]
                push?.arrParentingDashboardId = ["001","012"]
                self.navigationController?.pushViewController(push!, animated: true)
            }
            if str == "Parenting Children with Special Needs" {
                
                let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ParentingDashbaordId") as? ParentingDashbaord
                push?.matchCategory = dictevent["id_module"] as? String ?? ""
                push?.matchSubCategory = dictevent["id_category"] as? String ?? ""
                push?.matchTitleSelect = self.matchTitleSelect
                push?.matchTitleShowSelect = str1
                push?.devesionIdCategory = dictevent["id_division"] as? String ?? ""
                push?.arrParentingDashboardTitle = ["Articles","legal Forms","Resources"]
                push?.arrParentingDashboardImage = ["note1","note2","care"]
                push?.arrParentingDashboardId = ["001","006","012"]
                self.navigationController?.pushViewController(push!, animated: true)
            }
            if str == "Sibling Relationships" {
                
                let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ParentingDashbaordId") as? ParentingDashbaord
                push?.matchCategory = dictevent["id_module"] as? String ?? ""
                push?.matchSubCategory = dictevent["id_category"] as? String ?? ""
                push?.matchTitleSelect = self.matchTitleSelect
                push?.matchTitleShowSelect = str1
                push?.devesionIdCategory = dictevent["id_division"] as? String ?? ""
                push?.arrParentingDashboardTitle = ["Articles"]
                push?.arrParentingDashboardImage = ["note1"]
                push?.arrParentingDashboardId = ["001"]
                self.navigationController?.pushViewController(push!, animated: true)
            }
            if str == "Single Parenting" {
                
                let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ParentingDashbaordId") as? ParentingDashbaord
                push?.matchCategory = dictevent["id_module"] as? String ?? ""
                push?.matchSubCategory = dictevent["id_category"] as? String ?? ""
                push?.matchTitleSelect = self.matchTitleSelect
                push?.matchTitleShowSelect = str1
                push?.devesionIdCategory = dictevent["id_division"] as? String ?? ""
                push?.arrParentingDashboardTitle = ["Articles","Audio"]
                push?.arrParentingDashboardImage = ["note1","music1"]
                push?.arrParentingDashboardId = ["001","002"]
                self.navigationController?.pushViewController(push!, animated: true)
            }
            if str == "Staying Organized" {
                
                let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ParentingDashbaordId") as? ParentingDashbaord
                push?.matchCategory = dictevent["id_module"] as? String ?? ""
                push?.matchSubCategory = dictevent["id_category"] as? String ?? ""
                push?.matchTitleSelect = self.matchTitleSelect
                push?.matchTitleShowSelect = str1
                push?.devesionIdCategory = dictevent["id_division"] as? String ?? ""
                push?.arrParentingDashboardTitle = ["Articles","Audio","legal Forms","Online Seminars"]
                push?.arrParentingDashboardImage = ["note1","music1","note2","study2"]
                push?.arrParentingDashboardId = ["001","002","006","030"]
                self.navigationController?.pushViewController(push!, animated: true)
            }
            if str == "Stepparenting" {
                
                let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ParentingDashbaordId") as? ParentingDashbaord
                push?.matchCategory = dictevent["id_module"] as? String ?? ""
                push?.matchSubCategory = dictevent["id_category"] as? String ?? ""
                push?.matchTitleSelect = self.matchTitleSelect
                push?.matchTitleShowSelect = str1
                push?.devesionIdCategory = dictevent["id_division"] as? String ?? ""
                push?.arrParentingDashboardTitle = ["Articles","Audio"]
                push?.arrParentingDashboardImage = ["note1","music1"]
                
                push?.arrParentingDashboardId = ["001","002"]
                self.navigationController?.pushViewController(push!, animated: true)
            }
            if str == "Talking with Teens and Young Adults" {
                
                let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ParentingDashbaordId") as? ParentingDashbaord
                push?.matchCategory = dictevent["id_module"] as? String ?? ""
                push?.matchSubCategory = dictevent["id_category"] as? String ?? ""
                push?.matchTitleSelect = self.matchTitleSelect
                push?.matchTitleShowSelect = str1
                push?.devesionIdCategory = dictevent["id_division"] as? String ?? ""
                push?.arrParentingDashboardTitle = ["Articles","Audio","legal Forms","Online Seminars"]
                push?.arrParentingDashboardImage = ["note1","music1","note2","study2"]
                
                push?.arrParentingDashboardId = ["001","002","006","030"]
                
                self.navigationController?.pushViewController(push!, animated: true)
            }
            if str == "More Parenting Information" {
                
                let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ParentingDashbaordId") as? ParentingDashbaord
                push?.matchCategory = dictevent["id_module"] as? String ?? ""
                push?.matchSubCategory = dictevent["id_category"] as? String ?? ""
                push?.matchTitleSelect = self.matchTitleSelect
                push?.matchTitleShowSelect = str1
                push?.arrParentingDashboardTitle = ["Articles","Audio","Online Seminars","Resources"]
                push?.arrParentingDashboardImage = ["note1","music1","study2","care"]
                push?.devesionIdCategory = dictevent["id_division"] as? String ?? ""
                push?.arrParentingDashboardId = ["001","002","030","012"]
                self.navigationController?.pushViewController(push!, animated: true)
            }
        }
        if str1 == "Adoption" {
            // MARK:- Parenting category Adoption -
            
            if str == "Adopting Multiple Children" {
                
                let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ParentingDashbaordId") as? ParentingDashbaord
                push?.matchCategory = dictevent["id_module"] as? String ?? ""
                push?.matchSubCategory = dictevent["id_category"] as? String ?? ""
                push?.matchTitleSelect = self.matchTitleSelect
                push?.matchTitleShowSelect = str1
                push?.arrParentingDashboardTitle = ["Resources"]
                push?.arrParentingDashboardImage = ["care"]
                push?.arrParentingDashboardId = ["012"]
                push?.devesionIdCategory = dictevent["id_division"] as? String ?? ""
                self.navigationController?.pushViewController(push!, animated: true)
            }
            if str == "Adopting Children with Special Needs" {
                
                let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ParentingDashbaordId") as? ParentingDashbaord
                push?.matchCategory = dictevent["id_module"] as? String ?? ""
                push?.matchSubCategory = dictevent["id_category"] as? String ?? ""
                push?.matchTitleSelect = self.matchTitleSelect
                push?.matchTitleShowSelect = str1
                push?.arrParentingDashboardTitle = ["Articles","Resources"]
                push?.arrParentingDashboardImage = ["note1","care"]
                push?.devesionIdCategory = dictevent["id_division"] as? String ?? ""
                push?.arrParentingDashboardId = ["001","012"]
                self.navigationController?.pushViewController(push!, animated: true)
            }
            
            if str == "Adoption for Gay or Lesbian Parents" {
                
                let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ParentingDashbaordId") as? ParentingDashbaord
                push?.matchCategory = dictevent["id_module"] as? String ?? ""
                push?.matchSubCategory = dictevent["id_category"] as? String ?? ""
                push?.matchTitleSelect = self.matchTitleSelect
                push?.matchTitleShowSelect = str1
                push?.arrParentingDashboardTitle = ["Resources"]
                push?.arrParentingDashboardImage = ["care"]
                push?.devesionIdCategory = dictevent["id_division"] as? String ?? ""
                push?.arrParentingDashboardId = ["012"]
                self.navigationController?.pushViewController(push!, animated: true)
            }
            if str == "Adoption for LGBTQ+ Parents" {
                
                let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ParentingDashbaordId") as? ParentingDashbaord
                push?.matchCategory = dictevent["id_module"] as? String ?? ""
                push?.matchSubCategory = dictevent["id_category"] as? String ?? ""
                push?.matchTitleSelect = self.matchTitleSelect
                push?.matchTitleShowSelect = str1
                push?.arrParentingDashboardTitle = ["Resources"]
                push?.arrParentingDashboardImage = ["care"]
                push?.devesionIdCategory = dictevent["id_division"] as? String ?? ""
                push?.arrParentingDashboardId = ["012"]
                self.navigationController?.pushViewController(push!, animated: true)
            }
            if str == "Adoption for Single Parents" {
                
                let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ParentingDashbaordId") as? ParentingDashbaord
                push?.matchCategory = dictevent["id_module"] as? String ?? ""
                push?.matchSubCategory = dictevent["id_category"] as? String ?? ""
                push?.matchTitleSelect = self.matchTitleSelect
                push?.matchTitleShowSelect = str1
                push?.arrParentingDashboardTitle = ["Resources"]
                push?.arrParentingDashboardImage = ["care"]
                push?.devesionIdCategory = dictevent["id_division"] as? String ?? ""
                push?.arrParentingDashboardId = ["012"]
                self.navigationController?.pushViewController(push!, animated: true)
            }
            if str == "Adoption Process" {
                
                let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ParentingDashbaordId") as? ParentingDashbaord
                push?.matchCategory = dictevent["id_module"] as? String ?? ""
                push?.matchSubCategory = dictevent["id_category"] as? String ?? ""
                push?.matchTitleSelect = self.matchTitleSelect
                push?.matchTitleShowSelect = str1
                push?.arrParentingDashboardTitle = ["Articles","Glossary","Resources"]
                push?.arrParentingDashboardImage = ["note1","Glossary","care"]
                push?.devesionIdCategory = dictevent["id_division"] as? String ?? ""
                push?.arrParentingDashboardId = ["001","009","012"]
                self.navigationController?.pushViewController(push!, animated: true)
            }
            if str == "Considering Adoption" {
                
                let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ParentingDashbaordId") as? ParentingDashbaord
                push?.matchCategory = dictevent["id_module"] as? String ?? ""
                push?.matchSubCategory = dictevent["id_category"] as? String ?? ""
                push?.matchTitleSelect = self.matchTitleSelect
                push?.matchTitleShowSelect = str1
                push?.arrParentingDashboardTitle = ["Articles","Resources"]
                push?.arrParentingDashboardImage = ["note1","care"]
                push?.devesionIdCategory = dictevent["id_division"] as? String ?? ""
                push?.arrParentingDashboardId = ["001","012"]
                self.navigationController?.pushViewController(push!, animated: true)
            }
            if str == "Domestic Adoption" {
                
                let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ParentingDashbaordId") as? ParentingDashbaord
                push?.matchCategory = dictevent["id_module"] as? String ?? ""
                push?.matchSubCategory = dictevent["id_category"] as? String ?? ""
                push?.matchTitleSelect = self.matchTitleSelect
                push?.matchTitleShowSelect = str1
                push?.arrParentingDashboardTitle = ["Resources"]
                push?.arrParentingDashboardImage = ["care"]
                push?.devesionIdCategory = dictevent["id_division"] as? String ?? ""
                push?.arrParentingDashboardId = ["012"]
                self.navigationController?.pushViewController(push!, animated: true)
                
            }
            if str == "Family and Parenting Issues" {
                
                let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ParentingDashbaordId") as? ParentingDashbaord
                push?.matchCategory = dictevent["id_module"] as? String ?? ""
                push?.matchSubCategory = dictevent["id_category"] as? String ?? ""
                push?.matchTitleSelect = self.matchTitleSelect
                push?.matchTitleShowSelect = str1
                push?.arrParentingDashboardTitle = ["Articles","Resources"]
                push?.arrParentingDashboardImage = ["note1","care"]
                push?.devesionIdCategory = dictevent["id_division"] as? String ?? ""
                push?.arrParentingDashboardId = ["001","012"]
                self.navigationController?.pushViewController(push!, animated: true)
            }
            if str == "Finding Birth Parents and Siblings" {
                
                let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ParentingDashbaordId") as? ParentingDashbaord
                push?.matchCategory = dictevent["id_module"] as? String ?? ""
                push?.matchSubCategory = dictevent["id_category"] as? String ?? ""
                push?.matchTitleSelect = self.matchTitleSelect
                push?.matchTitleShowSelect = str1
                push?.arrParentingDashboardTitle = ["Articles","Resources"]
                push?.arrParentingDashboardImage = ["note1","care"]
                push?.devesionIdCategory = dictevent["id_division"] as? String ?? ""
                push?.arrParentingDashboardId = ["001","012"]
                self.navigationController?.pushViewController(push!, animated: true)
            }
            if str == "International Adoption" {
                
                let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ParentingDashbaordId") as? ParentingDashbaord
                push?.matchCategory = dictevent["id_module"] as? String ?? ""
                push?.matchSubCategory = dictevent["id_category"] as? String ?? ""
                push?.matchTitleSelect = self.matchTitleSelect
                push?.matchTitleShowSelect = str1
                push?.arrParentingDashboardTitle = ["Articles","Resources"]
                push?.arrParentingDashboardImage = ["note1","care"]
                push?.devesionIdCategory = dictevent["id_division"] as? String ?? ""
                push?.arrParentingDashboardId = ["001","012"]
                self.navigationController?.pushViewController(push!, animated: true)
            }
            if str == "Legal and Financial Issues" {
                
                let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ParentingDashbaordId") as? ParentingDashbaord
                push?.matchCategory = dictevent["id_module"] as? String ?? ""
                push?.matchSubCategory = dictevent["id_category"] as? String ?? ""
                push?.matchTitleSelect = self.matchTitleSelect
                push?.matchTitleShowSelect = str1
                push?.arrParentingDashboardTitle = ["Articles","Glossary","Resources"]
                push?.arrParentingDashboardImage = ["note1","Glossary","care"]
                push?.devesionIdCategory = dictevent["id_division"] as? String ?? ""
                push?.arrParentingDashboardId = ["001","009","012"]
                self.navigationController?.pushViewController(push!, animated: true)
            }
            
        }
        if str1 == "Child Care" {
            // MARK:- Parenting category Chile Care -
           if str == "Backup Care" {
                
                let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ParentingDashbaordId") as? ParentingDashbaord
                push?.matchCategory = dictevent["id_module"] as? String ?? ""
                push?.matchSubCategory = dictevent["id_category"] as? String ?? ""
                push?.matchTitleSelect = self.matchTitleSelect
                push?.matchTitleShowSelect = str1
                push?.arrParentingDashboardTitle = ["Articles","Handbooks"]
                push?.arrParentingDashboardImage = ["note1","Handbooks"]
                push?.arrParentingDashboardId = ["001","004"]
                push?.devesionIdCategory = dictevent["id_division"] as? String ?? ""
                self.navigationController?.pushViewController(push!, animated: true)
            }
            
            if str == "Center Care" {
                
                let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ParentingDashbaordId") as? ParentingDashbaord
                push?.matchCategory = dictevent["id_module"] as? String ?? ""
                push?.matchSubCategory = dictevent["id_category"] as? String ?? ""
                push?.matchTitleSelect = self.matchTitleSelect
                push?.matchTitleShowSelect = str1
                push?.arrParentingDashboardTitle = ["Articles","Checklists","Handbooks","Regulations"]
                push?.arrParentingDashboardImage = ["note1","checklists","Handbooks","regulation"]
                push?.devesionIdCategory = dictevent["id_division"] as? String ?? ""
                push?.arrParentingDashboardId = ["001","024","004","008"]
                
                self.navigationController?.pushViewController(push!, animated: true)
            }
            if str == "Communication with Your Provider" {
                
                let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ParentingDashbaordId") as? ParentingDashbaord
                push?.matchCategory = dictevent["id_module"] as? String ?? ""
                push?.matchSubCategory = dictevent["id_category"] as? String ?? ""
                push?.matchTitleSelect = self.matchTitleSelect
                push?.matchTitleShowSelect = str1
                push?.devesionIdCategory = dictevent["id_division"] as? String ?? ""
                push?.arrParentingDashboardTitle = ["Articles","Handbooks"]
                push?.arrParentingDashboardImage = ["note1","Handbooks"]
                push?.arrParentingDashboardId = ["001","004"]
                self.navigationController?.pushViewController(push!, animated: true)
            }
            if str == "Family Day Care" {
                
                let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ParentingDashbaordId") as? ParentingDashbaord
                push?.matchCategory = dictevent["id_module"] as? String ?? ""
                push?.matchSubCategory = dictevent["id_category"] as? String ?? ""
                push?.matchTitleSelect = self.matchTitleSelect
                push?.matchTitleShowSelect = str1
                push?.arrParentingDashboardTitle = ["Articles","Checklists","Handbooks"]
                push?.arrParentingDashboardImage = ["note1","checklists","Handbooks"]
                push?.arrParentingDashboardId = ["001","024","004"]
                push?.devesionIdCategory = dictevent["id_division"] as? String ?? ""
                self.navigationController?.pushViewController(push!, animated: true)
            }
            if str == "In-Home Care" {
                
                let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ParentingDashbaordId") as? ParentingDashbaord
                push?.matchCategory = dictevent["id_module"] as? String ?? ""
                push?.matchSubCategory = dictevent["id_category"] as? String ?? ""
                push?.matchTitleSelect = self.matchTitleSelect
                push?.matchTitleShowSelect = str1
                push?.arrParentingDashboardTitle = ["Articles","Handbooks","legal Forms"]
                push?.arrParentingDashboardImage = ["note1","Handbooks","note2"]
                push?.arrParentingDashboardId = ["001","004","006"]
                push?.devesionIdCategory = dictevent["id_division"] as? String ?? ""
                self.navigationController?.pushViewController(push!, animated: true)
            }
            if str == "Preschool" {
                
                let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ParentingDashbaordId") as? ParentingDashbaord
                push?.matchCategory = dictevent["id_module"] as? String ?? ""
                push?.matchSubCategory = dictevent["id_category"] as? String ?? ""
                push?.matchTitleSelect = self.matchTitleSelect
                push?.matchTitleShowSelect = str1
                push?.arrParentingDashboardTitle = ["Articles","Handbooks"]
                push?.arrParentingDashboardImage = ["note1","Handbooks"]
                push?.arrParentingDashboardId = ["001","004"]
                push?.devesionIdCategory = dictevent["id_division"] as? String ?? ""
                self.navigationController?.pushViewController(push!, animated: true)
            }
            if str == "Quality Care" {
                
                let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ParentingDashbaordId") as? ParentingDashbaord
                push?.matchCategory = dictevent["id_module"] as? String ?? ""
                push?.matchSubCategory = dictevent["id_category"] as? String ?? ""
                push?.matchTitleSelect = self.matchTitleSelect
                push?.matchTitleShowSelect = str1
                push?.arrParentingDashboardTitle = ["Articles","Checklists","Handbooks"]
                push?.arrParentingDashboardImage = ["note1","checklists","Handbooks"]
                push?.arrParentingDashboardId = ["001","024","004"]
                push?.devesionIdCategory = dictevent["id_division"] as? String ?? ""
                self.navigationController?.pushViewController(push!, animated: true)
            }
            if str == "School-Age Issues" {
                
                let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ParentingDashbaordId") as? ParentingDashbaord
                push?.matchCategory = dictevent["id_module"] as? String ?? ""
                push?.matchSubCategory = dictevent["id_category"] as? String ?? ""
                push?.matchTitleSelect = self.matchTitleSelect
                push?.matchTitleShowSelect = str1
                push?.devesionIdCategory = dictevent["id_division"] as? String ?? ""
                push?.arrParentingDashboardTitle = ["Articles","Handbooks"]
                push?.arrParentingDashboardImage = ["note1","Handbooks"]
                push?.arrParentingDashboardId = ["001","004"]
                self.navigationController?.pushViewController(push!, animated: true)
            }
            if str == "Self-Care" {
                
                let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ParentingDashbaordId") as? ParentingDashbaord
                push?.matchCategory = dictevent["id_module"] as? String ?? ""
                push?.matchSubCategory = dictevent["id_category"] as? String ?? ""
                push?.matchTitleSelect = self.matchTitleSelect
                push?.matchTitleShowSelect = str1
                push?.arrParentingDashboardTitle = ["Articles"]
                push?.arrParentingDashboardImage = ["note1"]
                push?.arrParentingDashboardId = ["001"]
                push?.devesionIdCategory = dictevent["id_division"] as? String ?? ""
                self.navigationController?.pushViewController(push!, animated: true)
            }
            if str == "State Regulations" {
                
                let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ParentingDashbaordId") as? ParentingDashbaord
                push?.matchCategory = dictevent["id_module"] as? String ?? ""
                push?.matchSubCategory = dictevent["id_category"] as? String ?? ""
                push?.matchTitleSelect = self.matchTitleSelect
                push?.matchTitleShowSelect = str1
                push?.arrParentingDashboardTitle = ["Handbooks","Regulations"]
                push?.arrParentingDashboardImage = ["Handbooks","regulation"]
                push?.arrParentingDashboardId = ["024","008"]
                push?.devesionIdCategory = dictevent["id_division"] as? String ?? ""
                self.navigationController?.pushViewController(push!, animated: true)
            }
            if str == "Summer Camp" {
                
                let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ParentingDashbaordId") as? ParentingDashbaord
                push?.matchCategory = dictevent["id_module"] as? String ?? ""
                push?.matchSubCategory = dictevent["id_category"] as? String ?? ""
                push?.matchTitleSelect = self.matchTitleSelect
                push?.matchTitleShowSelect = str1
                push?.arrParentingDashboardTitle = ["Articles","Checklists","Handbooks","Regulations"]
                push?.arrParentingDashboardImage = ["note1","checklists","Handbooks","regulation"]
                push?.devesionIdCategory = dictevent["id_division"] as? String ?? ""
                push?.arrParentingDashboardId = ["001","024","004","008"]
                
                self.navigationController?.pushViewController(push!, animated: true)
            }
            
        }
        if str1 == "Developmental Stages" {
            // MARK:- Parenting category Developmental Stages -
            
            if str == "Overview" {
                
                let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ParentingDashbaordId") as? ParentingDashbaord
                push?.matchCategory = dictevent["id_module"] as? String ?? ""
                push?.matchSubCategory = dictevent["id_category"] as? String ?? ""
                push?.matchTitleSelect = self.matchTitleSelect
                push?.matchTitleShowSelect = str1
                push?.arrParentingDashboardTitle = ["Articles","Medline","Resources"]
                push?.arrParentingDashboardImage = ["note1","Medecine","care"]
                push?.arrParentingDashboardId = ["001","016","012"]
                push?.devesionIdCategory = dictevent["id_division"] as? String ?? ""
                self.navigationController?.pushViewController(push!, animated: true)
            }
            if str == "Infants" {
                
                let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ParentingDashbaordId") as? ParentingDashbaord
                push?.matchCategory = dictevent["id_module"] as? String ?? ""
                push?.matchSubCategory = dictevent["id_category"] as? String ?? ""
                push?.matchTitleSelect = self.matchTitleSelect
                push?.matchTitleShowSelect = str1
                push?.arrParentingDashboardTitle = ["Articles","Medline","Resources"]
                push?.arrParentingDashboardImage = ["note1","Medecine","care"]
                push?.devesionIdCategory = dictevent["id_division"] as? String ?? ""
                push?.arrParentingDashboardId = ["001","016","012"]
                self.navigationController?.pushViewController(push!, animated: true)
            }
            if str == "Toddlers" {
                
                let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ParentingDashbaordId") as? ParentingDashbaord
                push?.matchCategory = dictevent["id_module"] as? String ?? ""
                push?.matchSubCategory = dictevent["id_category"] as? String ?? ""
                push?.matchTitleSelect = self.matchTitleSelect
                push?.matchTitleShowSelect = str1
                push?.arrParentingDashboardTitle = ["Articles","Frequently Asked Question","Medline","Resources"]
                push?.arrParentingDashboardImage = ["note1","faq","Medecine","care"]
                push?.devesionIdCategory = dictevent["id_division"] as? String ?? ""
                push?.arrParentingDashboardId = ["001","013","016","012"]
                self.navigationController?.pushViewController(push!, animated: true)
            }
            if str == "School-Age (5-9 years old)" {
                
                let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ParentingDashbaordId") as? ParentingDashbaord
                push?.matchCategory = dictevent["id_module"] as? String ?? ""
                push?.matchSubCategory = dictevent["id_category"] as? String ?? ""
                push?.matchTitleSelect = self.matchTitleSelect
                
                push?.matchTitleShowSelect = str1
                push?.arrParentingDashboardTitle = ["Articles","Audio","Medline","Resources"]
                push?.arrParentingDashboardImage = ["note1","music1","Medecine","care"]
                push?.devesionIdCategory = dictevent["id_division"] as? String ?? ""
                push?.arrParentingDashboardId = ["001","002","016","012"]
                self.navigationController?.pushViewController(push!, animated: true)
            }
            if str == "Tweens (10-12 years old)" {
                
                let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ParentingDashbaordId") as? ParentingDashbaord
                push?.matchCategory = dictevent["id_module"] as? String ?? ""
                push?.matchSubCategory = dictevent["id_category"] as? String ?? ""
                push?.matchTitleSelect = self.matchTitleSelect
                push?.devesionIdCategory = dictevent["id_division"] as? String ?? ""
                push?.matchTitleShowSelect = str1
                push?.arrParentingDashboardTitle = ["Articles","Medline","Online Seminars","Resources"]
                
                push?.arrParentingDashboardId = ["001","016","030","012"]
                push?.arrParentingDashboardImage = ["note1","Medecine","study2","care"]
                self.navigationController?.pushViewController(push!, animated: true)
            }
            if str == "Teenagers" {
                
                let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ParentingDashbaordId") as? ParentingDashbaord
                push?.matchCategory = dictevent["id_module"] as? String ?? ""
                push?.matchSubCategory = dictevent["id_category"] as? String ?? ""
                push?.matchTitleSelect = self.matchTitleSelect
                push?.devesionIdCategory = dictevent["id_division"] as? String ?? ""
                push?.matchTitleShowSelect = str1
                push?.arrParentingDashboardTitle = ["Articles","Medline","Resources"]
                push?.arrParentingDashboardImage = ["note1","Medecine","care"]
                
                push?.arrParentingDashboardId = ["001","016","012"]
                
                self.navigationController?.pushViewController(push!, animated: true)
            }
        }
        if str1 == "Kids' Well-Being" {
            // MARK:- Parenting category Kids' Well-Being -
            
            if str == "Children's Health" {
                
                let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ParentingDashbaordId") as? ParentingDashbaord
                push?.matchCategory = dictevent["id_module"] as? String ?? ""
                push?.matchSubCategory = dictevent["id_category"] as? String ?? ""
                push?.matchTitleSelect = self.matchTitleSelect
                push?.devesionIdCategory = dictevent["id_division"] as? String ?? ""
                push?.matchTitleShowSelect = str1
                push?.arrParentingDashboardTitle = ["Articles","Audio","Medline","Online Seminars","Resources"]
                push?.arrParentingDashboardImage = ["note1","music1","Medecine","study2","care"]
                
                push?.arrParentingDashboardId = ["001","002","016","030","012"]
                self.navigationController?.pushViewController(push!, animated: true)
            }
            if str == "Children's Safety" {
                
                let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ParentingDashbaordId") as? ParentingDashbaord
                push?.matchCategory = dictevent["id_module"] as? String ?? ""
                push?.matchSubCategory = dictevent["id_category"] as? String ?? ""
                push?.matchTitleSelect = self.matchTitleSelect
                push?.devesionIdCategory = dictevent["id_division"] as? String ?? ""
                push?.matchTitleShowSelect = str1
                push?.arrParentingDashboardTitle = ["Articles","Audio","Checklists","Online Seminars","Resources"]
                push?.arrParentingDashboardImage = ["note1","music1","checklists","study2","care"]
                
                push?.arrParentingDashboardId = ["001","002","024","030","012"]
                self.navigationController?.pushViewController(push!, animated: true)
            }
            if str == "Courtesy and Responsibility" {
                
                let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ParentingDashbaordId") as? ParentingDashbaord
                push?.matchCategory = dictevent["id_module"] as? String ?? ""
                push?.matchSubCategory = dictevent["id_category"] as? String ?? ""
                push?.matchTitleSelect = self.matchTitleSelect
                push?.devesionIdCategory = dictevent["id_division"] as? String ?? ""
                push?.matchTitleShowSelect = str1
                push?.arrParentingDashboardTitle = ["Articles","Resources","Volunteer services"]
                push?.arrParentingDashboardImage = ["note1","care","Medecine"]
                
                push?.arrParentingDashboardId = ["001","012","018"]
                self.navigationController?.pushViewController(push!, animated: true)
            }
            if str == "Discipline" {
                
                let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ParentingDashbaordId") as? ParentingDashbaord
                push?.matchCategory = dictevent["id_module"] as? String ?? ""
                push?.matchSubCategory = dictevent["id_category"] as? String ?? ""
                push?.matchTitleSelect = self.matchTitleSelect
                push?.devesionIdCategory = dictevent["id_division"] as? String ?? ""
                push?.matchTitleShowSelect = str1
                push?.arrParentingDashboardTitle = ["Articles"]
                push?.arrParentingDashboardImage = ["note1"]
                
                push?.arrParentingDashboardId = ["001"]
                self.navigationController?.pushViewController(push!, animated: true)
            }
            if str == "Discouraging Drug and Tobacco Use" {
                
                let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ParentingDashbaordId") as? ParentingDashbaord
                push?.matchCategory = dictevent["id_module"] as? String ?? ""
                push?.matchSubCategory = dictevent["id_category"] as? String ?? ""
                push?.matchTitleSelect = self.matchTitleSelect
                push?.devesionIdCategory = dictevent["id_division"] as? String ?? ""
                push?.matchTitleShowSelect = str1
                push?.arrParentingDashboardTitle = ["Articles","Audio","Resources"]
                push?.arrParentingDashboardImage = ["note1","music1","care"]
                
                push?.arrParentingDashboardId = ["001","002","012"]
                
                self.navigationController?.pushViewController(push!, animated: true)
            }
            if str == "Health for Teens and Young Adults" {
                
                let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ParentingDashbaordId") as? ParentingDashbaord
                push?.matchCategory = dictevent["id_module"] as? String ?? ""
                push?.matchSubCategory = dictevent["id_category"] as? String ?? ""
                push?.matchTitleSelect = self.matchTitleSelect
                push?.devesionIdCategory = dictevent["id_division"] as? String ?? ""
                push?.matchTitleShowSelect = str1
                push?.arrParentingDashboardTitle = ["Articles","Audio"]
                push?.arrParentingDashboardImage = ["note1","music1"]
                
                push?.arrParentingDashboardId = ["001","002"]
                
                self.navigationController?.pushViewController(push!, animated: true)
            }
            if str == "Immunizations and Medical Care" {
                
                let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ParentingDashbaordId") as? ParentingDashbaord
                push?.matchCategory = dictevent["id_module"] as? String ?? ""
                push?.matchSubCategory = dictevent["id_category"] as? String ?? ""
                push?.matchTitleSelect = self.matchTitleSelect
                push?.devesionIdCategory = dictevent["id_division"] as? String ?? ""
                push?.matchTitleShowSelect = str1
                push?.arrParentingDashboardTitle = ["Articles","Audio"]
                push?.arrParentingDashboardImage = ["note1","music1"]
                
                push?.arrParentingDashboardId = ["001","002"]
                
                self.navigationController?.pushViewController(push!, animated: true)
            }
            if str == "Media and Internet Awareness" {
                
                let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ParentingDashbaordId") as? ParentingDashbaord
                push?.matchCategory = dictevent["id_module"] as? String ?? ""
                push?.matchSubCategory = dictevent["id_category"] as? String ?? ""
                push?.matchTitleSelect = self.matchTitleSelect
                push?.devesionIdCategory = dictevent["id_division"] as? String ?? ""
                push?.matchTitleShowSelect = str1
                push?.arrParentingDashboardTitle = ["Articles","Online Seminars","Resources"]
                push?.arrParentingDashboardImage = ["note1","study2","care"]
                
                push?.arrParentingDashboardId = ["001","030","012"]
                
                self.navigationController?.pushViewController(push!, animated: true)
            }
            if str == "Safety for Teens and Young Adults" {
                
                let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ParentingDashbaordId") as? ParentingDashbaord
                push?.matchCategory = dictevent["id_module"] as? String ?? ""
                push?.matchSubCategory = dictevent["id_category"] as? String ?? ""
                push?.matchTitleSelect = self.matchTitleSelect
                push?.devesionIdCategory = dictevent["id_division"] as? String ?? ""
                push?.matchTitleShowSelect = str1
                push?.arrParentingDashboardTitle = ["Articles","Audio","Online Seminars","Resources"]
                push?.arrParentingDashboardImage = ["note1","music1","study2","care"]
                
                push?.arrParentingDashboardId = ["001","002","030","012"]
                self.navigationController?.pushViewController(push!, animated: true)
            }
            if str == "More Information on Kids\' Wellbeing" {
                
                let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ParentingDashbaordId") as? ParentingDashbaord
                push?.matchCategory = dictevent["id_module"] as? String ?? ""
                push?.matchSubCategory = dictevent["id_category"] as? String ?? ""
                push?.matchTitleSelect = self.matchTitleSelect
                push?.devesionIdCategory = dictevent["id_division"] as? String ?? ""
                push?.matchTitleShowSelect = str1
                push?.arrParentingDashboardTitle = ["Articles","Resources"]
                push?.arrParentingDashboardImage = ["note1","care"]
                push?.arrParentingDashboardId = ["001","012"]
                
                self.navigationController?.pushViewController(push!, animated: true)
            }
        }
        
        // MARK:- Parenting category Education -
        
        if str1 == "Education" {
            
            if str == "Early Development" {
                
                let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ParentingDashbaordId") as? ParentingDashbaord
                push?.matchCategory = dictevent["id_module"] as? String ?? ""
                push?.matchSubCategory = dictevent["id_category"] as? String ?? ""
                push?.matchTitleSelect = self.matchTitleSelect
                push?.devesionIdCategory = dictevent["id_division"] as? String ?? ""
                push?.matchTitleShowSelect = str1
                push?.arrParentingDashboardTitle = ["Articles","Frequently Asked Question"]
                push?.arrParentingDashboardImage = ["note1","faq"]
                
                push?.arrParentingDashboardId = ["001","013"]
                
                self.navigationController?.pushViewController(push!, animated: true)
            }
            if str == "Parent and Teacher Communications" {
                
                let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ParentingDashbaordId") as? ParentingDashbaord
                push?.matchCategory = dictevent["id_module"] as? String ?? ""
                push?.matchSubCategory = dictevent["id_category"] as? String ?? ""
                push?.matchTitleSelect = self.matchTitleSelect
                push?.devesionIdCategory = dictevent["id_division"] as? String ?? ""
                push?.matchTitleShowSelect = str1
                push?.arrParentingDashboardTitle = ["Articles","Resources"]
                push?.arrParentingDashboardImage = ["note1","care"]
                
                push?.arrParentingDashboardId = ["001","012"]
                
                self.navigationController?.pushViewController(push!, animated: true)
            }
            if str == "Homework" {
                
                let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ParentingDashbaordId") as? ParentingDashbaord
                push?.matchCategory = dictevent["id_module"] as? String ?? ""
                push?.matchSubCategory = dictevent["id_category"] as? String ?? ""
                push?.matchTitleSelect = self.matchTitleSelect
                push?.devesionIdCategory = dictevent["id_division"] as? String ?? ""
                push?.matchTitleShowSelect = str1
                push?.arrParentingDashboardTitle = ["Articles","Resources"]
                push?.arrParentingDashboardImage = ["note1","care"]
                
                push?.arrParentingDashboardId = ["001","012"]
                
                self.navigationController?.pushViewController(push!, animated: true)
            }
            
            if str == "Choosing a K-12 School" {
                
                let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ParentingDashbaordId") as? ParentingDashbaord
                push?.matchCategory = dictevent["id_module"] as? String ?? ""
                push?.matchSubCategory = dictevent["id_category"] as? String ?? ""
                push?.matchTitleSelect = self.matchTitleSelect
                push?.devesionIdCategory = dictevent["id_division"] as? String ?? ""
                push?.matchTitleShowSelect = str1
                push?.arrParentingDashboardTitle = ["Articles","Handbooks"]
                push?.arrParentingDashboardImage = ["note1","Handbooks"]
                
                push?.arrParentingDashboardId = ["001","004"]
                self.navigationController?.pushViewController(push!, animated: true)
            }
            if str == "Homeschooling" {
                
                let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ParentingDashbaordId") as? ParentingDashbaord
                push?.matchCategory = dictevent["id_module"] as? String ?? ""
                push?.matchSubCategory = dictevent["id_category"] as? String ?? ""
                push?.matchTitleSelect = self.matchTitleSelect
                push?.devesionIdCategory = dictevent["id_division"] as? String ?? ""
                push?.matchTitleShowSelect = str1
                push?.arrParentingDashboardTitle = ["Articles","Resources"]
                push?.arrParentingDashboardImage = ["note1","care"]
                
                push?.arrParentingDashboardId = ["001","012"]
                self.navigationController?.pushViewController(push!, animated: true)
            }
            
            if str == "Special Needs" {
                
                let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ParentingDashbaordId") as? ParentingDashbaord
                push?.matchCategory = dictevent["id_module"] as? String ?? ""
                push?.matchSubCategory = dictevent["id_category"] as? String ?? ""
                push?.matchTitleSelect = self.matchTitleSelect
                push?.devesionIdCategory = dictevent["id_division"] as? String ?? ""
                push?.matchTitleShowSelect = str1
                push?.arrParentingDashboardTitle = ["Articles","Frequently Asked Question","Legal Forms","Resources"]
                push?.arrParentingDashboardImage = ["note1","faq","note2","care"]
                
                push?.arrParentingDashboardId = ["001","013","006","012"]
                self.navigationController?.pushViewController(push!, animated: true)
            }
            
            if str == "Autism Spectrum Disorder" {
                
                let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ParentingDashbaordId") as? ParentingDashbaord
                push?.matchCategory = dictevent["id_module"] as? String ?? ""
                push?.matchSubCategory = dictevent["id_category"] as? String ?? ""
                push?.matchTitleSelect = self.matchTitleSelect
                push?.devesionIdCategory = dictevent["id_division"] as? String ?? ""
                push?.matchTitleShowSelect = str1
                push?.arrParentingDashboardTitle = ["Articles","Resources"]
                push?.arrParentingDashboardImage = ["note1","care"]
                
                push?.arrParentingDashboardId = ["001","012"]
                self.navigationController?.pushViewController(push!, animated: true)
            }
            if str == "ADHD" {
                
                let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ParentingDashbaordId") as? ParentingDashbaord
                push?.matchCategory = dictevent["id_module"] as? String ?? ""
                push?.matchSubCategory = dictevent["id_category"] as? String ?? ""
                push?.matchTitleSelect = self.matchTitleSelect
                push?.arrParentingDashboardTitle = ["Articles","Resources"]
                push?.arrParentingDashboardImage = ["note1","care"]
                push?.matchTitleShowSelect = str1
                push?.arrParentingDashboardId = ["001","012"]
                push?.devesionIdCategory = dictevent["id_division"] as? String ?? ""
                self.navigationController?.pushViewController(push!, animated: true)
            }
            if str == "At-Risk Youths" {
                
                let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ParentingDashbaordId") as? ParentingDashbaord
                push?.matchCategory = dictevent["id_module"] as? String ?? ""
                push?.matchSubCategory = dictevent["id_category"] as? String ?? ""
                push?.matchTitleSelect = self.matchTitleSelect
                push?.arrParentingDashboardTitle = ["Articles","Resources"]
                push?.arrParentingDashboardImage = ["note1","care"]
                push?.matchTitleShowSelect = str1
                push?.devesionIdCategory = dictevent["id_division"] as? String ?? ""
                push?.arrParentingDashboardId = ["001","012"]
                self.navigationController?.pushViewController(push!, animated: true)
            }
            if str == "College Testing" {
                
                let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ParentingDashbaordId") as? ParentingDashbaord
                push?.matchCategory = dictevent["id_module"] as? String ?? ""
                push?.matchSubCategory = dictevent["id_category"] as? String ?? ""
                push?.matchTitleSelect = self.matchTitleSelect
                push?.arrParentingDashboardTitle = ["Articles","Resources"]
                push?.arrParentingDashboardImage = ["note1","care"]
                push?.matchTitleShowSelect = str1
                push?.arrParentingDashboardId = ["001","012"]
                push?.devesionIdCategory = dictevent["id_division"] as? String ?? ""
                self.navigationController?.pushViewController(push!, animated: true)
            }
            if str == "College Prep - Academics" {
                
                let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ParentingDashbaordId") as? ParentingDashbaord
                push?.matchCategory = dictevent["id_module"] as? String ?? ""
                push?.matchSubCategory = dictevent["id_category"] as? String ?? ""
                push?.matchTitleSelect = self.matchTitleSelect
                push?.arrParentingDashboardTitle = ["Articles","Checklists","Resources"]
                push?.arrParentingDashboardImage = ["note1","checklists","care"]
                push?.matchTitleShowSelect = str1
                push?.devesionIdCategory = dictevent["id_division"] as? String ?? ""
                push?.arrParentingDashboardId = ["001","024","012"]
                self.navigationController?.pushViewController(push!, animated: true)
            }
            if str == "College Prep - Financial" {
                
                let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ParentingDashbaordId") as? ParentingDashbaord
                push?.matchCategory = dictevent["id_module"] as? String ?? ""
                push?.matchSubCategory = dictevent["id_category"] as? String ?? ""
                push?.matchTitleSelect = self.matchTitleSelect
                push?.arrParentingDashboardTitle = ["Articles","Resources"]
                push?.arrParentingDashboardImage = ["note1","care"]
                push?.matchTitleShowSelect = str1
                push?.devesionIdCategory = dictevent["id_division"] as? String ?? ""
                push?.arrParentingDashboardId = ["001","012"]
                self.navigationController?.pushViewController(push!, animated: true)
            }
            if str == "College Prep - Selecting a College" {
                
                let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ParentingDashbaordId") as? ParentingDashbaord
                push?.matchCategory = dictevent["id_module"] as? String ?? ""
                push?.matchSubCategory = dictevent["id_category"] as? String ?? ""
                push?.matchTitleSelect = self.matchTitleSelect
                push?.arrParentingDashboardTitle = ["Articles","Resources"]
                push?.arrParentingDashboardImage = ["note1","care"]
                push?.matchTitleShowSelect = str1
                push?.arrParentingDashboardId = ["001","012"]
                push?.devesionIdCategory = dictevent["id_division"] as? String ?? ""
                self.navigationController?.pushViewController(push!, animated: true)
            }
            if str == "College Life - For Parents" {
                
                let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ParentingDashbaordId") as? ParentingDashbaord
                push?.matchCategory = dictevent["id_module"] as? String ?? ""
                push?.matchSubCategory = dictevent["id_category"] as? String ?? ""
                push?.matchTitleSelect = self.matchTitleSelect
                push?.arrParentingDashboardTitle = ["Articles","Resources"]
                push?.arrParentingDashboardImage = ["note1","care"]
                push?.matchTitleShowSelect = str1
                push?.arrParentingDashboardId = ["001","012"]
                push?.devesionIdCategory = dictevent["id_division"] as? String ?? ""
                self.navigationController?.pushViewController(push!, animated: true)
            }
            if str == "College Life - For Students" {
                
                let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ParentingDashbaordId") as? ParentingDashbaord
                push?.matchCategory = dictevent["id_module"] as? String ?? ""
                push?.matchSubCategory = dictevent["id_category"] as? String ?? ""
                push?.matchTitleSelect = self.matchTitleSelect
                push?.arrParentingDashboardTitle = ["Articles","Resources"]
                push?.arrParentingDashboardImage = ["note1","care"]
                push?.matchTitleShowSelect = str1
                push?.arrParentingDashboardId = ["001","012"]
                push?.devesionIdCategory = dictevent["id_division"] as? String ?? ""
                self.navigationController?.pushViewController(push!, animated: true)
            }
            if str == "Scholarships and Financial Aid" {
                
                let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ParentingDashbaordId") as? ParentingDashbaord
                push?.matchCategory = dictevent["id_module"] as? String ?? ""
                push?.matchSubCategory = dictevent["id_category"] as? String ?? ""
                push?.matchTitleSelect = self.matchTitleSelect
                push?.arrParentingDashboardTitle = ["Articles","Resources"]
                push?.arrParentingDashboardImage = ["note1","care"]
                push?.matchTitleShowSelect = str1
                push?.arrParentingDashboardId = ["001","012"]
                push?.devesionIdCategory = dictevent["id_division"] as? String ?? ""
                self.navigationController?.pushViewController(push!, animated: true)
            }
            if str == "College Locator" {
                
                //                let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ParentingDashbaordId") as? ParentingDashbaord
                //                push?.matchCategory = dictevent["id_module"] as? String ?? ""
                //                push?.matchSubCategory = dictevent["id_category"] as? String ?? ""
                //
                //                push?.arrParentingDashboardTitle = ["Provider Search"]
                //                push?.arrParentingDashboardImage = ["Provider"]
                //
                //                push?.arrParentingDashboardId = ["007"]
                //
                //                self.navigationController?.pushViewController(push!, animated: true)
                
            }
            if str == "Online and Distance Learning" {
                
                let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ParentingDashbaordId") as? ParentingDashbaord
                push?.matchCategory = dictevent["id_module"] as? String ?? ""
                push?.matchSubCategory = dictevent["id_category"] as? String ?? ""
                push?.matchTitleSelect = self.matchTitleSelect
                push?.arrParentingDashboardTitle = ["Articles","Resources"]
                push?.arrParentingDashboardImage = ["note1","care"]
                push?.matchTitleShowSelect = str1
                push?.arrParentingDashboardId = ["001","012"]
                push?.devesionIdCategory = dictevent["id_division"] as? String ?? ""
                self.navigationController?.pushViewController(push!, animated: true)
            }
            if str == "Adult and Continuing Education" {
                
                let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ParentingDashbaordId") as? ParentingDashbaord
                push?.matchCategory = dictevent["id_module"] as? String ?? ""
                push?.matchSubCategory = dictevent["id_category"] as? String ?? ""
                push?.matchTitleSelect = self.matchTitleSelect
                push?.arrParentingDashboardTitle = ["Resources"]
                push?.arrParentingDashboardImage = ["care"]
                push?.matchTitleShowSelect = str1
                push?.arrParentingDashboardId = ["012"]
                push?.devesionIdCategory = dictevent["id_division"] as? String ?? ""
                self.navigationController?.pushViewController(push!, animated: true)
            }
            if str == "Non-College Options" {
                
                let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ParentingDashbaordId") as? ParentingDashbaord
                push?.matchCategory = dictevent["id_module"] as? String ?? ""
                push?.matchSubCategory = dictevent["id_category"] as? String ?? ""
                push?.arrParentingDashboardTitle = ["Articles","Resources"]
                push?.arrParentingDashboardImage = ["note1","care"]
                push?.matchTitleSelect = self.matchTitleSelect
                push?.arrParentingDashboardId = ["001","012"]
                push?.matchTitleShowSelect = str1
                push?.devesionIdCategory = dictevent["id_division"] as? String ?? ""
                self.navigationController?.pushViewController(push!, animated: true)
            }
        }
        // MARK:- Aging category
        if str1 == "Adults With Disabilities"
        {
            // MARK:- Aging category Adults With Disabilities -
            
            if str == "Accessing Services" {
                
                let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ParentingDashbaordId") as? ParentingDashbaord
                push?.matchCategory = dictevent["id_module"] as? String ?? ""
                push?.matchSubCategory = dictevent["id_category"] as? String ?? ""
                push?.arrParentingDashboardTitle = ["Articles","Resources"]
                push?.arrParentingDashboardImage = ["note1","care"]
                push?.matchTitleSelect = self.matchTitleSelect
                push?.matchTitleShowSelect = str1
                push?.arrParentingDashboardId = ["001","012"]
                push?.devesionIdCategory = dictevent["id_division"] as? String ?? ""
                self.navigationController?.pushViewController(push!, animated: true)
            }
            if str == "Adaptive Strategies" {
                
                let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ParentingDashbaordId") as? ParentingDashbaord
                push?.matchCategory = dictevent["id_module"] as? String ?? ""
                push?.matchSubCategory = dictevent["id_category"] as? String ?? ""
                push?.arrParentingDashboardTitle = ["Articles"]
                push?.arrParentingDashboardImage = ["note1"]
                push?.matchTitleShowSelect = str1
                push?.matchTitleSelect = self.matchTitleSelect
                push?.arrParentingDashboardId = ["001"]
                push?.devesionIdCategory = dictevent["id_division"] as? String ?? ""
                self.navigationController?.pushViewController(push!, animated: true)
            }
            if str == "More on Adults with Disabilities" {
                
                let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ParentingDashbaordId") as? ParentingDashbaord
                push?.matchCategory = dictevent["id_module"] as? String ?? ""
                push?.matchSubCategory = dictevent["id_category"] as? String ?? ""
                push?.arrParentingDashboardTitle = ["Articles","Medline","Resources"]
                push?.arrParentingDashboardImage = ["note1","Medecine","care"]
                push?.matchTitleSelect = self.matchTitleSelect
                push?.matchTitleShowSelect = str1
                push?.arrParentingDashboardId = ["001","016","012"]
                push?.devesionIdCategory = dictevent["id_division"] as? String ?? ""
                self.navigationController?.pushViewController(push!, animated: true)
            }
        }
        if str1 == "Aging Well"
        {
            // MARK:- Aging category Aging Well -
            
            if str == "Aging and Physical Changes" {
                
                let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ParentingDashbaordId") as? ParentingDashbaord
                push?.matchCategory = dictevent["id_module"] as? String ?? ""
                push?.matchSubCategory = dictevent["id_category"] as? String ?? ""
                push?.arrParentingDashboardTitle = ["Articles","Medline","Resources"]
                push?.arrParentingDashboardImage = ["note1","Medecine","care"]
                push?.matchTitleSelect = self.matchTitleSelect
                push?.matchTitleShowSelect = str1
                push?.arrParentingDashboardId = ["001","016","012"]
                push?.devesionIdCategory = dictevent["id_division"] as? String ?? ""
                self.navigationController?.pushViewController(push!, animated: true)
            }
            if str == "Employment and Retirement"
            {
                
                let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ParentingDashbaordId") as? ParentingDashbaord
                push?.matchCategory = dictevent["id_module"] as? String ?? ""
                push?.matchSubCategory = dictevent["id_category"] as? String ?? ""
                push?.arrParentingDashboardTitle = ["Articles","calculators","Online Seminars","Resources"]
                push?.matchTitleSelect = self.matchTitleSelect
                push?.matchTitleShowSelect = str1
                push?.arrParentingDashboardImage = ["note1","note2","study2","care"]
                push?.arrParentingDashboardId = ["001","034","030","012"]
                push?.devesionIdCategory = dictevent["id_division"] as? String ?? ""
                self.navigationController?.pushViewController(push!, animated: true)
                
            }
            if str == "Fitness and Exercise" {
                
                let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ParentingDashbaordId") as? ParentingDashbaord
                push?.matchCategory = dictevent["id_module"] as? String ?? ""
                push?.matchSubCategory = dictevent["id_category"] as? String ?? ""
                push?.arrParentingDashboardTitle = ["Articles","Audio","Handbooks","Online Seminars","Resources"]
                push?.arrParentingDashboardImage = ["note1","music1","Handbooks","study2","care"]
                push?.matchTitleSelect = self.matchTitleSelect
                push?.matchTitleShowSelect = str1
                push?.arrParentingDashboardId = ["001","002","004","030","012"]
                push?.devesionIdCategory = dictevent["id_division"] as? String ?? ""
                self.navigationController?.pushViewController(push!, animated: true)
            }
            if str == "Lifelong Learning" {
                
                let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ParentingDashbaordId") as? ParentingDashbaord
                push?.matchCategory = dictevent["id_module"] as? String ?? ""
                push?.matchSubCategory = dictevent["id_category"] as? String ?? ""
                push?.arrParentingDashboardTitle = ["Articles","Resources","Volunteer services"]
                push?.arrParentingDashboardImage = ["note1","care","Medecine"]
                push?.matchTitleSelect = self.matchTitleSelect
                push?.matchTitleShowSelect = str1
                push?.arrParentingDashboardId = ["001","012","018"]
                push?.devesionIdCategory = dictevent["id_division"] as? String ?? ""
                self.navigationController?.pushViewController(push!, animated: true)
            }
            if str == "Living Better Longer"
            {
                
                let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ParentingDashbaordId") as? ParentingDashbaord
                push?.matchCategory = dictevent["id_module"] as? String ?? ""
                push?.matchSubCategory = dictevent["id_category"] as? String ?? ""
                push?.arrParentingDashboardTitle = ["Articles","Audio","Handbooks","Online Seminars","Resources"]
                push?.arrParentingDashboardImage = ["note1","music1","Handbooks","study2","care"]
                push?.matchTitleSelect = self.matchTitleSelect
                push?.matchTitleShowSelect = str1
                push?.arrParentingDashboardId = ["001","002","004","030","012"]
                push?.devesionIdCategory = dictevent["id_division"] as? String ?? ""
                self.navigationController?.pushViewController(push!, animated: true)
            }
            if str == "Older Adult Safety"
            {
                
                let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ParentingDashbaordId") as? ParentingDashbaord
                push?.matchCategory = dictevent["id_module"] as? String ?? ""
                push?.matchSubCategory = dictevent["id_category"] as? String ?? ""
                push?.arrParentingDashboardTitle = ["Articles","Audio","Handbooks","Resources"]
                push?.arrParentingDashboardImage = ["note1","music1","Handbooks","care"]
                push?.matchTitleSelect = self.matchTitleSelect
                push?.matchTitleShowSelect = str1
                push?.arrParentingDashboardId = ["001","002","004","012"]
                push?.devesionIdCategory = dictevent["id_division"] as? String ?? ""
                self.navigationController?.pushViewController(push!, animated: true)
                
            }
            if str == "Travel"
            {
                
                let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ParentingDashbaordId") as? ParentingDashbaord
                push?.matchCategory = dictevent["id_module"] as? String ?? ""
                push?.matchSubCategory = dictevent["id_category"] as? String ?? ""
                push?.arrParentingDashboardTitle = ["Articles","Resources"]
                push?.arrParentingDashboardImage = ["note1","care"]
                push?.matchTitleSelect = self.matchTitleSelect
                push?.matchTitleShowSelect = str1
                push?.arrParentingDashboardId = ["001","012"]
                push?.devesionIdCategory = dictevent["id_division"] as? String ?? ""
                self.navigationController?.pushViewController(push!, animated: true)
                
            }
            if str == "More Information on Aging Well"
            {
                
                let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ParentingDashbaordId") as? ParentingDashbaord
                push?.matchCategory = dictevent["id_module"] as? String ?? ""
                push?.matchSubCategory = dictevent["id_category"] as? String ?? ""
                push?.arrParentingDashboardTitle = ["Articles","Frequently Asked Question","Handbooks","Resources"]
                push?.arrParentingDashboardImage = ["note1","faq","Handbooks","care"]
                push?.matchTitleSelect = self.matchTitleSelect
                push?.matchTitleShowSelect = str1
                push?.arrParentingDashboardId = ["001","013","004","012"]
                push?.devesionIdCategory = dictevent["id_division"] as? String ?? ""
                self.navigationController?.pushViewController(push!, animated: true)
                
            }
        }
        if str1 == "Planning the Future"
        {
            // MARK:- Aging category Planning the Future -
            
            if str == "Advance Directives"
            {
                
                let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ParentingDashbaordId") as? ParentingDashbaord
                push?.matchCategory = dictevent["id_module"] as? String ?? ""
                push?.matchSubCategory = dictevent["id_category"] as? String ?? ""
                push?.arrParentingDashboardTitle = ["Articles","Online seminars","Handbooks","Resources"]
                push?.matchTitleSelect = self.matchTitleSelect
                push?.matchTitleShowSelect = str1
                push?.arrParentingDashboardImage = ["note1","study2","Handbooks","care"]
                push?.arrParentingDashboardId = ["001","030","004","012"]
                push?.devesionIdCategory = dictevent["id_division"] as? String ?? ""
                self.navigationController?.pushViewController(push!, animated: true)
                
            }
            if str == "Legal"
            {
                
                let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ParentingDashbaordId") as? ParentingDashbaord
                push?.matchCategory = dictevent["id_module"] as? String ?? ""
                push?.matchSubCategory = dictevent["id_category"] as? String ?? ""
                push?.arrParentingDashboardTitle = ["Articles","Checklists","Online Seminars","Resources"]
                push?.arrParentingDashboardImage = ["note1","checklists","study2","care"]
                push?.matchTitleSelect = self.matchTitleSelect
                push?.matchTitleShowSelect = str1
                push?.arrParentingDashboardId = ["001","024","030","012"]
                push?.devesionIdCategory = dictevent["id_division"] as? String ?? ""
                self.navigationController?.pushViewController(push!, animated: true)
                
            }
            if str == "Power of Attorney"
            {
                
                let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ParentingDashbaordId") as? ParentingDashbaord
                push?.matchCategory = dictevent["id_module"] as? String ?? ""
                push?.matchSubCategory = dictevent["id_category"] as? String ?? ""
                push?.arrParentingDashboardTitle = ["Articles","Online Seminars","Resources"]
                push?.arrParentingDashboardImage = ["note1","study2","care"]
                push?.matchTitleSelect = self.matchTitleSelect
                push?.arrParentingDashboardId = ["001","030","012"]
                push?.matchTitleShowSelect = str1
                push?.devesionIdCategory = dictevent["id_division"] as? String ?? ""
                self.navigationController?.pushViewController(push!, animated: true)
                
            }
            if str == "Wills"
            {
                
                let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ParentingDashbaordId") as? ParentingDashbaord
                push?.matchCategory = dictevent["id_module"] as? String ?? ""
                push?.matchSubCategory = dictevent["id_category"] as? String ?? ""
                push?.arrParentingDashboardTitle = ["Articles","Audio","Online Seminars","Resources"]
                push?.arrParentingDashboardImage = ["note1","music1","study2","care"]
                push?.matchTitleSelect = self.matchTitleSelect
                push?.arrParentingDashboardId = ["001","002","030","012"]
                push?.matchTitleShowSelect = str1
                push?.devesionIdCategory = dictevent["id_division"] as? String ?? ""
                self.navigationController?.pushViewController(push!, animated: true)
                
            }
            if str == "Other Considerations"
            {
                
                let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ParentingDashbaordId") as? ParentingDashbaord
                push?.matchCategory = dictevent["id_module"] as? String ?? ""
                push?.matchSubCategory = dictevent["id_category"] as? String ?? ""
                push?.arrParentingDashboardTitle = ["Articles","Checklists","Online Seminars","Resources"]
                push?.arrParentingDashboardImage = ["note1","checklists","study2","care"]
                push?.matchTitleSelect = self.matchTitleSelect
                push?.arrParentingDashboardId = ["001","024","030","012"]
                push?.matchTitleShowSelect = str1
                push?.devesionIdCategory = dictevent["id_division"] as? String ?? ""
                self.navigationController?.pushViewController(push!, animated: true)
                
            }
        }
        // MARK:- Aging category Housing Options -
        if str1 == "Housing Options"
        {
            if str == "Alternative Living Arrangements"
            {
                
                let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ParentingDashbaordId") as? ParentingDashbaord
                push?.matchCategory = dictevent["id_module"] as? String ?? ""
                push?.matchSubCategory = dictevent["id_category"] as? String ?? ""
                push?.arrParentingDashboardTitle = ["Articles","Glossary"]
                push?.arrParentingDashboardImage = ["note1","Glossary"]
                push?.arrParentingDashboardId = ["001","009"]
                push?.matchTitleSelect = self.matchTitleSelect
                push?.matchTitleShowSelect = str1
                push?.devesionIdCategory = dictevent["id_division"] as? String ?? ""
                self.navigationController?.pushViewController(push!, animated: true)
                
            }
            if str == "Assisted Living"
            {
                
                let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ParentingDashbaordId") as? ParentingDashbaord
                push?.matchCategory = dictevent["id_module"] as? String ?? ""
                push?.matchSubCategory = dictevent["id_category"] as? String ?? ""
                push?.arrParentingDashboardTitle = ["Articles","Checklists","Resources"]
                push?.arrParentingDashboardImage = ["note1","checklists","care"]
                push?.arrParentingDashboardId = ["001","024","012"]
                push?.matchTitleSelect = self.matchTitleSelect
                push?.matchTitleShowSelect = str1
                push?.devesionIdCategory = dictevent["id_division"] as? String ?? ""
                self.navigationController?.pushViewController(push!, animated: true)
                
            }
            if str == "Hospice Care"
            {
                
                let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ParentingDashbaordId") as? ParentingDashbaord
                push?.matchCategory = dictevent["id_module"] as? String ?? ""
                push?.matchSubCategory = dictevent["id_category"] as? String ?? ""
                push?.arrParentingDashboardTitle = ["Articles"]
                push?.arrParentingDashboardImage = ["note1"]
                push?.arrParentingDashboardId = ["001"]
                push?.matchTitleSelect = self.matchTitleSelect
                push?.matchTitleShowSelect = str1
                push?.devesionIdCategory = dictevent["id_division"] as? String ?? ""
                self.navigationController?.pushViewController(push!, animated: true)
                
            }
            if str == "Long-Term Care"
            {
                
                let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ParentingDashbaordId") as? ParentingDashbaord
                push?.matchCategory = dictevent["id_module"] as? String ?? ""
                push?.matchSubCategory = dictevent["id_category"] as? String ?? ""
                push?.arrParentingDashboardTitle = ["Articles","Audio","Checklists"]
                push?.arrParentingDashboardImage = ["note1","music1","checklists"]
                push?.matchTitleSelect = self.matchTitleSelect
                push?.arrParentingDashboardId = ["001","002","024"]
                push?.matchTitleShowSelect = str1
                push?.devesionIdCategory = dictevent["id_division"] as? String ?? ""
                self.navigationController?.pushViewController(push!, animated: true)
                
            }
            if str == "Nursing Homes"
            {
                
                let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ParentingDashbaordId") as? ParentingDashbaord
                push?.matchCategory = dictevent["id_module"] as? String ?? ""
                push?.matchSubCategory = dictevent["id_category"] as? String ?? ""
                push?.arrParentingDashboardTitle = ["Articles","Checklists","Resources"]
                push?.arrParentingDashboardImage = ["note1","checklists","care"]
                push?.arrParentingDashboardId = ["001","024","012"]
                push?.matchTitleSelect = self.matchTitleSelect
                push?.matchTitleShowSelect = str1
                push?.devesionIdCategory = dictevent["id_division"] as? String ?? ""
                self.navigationController?.pushViewController(push!, animated: true)
                
            }
            if str == "More Information on Housing Options"
            {
                
                let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ParentingDashbaordId") as? ParentingDashbaord
                push?.matchCategory = dictevent["id_module"] as? String ?? ""
                push?.matchSubCategory = dictevent["id_category"] as? String ?? ""
                push?.arrParentingDashboardTitle = ["Articles","Checklists","Resources"]
                push?.arrParentingDashboardImage = ["note1","checklists","care"]
                push?.arrParentingDashboardId = ["001","024","012"]
                push?.matchTitleSelect = self.matchTitleSelect
                push?.matchTitleShowSelect = str1
                push?.devesionIdCategory = dictevent["id_division"] as? String ?? ""
                self.navigationController?.pushViewController(push!, animated: true)
                
            }
        }
        if str1 == "Home Care"
        {
            // MARK:- Aging category Home care -
            
            if str == "Hiring Home Care Providers"
            {
                
                let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ParentingDashbaordId") as? ParentingDashbaord
                push?.matchCategory = dictevent["id_module"] as? String ?? ""
                push?.matchSubCategory = dictevent["id_category"] as? String ?? ""
                push?.arrParentingDashboardTitle = ["Articles","Checklists"]
                push?.arrParentingDashboardImage = ["note1","checklists"]
                push?.arrParentingDashboardId = ["001","024"]
                push?.matchTitleSelect = self.matchTitleSelect
                push?.matchTitleShowSelect = str1
                push?.devesionIdCategory = dictevent["id_division"] as? String ?? ""
                self.navigationController?.pushViewController(push!, animated: true)
            }
            
            if str == "Caring for the Caregiver"
            {
                
                let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ParentingDashbaordId") as? ParentingDashbaord
                push?.matchCategory = dictevent["id_module"] as? String ?? ""
                push?.matchSubCategory = dictevent["id_category"] as? String ?? ""
                push?.arrParentingDashboardTitle = ["Articles","Frequently Asked Question","Handbooks","Medline","Online Seminars"]
                push?.arrParentingDashboardImage = ["note1","faq","Handbooks","Medecine","study2"]
                push?.arrParentingDashboardId = ["001","013","004","016","030"]
                push?.matchTitleSelect = self.matchTitleSelect
                push?.matchTitleShowSelect = str1
                push?.devesionIdCategory = dictevent["id_division"] as? String ?? ""
                self.navigationController?.pushViewController(push!, animated: true)
                
            }
            if str == "Home Caregiving Tips"
            {
                
                let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ParentingDashbaordId") as? ParentingDashbaord
                push?.matchCategory = dictevent["id_module"] as? String ?? ""
                push?.matchSubCategory = dictevent["id_category"] as? String ?? ""
                push?.arrParentingDashboardTitle = ["Articles","Medline","Online Seminars","Resources"]
                push?.arrParentingDashboardImage = ["note1","Medecine","study2","care"]
                push?.matchTitleSelect = self.matchTitleSelect
                push?.matchTitleShowSelect = str1
                push?.arrParentingDashboardId = ["001","016","030","012"]
                push?.devesionIdCategory = dictevent["id_division"] as? String ?? ""
                self.navigationController?.pushViewController(push!, animated: true)
                
            }
            if str == "More Home Care Information"
            {
                
                let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ParentingDashbaordId") as? ParentingDashbaord
                push?.matchCategory = dictevent["id_module"] as? String ?? ""
                push?.matchSubCategory = dictevent["id_category"] as? String ?? ""
                push?.arrParentingDashboardTitle = ["Articles"]
                push?.arrParentingDashboardImage = ["note1"]
                push?.arrParentingDashboardId = ["001"]
                push?.matchTitleSelect = self.matchTitleSelect
                push?.matchTitleShowSelect = str1
                push?.devesionIdCategory = dictevent["id_division"] as? String ?? ""
                self.navigationController?.pushViewController(push!, animated: true)
                
            }
        }
        
        
        if str1 == "Caregivers"
        {
            // MARK:- Aging category Caregivers -
            
            if str == "Caregiver Support"
            {
                
                let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ParentingDashbaordId") as? ParentingDashbaord
                push?.matchCategory = dictevent["id_module"] as? String ?? ""
                push?.matchSubCategory = dictevent["id_category"] as? String ?? ""
                push?.arrParentingDashboardTitle = ["Articles","Audio","Checklists","Handbooks","Online Seminars","Resources"]
                push?.arrParentingDashboardImage = ["note1","music1","checklists","Handbooks","study2","care"]
                push?.arrParentingDashboardId = ["001","004","024","004","030","012"]
                push?.matchTitleSelect = self.matchTitleSelect
                push?.matchTitleShowSelect = str1
                push?.devesionIdCategory = dictevent["id_division"] as? String ?? ""
                self.navigationController?.pushViewController(push!, animated: true)
                
            }
            if str == "Caregiving Tips"
            {
                
                let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ParentingDashbaordId") as? ParentingDashbaord
                push?.matchCategory = dictevent["id_module"] as? String ?? ""
                push?.matchSubCategory = dictevent["id_category"] as? String ?? ""
                push?.arrParentingDashboardTitle = ["Articles","Audio","Handbooks","Medline","Online Seminars","Resources"]
                push?.arrParentingDashboardImage = ["note1","music1","Handbooks","Medecine","study2","care"]
                push?.arrParentingDashboardId = ["001","002","004","016","030","012"]
                push?.matchTitleSelect = self.matchTitleSelect
                push?.matchTitleShowSelect = str1
                push?.devesionIdCategory = dictevent["id_division"] as? String ?? ""
                self.navigationController?.pushViewController(push!, animated: true)
                
            }
        }
        
        if str1 == "Grief and Loss"
        {
            
            // MARK:- Aging category Grief and Loss -
            
            if str == "Grief Process"
            {
                
                let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ParentingDashbaordId") as? ParentingDashbaord
                push?.matchCategory = dictevent["id_module"] as? String ?? ""
                push?.matchSubCategory = dictevent["id_category"] as? String ?? ""
                push?.arrParentingDashboardTitle = ["Articles","Resources"]
                push?.arrParentingDashboardImage = ["note1","care"]
                push?.matchTitleSelect = self.matchTitleSelect
                push?.matchTitleShowSelect = str1
                push?.arrParentingDashboardId = ["001","012"]
                push?.devesionIdCategory = dictevent["id_division"] as? String ?? ""
                self.navigationController?.pushViewController(push!, animated: true)
                
            }
            if str == "Aging and Loss"
            {
                
                let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ParentingDashbaordId") as? ParentingDashbaord
                push?.matchCategory = dictevent["id_module"] as? String ?? ""
                push?.matchSubCategory = dictevent["id_category"] as? String ?? ""
                push?.arrParentingDashboardTitle = ["Articles"]
                push?.arrParentingDashboardImage = ["note1"]
                push?.matchTitleSelect = self.matchTitleSelect
                push?.arrParentingDashboardId = ["001"]
                push?.matchTitleShowSelect = str1
                push?.devesionIdCategory = dictevent["id_division"] as? String ?? ""
                self.navigationController?.pushViewController(push!, animated: true)
                
            }
            if str == "Supporting the Bereaved"
            {
                
                let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ParentingDashbaordId") as? ParentingDashbaord
                push?.matchCategory = dictevent["id_module"] as? String ?? ""
                push?.matchSubCategory = dictevent["id_category"] as? String ?? ""
                push?.arrParentingDashboardTitle = ["Articles"]
                push?.arrParentingDashboardImage = ["note1"]
                push?.matchTitleSelect = self.matchTitleSelect
                push?.arrParentingDashboardId = ["001"]
                push?.matchTitleShowSelect = str1
                push?.devesionIdCategory = dictevent["id_division"] as? String ?? ""
                self.navigationController?.pushViewController(push!, animated: true)
                
            }
            if str == "Death and Dying"
            {
                
                let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ParentingDashbaordId") as? ParentingDashbaord
                push?.matchCategory = dictevent["id_module"] as? String ?? ""
                push?.matchSubCategory = dictevent["id_category"] as? String ?? ""
                push?.arrParentingDashboardTitle = ["Articles","Audio","Medline"]
                push?.arrParentingDashboardImage = ["note1","music1","Medecine"]
                push?.matchTitleSelect = self.matchTitleSelect
                push?.arrParentingDashboardId = ["001","002","016"]
                push?.matchTitleShowSelect = str1
                push?.devesionIdCategory = dictevent["id_division"] as? String ?? ""
                self.navigationController?.pushViewController(push!, animated: true)
                
            }
        }
        if str1 == "Government Programs"
        {
            // MARK:- Aging category Government Programs -
            
            if str == "Community Resources"
            {
                
                let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ParentingDashbaordId") as? ParentingDashbaord
                push?.matchCategory = dictevent["id_module"] as? String ?? ""
                push?.matchSubCategory = dictevent["id_category"] as? String ?? ""
                push?.arrParentingDashboardTitle = ["Articles","Handbooks","Resources"]
                push?.arrParentingDashboardImage = ["note1","Handbooks","care"]
                push?.matchTitleSelect = self.matchTitleSelect
                push?.arrParentingDashboardId = ["001","004","012"]
                push?.matchTitleShowSelect = str1
                push?.devesionIdCategory = dictevent["id_division"] as? String ?? ""
                self.navigationController?.pushViewController(push!, animated: true)
                
            }
            
            if str == "Medicare and Medicaid"
            {
                
                let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ParentingDashbaordId") as? ParentingDashbaord
                push?.matchCategory = dictevent["id_module"] as? String ?? ""
                push?.matchSubCategory = dictevent["id_category"] as? String ?? ""
                push?.arrParentingDashboardTitle = ["Articles","Handbooks","Resources"]
                push?.arrParentingDashboardImage = ["note1","Handbooks","care"]
                push?.matchTitleSelect = self.matchTitleSelect
                push?.arrParentingDashboardId = ["001","004","012"]
                push?.matchTitleShowSelect = str1
                push?.devesionIdCategory = dictevent["id_division"] as? String ?? ""
                self.navigationController?.pushViewController(push!, animated: true)
                
            }
            if str == "Social Security"
            {
                
                let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ParentingDashbaordId") as? ParentingDashbaord
                push?.matchCategory = dictevent["id_module"] as? String ?? ""
                push?.matchSubCategory = dictevent["id_category"] as? String ?? ""
                push?.arrParentingDashboardTitle = ["Articles","Handbooks","Resources"]
                push?.arrParentingDashboardImage = ["note1","Handbooks","care"]
                push?.matchTitleSelect = self.matchTitleSelect
                push?.arrParentingDashboardId = ["001","004","012"]
                push?.matchTitleShowSelect = str1
                push?.devesionIdCategory = dictevent["id_division"] as? String ?? ""
                self.navigationController?.pushViewController(push!, animated: true)
                
            }
            if str == "More Information on U.S. Systems"
            {
                
                let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ParentingDashbaordId") as? ParentingDashbaord
                push?.matchCategory = dictevent["id_module"] as? String ?? ""
                push?.matchSubCategory = dictevent["id_category"] as? String ?? ""
                push?.arrParentingDashboardTitle = ["Resources"]
                push?.arrParentingDashboardImage = ["care"]
                push?.matchTitleSelect = self.matchTitleSelect
                push?.arrParentingDashboardId = ["012"]
                push?.matchTitleShowSelect = str1
                push?.devesionIdCategory = dictevent["id_division"] as? String ?? ""
                self.navigationController?.pushViewController(push!, animated: true)
                
            }
        }
        if str1 == "Health"
        {
            
            
            if str == "Alzheimer's and Dementia"
            {
                
                let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ParentingDashbaordId") as? ParentingDashbaord
                push?.matchCategory = dictevent["id_module"] as? String ?? ""
                push?.matchSubCategory = dictevent["id_category"] as? String ?? ""
                push?.arrParentingDashboardTitle = ["Articles","Audio","Medline","Online seminars","Resources","Videos"]
                push?.arrParentingDashboardImage = ["note1","music1","Medecine","study2","care","Videos"]
                push?.matchTitleSelect = self.matchTitleSelect
                push?.arrParentingDashboardId = ["001","002","016","030","012","045"]
                push?.matchTitleShowSelect = str1
                push?.devesionIdCategory = dictevent["id_division"] as? String ?? ""
                self.navigationController?.pushViewController(push!, animated: true)
                
            }
            if str == "Arthritis"
            {
                
                let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ParentingDashbaordId") as? ParentingDashbaord
                push?.matchCategory = dictevent["id_module"] as? String ?? ""
                push?.matchSubCategory = dictevent["id_category"] as? String ?? ""
                push?.arrParentingDashboardTitle = ["Articles","Frequently Asked Question","Medline"]
                push?.arrParentingDashboardImage = ["note1","faq","Medecine"]
                push?.arrParentingDashboardId = ["001","013","016"]
                push?.matchTitleSelect = self.matchTitleSelect
                push?.matchTitleShowSelect = str1
                push?.devesionIdCategory = dictevent["id_division"] as? String ?? ""
                self.navigationController?.pushViewController(push!, animated: true)
                
            }
            if str == "Cancer"
            {
                
                let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ParentingDashbaordId") as? ParentingDashbaord
                push?.matchCategory = dictevent["id_module"] as? String ?? ""
                push?.matchSubCategory = dictevent["id_category"] as? String ?? ""
                push?.arrParentingDashboardTitle = ["Articles","Frequently Asked Question","Medline","Resources"]
                push?.arrParentingDashboardImage = ["note1","faq","Medecine","care"]
                push?.arrParentingDashboardId = ["001","013","016","012"]
                push?.matchTitleSelect = self.matchTitleSelect
                push?.matchTitleShowSelect = str1
                push?.devesionIdCategory = dictevent["id_division"] as? String ?? ""
                self.navigationController?.pushViewController(push!, animated: true)
                
            }
            if str == "Cardiovascular Concerns"
            {
                
                let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ParentingDashbaordId") as? ParentingDashbaord
                push?.matchCategory = dictevent["id_module"] as? String ?? ""
                push?.matchSubCategory = dictevent["id_category"] as? String ?? ""
                push?.arrParentingDashboardTitle = ["Articles","Frequently Asked Question","Medline","Online seminars"]
                push?.arrParentingDashboardImage = ["note1","faq","Medecine","study2"]
                push?.arrParentingDashboardId = ["001","013","016","030"]
                push?.matchTitleSelect = self.matchTitleSelect
                push?.matchTitleShowSelect = str1
                push?.devesionIdCategory = dictevent["id_division"] as? String ?? ""
                self.navigationController?.pushViewController(push!, animated: true)
                
            }
            if str == "Depression"
            {
                
                let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ParentingDashbaordId") as? ParentingDashbaord
                push?.matchCategory = dictevent["id_module"] as? String ?? ""
                push?.matchSubCategory = dictevent["id_category"] as? String ?? ""
                push?.arrParentingDashboardTitle = ["Articles","Audio","Medline","Resources"]
                push?.arrParentingDashboardImage = ["note1","music1","Medecine","care"]
                push?.arrParentingDashboardId = ["001","002","016","012"]
                push?.matchTitleSelect = self.matchTitleSelect
                push?.matchTitleShowSelect = str1
                push?.devesionIdCategory = dictevent["id_division"] as? String ?? ""
                self.navigationController?.pushViewController(push!, animated: true)
                
            }
            if str == "Exercise and Fitness"
            {
                
                let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ParentingDashbaordId") as? ParentingDashbaord
                push?.matchCategory = dictevent["id_module"] as? String ?? ""
                push?.matchSubCategory = dictevent["id_category"] as? String ?? ""
                push?.arrParentingDashboardTitle = ["Articles","Audio"]
                push?.arrParentingDashboardImage = ["note1","music1"]
                push?.arrParentingDashboardId = ["001","002"]
                push?.matchTitleSelect = self.matchTitleSelect
                push?.matchTitleShowSelect = str1
                push?.devesionIdCategory = dictevent["id_division"] as? String ?? ""
                self.navigationController?.pushViewController(push!, animated: true)
                
            }
            if str == "Medical Care"
            {
                
                let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ParentingDashbaordId") as? ParentingDashbaord
                push?.matchCategory = dictevent["id_module"] as? String ?? ""
                push?.matchSubCategory = dictevent["id_category"] as? String ?? ""
                push?.arrParentingDashboardTitle = ["Articles","Audio","Medline"]
                push?.arrParentingDashboardImage = ["note1","music1","Medecine"]
                push?.arrParentingDashboardId = ["001","002","016"]
                push?.matchTitleSelect = self.matchTitleSelect
                push?.matchTitleShowSelect = str1
                push?.devesionIdCategory = dictevent["id_division"] as? String ?? ""
                self.navigationController?.pushViewController(push!, animated: true)
                
            }
            if str == "Osteoporosis"
            {
                
                let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ParentingDashbaordId") as? ParentingDashbaord
                push?.matchCategory = dictevent["id_module"] as? String ?? ""
                push?.matchSubCategory = dictevent["id_category"] as? String ?? ""
                push?.arrParentingDashboardTitle = ["Articles","Audio","Medline","Resources"]
                push?.arrParentingDashboardImage = ["note1","music1","Medecine","care"]
                push?.arrParentingDashboardId = ["001","002","016","012"]
                push?.matchTitleSelect = self.matchTitleSelect
                push?.matchTitleShowSelect = str1
                push?.devesionIdCategory = dictevent["id_division"] as? String ?? ""
                self.navigationController?.pushViewController(push!, animated: true)
                
            }
            if str == "Parkinson's"
            {
                
                let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ParentingDashbaordId") as? ParentingDashbaord
                push?.matchCategory = dictevent["id_module"] as? String ?? ""
                push?.matchSubCategory = dictevent["id_category"] as? String ?? ""
                push?.arrParentingDashboardTitle = ["Medline","Resources"]
                push?.arrParentingDashboardImage = ["Medecine","care"]
                push?.arrParentingDashboardId = ["016","012"]
                push?.matchTitleSelect = self.matchTitleSelect
                push?.matchTitleShowSelect = str1
                push?.devesionIdCategory = dictevent["id_division"] as? String ?? ""
                self.navigationController?.pushViewController(push!, animated: true)
                
            }
            if str == "Prescription Drugs"
            {
                
                let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ParentingDashbaordId") as? ParentingDashbaord
                push?.matchCategory = dictevent["id_module"] as? String ?? ""
                push?.matchSubCategory = dictevent["id_category"] as? String ?? ""
                push?.arrParentingDashboardTitle = ["Articles","Medline","Resources","SAMHSA"]
                push?.arrParentingDashboardImage = ["note1","Medecine","care","SMSHA"]
                push?.arrParentingDashboardId = ["001","016","012","037"]
                push?.matchTitleSelect = self.matchTitleSelect
                push?.matchTitleShowSelect = str1
                push?.devesionIdCategory = dictevent["id_division"] as? String ?? ""
                self.navigationController?.pushViewController(push!, animated: true)
                
            }
            if str == "Sleep"
            {
                
                let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ParentingDashbaordId") as? ParentingDashbaord
                push?.matchCategory = dictevent["id_module"] as? String ?? ""
                push?.matchSubCategory = dictevent["id_category"] as? String ?? ""
                push?.arrParentingDashboardTitle = ["Articles","Audio","Medline","Videos"]
                push?.arrParentingDashboardImage = ["note1","music1","Medecine","Videos"]
                push?.arrParentingDashboardId = ["001","002","016","045"]
                push?.matchTitleSelect = self.matchTitleSelect
                push?.devesionIdCategory = dictevent["id_division"] as? String ?? ""
                push?.matchTitleShowSelect = str1
                self.navigationController?.pushViewController(push!, animated: true)
                
            }
            if str == "Vision"
            {
                
                let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ParentingDashbaordId") as? ParentingDashbaord
                push?.matchCategory = dictevent["id_module"] as? String ?? ""
                push?.matchSubCategory = dictevent["id_category"] as? String ?? ""
                push?.arrParentingDashboardTitle = ["Articles","Medline","Resources"]
                push?.arrParentingDashboardImage = ["note1","Medecine","care"]
                push?.arrParentingDashboardId = ["001","016","012"]
                push?.matchTitleSelect = self.matchTitleSelect
                push?.matchTitleShowSelect = str1
                push?.devesionIdCategory = dictevent["id_division"] as? String ?? ""
                self.navigationController?.pushViewController(push!, animated: true)
                
            }
            if str == "More Aging Health Topics"
            {
                
                let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ParentingDashbaordId") as? ParentingDashbaord
                push?.matchCategory = dictevent["id_module"] as? String ?? ""
                push?.matchSubCategory = dictevent["id_category"] as? String ?? ""
                push?.arrParentingDashboardTitle = ["Articles","Audio","Frequently Asked Question","Online seminars","Resources","Videos"]
                push?.arrParentingDashboardImage = ["note1","music1","faq","study2","care","Videos"]
                push?.arrParentingDashboardId = ["001","002","013","030","012","045"]
                push?.matchTitleShowSelect = str1
                push?.matchTitleSelect = self.matchTitleSelect
                push?.devesionIdCategory = dictevent["id_division"] as? String ?? ""
                self.navigationController?.pushViewController(push!, animated: true)
                
            }
            
        }
        // MARK:- Balancing category
        if str1 == "Personal Growth"
        {
            // MARK:- Balancing category Personal Growth -
            
            if str == "Building Self-Esteem"
            {
                let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ParentingDashbaordId") as? ParentingDashbaord
                push?.matchCategory = dictevent["id_module"] as? String ?? ""
                push?.matchSubCategory = dictevent["id_category"] as? String ?? ""
                push?.arrParentingDashboardTitle = ["Articles","Audio","Online seminars"]
                push?.arrParentingDashboardImage = ["note1","music1","study2"]
                push?.arrParentingDashboardId = ["001","002","030"]
                push?.matchTitleSelect = self.matchTitleSelect
                push?.matchTitleShowSelect = str1
                push?.devesionIdCategory = dictevent["id_division"] as? String ?? ""
                self.navigationController?.pushViewController(push!, animated: true)
                
            }
            if str == "Learning for Fun and Personal Growth"
            {
                let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ParentingDashbaordId") as? ParentingDashbaord
                push?.matchCategory = dictevent["id_module"] as? String ?? ""
                push?.matchSubCategory = dictevent["id_category"] as? String ?? ""
                push?.arrParentingDashboardTitle = ["Articles","Online seminars","Resources","Volunteer Service"]
                push?.arrParentingDashboardImage = ["note1","study2","care","Medecine"]
                push?.arrParentingDashboardId = ["001","030","012","018"]
                push?.matchTitleSelect = self.matchTitleSelect
                push?.matchTitleShowSelect = str1
                push?.devesionIdCategory = dictevent["id_division"] as? String ?? ""
                self.navigationController?.pushViewController(push!, animated: true)
                
            }
            if str == "Managing Change"
            {
                let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ParentingDashbaordId") as? ParentingDashbaord
                push?.matchCategory = dictevent["id_module"] as? String ?? ""
                push?.matchSubCategory = dictevent["id_category"] as? String ?? ""
                push?.arrParentingDashboardTitle = ["Articles","Audio","Online seminars"]
                push?.arrParentingDashboardImage = ["note1","music1","study2"]
                push?.arrParentingDashboardId = ["001","002","030"]
                push?.matchTitleSelect = self.matchTitleSelect
                push?.matchTitleShowSelect = str1
                push?.devesionIdCategory = dictevent["id_division"] as? String ?? ""
                self.navigationController?.pushViewController(push!, animated: true)
                
            }
            if str == "Managing Emotions"
            {
                let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ParentingDashbaordId") as? ParentingDashbaord
                push?.matchCategory = dictevent["id_module"] as? String ?? ""
                push?.matchSubCategory = dictevent["id_category"] as? String ?? ""
                push?.arrParentingDashboardTitle = ["Articles","Audio","Online seminars"]
                push?.arrParentingDashboardImage = ["note1","music1","study2"]
                push?.arrParentingDashboardId = ["001","002","012"]
                push?.matchTitleSelect = self.matchTitleSelect
                push?.matchTitleShowSelect = str1
                push?.devesionIdCategory = dictevent["id_division"] as? String ?? ""
                self.navigationController?.pushViewController(push!, animated: true)
                
            }
            if str == "Setting Goals"
            {
                let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ParentingDashbaordId") as? ParentingDashbaord
                push?.matchCategory = dictevent["id_module"] as? String ?? ""
                push?.matchSubCategory = dictevent["id_category"] as? String ?? ""
                push?.arrParentingDashboardTitle = ["Articles","Audio","Online seminars"]
                push?.arrParentingDashboardImage = ["note1","music1","study2"]
                push?.arrParentingDashboardId = ["001","002","012"]
                push?.matchTitleSelect = self.matchTitleSelect
                push?.matchTitleShowSelect = str1
                push?.devesionIdCategory = dictevent["id_division"] as? String ?? ""
                self.navigationController?.pushViewController(push!, animated: true)
                
            }
            if str == "Sexual Orientation"
            {
                let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ParentingDashbaordId") as? ParentingDashbaord
                push?.matchCategory = dictevent["id_module"] as? String ?? ""
                push?.matchSubCategory = dictevent["id_category"] as? String ?? ""
                push?.arrParentingDashboardTitle = ["Articles","Resources"]
                push?.arrParentingDashboardImage = ["note1","care"]
                push?.arrParentingDashboardId = ["001","012"]
                push?.matchTitleSelect = self.matchTitleSelect
                push?.matchTitleShowSelect = str1
                push?.devesionIdCategory = dictevent["id_division"] as? String ?? ""
                self.navigationController?.pushViewController(push!, animated: true)
                
            }
            if str == "More Information for Personal Growth"
            {
                let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ParentingDashbaordId") as? ParentingDashbaord
                push?.matchCategory = dictevent["id_module"] as? String ?? ""
                push?.matchSubCategory = dictevent["id_category"] as? String ?? ""
                push?.arrParentingDashboardTitle = ["Articles","Online seminars","Resources","SAMHSA"]
                push?.arrParentingDashboardImage = ["note1","study2","care","SMSHA"]
                push?.arrParentingDashboardId = ["001","030","012","037"]
                push?.matchTitleSelect = self.matchTitleSelect
                push?.matchTitleShowSelect = str1
                push?.devesionIdCategory = dictevent["id_division"] as? String ?? ""
                self.navigationController?.pushViewController(push!, animated: true)
                
            }
        }
        if str1 == "Communication"
        {
            // MARK:- Balancing category Communication -
            
            if str == "Communication Tips"
            {
                let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ParentingDashbaordId") as? ParentingDashbaord
                push?.matchCategory = dictevent["id_module"] as? String ?? ""
                push?.matchSubCategory = dictevent["id_category"] as? String ?? ""
                push?.arrParentingDashboardTitle = ["Articles","Audio","Online seminars"]
                push?.arrParentingDashboardImage = ["note1","music1","study2"]
                push?.arrParentingDashboardId = ["001","002","030"]
                push?.matchTitleSelect = self.matchTitleSelect
                push?.matchTitleShowSelect = str1
                push?.devesionIdCategory = dictevent["id_division"] as? String ?? ""
                self.navigationController?.pushViewController(push!, animated: true)
                
            }
            if str == "Conflict Resolution"
            {
                let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ParentingDashbaordId") as? ParentingDashbaord
                push?.matchCategory = dictevent["id_module"] as? String ?? ""
                push?.matchSubCategory = dictevent["id_category"] as? String ?? ""
                push?.arrParentingDashboardTitle = ["Articles","Audio","Online seminars"]
                push?.arrParentingDashboardImage = ["note1","music1","study2"]
                push?.arrParentingDashboardId = ["001","002","030"]
                push?.matchTitleSelect = self.matchTitleSelect
                push?.matchTitleShowSelect = str1
                push?.devesionIdCategory = dictevent["id_division"] as? String ?? ""
                self.navigationController?.pushViewController(push!, animated: true)
                
            }
            if str == "Long Distance"
            {
                let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ParentingDashbaordId") as? ParentingDashbaord
                push?.matchCategory = dictevent["id_module"] as? String ?? ""
                push?.matchSubCategory = dictevent["id_category"] as? String ?? ""
                push?.arrParentingDashboardTitle = ["Articles"]
                push?.arrParentingDashboardImage = ["note1"]
                push?.arrParentingDashboardId = ["001"]
                push?.matchTitleShowSelect = str1
                push?.devesionIdCategory = dictevent["id_division"] as? String ?? ""
                push?.matchTitleSelect = self.matchTitleSelect
                self.navigationController?.pushViewController(push!, animated: true)
                
            }
            if str == "With Your Adult Children"
            {
                let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ParentingDashbaordId") as? ParentingDashbaord
                push?.matchCategory = dictevent["id_module"] as? String ?? ""
                push?.matchSubCategory = dictevent["id_category"] as? String ?? ""
                push?.arrParentingDashboardTitle = ["Articles","Audio"]
                push?.arrParentingDashboardImage = ["note1","music1"]
                push?.arrParentingDashboardId = ["001","002"]
                push?.matchTitleSelect = self.matchTitleSelect
                push?.matchTitleShowSelect = str1
                push?.devesionIdCategory = dictevent["id_division"] as? String ?? ""
                self.navigationController?.pushViewController(push!, animated: true)
                
            }
            if str == "With Your Aging Parents"
            {
                let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ParentingDashbaordId") as? ParentingDashbaord
                push?.matchCategory = dictevent["id_module"] as? String ?? ""
                push?.matchSubCategory = dictevent["id_category"] as? String ?? ""
                push?.arrParentingDashboardTitle = ["Articles","Audio"]
                push?.arrParentingDashboardImage = ["note1","music1"]
                push?.arrParentingDashboardId = ["001","002"]
                push?.matchTitleSelect = self.matchTitleSelect
                push?.matchTitleShowSelect = str1
                push?.devesionIdCategory = dictevent["id_division"] as? String ?? ""
                self.navigationController?.pushViewController(push!, animated: true)
                
            }
            if str == "With Your Teen"
            {
                let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ParentingDashbaordId") as? ParentingDashbaord
                push?.matchCategory = dictevent["id_module"] as? String ?? ""
                push?.matchSubCategory = dictevent["id_category"] as? String ?? ""
                push?.arrParentingDashboardTitle = ["Articles","Online seminars","Resources"]
                push?.arrParentingDashboardImage = ["note1","study2","care"]
                push?.arrParentingDashboardId = ["001","030","012"]
                push?.matchTitleSelect = self.matchTitleSelect
                push?.matchTitleShowSelect = str1
                push?.devesionIdCategory = dictevent["id_division"] as? String ?? ""
                self.navigationController?.pushViewController(push!, animated: true)
                
            }
        }
        
        if str1 == "Families"
        {
            if str == "Adult Children with Aging Parents"
            {
                let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ParentingDashbaordId") as? ParentingDashbaord
                push?.matchCategory = dictevent["id_module"] as? String ?? ""
                push?.matchSubCategory = dictevent["id_category"] as? String ?? ""
                push?.arrParentingDashboardTitle = ["Articles","Audio", "Checklist","Online seminars","Resources"]
                push?.arrParentingDashboardImage = ["note1","music1","checklists","study2","care"]
                push?.arrParentingDashboardId = ["001","002","024","030","012"]
                push?.matchTitleSelect = self.matchTitleSelect
                push?.matchTitleShowSelect = str1
                push?.devesionIdCategory = dictevent["id_division"] as? String ?? ""
                self.navigationController?.pushViewController(push!, animated: true)
                
            }
            if str == "Divorce and Parenting"
            {
                let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ParentingDashbaordId") as? ParentingDashbaord
                push?.matchCategory = dictevent["id_module"] as? String ?? ""
                push?.matchSubCategory = dictevent["id_category"] as? String ?? ""
                push?.arrParentingDashboardTitle = ["Articles","Online seminars","Resources"]
                push?.arrParentingDashboardImage = ["note1","study2","care"]
                push?.arrParentingDashboardId = ["001","030","012"]
                push?.matchTitleSelect = self.matchTitleSelect
                push?.matchTitleShowSelect = str1
                push?.devesionIdCategory = dictevent["id_division"] as? String ?? ""
                self.navigationController?.pushViewController(push!, animated: true)
                
            }
            
            if str == "Family and LGBTQ+ Questions"
            {
                let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ParentingDashbaordId") as? ParentingDashbaord
                push?.matchCategory = dictevent["id_module"] as? String ?? ""
                push?.matchSubCategory = dictevent["id_category"] as? String ?? ""
                push?.arrParentingDashboardTitle = ["Articles","Online seminars","Resources"]
                push?.arrParentingDashboardImage = ["note1","study2","care"]
                push?.arrParentingDashboardId = ["001","030","012"]
                push?.matchTitleSelect = self.matchTitleSelect
                push?.matchTitleShowSelect = str1
                push?.devesionIdCategory = dictevent["id_division"] as? String ?? ""
                self.navigationController?.pushViewController(push!, animated: true)
                
            }
            
            
            if str == "Grandparents"
            {
                let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ParentingDashbaordId") as? ParentingDashbaord
                push?.matchCategory = dictevent["id_module"] as? String ?? ""
                push?.matchSubCategory = dictevent["id_category"] as? String ?? ""
                push?.arrParentingDashboardTitle = ["Articles","Audio","Online seminars","Resources"]
                push?.arrParentingDashboardImage = ["note1","music1","study2","care"]
                push?.arrParentingDashboardId = ["001","002","030","012"]
                push?.matchTitleSelect = self.matchTitleSelect
                push?.matchTitleShowSelect = str1
                push?.devesionIdCategory = dictevent["id_division"] as? String ?? ""
                self.navigationController?.pushViewController(push!, animated: true)
                
            }
            if str == "Long Distance"
            {
                let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ParentingDashbaordId") as? ParentingDashbaord
                push?.matchCategory = dictevent["id_module"] as? String ?? ""
                push?.matchSubCategory = dictevent["id_category"] as? String ?? ""
                push?.arrParentingDashboardTitle = ["Articles","Online seminars"]
                push?.arrParentingDashboardImage = ["note1","study2"]
                push?.arrParentingDashboardId = ["001","030"]
                push?.matchTitleSelect = self.matchTitleSelect
                push?.matchTitleShowSelect = str1
                push?.devesionIdCategory = dictevent["id_division"] as? String ?? ""
                self.navigationController?.pushViewController(push!, animated: true)
                
            }
            if str == "New Parents"
            {
                let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ParentingDashbaordId") as? ParentingDashbaord
                push?.matchCategory = dictevent["id_module"] as? String ?? ""
                push?.matchSubCategory = dictevent["id_category"] as? String ?? ""
                push?.arrParentingDashboardTitle = ["Articles","Audio","Medline","Resources"]
                push?.arrParentingDashboardImage = ["note1","music1","Medecine","care"]
                push?.arrParentingDashboardId = ["001","002","016","012"]
                push?.matchTitleSelect = self.matchTitleSelect
                push?.devesionIdCategory = dictevent["id_division"] as? String ?? ""
                push?.matchTitleShowSelect = str1
                self.navigationController?.pushViewController(push!, animated: true)
                
            }
            if str == "Siblings"
            {
                let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ParentingDashbaordId") as? ParentingDashbaord
                push?.matchCategory = dictevent["id_module"] as? String ?? ""
                push?.matchSubCategory = dictevent["id_category"] as? String ?? ""
                push?.arrParentingDashboardTitle = ["Articles","Online seminars","Resources"]
                push?.arrParentingDashboardImage = ["note1","study2","care"]
                push?.arrParentingDashboardId = ["001","030","012"]
                push?.matchTitleSelect = self.matchTitleSelect
                push?.devesionIdCategory = dictevent["id_division"] as? String ?? ""
                push?.matchTitleShowSelect = str1
                self.navigationController?.pushViewController(push!, animated: true)
                
            }
            if str == "Parents with Adult Children"
            {
                let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ParentingDashbaordId") as? ParentingDashbaord
                push?.matchCategory = dictevent["id_module"] as? String ?? ""
                push?.matchSubCategory = dictevent["id_category"] as? String ?? ""
                push?.arrParentingDashboardTitle = ["Articles","Online seminars"]
                push?.arrParentingDashboardImage = ["note1","study2"]
                push?.arrParentingDashboardId = ["001","030"]
                push?.matchTitleSelect = self.matchTitleSelect
                push?.devesionIdCategory = dictevent["id_division"] as? String ?? ""
                push?.matchTitleShowSelect = str1
                self.navigationController?.pushViewController(push!, animated: true)
                
            }
            if str == "Single-Parent Families"
            {
                let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ParentingDashbaordId") as? ParentingDashbaord
                push?.matchCategory = dictevent["id_module"] as? String ?? ""
                push?.matchSubCategory = dictevent["id_category"] as? String ?? ""
                push?.arrParentingDashboardTitle = ["Articles","Audio","Online seminars"]
                push?.arrParentingDashboardImage = ["note1","music1","study2"]
                push?.arrParentingDashboardId = ["001","002","030"]
                push?.matchTitleSelect = self.matchTitleSelect
                push?.devesionIdCategory = dictevent["id_division"] as? String ?? ""
                push?.matchTitleShowSelect = str1
                self.navigationController?.pushViewController(push!, animated: true)
                
            }
            if str == "Blended and Stepfamilies"
            {
                let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ParentingDashbaordId") as? ParentingDashbaord
                push?.matchCategory = dictevent["id_module"] as? String ?? ""
                push?.matchSubCategory = dictevent["id_category"] as? String ?? ""
                push?.arrParentingDashboardTitle = ["Articles","Online seminars","Resources"]
                push?.arrParentingDashboardImage = ["note1","study2","care"]
                push?.arrParentingDashboardId = ["001","030","012"]
                push?.matchTitleSelect = self.matchTitleSelect
                push?.matchTitleShowSelect = str1
                push?.devesionIdCategory = dictevent["id_division"] as? String ?? ""
                self.navigationController?.pushViewController(push!, animated: true)
                
            }
            if str == "Military Families"
            {
                let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ParentingDashbaordId") as? ParentingDashbaord
                push?.matchCategory = dictevent["id_module"] as? String ?? ""
                push?.matchSubCategory = dictevent["id_category"] as? String ?? ""
                push?.arrParentingDashboardTitle = ["Articles","Online seminars","Resources"]
                push?.arrParentingDashboardImage = ["note1","study2","care"]
                push?.arrParentingDashboardId = ["001","030","012"]
                push?.matchTitleSelect = self.matchTitleSelect
                push?.matchTitleShowSelect = str1
                push?.devesionIdCategory = dictevent["id_division"] as? String ?? ""
                self.navigationController?.pushViewController(push!, animated: true)
                
            }
            if str == "More Information on Families"
            {
                let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ParentingDashbaordId") as? ParentingDashbaord
                push?.matchCategory = dictevent["id_module"] as? String ?? ""
                push?.matchSubCategory = dictevent["id_category"] as? String ?? ""
                push?.arrParentingDashboardTitle = ["Articles","Online seminars","Resources"]
                push?.arrParentingDashboardImage = ["note1","study2","care"]
                push?.arrParentingDashboardId = ["001","030","012"]
                push?.matchTitleSelect = self.matchTitleSelect
                push?.devesionIdCategory = dictevent["id_division"] as? String ?? ""
                push?.matchTitleShowSelect = str1
                self.navigationController?.pushViewController(push!, animated: true)
                
            }
            
        }
        if str1 == "Relationships"
        {
            
            // MARK:- Balancing category Relationships -
            if str == "Relationship Tips"
            {
                let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ParentingDashbaordId") as? ParentingDashbaord
                push?.matchCategory = dictevent["id_module"] as? String ?? ""
                push?.matchSubCategory = dictevent["id_category"] as? String ?? ""
                push?.arrParentingDashboardTitle = ["Articles","Audio","Online seminars","Resources"]
                push?.arrParentingDashboardImage = ["note1","music1","study2","care"]
                push?.arrParentingDashboardId = ["001","002","030","012"]
                push?.matchTitleSelect = self.matchTitleSelect
                push?.matchTitleShowSelect = str1
                push?.devesionIdCategory = dictevent["id_division"] as? String ?? ""
                self.navigationController?.pushViewController(push!, animated: true)
                
            }
            if str == "Coping with Separation or Divorce"
            {
                let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ParentingDashbaordId") as? ParentingDashbaord
                push?.matchCategory = dictevent["id_module"] as? String ?? ""
                push?.matchSubCategory = dictevent["id_category"] as? String ?? ""
                push?.arrParentingDashboardTitle = ["Articles"]
                push?.arrParentingDashboardImage = ["note1"]
                push?.arrParentingDashboardId = ["001"]
                push?.matchTitleSelect = self.matchTitleSelect
                push?.matchTitleShowSelect = str1
                push?.devesionIdCategory = dictevent["id_division"] as? String ?? ""
                self.navigationController?.pushViewController(push!, animated: true)
                
            }
            if str == "Couples"
            {
                let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ParentingDashbaordId") as? ParentingDashbaord
                push?.matchCategory = dictevent["id_module"] as? String ?? ""
                push?.matchSubCategory = dictevent["id_category"] as? String ?? ""
                push?.arrParentingDashboardTitle = ["Articles","Audio","Online seminars","Resources","procedure"]
                push?.arrParentingDashboardImage = ["note1","music1","study2","care","Procedure"]
                push?.arrParentingDashboardId = ["001","002","030","012","033"]
                push?.matchTitleSelect = self.matchTitleSelect
                push?.matchTitleShowSelect = str1
                push?.devesionIdCategory = dictevent["id_division"] as? String ?? ""
                self.navigationController?.pushViewController(push!, animated: true)
                
            }
            if str == "Coworkers"
            {
                let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ParentingDashbaordId") as? ParentingDashbaord
                push?.matchCategory = dictevent["id_module"] as? String ?? ""
                push?.matchSubCategory = dictevent["id_category"] as? String ?? ""
                push?.arrParentingDashboardTitle = ["Articles","Audio","Online seminars"]
                push?.arrParentingDashboardImage = ["note1","music1","study2"]
                push?.arrParentingDashboardId = ["001","002","030"]
                push?.matchTitleSelect = self.matchTitleSelect
                push?.matchTitleShowSelect = str1
                push?.devesionIdCategory = dictevent["id_division"] as? String ?? ""
                self.navigationController?.pushViewController(push!, animated: true)
                
            }
            if str == "Dating"
            {
                let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ParentingDashbaordId") as? ParentingDashbaord
                push?.matchCategory = dictevent["id_module"] as? String ?? ""
                push?.matchSubCategory = dictevent["id_category"] as? String ?? ""
                push?.arrParentingDashboardTitle = ["Articles","Audio","Resources"]
                push?.arrParentingDashboardImage = ["note1","music1","care"]
                push?.arrParentingDashboardId = ["001","002","012"]
                push?.matchTitleSelect = self.matchTitleSelect
                push?.matchTitleShowSelect = str1
                push?.devesionIdCategory = dictevent["id_division"] as? String ?? ""
                self.navigationController?.pushViewController(push!, animated: true)
                
            }
            if str == "Friendships"
            {
                let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ParentingDashbaordId") as? ParentingDashbaord
                push?.matchCategory = dictevent["id_module"] as? String ?? ""
                push?.matchSubCategory = dictevent["id_category"] as? String ?? ""
                push?.arrParentingDashboardTitle = ["Articles","Audio"]
                push?.arrParentingDashboardImage = ["note1","music1"]
                push?.arrParentingDashboardId = ["001","002"]
                push?.matchTitleShowSelect = str1
                push?.matchTitleSelect = self.matchTitleSelect
                push?.devesionIdCategory = dictevent["id_division"] as? String ?? ""
                self.navigationController?.pushViewController(push!, animated: true)
                
            }
            if str == "LGBTQ+ Couples"
            {
                let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ParentingDashbaordId") as? ParentingDashbaord
                push?.matchCategory = dictevent["id_module"] as? String ?? ""
                push?.matchSubCategory = dictevent["id_category"] as? String ?? ""
                push?.arrParentingDashboardTitle = ["Articles","Audio","Online seminars","Resources"]
                push?.arrParentingDashboardImage = ["note1","music1","study2","care"]
                push?.arrParentingDashboardId = ["001","002","030","012"]
                push?.matchTitleSelect = self.matchTitleSelect
                push?.devesionIdCategory = dictevent["id_division"] as? String ?? ""
                push?.matchTitleShowSelect = str1
                self.navigationController?.pushViewController(push!, animated: true)
                
            }
            if str == "Military"
            {
                let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ParentingDashbaordId") as? ParentingDashbaord
                push?.matchCategory = dictevent["id_module"] as? String ?? ""
                push?.matchSubCategory = dictevent["id_category"] as? String ?? ""
                push?.arrParentingDashboardTitle = ["Articles","Audio","Online seminars"]
                push?.arrParentingDashboardImage = ["note1","music1","study2"]
                push?.arrParentingDashboardId = ["001","002","030"]
                push?.matchTitleSelect = self.matchTitleSelect
                push?.matchTitleShowSelect = str1
                push?.devesionIdCategory = dictevent["id_division"] as? String ?? ""
                self.navigationController?.pushViewController(push!, animated: true)
                
            }
            if str == "Newlyweds"
            {
                let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ParentingDashbaordId") as? ParentingDashbaord
                push?.matchCategory = dictevent["id_module"] as? String ?? ""
                push?.matchSubCategory = dictevent["id_category"] as? String ?? ""
                push?.arrParentingDashboardTitle = ["Articles","Audio"]
                push?.arrParentingDashboardImage = ["note1","music1"]
                push?.arrParentingDashboardId = ["001","002"]
                push?.matchTitleSelect = self.matchTitleSelect
                push?.devesionIdCategory = dictevent["id_division"] as? String ?? ""
                push?.matchTitleShowSelect = str1
                self.navigationController?.pushViewController(push!, animated: true)
                
            }
            if str == "Singles"
            {
                let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ParentingDashbaordId") as? ParentingDashbaord
                push?.matchCategory = dictevent["id_module"] as? String ?? ""
                push?.matchSubCategory = dictevent["id_category"] as? String ?? ""
                push?.arrParentingDashboardTitle = ["Articles"]
                push?.arrParentingDashboardImage = ["note1"]
                push?.arrParentingDashboardId = ["001"]
                push?.devesionIdCategory = dictevent["id_division"] as? String ?? ""
                push?.matchTitleSelect = self.matchTitleSelect
                push?.matchTitleShowSelect = str1
                self.navigationController?.pushViewController(push!, animated: true)
                
            }
            if str == "Abusive"
            {
                let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ParentingDashbaordId") as? ParentingDashbaord
                push?.matchCategory = dictevent["id_module"] as? String ?? ""
                push?.matchSubCategory = dictevent["id_category"] as? String ?? ""
                push?.arrParentingDashboardTitle = ["Articles","Online seminars","Resources","SAMHSA"]
                push?.arrParentingDashboardImage = ["note1","study2","care","SMSHA"]
                push?.arrParentingDashboardId = ["001","002","012","037"]
                push?.matchTitleSelect = self.matchTitleSelect
                push?.devesionIdCategory = dictevent["id_division"] as? String ?? ""
                push?.matchTitleShowSelect = str1
                self.navigationController?.pushViewController(push!, animated: true)
                
            }
        }
        
        // MARK:- Balancing category Grief and Loss -
        
        if str == "Bereavement and Support"
        {
            let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ParentingDashbaordId") as? ParentingDashbaord
            push?.matchCategory = dictevent["id_module"] as? String ?? ""
            push?.matchSubCategory = dictevent["id_category"] as? String ?? ""
            push?.arrParentingDashboardTitle = ["Articles","Online seminars","Resources"]
            push?.arrParentingDashboardImage = ["note1","study2","care"]
            push?.arrParentingDashboardId = ["001","030","012"]
            push?.matchTitleSelect = self.matchTitleSelect
            push?.matchTitleShowSelect = str1
            push?.devesionIdCategory = dictevent["id_division"] as? String ?? ""
            self.navigationController?.pushViewController(push!, animated: true)
            
        }
        if str == "Coping with Chronic or Life-Threatening Illness"
        {
            let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ParentingDashbaordId") as? ParentingDashbaord
            push?.matchCategory = dictevent["id_module"] as? String ?? ""
            push?.matchSubCategory = dictevent["id_category"] as? String ?? ""
            push?.arrParentingDashboardTitle = ["Articles","Medline","Online seminars","Resources"]
            push?.arrParentingDashboardImage = ["note1","Medecine","study2","care"]
            push?.arrParentingDashboardId = ["001","016","030","012"]
            push?.matchTitleSelect = self.matchTitleSelect
            push?.matchTitleShowSelect = str1
            push?.devesionIdCategory = dictevent["id_division"] as? String ?? ""
            self.navigationController?.pushViewController(push!, animated: true)
            
        }
        if str == "Coping with Traumatic Loss"
        {
            let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ParentingDashbaordId") as? ParentingDashbaord
            push?.matchCategory = dictevent["id_module"] as? String ?? ""
            push?.matchSubCategory = dictevent["id_category"] as? String ?? ""
            push?.arrParentingDashboardTitle = ["Articles","Frequently Asked Questions","Online seminars","Resources"]
            push?.arrParentingDashboardImage = ["note1","faq","study2","care"]
            push?.arrParentingDashboardId = ["001","013","030","012"]
            push?.matchTitleSelect = self.matchTitleSelect
            push?.devesionIdCategory = dictevent["id_division"] as? String ?? ""
            push?.matchTitleShowSelect = str1
            self.navigationController?.pushViewController(push!, animated: true)
            
        }
        if str == "Death of a Child"
        {
            let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ParentingDashbaordId") as? ParentingDashbaord
            push?.matchCategory = dictevent["id_module"] as? String ?? ""
            push?.matchSubCategory = dictevent["id_category"] as? String ?? ""
            push?.arrParentingDashboardTitle = ["Articles","Online seminars","Resources"]
            push?.arrParentingDashboardImage = ["note1","study2","care"]
            push?.arrParentingDashboardId = ["001","030","012"]
            push?.matchTitleSelect = self.matchTitleSelect
            push?.devesionIdCategory = dictevent["id_division"] as? String ?? ""
            push?.matchTitleShowSelect = str1
            self.navigationController?.pushViewController(push!, animated: true)
            
        }
        if str == "Death of a Spouse"
        {
            let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ParentingDashbaordId") as? ParentingDashbaord
            push?.matchCategory = dictevent["id_module"] as? String ?? ""
            push?.matchSubCategory = dictevent["id_category"] as? String ?? ""
            push?.arrParentingDashboardTitle = ["Articles","Online seminars","Resources"]
            push?.arrParentingDashboardImage = ["note1","study2","care"]
            push?.arrParentingDashboardId = ["001","030","012"]
            push?.matchTitleSelect = self.matchTitleSelect
            push?.devesionIdCategory = dictevent["id_division"] as? String ?? ""
            push?.matchTitleShowSelect = str1
            self.navigationController?.pushViewController(push!, animated: true)
            
        }
        if str == "Death of a Parent or Grandparent"
        {
            let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ParentingDashbaordId") as? ParentingDashbaord
            push?.matchCategory = dictevent["id_module"] as? String ?? ""
            push?.matchSubCategory = dictevent["id_category"] as? String ?? ""
            push?.arrParentingDashboardTitle = ["Articles","Online seminars"]
            push?.arrParentingDashboardImage = ["note1","study2"]
            push?.arrParentingDashboardId = ["001","030"]
            push?.matchTitleSelect = self.matchTitleSelect
            push?.devesionIdCategory = dictevent["id_division"] as? String ?? ""
            push?.matchTitleShowSelect = str1
            self.navigationController?.pushViewController(push!, animated: true)
            
        }
        if str == "Death of a Friend"
        {
            let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ParentingDashbaordId") as? ParentingDashbaord
            push?.matchCategory = dictevent["id_module"] as? String ?? ""
            push?.matchSubCategory = dictevent["id_category"] as? String ?? ""
            push?.arrParentingDashboardTitle = ["Articles","Online seminars","Resources"]
            push?.arrParentingDashboardImage = ["note1","study2","care"]
            push?.arrParentingDashboardId = ["001","030","012"]
            push?.matchTitleSelect = self.matchTitleSelect
            push?.devesionIdCategory = dictevent["id_division"] as? String ?? ""
            push?.matchTitleShowSelect = str1
            self.navigationController?.pushViewController(push!, animated: true)
            
        }
        if str == "Death of a Co-Worker"
        {
            let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ParentingDashbaordId") as? ParentingDashbaord
            push?.matchCategory = dictevent["id_module"] as? String ?? ""
            push?.matchSubCategory = dictevent["id_category"] as? String ?? ""
            push?.arrParentingDashboardTitle = ["Articles","Online seminars","Resources"]
            push?.arrParentingDashboardImage = ["note1","study2","care"]
            push?.arrParentingDashboardId = ["001","030","012"]
            push?.matchTitleSelect = self.matchTitleSelect
            push?.devesionIdCategory = dictevent["id_division"] as? String ?? ""
            push?.matchTitleShowSelect = str1
            self.navigationController?.pushViewController(push!, animated: true)
            
        }
        if str == "Loss of a Job"
        {
            let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ParentingDashbaordId") as? ParentingDashbaord
            push?.matchCategory = dictevent["id_module"] as? String ?? ""
            push?.matchSubCategory = dictevent["id_category"] as? String ?? ""
            push?.arrParentingDashboardTitle = ["Articles","Online seminars"]
            push?.arrParentingDashboardImage = ["note1","study2"]
            push?.arrParentingDashboardId = ["001","030"]
            push?.devesionIdCategory = dictevent["id_division"] as? String ?? ""
            push?.matchTitleSelect = self.matchTitleSelect
            push?.matchTitleShowSelect = str1
            self.navigationController?.pushViewController(push!, animated: true)
            
        }
        if str == "Loss of a Relationship"
        {
            let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ParentingDashbaordId") as? ParentingDashbaord
            push?.matchCategory = dictevent["id_module"] as? String ?? ""
            push?.matchSubCategory = dictevent["id_category"] as? String ?? ""
            push?.arrParentingDashboardTitle = ["Articles","Online seminars"]
            push?.arrParentingDashboardImage = ["note1","study2"]
            push?.arrParentingDashboardId = ["001","030"]
            push?.devesionIdCategory = dictevent["id_division"] as? String ?? ""
            push?.matchTitleSelect = self.matchTitleSelect
            push?.matchTitleShowSelect = str1
            self.navigationController?.pushViewController(push!, animated: true)
            
        }
        if str == "Loss of a Pet"
        {
            let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ParentingDashbaordId") as? ParentingDashbaord
            push?.matchCategory = dictevent["id_module"] as? String ?? ""
            push?.matchSubCategory = dictevent["id_category"] as? String ?? ""
            push?.arrParentingDashboardTitle = ["Articles","Online seminars","Resources"]
            push?.arrParentingDashboardImage = ["note1","study2","care"]
            push?.arrParentingDashboardId = ["001","030","012"]
            push?.devesionIdCategory = dictevent["id_division"] as? String ?? ""
            push?.matchTitleSelect = self.matchTitleSelect
            push?.matchTitleShowSelect = str1
            self.navigationController?.pushViewController(push!, animated: true)
            
        }
        if str == "Funerals"
        {
            let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ParentingDashbaordId") as? ParentingDashbaord
            push?.matchCategory = dictevent["id_module"] as? String ?? ""
            push?.matchSubCategory = dictevent["id_category"] as? String ?? ""
            push?.arrParentingDashboardTitle = ["Articles"]
            push?.arrParentingDashboardImage = ["note1"]
            push?.arrParentingDashboardId = ["001"]
            push?.devesionIdCategory = dictevent["id_division"] as? String ?? ""
            push?.matchTitleSelect = self.matchTitleSelect
            push?.matchTitleShowSelect = str1
            self.navigationController?.pushViewController(push!, animated: true)
            
        }
        if str1 == "Mental Health"
        {
            // MARK:- Balancing category Mental Health -
            
            if str == "Coping with Mental Health Issues"
            {
                let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ParentingDashbaordId") as? ParentingDashbaord
                push?.matchCategory = dictevent["id_module"] as? String ?? ""
                push?.matchSubCategory = dictevent["id_category"] as? String ?? ""
                push?.arrParentingDashboardTitle = ["Articles","Audio","Online seminars","procedure","Resources","Video"]
                push?.arrParentingDashboardImage = ["note1","music1","study2","Procedure","care","Videos"]
                push?.arrParentingDashboardId = ["001","002","030","033","012","045"]
                push?.matchTitleSelect = self.matchTitleSelect
                push?.devesionIdCategory = dictevent["id_division"] as? String ?? ""
                push?.matchTitleShowSelect = str1
                self.navigationController?.pushViewController(push!, animated: true)
                
            }
            if str == "ADHD" {
                
                let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ParentingDashbaordId") as? ParentingDashbaord
                push?.matchCategory = dictevent["id_module"] as? String ?? ""
                push?.matchSubCategory = dictevent["id_category"] as? String ?? ""
                push?.matchTitleShowSelect = str1
                push?.arrParentingDashboardTitle = ["Articles","Resources"]
                push?.arrParentingDashboardImage = ["note1","care"]
                push?.matchTitleSelect = self.matchTitleSelect
                push?.arrParentingDashboardId = ["001","012"]
                push?.devesionIdCategory = dictevent["id_division"] as? String ?? ""
                self.navigationController?.pushViewController(push!, animated: true)
            }
            if str == "Anxiety and Panic"
            {
                let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ParentingDashbaordId") as? ParentingDashbaord
                push?.matchCategory = dictevent["id_module"] as? String ?? ""
                push?.matchSubCategory = dictevent["id_category"] as? String ?? ""
                push?.arrParentingDashboardTitle = ["Articles","Audio","Online seminars","procedure","Resources","Videos"]
                push?.arrParentingDashboardImage = ["note1","music1","study2","Procedure","care","Videos"]
                push?.matchTitleSelect = self.matchTitleSelect
                push?.devesionIdCategory = dictevent["id_division"] as? String ?? ""
                push?.matchTitleShowSelect = str1
                push?.arrParentingDashboardId = ["001","002","030","033","012","045"]
                self.navigationController?.pushViewController(push!, animated: true)
                
            }
            if str == "Autism Spectrum Disorders (ASD)"
            {
                let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ParentingDashbaordId") as? ParentingDashbaord
                push?.matchCategory = dictevent["id_module"] as? String ?? ""
                push?.matchSubCategory = dictevent["id_category"] as? String ?? ""
                push?.arrParentingDashboardTitle = ["Articles","Frequently Asked Questions"]
                push?.arrParentingDashboardImage = ["note1","faq"]
                push?.matchTitleSelect = self.matchTitleSelect
                push?.arrParentingDashboardId = ["001","013"]
                push?.devesionIdCategory = dictevent["id_division"] as? String ?? ""
                push?.matchTitleShowSelect = str1
                self.navigationController?.pushViewController(push!, animated: true)
                
            }
            if str == "Bipolar Disorder"
            {
                let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ParentingDashbaordId") as? ParentingDashbaord
                push?.matchCategory = dictevent["id_module"] as? String ?? ""
                push?.matchSubCategory = dictevent["id_category"] as? String ?? ""
                push?.arrParentingDashboardTitle = ["Articles","Frequently Asked Questions","Resources"]
                push?.arrParentingDashboardImage = ["note1","faq","care"]
                push?.matchTitleSelect = self.matchTitleSelect
                push?.arrParentingDashboardId = ["001","013","012"]
                push?.devesionIdCategory = dictevent["id_division"] as? String ?? ""
                push?.matchTitleShowSelect = str1
                self.navigationController?.pushViewController(push!, animated: true)
                
            }
            if str == "Depression and Dysthymia"
            {
                
                let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ParentingDashbaordId") as? ParentingDashbaord
                push?.matchCategory = dictevent["id_module"] as? String ?? ""
                push?.matchSubCategory = dictevent["id_category"] as? String ?? ""
                push?.arrParentingDashboardTitle = ["Articles","Audio","Frequently Asked Questions","Online seminars","Resources","Videos"]
                push?.arrParentingDashboardImage = ["note1","music1","faq","study2","care","Videos"]
                push?.matchTitleSelect = self.matchTitleSelect
                push?.arrParentingDashboardId = ["001","002","013","012","045"]
                push?.devesionIdCategory = dictevent["id_division"] as? String ?? ""
                push?.matchTitleShowSelect = str1
                self.navigationController?.pushViewController(push!, animated: true)
                
            }
            if str == "Coping with Crisis"
            {
                
                let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ParentingDashbaordId") as? ParentingDashbaord
                push?.matchCategory = dictevent["id_module"] as? String ?? ""
                push?.matchSubCategory = dictevent["id_category"] as? String ?? ""
                push?.arrParentingDashboardTitle = ["Articles","Online seminars","Resources"]
                push?.arrParentingDashboardImage = ["note1","study2","care"]
                push?.matchTitleSelect = self.matchTitleSelect
                push?.arrParentingDashboardId = ["001","030","012"]
                push?.devesionIdCategory = dictevent["id_division"] as? String ?? ""
                push?.matchTitleShowSelect = str1
                self.navigationController?.pushViewController(push!, animated: true)
                
            }
            if str == "Compulsive Disorders"
            {
                
                let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ParentingDashbaordId") as? ParentingDashbaord
                push?.matchCategory = dictevent["id_module"] as? String ?? ""
                push?.matchSubCategory = dictevent["id_category"] as? String ?? ""
                push?.arrParentingDashboardTitle = ["Articles","Online seminars","Resources","SAMHSA"]
                push?.arrParentingDashboardImage = ["note1","study2","care","SMSHA"]
                push?.matchTitleSelect = self.matchTitleSelect
                push?.matchTitleShowSelect = str1
                push?.devesionIdCategory = dictevent["id_division"] as? String ?? ""
                push?.arrParentingDashboardId = ["001","030","012","037"]
                self.navigationController?.pushViewController(push!, animated: true)
                
            }
            if str == "Mental Health Consumer Tips"
            {
                
                let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ParentingDashbaordId") as? ParentingDashbaord
                push?.matchCategory = dictevent["id_module"] as? String ?? ""
                push?.matchSubCategory = dictevent["id_category"] as? String ?? ""
                push?.arrParentingDashboardTitle = ["Articles","Audio","Frequently Asked Questions","Online seminars","Resources"]
                push?.arrParentingDashboardImage = ["note1","music1","faq","study2","care"]
                push?.matchTitleSelect = self.matchTitleSelect
                push?.devesionIdCategory = dictevent["id_division"] as? String ?? ""
                push?.matchTitleShowSelect = str1
                push?.arrParentingDashboardId = ["001","002","013","030","012"]
                self.navigationController?.pushViewController(push!, animated: true)
                
            }
            if str == "Personality Disorders"
            {
                
                let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ParentingDashbaordId") as? ParentingDashbaord
                push?.matchCategory = dictevent["id_module"] as? String ?? ""
                push?.devesionIdCategory = dictevent["id_division"] as? String ?? ""
                push?.matchSubCategory = dictevent["id_category"] as? String ?? ""
                push?.arrParentingDashboardTitle = ["Articles","Audio","Frequently Asked Questions","Resources"]
                push?.arrParentingDashboardImage = ["note1","music1","faq","care"]
                push?.matchTitleSelect = self.matchTitleSelect
                push?.matchTitleShowSelect = str1
                push?.arrParentingDashboardId = ["001","002","013","012"]
                self.navigationController?.pushViewController(push!, animated: true)
                
            }
            if str == "Phobias"
            {
                
                let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ParentingDashbaordId") as? ParentingDashbaord
                push?.matchCategory = dictevent["id_module"] as? String ?? ""
                push?.devesionIdCategory = dictevent["id_division"] as? String ?? ""
                push?.matchSubCategory = dictevent["id_category"] as? String ?? ""
                push?.arrParentingDashboardTitle = ["Articles","Resources"]
                push?.arrParentingDashboardImage = ["note1","care"]
                push?.matchTitleSelect = self.matchTitleSelect
                push?.arrParentingDashboardId = ["001","012"]
                push?.matchTitleShowSelect = str1
                self.navigationController?.pushViewController(push!, animated: true)
                
            }
            if str == "Schizophrenia"
            {
                
                let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ParentingDashbaordId") as? ParentingDashbaord
                push?.matchCategory = dictevent["id_module"] as? String ?? ""
                push?.devesionIdCategory = dictevent["id_division"] as? String ?? ""
                push?.matchSubCategory = dictevent["id_category"] as? String ?? ""
                push?.arrParentingDashboardTitle = ["Resources"]
                push?.arrParentingDashboardImage = ["care"]
                push?.matchTitleSelect = self.matchTitleSelect
                push?.arrParentingDashboardId = ["012"]
                push?.matchTitleShowSelect = str1
                self.navigationController?.pushViewController(push!, animated: true)
                
            }
            if str == "Seasonal Affective Disorder"
            {
                
                let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ParentingDashbaordId") as? ParentingDashbaord
                push?.matchCategory = dictevent["id_module"] as? String ?? ""
                push?.devesionIdCategory = dictevent["id_division"] as? String ?? ""
                push?.matchSubCategory = dictevent["id_category"] as? String ?? ""
                push?.arrParentingDashboardTitle = ["Articles","Audio","Online seminars, Resources","Resources","Video"]
                push?.arrParentingDashboardImage = ["note1","music1","study2","care","Videos"]
                push?.matchTitleSelect = self.matchTitleSelect
                push?.matchTitleShowSelect = str1
                push?.arrParentingDashboardId = ["001","002","030","012","045"]
                self.navigationController?.pushViewController(push!, animated: true)
                
            }
            if str == "Stress"
            {
                
                let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ParentingDashbaordId") as? ParentingDashbaord
                push?.matchCategory = dictevent["id_module"] as? String ?? ""
                push?.matchSubCategory = dictevent["id_category"] as? String ?? ""
                push?.devesionIdCategory = dictevent["id_division"] as? String ?? ""
                push?.arrParentingDashboardTitle = ["Articles","Audio","Frequently Asked Questions","Online seminars","Resources","Video"]
                push?.arrParentingDashboardImage = ["note1","music1","faq","study2","care","Videos"]
                push?.matchTitleSelect = self.matchTitleSelect
                push?.matchTitleShowSelect = str1
                push?.arrParentingDashboardId = ["001","002","013","030","012","045"]
                self.navigationController?.pushViewController(push!, animated: true)
                
            }
            if str == "Suicide"
            {
                
                let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ParentingDashbaordId") as? ParentingDashbaord
                push?.matchCategory = dictevent["id_module"] as? String ?? ""
                push?.devesionIdCategory = dictevent["id_division"] as? String ?? ""
                push?.matchSubCategory = dictevent["id_category"] as? String ?? ""
                push?.arrParentingDashboardTitle = ["Articles","Online seminars","Resources"]
                push?.arrParentingDashboardImage = ["note1","study2","care"]
                push?.arrParentingDashboardId = ["001","030","012"]
                push?.matchTitleSelect = self.matchTitleSelect
                push?.matchTitleShowSelect = str1
                self.navigationController?.pushViewController(push!, animated: true)
                
            }
        }
        if str1 == "Addiction and Recovery"
        {
            // MARK:- Balancing category Addiction and Recovery -
            if str == "Preventing Addictive Behavior"
            {
                
                let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ParentingDashbaordId") as? ParentingDashbaord
                push?.matchCategory = dictevent["id_module"] as? String ?? ""
                push?.devesionIdCategory = dictevent["id_division"] as? String ?? ""
                push?.matchSubCategory = dictevent["id_category"] as? String ?? ""
                push?.arrParentingDashboardTitle = ["Articles","Resources"]
                push?.arrParentingDashboardImage = ["note1","care"]
                push?.arrParentingDashboardId = ["001","012"]
                push?.matchTitleSelect = self.matchTitleSelect
                push?.matchTitleShowSelect = str1
                self.navigationController?.pushViewController(push!, animated: true)
                
            }
            if str == "Preventing Substance Addiction"
            {
                
                let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ParentingDashbaordId") as? ParentingDashbaord
                push?.matchCategory = dictevent["id_module"] as? String ?? ""
                push?.matchSubCategory = dictevent["id_category"] as? String ?? ""
                push?.arrParentingDashboardTitle = ["Articles","Medline","Resources"]
                push?.arrParentingDashboardImage = ["note1","Medecine","care"]
                push?.arrParentingDashboardId = ["001","016","012"]
                push?.devesionIdCategory = dictevent["id_division"] as? String ?? ""
                push?.matchTitleSelect = self.matchTitleSelect
                push?.matchTitleShowSelect = str1
                self.navigationController?.pushViewController(push!, animated: true)
                
            }
            if str == "Family Coping Strategies"
            {
                
                let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ParentingDashbaordId") as? ParentingDashbaord
                push?.matchCategory = dictevent["id_module"] as? String ?? ""
                push?.matchSubCategory = dictevent["id_category"] as? String ?? ""
                push?.arrParentingDashboardTitle = ["Articles","Online seminars","Resources"]
                push?.arrParentingDashboardImage = ["note1","study2","care"]
                push?.arrParentingDashboardId = ["001","030","012"]
                push?.devesionIdCategory = dictevent["id_division"] as? String ?? ""
                push?.matchTitleSelect = self.matchTitleSelect
                push?.matchTitleShowSelect = str1
                self.navigationController?.pushViewController(push!, animated: true)
                
            }
            if str == "Recovery"
            {
                
                let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ParentingDashbaordId") as? ParentingDashbaord
                push?.matchCategory = dictevent["id_module"] as? String ?? ""
                push?.matchSubCategory = dictevent["id_category"] as? String ?? ""
                push?.arrParentingDashboardTitle = ["Articles","Audio","Online seminars","Resources","SAMHSA"]
                push?.arrParentingDashboardImage = ["note1","music1","study2","care","SMSHA"]
                push?.arrParentingDashboardId = ["001","002","030","012","037"]
                push?.matchTitleSelect = self.matchTitleSelect
                push?.devesionIdCategory = dictevent["id_division"] as? String ?? ""
                push?.matchTitleShowSelect = str1
                self.navigationController?.pushViewController(push!, animated: true)
                
            }
            if str == "Spotting Addiction"
            {
                
                let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ParentingDashbaordId") as? ParentingDashbaord
                push?.matchCategory = dictevent["id_module"] as? String ?? ""
                push?.matchSubCategory = dictevent["id_category"] as? String ?? ""
                push?.arrParentingDashboardTitle = ["Articles","Online seminars","Resources"]
                push?.arrParentingDashboardImage = ["note1","study2","care"]
                push?.arrParentingDashboardId = ["001","030","012"]
                push?.matchTitleSelect = self.matchTitleSelect
                push?.devesionIdCategory = dictevent["id_division"] as? String ?? ""
                push?.matchTitleShowSelect = str1
                self.navigationController?.pushViewController(push!, animated: true)
                
            }
            if str == "Gambling and Online Gaming"
            {
                
                let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ParentingDashbaordId") as? ParentingDashbaord
                push?.matchCategory = dictevent["id_module"] as? String ?? ""
                push?.matchSubCategory = dictevent["id_category"] as? String ?? ""
                push?.arrParentingDashboardTitle = ["Articles","Online seminars","Resources"]
                push?.arrParentingDashboardImage = ["note1","study2","care"]
                push?.arrParentingDashboardId = ["001","030","012"]
                push?.matchTitleSelect = self.matchTitleSelect
                push?.devesionIdCategory = dictevent["id_division"] as? String ?? ""
                push?.matchTitleShowSelect = str1
                self.navigationController?.pushViewController(push!, animated: true)
                
            }
            if str == "Shopping"
            {
                
                let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ParentingDashbaordId") as? ParentingDashbaord
                push?.matchCategory = dictevent["id_module"] as? String ?? ""
                push?.matchSubCategory = dictevent["id_category"] as? String ?? ""
                push?.arrParentingDashboardTitle = ["Online seminars"]
                push?.arrParentingDashboardImage = ["study2"]
                push?.matchTitleSelect = self.matchTitleSelect
                push?.devesionIdCategory = dictevent["id_division"] as? String ?? ""
                push?.matchTitleShowSelect = str1
                push?.arrParentingDashboardId = ["030"]
                self.navigationController?.pushViewController(push!, animated: true)
                
            }
            if str == "Other Addictive Behaviors"
            {
                
                let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ParentingDashbaordId") as? ParentingDashbaord
                push?.matchCategory = dictevent["id_module"] as? String ?? ""
                push?.matchSubCategory = dictevent["id_category"] as? String ?? ""
                push?.arrParentingDashboardTitle = ["Articles","Online seminars","Resources"]
                push?.arrParentingDashboardImage = ["note1","study2","care"]
                push?.arrParentingDashboardId = ["001","030","012"]
                push?.matchTitleShowSelect = str1
                push?.matchTitleSelect = self.matchTitleSelect
                push?.devesionIdCategory = dictevent["id_division"] as? String ?? ""
                self.navigationController?.pushViewController(push!, animated: true)
                
            }
            if str == "Alcohol"
            {
                
                let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ParentingDashbaordId") as? ParentingDashbaord
                push?.matchCategory = dictevent["id_module"] as? String ?? ""
                push?.matchSubCategory = dictevent["id_category"] as? String ?? ""
                push?.arrParentingDashboardTitle = ["Articles","Frequently Asked Questions","Online seminars","Resources"]
                push?.arrParentingDashboardImage = ["note1","faq","study2","care"]
                push?.arrParentingDashboardId = ["001","013","030","012"]
                push?.matchTitleSelect = self.matchTitleSelect
                push?.devesionIdCategory = dictevent["id_division"] as? String ?? ""
                push?.matchTitleShowSelect = str1
                self.navigationController?.pushViewController(push!, animated: true)
                
            }
            if str == "Club Drugs"
            {
                
                let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ParentingDashbaordId") as? ParentingDashbaord
                push?.matchCategory = dictevent["id_module"] as? String ?? ""
                push?.matchSubCategory = dictevent["id_category"] as? String ?? ""
                push?.arrParentingDashboardTitle = ["Online seminars"]
                push?.arrParentingDashboardImage = ["study2"]
                push?.devesionIdCategory = dictevent["id_division"] as? String ?? ""
                push?.arrParentingDashboardId = ["030"]
                push?.matchTitleSelect = self.matchTitleSelect
                push?.matchTitleShowSelect = str1
                self.navigationController?.pushViewController(push!, animated: true)
                
            }
            if str == "Cocaine and Crack"
            {
                
                let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ParentingDashbaordId") as? ParentingDashbaord
                push?.matchCategory = dictevent["id_module"] as? String ?? ""
                push?.matchSubCategory = dictevent["id_category"] as? String ?? ""
                push?.arrParentingDashboardTitle = ["Online seminars","Resources"]
                push?.arrParentingDashboardImage = ["study2","care"]
                push?.devesionIdCategory = dictevent["id_division"] as? String ?? ""
                push?.arrParentingDashboardId = ["030","012"]
                push?.matchTitleSelect = self.matchTitleSelect
                push?.matchTitleShowSelect = str1
                self.navigationController?.pushViewController(push!, animated: true)
                
            }
            if str == "Heroin"
            {
                
                let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ParentingDashbaordId") as? ParentingDashbaord
                push?.matchCategory = dictevent["id_module"] as? String ?? ""
                push?.matchSubCategory = dictevent["id_category"] as? String ?? ""
                push?.arrParentingDashboardTitle = ["Articles","Online seminars","Resources"]
                push?.arrParentingDashboardImage = ["note1","study2","care"]
                push?.arrParentingDashboardId = ["001","030","012"]
                push?.matchTitleSelect = self.matchTitleSelect
                push?.devesionIdCategory = dictevent["id_division"] as? String ?? ""
                push?.matchTitleShowSelect = str1
                self.navigationController?.pushViewController(push!, animated: true)
                
            }
            if str == "Inhalants"
            {
                
                let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ParentingDashbaordId") as? ParentingDashbaord
                push?.matchCategory = dictevent["id_module"] as? String ?? ""
                push?.matchSubCategory = dictevent["id_category"] as? String ?? ""
                push?.arrParentingDashboardTitle = ["Articles","Online seminars"]
                push?.arrParentingDashboardImage = ["note1","study2"]
                push?.arrParentingDashboardId = ["001","030"]
                push?.matchTitleSelect = self.matchTitleSelect
                push?.devesionIdCategory = dictevent["id_division"] as? String ?? ""
                push?.matchTitleShowSelect = str1
                self.navigationController?.pushViewController(push!, animated: true)
                
            }
            if str == "Marijuana"
            {
                
                let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ParentingDashbaordId") as? ParentingDashbaord
                push?.matchCategory = dictevent["id_module"] as? String ?? ""
                push?.matchSubCategory = dictevent["id_category"] as? String ?? ""
                push?.arrParentingDashboardTitle = ["Frequently Asked Questions","Online seminars"]
                push?.arrParentingDashboardImage = ["faq","study2"]
                push?.arrParentingDashboardId = ["001","030"]
                push?.devesionIdCategory = dictevent["id_division"] as? String ?? ""
                push?.matchTitleSelect = self.matchTitleSelect
                push?.matchTitleShowSelect = str1
                self.navigationController?.pushViewController(push!, animated: true)
                
            }
            if str == "Methamphetamine"
            {
                
                let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ParentingDashbaordId") as? ParentingDashbaord
                push?.matchCategory = dictevent["id_module"] as? String ?? ""
                push?.matchSubCategory = dictevent["id_category"] as? String ?? ""
                push?.arrParentingDashboardTitle = ["Online seminars"]
                push?.arrParentingDashboardImage = ["study2"]
                push?.devesionIdCategory = dictevent["id_division"] as? String ?? ""
                push?.arrParentingDashboardId = ["030"]
                push?.matchTitleShowSelect = str1
                push?.matchTitleSelect = self.matchTitleSelect
                self.navigationController?.pushViewController(push!, animated: true)
                
            }
            if str == "Nicotine and Tobacco"
            {
                
                let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ParentingDashbaordId") as? ParentingDashbaord
                push?.matchCategory = dictevent["id_module"] as? String ?? ""
                push?.matchSubCategory = dictevent["id_category"] as? String ?? ""
                push?.arrParentingDashboardTitle = ["Articles","Audio","Frequently Asked Questions","Online seminars","Resources","Video"]
                push?.devesionIdCategory = dictevent["id_division"] as? String ?? ""
                push?.arrParentingDashboardImage = ["note1","music1","faq","study2","care","Videos"]
                push?.arrParentingDashboardId = ["001","002","013","030","012","045"]
                push?.matchTitleSelect = self.matchTitleSelect
                push?.matchTitleShowSelect = str1
                self.navigationController?.pushViewController(push!, animated: true)
                
            }
            if str == "Prescription Medicines"
            {
                
                let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ParentingDashbaordId") as? ParentingDashbaord
                push?.matchCategory = dictevent["id_module"] as? String ?? ""
                push?.matchSubCategory = dictevent["id_category"] as? String ?? ""
                push?.arrParentingDashboardTitle = ["Articles","Online seminars","Resources"]
                push?.arrParentingDashboardImage = ["note1","study2","care"]
                push?.arrParentingDashboardId = ["001","030","012"]
                push?.matchTitleSelect = self.matchTitleSelect
                push?.devesionIdCategory = dictevent["id_division"] as? String ?? ""
                push?.matchTitleShowSelect = str1
                self.navigationController?.pushViewController(push!, animated: true)
                
            }
            
            if str == "Other Addictive Substances"
            {
                
                let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ParentingDashbaordId") as? ParentingDashbaord
                push?.matchCategory = dictevent["id_module"] as? String ?? ""
                push?.matchSubCategory = dictevent["id_category"] as? String ?? ""
                push?.arrParentingDashboardTitle = ["Articles","Frequently Asked Questions","Resources"]
                push?.arrParentingDashboardImage = ["note1","faq","care"]
                push?.arrParentingDashboardId = ["001","013","012"]
                push?.matchTitleSelect = self.matchTitleSelect
                push?.devesionIdCategory = dictevent["id_division"] as? String ?? ""
                push?.matchTitleShowSelect = str1
                self.navigationController?.pushViewController(push!, animated: true)
                
            }
        }
        if str1 == "Live Healthy"
        {
            if str == "How Healthy Are You?"
            {
                
                let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ParentingDashbaordId") as? ParentingDashbaord
                push?.matchCategory = dictevent["id_module"] as? String ?? ""
                push?.matchSubCategory = dictevent["id_category"] as? String ?? ""
                push?.arrParentingDashboardTitle = ["Articles","Frequently Asked Questions","Handbook","Medline","Online seminars","Resources","Videos","WebMd"]
                push?.arrParentingDashboardImage = ["note1","faq","Handbooks","Medecine","study2","care","Videos",""]
                push?.arrParentingDashboardId = ["001","013","004","016","030","012","045","049"]
                push?.matchTitleSelect = self.matchTitleSelect
                push?.devesionIdCategory = dictevent["id_division"] as? String ?? ""
                push?.matchTitleShowSelect = str1
                self.navigationController?.pushViewController(push!, animated: true)
                
            }
            if str == "Physical Fitness"
            {
                
                let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ParentingDashbaordId") as? ParentingDashbaord
                push?.matchCategory = dictevent["id_module"] as? String ?? ""
                push?.matchSubCategory = dictevent["id_category"] as? String ?? ""
                push?.arrParentingDashboardTitle = ["Articles","Frequently Asked Questions","Handbook","Medline","Online seminars","Resources","Slideshows","Videos"]
                push?.arrParentingDashboardImage = ["note1","faq","Handbooks","Medecine","study2","care","care","Videos"]
                push?.arrParentingDashboardId = ["001","013","004","016","030","012","066","045"]
                push?.matchTitleSelect = self.matchTitleSelect
                push?.devesionIdCategory = dictevent["id_division"] as? String ?? ""
                push?.matchTitleShowSelect = str1
                self.navigationController?.pushViewController(push!, animated: true)
                
            }
            if str == "Lifestyle Change"
            {
                
                let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ParentingDashbaordId") as? ParentingDashbaord
                push?.matchCategory = dictevent["id_module"] as? String ?? ""
                push?.matchSubCategory = dictevent["id_category"] as? String ?? ""
                push?.arrParentingDashboardTitle = ["Articles","Frequently Asked Questions","Handbook","Medline","Online seminars","Resources","Slideshows","Videos"]
                push?.arrParentingDashboardImage = ["note1","faq","Handbooks","Medecine","study2","care","care","Videos"]
                push?.arrParentingDashboardId = ["001","013","004","016","030","012","066","045"]
                push?.matchTitleSelect = self.matchTitleSelect
                push?.devesionIdCategory = dictevent["id_division"] as? String ?? ""
                push?.matchTitleShowSelect = str1
                self.navigationController?.pushViewController(push!, animated: true)
                
            }
            if str == "Prevention and Screening"
            {
                
                let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ParentingDashbaordId") as? ParentingDashbaord
                push?.matchCategory = dictevent["id_module"] as? String ?? ""
                push?.matchSubCategory = dictevent["id_category"] as? String ?? ""
                push?.arrParentingDashboardTitle = ["Articles","Frequently Asked Questions","Medline","Online seminars","Procedure","Resources","Videos"]
                push?.devesionIdCategory = dictevent["id_division"] as? String ?? ""
                push?.arrParentingDashboardImage = ["note1","faq","Medecine","study2","Procedure","care","Videos"]
                push?.arrParentingDashboardId = ["001","013","004","016","030","033","012","045"]
                push?.matchTitleSelect = self.matchTitleSelect
                push?.matchTitleShowSelect = str1
                self.navigationController?.pushViewController(push!, animated: true)
                
            }
            if str == "Tips for Healthy Living"
            {
                
                let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ParentingDashbaordId") as? ParentingDashbaord
                push?.matchCategory = dictevent["id_module"] as? String ?? ""
                push?.devesionIdCategory = dictevent["id_division"] as? String ?? ""
                push?.matchSubCategory = dictevent["id_category"] as? String ?? ""
                push?.arrParentingDashboardTitle = ["Articles","Frequently Asked Questions","Medline","Online seminars","Procedure","Resources","Slideshows","Videos"]
                push?.arrParentingDashboardImage = ["note1","faq","Medecine","study2","Procedure","care","care","Videos"]
                push?.matchTitleSelect = self.matchTitleSelect
                push?.matchTitleShowSelect = str1
                push?.arrParentingDashboardId = ["001","013","016","030","033","012","066","045"]
                self.navigationController?.pushViewController(push!, animated: true)
                
            }
        }
        if str1 == "Health Tools"
        {
            if str == "Assess Your Health"
            {
                
                let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ParentingDashbaordId") as? ParentingDashbaord
                push?.matchCategory = dictevent["id_module"] as? String ?? ""
                push?.matchSubCategory = dictevent["id_category"] as? String ?? ""
                push?.arrParentingDashboardTitle = ["Articles"]
                push?.arrParentingDashboardImage = ["note1"]
                push?.matchTitleShowSelect = str1
                push?.matchTitleSelect = self.matchTitleSelect
                push?.devesionIdCategory = dictevent["id_division"] as? String ?? ""
                push?.arrParentingDashboardId = ["001"]
                self.navigationController?.pushViewController(push!, animated: true)
                
            }
        }
        if str1 == "Healthy Eating"
        {
            if str == "Eating Disorders"
            {
                
                let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ParentingDashbaordId") as? ParentingDashbaord
                push?.matchCategory = dictevent["id_module"] as? String ?? ""
                push?.matchSubCategory = dictevent["id_category"] as? String ?? ""
                push?.arrParentingDashboardTitle = ["Articles","Frequently Asked Questions","Medline","Resources"]
                push?.arrParentingDashboardImage = ["note1","faq","Medecine","care"]
                push?.matchTitleSelect = self.matchTitleSelect
                push?.matchTitleShowSelect = str1
                push?.arrParentingDashboardId = ["001","013","016","012"]
                push?.devesionIdCategory = dictevent["id_division"] as? String ?? ""
                self.navigationController?.pushViewController(push!, animated: true)
                
            }
            if str == "Good Nutrition Guidelines"
            {
                
                let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ParentingDashbaordId") as? ParentingDashbaord
                push?.matchCategory = dictevent["id_module"] as? String ?? ""
                push?.matchSubCategory = dictevent["id_category"] as? String ?? ""
                push?.arrParentingDashboardTitle = ["Articles","Frequently Asked Questions","Handbook","Medline","Online seminars","Resources","Slideshows","Videos"]
                push?.arrParentingDashboardImage = ["note1","faq","Handbooks","Medecine","study2","care","care","Videos"]
                push?.matchTitleSelect = self.matchTitleSelect
                push?.matchTitleShowSelect = str1
                push?.arrParentingDashboardId = ["001","013","004","016","030","012","066","045"]
                push?.devesionIdCategory = dictevent["id_division"] as? String ?? ""
                self.navigationController?.pushViewController(push!, animated: true)
                
            }
            if str == "Herbs and Supplements and Vitamins"
            {
                
                let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ParentingDashbaordId") as? ParentingDashbaord
                push?.matchCategory = dictevent["id_module"] as? String ?? ""
                push?.matchSubCategory = dictevent["id_category"] as? String ?? ""
                push?.arrParentingDashboardTitle = ["Articles","Frequently Asked Questions","Medline","Videos"]
                push?.arrParentingDashboardImage = ["note1","faq","Medecine","Videos"]
                push?.matchTitleSelect = self.matchTitleSelect
                push?.arrParentingDashboardId = ["001","013","016","045"]
                push?.devesionIdCategory = dictevent["id_division"] as? String ?? ""
                push?.matchTitleShowSelect = str1
                self.navigationController?.pushViewController(push!, animated: true)
                
            }
            if str == "Weight Loss and Management"
            {
                
                let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ParentingDashbaordId") as? ParentingDashbaord
                push?.matchCategory = dictevent["id_module"] as? String ?? ""
                push?.matchSubCategory = dictevent["id_category"] as? String ?? ""
                push?.arrParentingDashboardTitle = ["Articles","Frequently Asked Questions","Medline","Online seminars","Resources","Slideshows","Videos"]
                push?.arrParentingDashboardImage = ["note1","faq","Medecine","study2","care","care","Videos"]
                push?.matchTitleSelect = self.matchTitleSelect
                push?.arrParentingDashboardId = ["001","013","016","030","012","066","045"]
                push?.devesionIdCategory = dictevent["id_division"] as? String ?? ""
                push?.matchTitleShowSelect = str1
                self.navigationController?.pushViewController(push!, animated: true)
           
             }
        }
        if str1 == "Health Challenges"
        {
            if str == "Allergies"
            {
                
                let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ParentingDashbaordId") as? ParentingDashbaord
                push?.matchCategory = dictevent["id_module"] as? String ?? ""
                push?.matchSubCategory = dictevent["id_category"] as? String ?? ""
                push?.arrParentingDashboardTitle = ["Articles","Frequently Asked Questions","Medline","Videos"]
                push?.arrParentingDashboardImage = ["note1","faq","Medecine","Videos"]
                push?.matchTitleSelect = self.matchTitleSelect
                push?.arrParentingDashboardId = ["001","013","016","045"]
                push?.devesionIdCategory = dictevent["id_division"] as? String ?? ""
                push?.matchTitleShowSelect = str1
                self.navigationController?.pushViewController(push!, animated: true)
                
            }
            if str == "Back and Joint Pain"
            {
                let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ParentingDashbaordId") as? ParentingDashbaord
                push?.matchCategory = dictevent["id_module"] as? String ?? ""
                push?.matchSubCategory = dictevent["id_category"] as? String ?? ""
                push?.arrParentingDashboardTitle = ["Articles","Audio","Frequently Asked Questions","Medline","Procedure","Videos","Slideshows"]
                push?.arrParentingDashboardImage = ["note1","music1","faq","Medecine","Procedure","Videos","care"]
                push?.matchTitleSelect = self.matchTitleSelect
                push?.arrParentingDashboardId = ["001","013","016","033","045","066"]
                push?.devesionIdCategory = dictevent["id_division"] as? String ?? ""
                push?.matchTitleShowSelect = str1
                self.navigationController?.pushViewController(push!, animated: true)
                
            }
            if str == "Cancer"
            {
                let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ParentingDashbaordId") as? ParentingDashbaord
                push?.matchCategory = dictevent["id_module"] as? String ?? ""
                push?.matchSubCategory = dictevent["id_category"] as? String ?? ""
                push?.arrParentingDashboardTitle = ["Articles","Audio","Frequently Asked Questions","Medline","Procedure","Videos","Slideshows"]
                push?.arrParentingDashboardImage = ["note1","music1","faq","Medecine","Procedure","Videos","care"]
                push?.arrParentingDashboardId = ["001","002","013","016","045","066"]
                push?.matchTitleSelect = self.matchTitleSelect
                push?.devesionIdCategory = dictevent["id_division"] as? String ?? ""
                push?.matchTitleShowSelect = str1
                self.navigationController?.pushViewController(push!, animated: true)
                
            }
            if str == "Cardiovascular"
            {
                let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ParentingDashbaordId") as? ParentingDashbaord
                push?.matchCategory = dictevent["id_module"] as? String ?? ""
                push?.matchSubCategory = dictevent["id_category"] as? String ?? ""
                push?.arrParentingDashboardTitle = ["Articles","Audio","Frequently Asked Questions","Medline","Online seminars","Procedure","Resources","Videos"]
                push?.arrParentingDashboardImage = ["note1","music1","faq","Medecine","study2","Procedure","care","Videos"]
                push?.arrParentingDashboardId = ["001","002","013","016","030","033","012","045"]
                push?.matchTitleSelect = self.matchTitleSelect
                push?.devesionIdCategory = dictevent["id_division"] as? String ?? ""
                push?.matchTitleShowSelect = str1
                self.navigationController?.pushViewController(push!, animated: true)
                
            }
            if str == "Depression"
            {
                let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ParentingDashbaordId") as? ParentingDashbaord
                push?.matchCategory = dictevent["id_module"] as? String ?? ""
                push?.matchSubCategory = dictevent["id_category"] as? String ?? ""
                push?.arrParentingDashboardTitle = ["Articles","Audio","Frequently Asked Questions","Medline","Online seminars","Resources"]
                push?.arrParentingDashboardImage = ["note1","music1","faq","Medecine","study2","care"]
                push?.arrParentingDashboardId = ["001","002","013","016","030","012"]
                push?.matchTitleSelect = self.matchTitleSelect
                push?.devesionIdCategory = dictevent["id_division"] as? String ?? ""
                push?.matchTitleShowSelect = str1
                self.navigationController?.pushViewController(push!, animated: true)
                
            }
            if str == "Diabetes"
            {
                
                let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ParentingDashbaordId") as? ParentingDashbaord
                push?.matchCategory = dictevent["id_module"] as? String ?? ""
                push?.matchSubCategory = dictevent["id_category"] as? String ?? ""
                push?.arrParentingDashboardTitle = ["Articles","Frequently Asked Questions","Medline","Resources","Slideshows","Videos"]
                push?.arrParentingDashboardImage = ["note1","faq","Medecine","care","care","Videos"]
                push?.arrParentingDashboardId = ["001","013","016","012","066","045"]
                push?.matchTitleSelect = self.matchTitleSelect
                push?.devesionIdCategory = dictevent["id_division"] as? String ?? ""
                push?.matchTitleShowSelect = str1
                self.navigationController?.pushViewController(push!, animated: true)
                
            }
            if str == "Flu"
            {
                
                let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ParentingDashbaordId") as? ParentingDashbaord
                push?.matchCategory = dictevent["id_module"] as? String ?? ""
                push?.matchSubCategory = dictevent["id_category"] as? String ?? ""
                push?.arrParentingDashboardTitle = ["Articles","Audio","Frequently Asked Questions","Medline","Resources","Videos"]
                push?.arrParentingDashboardImage = ["note1","music1","faq","Medecine","care","Videos"]
                push?.arrParentingDashboardId = ["001","002","013","016","012","045"]
                push?.matchTitleSelect = self.matchTitleSelect
                push?.matchTitleShowSelect = str1
                push?.devesionIdCategory = dictevent["id_division"] as? String ?? ""
                self.navigationController?.pushViewController(push!, animated: true)
                
            }
            if str == "Hearing"
            {
                
                let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ParentingDashbaordId") as? ParentingDashbaord
                push?.matchCategory = dictevent["id_module"] as? String ?? ""
                push?.matchSubCategory = dictevent["id_category"] as? String ?? ""
                push?.arrParentingDashboardTitle = ["Articles","Frequently Asked Questions","Medline","Procedure","Videos","Slideshows"]
                push?.arrParentingDashboardImage = ["note1","faq","Medecine","Procedure","Videos","care"]
                push?.arrParentingDashboardId = ["001","013","016","033","045","066"]
                push?.matchTitleSelect = self.matchTitleSelect
                push?.matchTitleShowSelect = str1
                push?.devesionIdCategory = dictevent["id_division"] as? String ?? ""
                self.navigationController?.pushViewController(push!, animated: true)
                
            }
            if str == "High Blood Pressure"
            {
                
                let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ParentingDashbaordId") as? ParentingDashbaord
                push?.matchCategory = dictevent["id_module"] as? String ?? ""
                push?.matchSubCategory = dictevent["id_category"] as? String ?? ""
                push?.arrParentingDashboardTitle = ["Articles","Frequently Asked Questions","Medline","Videos"]
                push?.arrParentingDashboardImage = ["note1","faq","Medecine","Videos"]
                push?.arrParentingDashboardId = ["001","013","016","045"]
                push?.matchTitleSelect = self.matchTitleSelect
                push?.matchTitleShowSelect = str1
                push?.devesionIdCategory = dictevent["id_division"] as? String ?? ""
                self.navigationController?.pushViewController(push!, animated: true)
                
            }
            if str == "High Cholesterol"
            {
                
                let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ParentingDashbaordId") as? ParentingDashbaord
                push?.matchCategory = dictevent["id_module"] as? String ?? ""
                push?.matchSubCategory = dictevent["id_category"] as? String ?? ""
                push?.arrParentingDashboardTitle = ["Articles","Frequently Asked Questions","Medline","Videos"]
                push?.arrParentingDashboardImage = ["note1","faq","Medecine","Videos"]
                push?.arrParentingDashboardId = ["001","013","016","045"]
                push?.matchTitleSelect = self.matchTitleSelect
                push?.matchTitleShowSelect = str1
                push?.devesionIdCategory = dictevent["id_division"] as? String ?? ""
                self.navigationController?.pushViewController(push!, animated: true)
                
            }
            if str == "HIV and AIDS"
            {
                
                let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ParentingDashbaordId") as? ParentingDashbaord
                push?.matchCategory = dictevent["id_module"] as? String ?? ""
                push?.matchSubCategory = dictevent["id_category"] as? String ?? ""
                push?.arrParentingDashboardTitle = ["Articles","Audio","Frequently Asked Questions","Medline","Procedure","Resource"]
                push?.arrParentingDashboardImage = ["note1","music1","faq","Medecine","Procedure","care"]
                push?.arrParentingDashboardId = ["001","002","013","016","033","012"]
                push?.matchTitleSelect = self.matchTitleSelect
                push?.matchTitleShowSelect = str1
                push?.devesionIdCategory = dictevent["id_division"] as? String ?? ""
                self.navigationController?.pushViewController(push!, animated: true)
                
            }
            if str == "Medications"
            {
                
                let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ParentingDashbaordId") as? ParentingDashbaord
                push?.matchCategory = dictevent["id_module"] as? String ?? ""
                push?.matchSubCategory = dictevent["id_category"] as? String ?? ""
                push?.arrParentingDashboardTitle = ["Articles","Medline"]
                push?.arrParentingDashboardImage = ["note1","Medecine"]
                push?.arrParentingDashboardId = ["001","016"]
                push?.matchTitleSelect = self.matchTitleSelect
                push?.matchTitleShowSelect = str1
                push?.devesionIdCategory = dictevent["id_division"] as? String ?? ""
                self.navigationController?.pushViewController(push!, animated: true)
                
            }
            if str == "Multiple Sclerosis"
            {
                let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ParentingDashbaordId") as? ParentingDashbaord
                push?.matchCategory = dictevent["id_module"] as? String ?? ""
                push?.matchSubCategory = dictevent["id_category"] as? String ?? ""
                push?.arrParentingDashboardTitle = ["Articles","Frequently Asked Questions","Medline","Resources","Videos"]
                push?.arrParentingDashboardImage = ["note1","faq","Medecine","care","Videos"]
                push?.arrParentingDashboardId = ["001","013","016","012","045"]
                push?.matchTitleSelect = self.matchTitleSelect
                push?.matchTitleShowSelect = str1
                push?.devesionIdCategory = dictevent["id_division"] as? String ?? ""
                self.navigationController?.pushViewController(push!, animated: true)
            }
            if str == "Osteoporosis"
            {
                let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ParentingDashbaordId") as? ParentingDashbaord
                push?.matchCategory = dictevent["id_module"] as? String ?? ""
                push?.matchSubCategory = dictevent["id_category"] as? String ?? ""
                push?.arrParentingDashboardTitle = ["Articles","Audio","Frequently Asked Questions","Medline"]
                push?.arrParentingDashboardImage = ["note1","music1","faq","Medecine"]
                push?.arrParentingDashboardId = ["001","002","013","016"]
                push?.matchTitleSelect = self.matchTitleSelect
                push?.matchTitleShowSelect = str1
                push?.devesionIdCategory = dictevent["id_division"] as? String ?? ""
                self.navigationController?.pushViewController(push!, animated: true)
            }
            if str == "Parkinsons"
            {
                let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ParentingDashbaordId") as? ParentingDashbaord
                push?.matchCategory = dictevent["id_module"] as? String ?? ""
                push?.matchSubCategory = dictevent["id_category"] as? String ?? ""
                push?.arrParentingDashboardTitle = ["Articles","Frequently Asked Questions","Medline","Resource","videos"]
                push?.arrParentingDashboardImage = ["note1","faq","Medecine","care","Videos"]
                push?.arrParentingDashboardId = ["001","013","016","012","045"]
                push?.matchTitleSelect = self.matchTitleSelect
                push?.matchTitleShowSelect = str1
                push?.devesionIdCategory = dictevent["id_division"] as? String ?? ""
                self.navigationController?.pushViewController(push!, animated: true)
            }
            if str == "Respiratory Issues"
            {
                let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ParentingDashbaordId") as? ParentingDashbaord
                push?.matchCategory = dictevent["id_module"] as? String ?? ""
                push?.matchSubCategory = dictevent["id_category"] as? String ?? ""
                push?.arrParentingDashboardTitle = ["Articles","Frequently Asked Questions","Medline","Online seminars","Procedure","Resource"]
                push?.arrParentingDashboardImage = ["note1","faq","Medecine","study2","Procedure","care"]
                push?.arrParentingDashboardId = ["001","013","016","030","033","012"]
                push?.matchTitleSelect = self.matchTitleSelect
                push?.matchTitleShowSelect = str1
                push?.devesionIdCategory = dictevent["id_division"] as? String ?? ""
                self.navigationController?.pushViewController(push!, animated: true)
            }
            
            if str == "Sleep"
            {
                let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ParentingDashbaordId") as? ParentingDashbaord
                push?.matchCategory = dictevent["id_module"] as? String ?? ""
                push?.matchSubCategory = dictevent["id_category"] as? String ?? ""
                push?.arrParentingDashboardTitle = ["Articles","Audio","Frequently Asked Questions","Medline","Online seminars","Resource","Videos","Slideshows"]
                push?.arrParentingDashboardImage = ["note1","music1","faq","Medecine","study2","care","Videos","care"]
                push?.arrParentingDashboardId = ["001","002","013","016","030","012","045","066"]
                push?.matchTitleSelect = self.matchTitleSelect
                push?.matchTitleShowSelect = str1
                push?.devesionIdCategory = dictevent["id_division"] as? String ?? ""
                self.navigationController?.pushViewController(push!, animated: true)
            }
            if str == "STDs"
            {
                let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ParentingDashbaordId") as? ParentingDashbaord
                push?.matchCategory = dictevent["id_module"] as? String ?? ""
                push?.matchSubCategory = dictevent["id_category"] as? String ?? ""
                push?.arrParentingDashboardTitle = ["Articles","Frequently Asked Questions","Medline","Resource"]
                push?.arrParentingDashboardImage = ["note1","faq","Medecine","care"]
                push?.matchTitleSelect = self.matchTitleSelect
                push?.arrParentingDashboardId = ["001","013","016","012"]
                push?.matchTitleShowSelect = str1
                push?.devesionIdCategory = dictevent["id_division"] as? String ?? ""
                self.navigationController?.pushViewController(push!, animated: true)
            }
            if str == "Stress"
            {
                let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ParentingDashbaordId") as? ParentingDashbaord
                push?.matchCategory = dictevent["id_module"] as? String ?? ""
                push?.matchSubCategory = dictevent["id_category"] as? String ?? ""
                push?.arrParentingDashboardTitle = ["Articles","Audio","Frequently Asked Questions","Medline","Online seminars","Resource"]
                push?.arrParentingDashboardImage = ["note1","music1","faq","Medecine","study2","care"]
                push?.matchTitleSelect = self.matchTitleSelect
                push?.arrParentingDashboardId = ["001","002","013","016","030","012"]
                push?.matchTitleShowSelect = str1
                push?.devesionIdCategory = dictevent["id_division"] as? String ?? ""
                self.navigationController?.pushViewController(push!, animated: true)
            }
            
            if str == "Stroke"
            {
                let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ParentingDashbaordId") as? ParentingDashbaord
                push?.matchCategory = dictevent["id_module"] as? String ?? ""
                push?.matchSubCategory = dictevent["id_category"] as? String ?? ""
                push?.arrParentingDashboardTitle = ["Articles","Audio","Frequently Asked Questions","Medline","Videos"]
                push?.arrParentingDashboardImage = ["note1","music1","faq","Medecine","Videos"]
                push?.matchTitleSelect = self.matchTitleSelect
                push?.arrParentingDashboardId = ["001","002","013","016","045"]
                push?.matchTitleShowSelect = str1
                push?.devesionIdCategory = dictevent["id_division"] as? String ?? ""
                self.navigationController?.pushViewController(push!, animated: true)
            }
            if str == "Vision"
            {
                let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ParentingDashbaordId") as? ParentingDashbaord
                push?.matchCategory = dictevent["id_module"] as? String ?? ""
                push?.matchSubCategory = dictevent["id_category"] as? String ?? ""
                push?.arrParentingDashboardTitle = ["Articles","Audio","Frequently Asked Questions","Medline","Procedure","Resources","Videos","Slideshows"]
                push?.arrParentingDashboardImage = ["note1","music1","faq","Medecine","Procedure","care","Videos","care"]
                push?.matchTitleSelect = self.matchTitleSelect
                push?.arrParentingDashboardId = ["001","002","013","016","033","012","045"]
                push?.matchTitleShowSelect = str1
                push?.devesionIdCategory = dictevent["id_division"] as? String ?? ""
                self.navigationController?.pushViewController(push!, animated: true)
            }
            if str == "Other Issues"
            {
                let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ParentingDashbaordId") as? ParentingDashbaord
                push?.matchCategory = dictevent["id_module"] as? String ?? ""
                push?.matchSubCategory = dictevent["id_category"] as? String ?? ""
                push?.arrParentingDashboardTitle = ["Articles","Frequently Asked Questions","Online seminars","Procedure","Resources","Videos","Slideshows"]
                push?.arrParentingDashboardImage = ["note1","faq","study2","Procedure","care","Videos","care"]
                push?.matchTitleSelect = self.matchTitleSelect
                push?.arrParentingDashboardId = ["001","013","030","033","012","045","066"]
                push?.matchTitleShowSelect = str1
                push?.devesionIdCategory = dictevent["id_division"] as? String ?? ""
                self.navigationController?.pushViewController(push!, animated: true)
            }
            if str == "Asthma"
            {
                let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ParentingDashbaordId") as? ParentingDashbaord
                push?.matchCategory = dictevent["id_module"] as? String ?? ""
                push?.matchSubCategory = dictevent["id_category"] as? String ?? ""
                push?.arrParentingDashboardTitle = ["Articles","Frequently Asked Questions","Procedure","Videos"]
                push?.arrParentingDashboardImage = ["note1","faq","Procedure","Videos"]
                push?.matchTitleSelect = self.matchTitleSelect
                push?.arrParentingDashboardId = ["001","013","033","045"]
                push?.matchTitleShowSelect = str1
                push?.devesionIdCategory = dictevent["id_division"] as? String ?? ""
                self.navigationController?.pushViewController(push!, animated: true)
            }
            if str == "Infections"
            {
                let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ParentingDashbaordId") as? ParentingDashbaord
                push?.matchCategory = dictevent["id_module"] as? String ?? ""
                push?.matchSubCategory = dictevent["id_category"] as? String ?? ""
                push?.arrParentingDashboardTitle = ["Articles","Frequently Asked Questions"]
                push?.arrParentingDashboardImage = ["note1","faq"]
                push?.matchTitleSelect = self.matchTitleSelect
                push?.arrParentingDashboardId = ["001","013"]
                push?.matchTitleShowSelect = str1
                push?.devesionIdCategory = dictevent["id_division"] as? String ?? ""
                self.navigationController?.pushViewController(push!, animated: true)
            }
        }
        if str1 == "Seniors' Health"
        {
            if str == "Common Health Concerns"
            {
                
                let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ParentingDashbaordId") as? ParentingDashbaord
                push?.matchCategory = dictevent["id_module"] as? String ?? ""
                push?.matchSubCategory = dictevent["id_category"] as? String ?? ""
                push?.arrParentingDashboardTitle = ["Articles","Audio","Frequently Asked Questions","Medline","Online seminars","Resources","Videos","Slideshows"]
                push?.arrParentingDashboardImage = ["note1","music1","faq","Medecine","study2","care","Videos","care"]
                push?.matchTitleSelect = self.matchTitleSelect
                push?.arrParentingDashboardId = ["001","002","013","016","030","012","045","066"]
                push?.matchTitleShowSelect = str1
                push?.devesionIdCategory = dictevent["id_division"] as? String ?? ""
                self.navigationController?.pushViewController(push!, animated: true)
            }
            if str == "Managing Medications"
            {
                
                let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ParentingDashbaordId") as? ParentingDashbaord
                push?.matchCategory = dictevent["id_module"] as? String ?? ""
                push?.matchSubCategory = dictevent["id_category"] as? String ?? ""
                push?.arrParentingDashboardTitle = ["Articles"]
                push?.arrParentingDashboardImage = ["note1"]
                push?.matchTitleSelect = self.matchTitleSelect
                push?.arrParentingDashboardId = ["001"]
                push?.matchTitleShowSelect = str1
                push?.devesionIdCategory = dictevent["id_division"] as? String ?? ""
                self.navigationController?.pushViewController(push!, animated: true)
            }
            if str == "Medicare and Medicaid"
            {
                
                let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ParentingDashbaordId") as? ParentingDashbaord
                push?.matchCategory = dictevent["id_module"] as? String ?? ""
                push?.matchSubCategory = dictevent["id_category"] as? String ?? ""
                push?.arrParentingDashboardTitle = ["Resources"]
                push?.arrParentingDashboardImage = ["care"]
                push?.matchTitleSelect = self.matchTitleSelect
                push?.arrParentingDashboardId = ["012"]
                push?.devesionIdCategory = dictevent["id_division"] as? String ?? ""
                push?.matchTitleShowSelect = str1
                self.navigationController?.pushViewController(push!, animated: true)
            }
            if str == "Preventative Screening"
            {
                
                let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ParentingDashbaordId") as? ParentingDashbaord
                push?.matchCategory = dictevent["id_module"] as? String ?? ""
                push?.matchSubCategory = dictevent["id_category"] as? String ?? ""
                push?.arrParentingDashboardTitle = ["Online seminars","Resources"]
                push?.arrParentingDashboardImage = ["study2","care"]
                push?.matchTitleSelect = self.matchTitleSelect
                push?.arrParentingDashboardId = ["030","012"]
                push?.matchTitleShowSelect = str1
                push?.devesionIdCategory = dictevent["id_division"] as? String ?? ""
                self.navigationController?.pushViewController(push!, animated: true)
            }
            if str == "Sexual Health"
            {
                
                let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ParentingDashbaordId") as? ParentingDashbaord
                push?.matchCategory = dictevent["id_module"] as? String ?? ""
                push?.matchSubCategory = dictevent["id_category"] as? String ?? ""
                push?.arrParentingDashboardTitle = ["Articles","Frequently Asked Questions","Resources"]
                push?.arrParentingDashboardImage = ["note1","faq","care"]
                push?.matchTitleSelect = self.matchTitleSelect
                push?.arrParentingDashboardId = ["001","013","012"]
                push?.matchTitleShowSelect = str1
                push?.devesionIdCategory = dictevent["id_division"] as? String ?? ""
                self.navigationController?.pushViewController(push!, animated: true)
            }
            if str == "Staying Active"
            {
                
                let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ParentingDashbaordId") as? ParentingDashbaord
                push?.matchCategory = dictevent["id_module"] as? String ?? ""
                push?.matchSubCategory = dictevent["id_category"] as? String ?? ""
                push?.arrParentingDashboardTitle = ["Articles","Resources","Videos"]
                push?.arrParentingDashboardImage = ["note1","care","Videos"]
                push?.matchTitleSelect = self.matchTitleSelect
                push?.arrParentingDashboardId = ["001","012","045"]
                push?.matchTitleShowSelect = str1
                push?.devesionIdCategory = dictevent["id_division"] as? String ?? ""
                self.navigationController?.pushViewController(push!, animated: true)
            }
        }
        
        if str1 == "Men's Health"
        {
            if str == "Annual Exams"
            {
                
                let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ParentingDashbaordId") as? ParentingDashbaord
                push?.matchCategory = dictevent["id_module"] as? String ?? ""
                push?.matchSubCategory = dictevent["id_category"] as? String ?? ""
                push?.arrParentingDashboardTitle = ["Articles","Resources"]
                push?.arrParentingDashboardImage = ["note1","care"]
                push?.matchTitleSelect = self.matchTitleSelect
                push?.arrParentingDashboardId = ["001","012"]
                push?.matchTitleShowSelect = str1
                push?.devesionIdCategory = dictevent["id_division"] as? String ?? ""
                self.navigationController?.pushViewController(push!, animated: true)
            }
            if str == "Concerns"
            {
                
                let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ParentingDashbaordId") as? ParentingDashbaord
                push?.matchCategory = dictevent["id_module"] as? String ?? ""
                push?.matchSubCategory = dictevent["id_category"] as? String ?? ""
                push?.arrParentingDashboardTitle = ["Articles","Frequently Asked Questions","Medline","Online seminars","Procedure","Resources"]
                push?.arrParentingDashboardImage = ["note1","faq","Medecine","study2","Procedure","care"]
                push?.matchTitleSelect = self.matchTitleSelect
                push?.arrParentingDashboardId = ["001","013","016","030","033","012"]
                push?.matchTitleShowSelect = str1
                push?.devesionIdCategory = dictevent["id_division"] as? String ?? ""
                self.navigationController?.pushViewController(push!, animated: true)
            }
            if str == "Infertility"
            {
                
                let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ParentingDashbaordId") as? ParentingDashbaord
                push?.matchCategory = dictevent["id_module"] as? String ?? ""
                push?.matchSubCategory = dictevent["id_category"] as? String ?? ""
                push?.arrParentingDashboardTitle = ["Articles","Frequently Asked Questions"]
                push?.arrParentingDashboardImage = ["note1","faq"]
                push?.matchTitleSelect = self.matchTitleSelect
                push?.arrParentingDashboardId = ["001","013"]
                push?.devesionIdCategory = dictevent["id_division"] as? String ?? ""
                push?.matchTitleShowSelect = str1
                self.navigationController?.pushViewController(push!, animated: true)
            }
            if str == "Men and Sexually Transmitted Disease"
            {
                
                let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ParentingDashbaordId") as? ParentingDashbaord
                push?.matchCategory = dictevent["id_module"] as? String ?? ""
                push?.matchSubCategory = dictevent["id_category"] as? String ?? ""
                push?.arrParentingDashboardTitle = ["Articles","Resources"]
                push?.arrParentingDashboardImage = ["note1","care"]
                push?.matchTitleSelect = self.matchTitleSelect
                push?.arrParentingDashboardId = ["001","012"]
                push?.matchTitleShowSelect = str1
                push?.devesionIdCategory = dictevent["id_division"] as? String ?? ""
                self.navigationController?.pushViewController(push!, animated: true)
            }
            if str == "Smoking"
            {
                
                let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ParentingDashbaordId") as? ParentingDashbaord
                push?.matchCategory = dictevent["id_module"] as? String ?? ""
                push?.matchSubCategory = dictevent["id_category"] as? String ?? ""
                push?.arrParentingDashboardTitle = ["Articles","Resources"]
                push?.arrParentingDashboardImage = ["note1","care"]
                push?.matchTitleSelect = self.matchTitleSelect
                push?.arrParentingDashboardId = ["001","012"]
                push?.matchTitleShowSelect = str1
                push?.devesionIdCategory = dictevent["id_division"] as? String ?? ""
                self.navigationController?.pushViewController(push!, animated: true)
            }
        }
        
        if str1 == "Women's Health"
        {
            if str == "Annual Exams"
            {
                let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ParentingDashbaordId") as? ParentingDashbaord
                push?.matchCategory = dictevent["id_module"] as? String ?? ""
                push?.matchSubCategory = dictevent["id_category"] as? String ?? ""
                push?.arrParentingDashboardTitle = ["Articles","Audio","Frequently Asked Questions","Procedure","Resources"]
                push?.arrParentingDashboardImage = ["note1","music1","faq","Procedure","care"]
                push?.matchTitleSelect = self.matchTitleSelect
                push?.arrParentingDashboardId = ["001","002","013","033","012"]
                push?.matchTitleShowSelect = str1
                push?.devesionIdCategory = dictevent["id_division"] as? String ?? ""
                self.navigationController?.pushViewController(push!, animated: true)
            }
            if str == "Concerns"
            {
                
                let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ParentingDashbaordId") as? ParentingDashbaord
                push?.matchCategory = dictevent["id_module"] as? String ?? ""
                push?.matchSubCategory = dictevent["id_category"] as? String ?? ""
                push?.arrParentingDashboardTitle = ["Articles","Audio","Frequently Asked Questions","Medline","Online seminars","Procedure","Resources","Videos","Slideshows"]
                push?.arrParentingDashboardImage = ["note1","music1","faq","Medecine","study2","Procedure","care","Videos","care"]
                push?.matchTitleSelect = self.matchTitleSelect
                push?.arrParentingDashboardId = ["001","002","013","016","030","033","012","045","066"]
                push?.matchTitleShowSelect = str1
                push?.devesionIdCategory = dictevent["id_division"] as? String ?? ""
                self.navigationController?.pushViewController(push!, animated: true)
            }
            if str == "Infertility"
            {
                
                let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ParentingDashbaordId") as? ParentingDashbaord
                push?.matchCategory = dictevent["id_module"] as? String ?? ""
                push?.matchSubCategory = dictevent["id_category"] as? String ?? ""
                push?.arrParentingDashboardTitle = ["Articles","Audio","Frequently Asked Questions","Medline","Procedure","Videos"]
                push?.arrParentingDashboardImage = ["note1","music1","faq","Medecine","Procedure","Videos"]
                push?.matchTitleSelect = self.matchTitleSelect
                push?.arrParentingDashboardId = ["001","002","013","016","033","045"]
                push?.matchTitleShowSelect = str1
                push?.devesionIdCategory = dictevent["id_division"] as? String ?? ""
                self.navigationController?.pushViewController(push!, animated: true)
            }
            if str == "Menopause"
            {
                
                let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ParentingDashbaordId") as? ParentingDashbaord
                push?.matchCategory = dictevent["id_module"] as? String ?? ""
                push?.matchSubCategory = dictevent["id_category"] as? String ?? ""
                push?.arrParentingDashboardTitle = ["Articles","Audio","Frequently Asked Questions","Medline","Videos"]
                push?.arrParentingDashboardImage = ["note1","music1","faq","Medecine","Videos"]
                push?.matchTitleSelect = self.matchTitleSelect
                push?.arrParentingDashboardId = ["001","002","013","016","045"]
                push?.matchTitleShowSelect = str1
                push?.devesionIdCategory = dictevent["id_division"] as? String ?? ""
                self.navigationController?.pushViewController(push!, animated: true)
            }
            if str == "Miscarriage"
            {
                
                let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ParentingDashbaordId") as? ParentingDashbaord
                push?.matchCategory = dictevent["id_module"] as? String ?? ""
                push?.matchSubCategory = dictevent["id_category"] as? String ?? ""
                push?.arrParentingDashboardTitle = ["Articles","Frequently Asked Questions"]
                push?.arrParentingDashboardImage = ["note1","faq"]
                push?.arrParentingDashboardId = ["001","013"]
                push?.matchTitleSelect = self.matchTitleSelect
                push?.matchTitleShowSelect = str1
                push?.devesionIdCategory = dictevent["id_division"] as? String ?? ""
                self.navigationController?.pushViewController(push!, animated: true)
            }
            if str == "Pregnancy"
            {
                
                let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ParentingDashbaordId") as? ParentingDashbaord
                push?.matchCategory = dictevent["id_module"] as? String ?? ""
                push?.matchSubCategory = dictevent["id_category"] as? String ?? ""
                push?.arrParentingDashboardTitle = ["Articles","Audio","Frequently Asked Questions","Medline","Procedure","Resources","Videos","Slideshows"]
                push?.matchTitleSelect = self.matchTitleSelect
                push?.arrParentingDashboardImage = ["note1","music1","faq","Medecine","Procedure","care","Videos","care"]
                push?.arrParentingDashboardId = ["001","002","013","033","012","045","066"]
                push?.matchTitleShowSelect = str1
                push?.devesionIdCategory = dictevent["id_division"] as? String ?? ""
                self.navigationController?.pushViewController(push!, animated: true)
            }
            if str == "Prenatal Advisories"
            {
                
                let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ParentingDashbaordId") as? ParentingDashbaord
                push?.matchCategory = dictevent["id_module"] as? String ?? ""
                push?.matchSubCategory = dictevent["id_category"] as? String ?? ""
                push?.arrParentingDashboardTitle = ["Articles","Procedure","Resources"]
                push?.matchTitleSelect = self.matchTitleSelect
                push?.arrParentingDashboardImage = ["note1","Procedure","care"]
                push?.arrParentingDashboardId = ["001","033","012"]
                push?.matchTitleShowSelect = str1
                push?.devesionIdCategory = dictevent["id_division"] as? String ?? ""
                self.navigationController?.pushViewController(push!, animated: true)
            }
            if str == "Women and Sexually Transmitted Disease"
            {
                
                let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ParentingDashbaordId") as? ParentingDashbaord
                push?.matchCategory = dictevent["id_module"] as? String ?? ""
                push?.matchSubCategory = dictevent["id_category"] as? String ?? ""
                push?.arrParentingDashboardTitle = ["Articles","Procedure","Resources","Videos"]
                push?.matchTitleSelect = self.matchTitleSelect
                push?.arrParentingDashboardImage = ["note1","Procedure","care","Videos"]
                push?.arrParentingDashboardId = ["001","033","012","045"]
                push?.matchTitleShowSelect = str1
                push?.devesionIdCategory = dictevent["id_division"] as? String ?? ""
                self.navigationController?.pushViewController(push!, animated: true)
            }
            if str == "Women's Contraception"
            {
                
                let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ParentingDashbaordId") as? ParentingDashbaord
                push?.matchCategory = dictevent["id_module"] as? String ?? ""
                push?.matchSubCategory = dictevent["id_category"] as? String ?? ""
                push?.arrParentingDashboardTitle = ["Articles","Frequently Asked Questions","Procedure","Resources"]
                push?.matchTitleSelect = self.matchTitleSelect
                push?.arrParentingDashboardImage = ["note1","faq","Procedure","care"]
                push?.arrParentingDashboardId = ["001","013","033","012"]
                push?.matchTitleShowSelect = str1
                push?.devesionIdCategory = dictevent["id_division"] as? String ?? ""
                self.navigationController?.pushViewController(push!, animated: true)
            }
            if str == "Women's Sexual Health"
            {
                
                let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ParentingDashbaordId") as? ParentingDashbaord
                push?.matchCategory = dictevent["id_module"] as? String ?? ""
                push?.matchSubCategory = dictevent["id_category"] as? String ?? ""
                push?.arrParentingDashboardTitle = ["Articles","Audio","Frequently Asked Questions","Medline","Procedure","Resources","Videos"]
                push?.matchTitleSelect = self.matchTitleSelect
                push?.arrParentingDashboardImage = ["note1","music1","faq","Medecine","Procedure","care","Videos"]
                push?.arrParentingDashboardId = ["001","002","013","033","012","045"]
                push?.matchTitleShowSelect = str1
                push?.devesionIdCategory = dictevent["id_division"] as? String ?? ""
                self.navigationController?.pushViewController(push!, animated: true)
            }
            if str == "Smoking"
            {
                
                let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ParentingDashbaordId") as? ParentingDashbaord
                push?.matchCategory = dictevent["id_module"] as? String ?? ""
                push?.matchSubCategory = dictevent["id_category"] as? String ?? ""
                push?.arrParentingDashboardTitle = ["Articles","Frequently Asked Questions","Resources"]
                push?.matchTitleSelect = self.matchTitleSelect
                push?.arrParentingDashboardImage = ["note1","faq","care"]
                push?.arrParentingDashboardId = ["001","013","012"]
                push?.matchTitleShowSelect = str1
                push?.devesionIdCategory = dictevent["id_division"] as? String ?? ""
                self.navigationController?.pushViewController(push!, animated: true)
            }
        }
        if str1 == "Adolescents' Health"
        {
            if str == "Common Issues"
            {
                
                let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ParentingDashbaordId") as? ParentingDashbaord
                push?.matchCategory = dictevent["id_module"] as? String ?? ""
                push?.matchSubCategory = dictevent["id_category"] as? String ?? ""
                push?.arrParentingDashboardTitle = ["Articles","Medline","Resources"]
                push?.matchTitleSelect = self.matchTitleSelect
                push?.arrParentingDashboardImage = ["note1","Medecine","care"]
                push?.arrParentingDashboardId = ["001","016","012"]
                push?.matchTitleShowSelect = str1
                push?.devesionIdCategory = dictevent["id_division"] as? String ?? ""
                self.navigationController?.pushViewController(push!, animated: true)
            }
            if str == "Acne"
            {
                
                let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ParentingDashbaordId") as? ParentingDashbaord
                push?.matchCategory = dictevent["id_module"] as? String ?? ""
                push?.matchSubCategory = dictevent["id_category"] as? String ?? ""
                push?.arrParentingDashboardTitle = ["Articles","Frequently Asked Questions","Resources"]
                push?.arrParentingDashboardImage = ["note1","faq","care"]
                push?.arrParentingDashboardId = ["001","013","012"]
                push?.matchTitleSelect = self.matchTitleSelect
                push?.matchTitleShowSelect = str1
                push?.devesionIdCategory = dictevent["id_division"] as? String ?? ""
                self.navigationController?.pushViewController(push!, animated: true)
                
            }
            if str == "Eating Disorders"
            {
                
                let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ParentingDashbaordId") as? ParentingDashbaord
                push?.matchCategory = dictevent["id_module"] as? String ?? ""
                push?.matchSubCategory = dictevent["id_category"] as? String ?? ""
                push?.arrParentingDashboardTitle = ["Articles","Frequently Asked Questions","Online seminars","Resources"]
                push?.arrParentingDashboardImage = ["note1","faq","study2","care"]
                push?.arrParentingDashboardId = ["001","013","030","012"]
                push?.matchTitleSelect = self.matchTitleSelect
                push?.matchTitleShowSelect = str1
                push?.devesionIdCategory = dictevent["id_division"] as? String ?? ""
                self.navigationController?.pushViewController(push!, animated: true)
                
            }
            if str == "Physical Activity and Sports"
            {
                
                let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ParentingDashbaordId") as? ParentingDashbaord
                push?.matchCategory = dictevent["id_module"] as? String ?? ""
                push?.matchSubCategory = dictevent["id_category"] as? String ?? ""
                push?.arrParentingDashboardTitle = ["Articles","Medline","Videos"]
                push?.arrParentingDashboardImage = ["note1","Medecine","Videos"]
                push?.arrParentingDashboardId = ["001","013","045"]
                push?.matchTitleSelect = self.matchTitleSelect
                push?.matchTitleShowSelect = str1
                push?.devesionIdCategory = dictevent["id_division"] as? String ?? ""
                self.navigationController?.pushViewController(push!, animated: true)
                
            }
            if str == "Puberty"
            {
                
                let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ParentingDashbaordId") as? ParentingDashbaord
                push?.matchCategory = dictevent["id_module"] as? String ?? ""
                push?.matchSubCategory = dictevent["id_category"] as? String ?? ""
                push?.arrParentingDashboardTitle = ["Articles","Resources"]
                push?.arrParentingDashboardImage = ["note1","care"]
                push?.arrParentingDashboardId = ["001","012"]
                push?.matchTitleSelect = self.matchTitleSelect
                push?.matchTitleShowSelect = str1
                push?.devesionIdCategory = dictevent["id_division"] as? String ?? ""
                self.navigationController?.pushViewController(push!, animated: true)
                
            }
            if str == "Sexuality"
            {
                
                let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ParentingDashbaordId") as? ParentingDashbaord
                push?.matchCategory = dictevent["id_module"] as? String ?? ""
                push?.matchSubCategory = dictevent["id_category"] as? String ?? ""
                push?.arrParentingDashboardTitle = ["Articles","Resources"]
                push?.arrParentingDashboardImage = ["note1","care"]
                push?.arrParentingDashboardId = ["001","012"]
                push?.matchTitleSelect = self.matchTitleSelect
                push?.matchTitleShowSelect = str1
                push?.devesionIdCategory = dictevent["id_division"] as? String ?? ""
                self.navigationController?.pushViewController(push!, animated: true)
                
            }
            if str == "Sexually Transmitted Diseases"
            {
                
                let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ParentingDashbaordId") as? ParentingDashbaord
                push?.matchCategory = dictevent["id_module"] as? String ?? ""
                push?.matchSubCategory = dictevent["id_category"] as? String ?? ""
                push?.arrParentingDashboardTitle = ["Articles","Resources"]
                push?.arrParentingDashboardImage = ["note1","care"]
                push?.arrParentingDashboardId = ["001","012"]
                push?.matchTitleSelect = self.matchTitleSelect
                push?.matchTitleShowSelect = str1
                push?.devesionIdCategory = dictevent["id_division"] as? String ?? ""
                self.navigationController?.pushViewController(push!, animated: true)
                
            }
            if str == "Alcohol"
            {
                
                let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ParentingDashbaordId") as? ParentingDashbaord
                push?.matchCategory = dictevent["id_module"] as? String ?? ""
                push?.matchSubCategory = dictevent["id_category"] as? String ?? ""
                push?.arrParentingDashboardTitle = ["Articles","Medline","Resources"]
                push?.arrParentingDashboardImage = ["note1","Medecine","care"]
                push?.arrParentingDashboardId = ["001","016","012"]
                push?.matchTitleSelect = self.matchTitleSelect
                push?.matchTitleShowSelect = str1
                push?.devesionIdCategory = dictevent["id_division"] as? String ?? ""
                self.navigationController?.pushViewController(push!, animated: true)
                
            }
            if str == "Marijuana"
            {
                
                let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ParentingDashbaordId") as? ParentingDashbaord
                push?.matchCategory = dictevent["id_module"] as? String ?? ""
                push?.matchSubCategory = dictevent["id_category"] as? String ?? ""
                push?.arrParentingDashboardTitle = ["Resources"]
                push?.arrParentingDashboardImage = ["care"]
                push?.arrParentingDashboardId = ["012"]
                push?.matchTitleSelect = self.matchTitleSelect
                push?.matchTitleShowSelect = str1
                push?.devesionIdCategory = dictevent["id_division"] as? String ?? ""
                self.navigationController?.pushViewController(push!, animated: true)
                
            }
            if str == "Tobacco"
            {
                
                let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ParentingDashbaordId") as? ParentingDashbaord
                push?.matchCategory = dictevent["id_module"] as? String ?? ""
                push?.matchSubCategory = dictevent["id_category"] as? String ?? ""
                push?.arrParentingDashboardTitle = ["Articles","Medline","Resources"]
                push?.arrParentingDashboardImage = ["note1","Medecine","care"]
                push?.arrParentingDashboardId = ["001","016","012"]
                push?.matchTitleSelect = self.matchTitleSelect
                push?.matchTitleShowSelect = str1
                push?.devesionIdCategory = dictevent["id_division"] as? String ?? ""
                self.navigationController?.pushViewController(push!, animated: true)
                
            }
            if str == "Other Drugs"
            {
                
                let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ParentingDashbaordId") as? ParentingDashbaord
                push?.matchCategory = dictevent["id_module"] as? String ?? ""
                push?.matchSubCategory = dictevent["id_category"] as? String ?? ""
                push?.arrParentingDashboardTitle = ["Articles","Resources"]
                push?.arrParentingDashboardImage = ["note1","care"]
                push?.arrParentingDashboardId = ["001","012"]
                push?.matchTitleShowSelect = str1
                push?.devesionIdCategory = dictevent["id_division"] as? String ?? ""
                push?.matchTitleSelect = self.matchTitleSelect
                self.navigationController?.pushViewController(push!, animated: true)
                
            }
        }
        if str1 == "Children\'s Health"
        {
            if str == "Common Problems"
            {
                
                let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ParentingDashbaordId") as? ParentingDashbaord
                push?.matchCategory = dictevent["id_module"] as? String ?? ""
                push?.matchSubCategory = dictevent["id_category"] as? String ?? ""
                push?.arrParentingDashboardTitle = ["Articles","Audio","Frequently Asked Questions","Medline","Videos"]
                push?.arrParentingDashboardImage = ["note1","music1","faq","Medecine","Videos"]
                push?.matchTitleSelect = self.matchTitleSelect
                push?.arrParentingDashboardId = ["001","002","013","045"]
                push?.matchTitleShowSelect = str1
                push?.devesionIdCategory = dictevent["id_division"] as? String ?? ""
                self.navigationController?.pushViewController(push!, animated: true)
                
            }
            if str == "Asthma and Allergies"
            {
                
                let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ParentingDashbaordId") as? ParentingDashbaord
                push?.matchCategory = dictevent["id_module"] as? String ?? ""
                push?.matchSubCategory = dictevent["id_category"] as? String ?? ""
                push?.arrParentingDashboardTitle = ["Articles","Audio"]
                push?.arrParentingDashboardImage = ["note1","music1"]
                push?.arrParentingDashboardId = ["001","002"]
                push?.devesionIdCategory = dictevent["id_division"] as? String ?? ""
                push?.matchTitleSelect = self.matchTitleSelect
                push?.matchTitleShowSelect = str1
                self.navigationController?.pushViewController(push!, animated: true)
                
            }
            if str == "Checkups"
            {
                
                let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ParentingDashbaordId") as? ParentingDashbaord
                push?.matchCategory = dictevent["id_module"] as? String ?? ""
                push?.matchSubCategory = dictevent["id_category"] as? String ?? ""
                push?.arrParentingDashboardTitle = ["Articles","Audio","Resources"]
                push?.arrParentingDashboardImage = ["note1","music1","care"]
                push?.arrParentingDashboardId = ["001","002","012"]
                push?.matchTitleSelect = self.matchTitleSelect
                push?.matchTitleShowSelect = str1
                push?.devesionIdCategory = dictevent["id_division"] as? String ?? ""
                self.navigationController?.pushViewController(push!, animated: true)
                
            }
            if str == "Child Safety"
            {
                
                let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ParentingDashbaordId") as? ParentingDashbaord
                push?.matchCategory = dictevent["id_module"] as? String ?? ""
                push?.matchSubCategory = dictevent["id_category"] as? String ?? ""
                push?.arrParentingDashboardTitle = ["Articles","Frequently Asked Questions","Resources"]
                push?.arrParentingDashboardImage = ["note1","faq","care"]
                push?.arrParentingDashboardId = ["001","013","012"]
                push?.matchTitleSelect = self.matchTitleSelect
                push?.matchTitleShowSelect = str1
                push?.devesionIdCategory = dictevent["id_division"] as? String ?? ""
                self.navigationController?.pushViewController(push!, animated: true)
                
            }
            if str == "Chronic Conditions"
            {
                
                let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ParentingDashbaordId") as? ParentingDashbaord
                push?.matchCategory = dictevent["id_module"] as? String ?? ""
                push?.matchSubCategory = dictevent["id_category"] as? String ?? ""
                push?.arrParentingDashboardTitle = ["Articles","Frequently Asked Questions","Resources"]
                push?.arrParentingDashboardImage = ["note1","faq","care"]
                push?.arrParentingDashboardId = ["001","013","012"]
                push?.matchTitleSelect = self.matchTitleSelect
                push?.matchTitleShowSelect = str1
                push?.devesionIdCategory = dictevent["id_division"] as? String ?? ""
                self.navigationController?.pushViewController(push!, animated: true)
                
            }
            if str == "Development"
            {
                
                let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ParentingDashbaordId") as? ParentingDashbaord
                push?.matchCategory = dictevent["id_module"] as? String ?? ""
                push?.matchSubCategory = dictevent["id_category"] as? String ?? ""
                push?.arrParentingDashboardTitle = ["Articles","Frequently Asked Questions","Medline"]
                push?.arrParentingDashboardImage = ["note1","faq","Medecine"]
                push?.arrParentingDashboardId = ["001","013","016"]
                push?.matchTitleSelect = self.matchTitleSelect
                push?.matchTitleShowSelect = str1
                push?.devesionIdCategory = dictevent["id_division"] as? String ?? ""
                self.navigationController?.pushViewController(push!, animated: true)
                
            }
            if str == "Ear Infections"
            {
                
                let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ParentingDashbaordId") as? ParentingDashbaord
                push?.matchCategory = dictevent["id_module"] as? String ?? ""
                push?.matchSubCategory = dictevent["id_category"] as? String ?? ""
                push?.arrParentingDashboardTitle = ["Articles","Audio","Medline","Procedure"]
                push?.arrParentingDashboardImage = ["note1","music1","Medecine","Procedure"]
                push?.arrParentingDashboardId = ["001","002","016",""]
                push?.matchTitleSelect = self.matchTitleSelect
                push?.matchTitleShowSelect = str1
                push?.devesionIdCategory = dictevent["id_division"] as? String ?? ""
                self.navigationController?.pushViewController(push!, animated: true)
                
            }
            if str == "Flu"
            {
                
                let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ParentingDashbaordId") as? ParentingDashbaord
                push?.matchCategory = dictevent["id_module"] as? String ?? ""
                push?.matchSubCategory = dictevent["id_category"] as? String ?? ""
                push?.arrParentingDashboardTitle = ["Articles","Audio","Frequently Asked Questions","Medline"]
                push?.arrParentingDashboardImage = ["note1","music1","faq","Medecine"]
                push?.arrParentingDashboardId = ["001","002","013","016"]
                push?.matchTitleSelect = self.matchTitleSelect
                push?.matchTitleShowSelect = str1
                push?.devesionIdCategory = dictevent["id_division"] as? String ?? ""
                self.navigationController?.pushViewController(push!, animated: true)
                
            }
            if str == "Nutrition"
            {
                
                let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ParentingDashbaordId") as? ParentingDashbaord
                push?.matchCategory = dictevent["id_module"] as? String ?? ""
                push?.matchSubCategory = dictevent["id_category"] as? String ?? ""
                push?.arrParentingDashboardTitle = ["Articles","Audio","Frequently Asked Questions","Medline"]
                push?.arrParentingDashboardImage = ["note1","music1","faq","Medecine"]
                push?.arrParentingDashboardId = ["001","002","013","016"]
                push?.matchTitleSelect = self.matchTitleSelect
                push?.matchTitleShowSelect = str1
                push?.devesionIdCategory = dictevent["id_division"] as? String ?? ""
                self.navigationController?.pushViewController(push!, animated: true)
                
            }
            
            if str == "Special Needs"
            {
                
                let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ParentingDashbaordId") as? ParentingDashbaord
                push?.matchCategory = dictevent["id_module"] as? String ?? ""
                push?.matchSubCategory = dictevent["id_category"] as? String ?? ""
                push?.arrParentingDashboardTitle = ["Articles","Frequently Asked Questions"]
                push?.arrParentingDashboardImage = ["note1","faq"]
                push?.arrParentingDashboardId = ["001","013"]
                push?.matchTitleSelect = self.matchTitleSelect
                push?.matchTitleShowSelect = str1
                push?.devesionIdCategory = dictevent["id_division"] as? String ?? ""
                self.navigationController?.pushViewController(push!, animated: true)
                
            }
            
            if str == "Sports"
            {
                
                let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ParentingDashbaordId") as? ParentingDashbaord
                push?.matchCategory = dictevent["id_module"] as? String ?? ""
                push?.matchSubCategory = dictevent["id_category"] as? String ?? ""
                push?.arrParentingDashboardTitle = ["Articles","Videos"]
                push?.arrParentingDashboardImage = ["note1","Videos"]
                push?.arrParentingDashboardId = ["001","045"]
                push?.matchTitleSelect = self.matchTitleSelect
                push?.matchTitleShowSelect = str1
                push?.devesionIdCategory = dictevent["id_division"] as? String ?? ""
                self.navigationController?.pushViewController(push!, animated: true)
            }
            if str == "Other Issues"
            {
                
                let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ParentingDashbaordId") as? ParentingDashbaord
                push?.matchCategory = dictevent["id_module"] as? String ?? ""
                push?.matchSubCategory = dictevent["id_category"] as? String ?? ""
                push?.arrParentingDashboardTitle = ["Articles","Frequently Asked Questions","Online seminars","Procedure","Resources","Videos"]
                push?.arrParentingDashboardImage = ["note1","faq","study2","Procedure","care","Videos"]
                push?.arrParentingDashboardId = ["001","013","030","033","012","045"]
                push?.matchTitleSelect = self.matchTitleSelect
                push?.matchTitleShowSelect = str1
                push?.devesionIdCategory = dictevent["id_division"] as? String ?? ""
                self.navigationController?.pushViewController(push!, animated: true)
            }
        }
        if str1 == "Medical Care"
        {
            if str == "More Medical Care Information"
            {
                
                let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ParentingDashbaordId") as? ParentingDashbaord
                push?.matchCategory = dictevent["id_module"] as? String ?? ""
                push?.matchSubCategory = dictevent["id_category"] as? String ?? ""
                push?.arrParentingDashboardTitle = ["Articles","Audio","Frequently Asked Questions","Procedure","Resources","Videos"]
                push?.arrParentingDashboardImage = ["note1","music1","faq","Procedure","care","Videos"]
                push?.arrParentingDashboardId = ["001","002","013","033","012","045"]
                push?.matchTitleSelect = self.matchTitleSelect
                push?.matchTitleShowSelect = str1
                push?.devesionIdCategory = dictevent["id_division"] as? String ?? ""
                self.navigationController?.pushViewController(push!, animated: true)
            }
            if str == "Talking with Health Providers"
            {
                
                let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ParentingDashbaordId") as? ParentingDashbaord
                push?.matchCategory = dictevent["id_module"] as? String ?? ""
                push?.matchSubCategory = dictevent["id_category"] as? String ?? ""
                push?.arrParentingDashboardTitle = ["Articles","Audio","Medline"]
                push?.arrParentingDashboardImage = ["note1","music1","Medecine"]
                push?.arrParentingDashboardId = ["001","012","016"]
                push?.matchTitleSelect = self.matchTitleSelect
                push?.matchTitleShowSelect = str1
                push?.devesionIdCategory = dictevent["id_division"] as? String ?? ""
                self.navigationController?.pushViewController(push!, animated: true)
            }
            if str == "Selecting Medical Professionals"
            {
                
                let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ParentingDashbaordId") as? ParentingDashbaord
                push?.matchCategory = dictevent["id_module"] as? String ?? ""
                push?.matchSubCategory = dictevent["id_category"] as? String ?? ""
                push?.arrParentingDashboardTitle = ["Articles","Medline","Resources"]
                push?.arrParentingDashboardImage = ["note1","Medecine","care"]
                push?.arrParentingDashboardId = ["001","016","012"]
                push?.matchTitleSelect = self.matchTitleSelect
                push?.matchTitleShowSelect = str1
                push?.devesionIdCategory = dictevent["id_division"] as? String ?? ""
                self.navigationController?.pushViewController(push!, animated: true)
            }
            if str == "Recuperation"
            {
                
                let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ParentingDashbaordId") as? ParentingDashbaord
                push?.matchCategory = dictevent["id_module"] as? String ?? ""
                push?.matchSubCategory = dictevent["id_category"] as? String ?? ""
                push?.arrParentingDashboardTitle = ["Articles","Audio","Frequently Asked Questions","Medline","Videos"]
                push?.arrParentingDashboardImage = ["note1","music1","faq","Medecine","Videos"]
                push?.arrParentingDashboardId = ["001","002","013","016","045"]
                push?.matchTitleSelect = self.matchTitleSelect
                push?.matchTitleShowSelect = str1
                push?.devesionIdCategory = dictevent["id_division"] as? String ?? ""
                self.navigationController?.pushViewController(push!, animated: true)
            }
            if str == "Prescription Drugs"
            {
                
                let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ParentingDashbaordId") as? ParentingDashbaord
                push?.matchCategory = dictevent["id_module"] as? String ?? ""
                push?.matchSubCategory = dictevent["id_category"] as? String ?? ""
                push?.arrParentingDashboardTitle = ["Articles","Audio","Frequently Asked Questions","Medline","Videos"]
                push?.arrParentingDashboardImage = ["note1","music1","faq","Medecine","Videos"]
                push?.arrParentingDashboardId = ["001","002","013","016","045"]
                push?.matchTitleSelect = self.matchTitleSelect
                push?.matchTitleShowSelect = str1
                push?.devesionIdCategory = dictevent["id_division"] as? String ?? ""
                self.navigationController?.pushViewController(push!, animated: true)
            }
            if str == "Paying for Medical Care"
            {
                
                let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ParentingDashbaordId") as? ParentingDashbaord
                push?.matchCategory = dictevent["id_module"] as? String ?? ""
                push?.matchSubCategory = dictevent["id_category"] as? String ?? ""
                push?.arrParentingDashboardTitle = ["Articles","Frequently Asked Questions","Resources"]
                push?.arrParentingDashboardImage = ["note1","faq","care"]
                push?.arrParentingDashboardId = ["001","013","012"]
                push?.matchTitleSelect = self.matchTitleSelect
                push?.matchTitleShowSelect = str1
                push?.devesionIdCategory = dictevent["id_division"] as? String ?? ""
                self.navigationController?.pushViewController(push!, animated: true)
            }
            if str == "New Treatments and Research"
            {
                
                let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ParentingDashbaordId") as? ParentingDashbaord
                push?.matchCategory = dictevent["id_module"] as? String ?? ""
                push?.matchSubCategory = dictevent["id_category"] as? String ?? ""
                push?.arrParentingDashboardTitle = ["Articles","Frequently Asked Questions","Medline"]
                push?.arrParentingDashboardImage = ["note1","faq","Medecine"]
                push?.arrParentingDashboardId = ["001","013","016"]
                push?.matchTitleSelect = self.matchTitleSelect
                push?.matchTitleShowSelect = str1
                push?.devesionIdCategory = dictevent["id_division"] as? String ?? ""
                self.navigationController?.pushViewController(push!, animated: true)
            }
            if str == "Health Consumer Tips"
            {
                
                let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ParentingDashbaordId") as? ParentingDashbaord
                push?.matchCategory = dictevent["id_module"] as? String ?? ""
                push?.matchSubCategory = dictevent["id_category"] as? String ?? ""
                push?.arrParentingDashboardTitle = ["Articles","Audio","Frequently Asked Questions","Videos"]
                push?.arrParentingDashboardImage = ["note1","music1","faq","Videos"]
                push?.arrParentingDashboardId = ["001","002","013","045"]
                push?.matchTitleSelect = self.matchTitleSelect
                push?.matchTitleShowSelect = str1
                push?.devesionIdCategory = dictevent["id_division"] as? String ?? ""
                self.navigationController?.pushViewController(push!, animated: true)
            }
            if str == "LGBTQ+ Medical Care Issues"
            {
                
                let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ParentingDashbaordId") as? ParentingDashbaord
                push?.matchCategory = dictevent["id_module"] as? String ?? ""
                push?.matchSubCategory = dictevent["id_category"] as? String ?? ""
                push?.arrParentingDashboardTitle = ["Articles","Audio","Procedure","Slideshow"]
                push?.arrParentingDashboardImage = ["note1","music1","Procedure","care"]
                push?.arrParentingDashboardId = ["001","002","033","066"]
                push?.matchTitleSelect = self.matchTitleSelect
                push?.matchTitleShowSelect = str1
                push?.devesionIdCategory = dictevent["id_division"] as? String ?? ""
                self.navigationController?.pushViewController(push!, animated: true)
            }
            if str == "Dental Care"
            {
                
                let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ParentingDashbaordId") as? ParentingDashbaord
                push?.matchCategory = dictevent["id_module"] as? String ?? ""
                push?.matchSubCategory = dictevent["id_category"] as? String ?? ""
                push?.arrParentingDashboardTitle = ["Articles","Frequently Asked Questions","Procedure","Slideshow"]
                push?.arrParentingDashboardImage = ["note1","faq","Procedure","care"]
                push?.arrParentingDashboardId = ["001","013","033","066"]
                push?.matchTitleSelect = self.matchTitleSelect
                push?.matchTitleShowSelect = str1
                push?.devesionIdCategory = dictevent["id_division"] as? String ?? ""
                self.navigationController?.pushViewController(push!, animated: true)
            }
            if str == "Alternative and Complementary Medicine"
            {
                
                let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ParentingDashbaordId") as? ParentingDashbaord
                push?.matchCategory = dictevent["id_module"] as? String ?? ""
                push?.matchSubCategory = dictevent["id_category"] as? String ?? ""
                push?.arrParentingDashboardTitle = ["Articles","Frequently Asked Questions","Procedure","Slideshow"]
                push?.arrParentingDashboardImage = ["note1","faq","Procedure","care"]
                push?.arrParentingDashboardId = ["001","013","033","066"]
                push?.matchTitleSelect = self.matchTitleSelect
                push?.matchTitleShowSelect = str1
                push?.devesionIdCategory = dictevent["id_division"] as? String ?? ""
                self.navigationController?.pushViewController(push!, animated: true)
            }
        }
        
        
        if str1 == "Infants' and Toddlers' Health"
        {
            if str == "Breastfeeding"
            {
                
                let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ParentingDashbaordId") as? ParentingDashbaord
                push?.matchCategory = dictevent["id_module"] as? String ?? ""
                push?.matchSubCategory = dictevent["id_category"] as? String ?? ""
                push?.arrParentingDashboardTitle = ["Articles","Frequently Asked Questions","Slideshow"]
                push?.arrParentingDashboardImage = ["note1","faq","care"]
                push?.arrParentingDashboardId = ["001","013","066"]
                push?.matchTitleSelect = self.matchTitleSelect
                push?.matchTitleShowSelect = str1
                push?.devesionIdCategory = dictevent["id_division"] as? String ?? ""
                self.navigationController?.pushViewController(push!, animated: true)
            }
            if str == "Common Problems"
            {
                
                let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ParentingDashbaordId") as? ParentingDashbaord
                push?.matchCategory = dictevent["id_module"] as? String ?? ""
                push?.matchSubCategory = dictevent["id_category"] as? String ?? ""
                push?.arrParentingDashboardTitle = ["Articles","Frequently Asked Questions","Medline","Slideshow"]
                push?.arrParentingDashboardImage = ["note1","faq","Medecine","care"]
                push?.arrParentingDashboardId = ["001","013","016","066"]
                push?.matchTitleSelect = self.matchTitleSelect
                push?.matchTitleShowSelect = str1
                push?.devesionIdCategory = dictevent["id_division"] as? String ?? ""
                self.navigationController?.pushViewController(push!, animated: true)
            }
            if str == "Checkups"
            {
                
                let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ParentingDashbaordId") as? ParentingDashbaord
                push?.matchCategory = dictevent["id_module"] as? String ?? ""
                push?.matchSubCategory = dictevent["id_category"] as? String ?? ""
                push?.arrParentingDashboardTitle = ["Articles"]
                push?.arrParentingDashboardImage = ["note1"]
                push?.arrParentingDashboardId = ["001"]
                push?.matchTitleSelect = self.matchTitleSelect
                push?.matchTitleShowSelect = str1
                push?.devesionIdCategory = dictevent["id_division"] as? String ?? ""
                self.navigationController?.pushViewController(push!, animated: true)
            }
            if str == "New Baby Care"
            {
                
                let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ParentingDashbaordId") as? ParentingDashbaord
                push?.matchCategory = dictevent["id_module"] as? String ?? ""
                push?.matchSubCategory = dictevent["id_category"] as? String ?? ""
                push?.arrParentingDashboardTitle = ["Articles","Frequently Asked Questions","Medline","Resources","Slideshow","Videos"]
                push?.arrParentingDashboardImage = ["note1","faq","Medecine","care","care","Videos"]
                push?.arrParentingDashboardId = ["001","013","016","012","066","045"]
                push?.matchTitleSelect = self.matchTitleSelect
                push?.matchTitleShowSelect = str1
                push?.devesionIdCategory = dictevent["id_division"] as? String ?? ""
                self.navigationController?.pushViewController(push!, animated: true)
            }
            if str == "Sleeping Issues"
            {
                
                let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ParentingDashbaordId") as? ParentingDashbaord
                push?.matchCategory = dictevent["id_module"] as? String ?? ""
                push?.matchSubCategory = dictevent["id_category"] as? String ?? ""
                push?.arrParentingDashboardTitle = ["Articles","Frequently Asked Questions"]
                push?.arrParentingDashboardImage = ["note1","faq"]
                push?.arrParentingDashboardId = ["001","013"]
                push?.matchTitleSelect = self.matchTitleSelect
                push?.matchTitleShowSelect = str1
                push?.devesionIdCategory = dictevent["id_division"] as? String ?? ""
                self.navigationController?.pushViewController(push!, animated: true)
            }
            if str == "Ear Infections"
            {
                
                let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ParentingDashbaordId") as? ParentingDashbaord
                push?.matchCategory = dictevent["id_module"] as? String ?? ""
                push?.matchSubCategory = dictevent["id_category"] as? String ?? ""
                push?.arrParentingDashboardTitle = ["Articles","Audio"]
                push?.arrParentingDashboardImage = ["note1","music1"]
                push?.arrParentingDashboardId = ["001","002"]
                push?.matchTitleSelect = self.matchTitleSelect
                push?.matchTitleShowSelect = str1
                push?.devesionIdCategory = dictevent["id_division"] as? String ?? ""
                self.navigationController?.pushViewController(push!, animated: true)
            }
        }
        if str1 == "Immigration"
        {
            if str == "Becoming a U.S. Citizen"
            {
                
                let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ParentingDashbaordId") as? ParentingDashbaord
                push?.matchCategory = dictevent["id_module"] as? String ?? ""
                push?.matchSubCategory = dictevent["id_category"] as? String ?? ""
                push?.arrParentingDashboardTitle = ["Articles","Resources"]
                push?.arrParentingDashboardImage = ["note1","care"]
                push?.arrParentingDashboardId = ["001","012"]
                push?.matchTitleSelect = self.matchTitleSelect
                push?.matchTitleShowSelect = str1
                push?.devesionIdCategory = dictevent["id_division"] as? String ?? ""
                self.navigationController?.pushViewController(push!, animated: true)
            }
            if str == "Visas and Residency"
            {
                
                let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ParentingDashbaordId") as? ParentingDashbaord
                push?.matchCategory = dictevent["id_module"] as? String ?? ""
                push?.matchSubCategory = dictevent["id_category"] as? String ?? ""
                push?.arrParentingDashboardTitle = ["Articles","Resources"]
                push?.arrParentingDashboardImage = ["note1","care"]
                push?.arrParentingDashboardId = ["001","012"]
                push?.matchTitleSelect = self.matchTitleSelect
                push?.matchTitleShowSelect = str1
                push?.devesionIdCategory = dictevent["id_division"] as? String ?? ""
                self.navigationController?.pushViewController(push!, animated: true)
            }
            if str == "Everyday Living"
            {
                
                let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ParentingDashbaordId") as? ParentingDashbaord
                push?.matchCategory = dictevent["id_module"] as? String ?? ""
                push?.matchSubCategory = dictevent["id_category"] as? String ?? ""
                push?.arrParentingDashboardTitle = ["Articles","Resources"]
                push?.arrParentingDashboardImage = ["note1","care"]
                push?.arrParentingDashboardId = ["001","012"]
                push?.matchTitleSelect = self.matchTitleSelect
                push?.matchTitleShowSelect = str1
                push?.devesionIdCategory = dictevent["id_division"] as? String ?? ""
                self.navigationController?.pushViewController(push!, animated: true)
            }
        }
        if str1 == "Relocating Abroad"
        {
            if str == "Managing Stress"
            {
                
                let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ParentingDashbaordId") as? ParentingDashbaord
                push?.matchCategory = dictevent["id_module"] as? String ?? ""
                push?.matchSubCategory = dictevent["id_category"] as? String ?? ""
                push?.arrParentingDashboardTitle = ["Articles","Resources"]
                push?.arrParentingDashboardImage = ["note1","care"]
                push?.arrParentingDashboardId = ["001","012"]
                push?.matchTitleSelect = self.matchTitleSelect
                push?.matchTitleShowSelect = str1
                push?.devesionIdCategory = dictevent["id_division"] as? String ?? ""
                self.navigationController?.pushViewController(push!, animated: true)
            }
            if str == "Moving Tips"
            {
                
                let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ParentingDashbaordId") as? ParentingDashbaord
                push?.matchCategory = dictevent["id_module"] as? String ?? ""
                push?.matchSubCategory = dictevent["id_category"] as? String ?? ""
                push?.arrParentingDashboardTitle = ["Articles","Resources"]
                push?.arrParentingDashboardImage = ["note1","care"]
                push?.arrParentingDashboardId = ["001","012"]
                push?.matchTitleSelect = self.matchTitleSelect
                push?.matchTitleShowSelect = str1
                push?.devesionIdCategory = dictevent["id_division"] as? String ?? ""
                self.navigationController?.pushViewController(push!, animated: true)
            }
            if str == "Know Before You Go"
            {
                
                let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ParentingDashbaordId") as? ParentingDashbaord
                push?.matchCategory = dictevent["id_module"] as? String ?? ""
                push?.matchSubCategory = dictevent["id_category"] as? String ?? ""
                push?.arrParentingDashboardTitle = ["Articles","Resources"]
                push?.arrParentingDashboardImage = ["note1","care"]
                push?.arrParentingDashboardId = ["001","012"]
                push?.matchTitleSelect = self.matchTitleSelect
                push?.matchTitleShowSelect = str1
                push?.devesionIdCategory = dictevent["id_division"] as? String ?? ""
                self.navigationController?.pushViewController(push!, animated: true)
            }
        }
        if str1 == "Emigration"
        {
            if str == "Support for Americans Abroad"
            {
                
                let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ParentingDashbaordId") as? ParentingDashbaord
                push?.matchCategory = dictevent["id_module"] as? String ?? ""
                push?.matchSubCategory = dictevent["id_category"] as? String ?? ""
                push?.arrParentingDashboardTitle = ["Articles"]
                push?.arrParentingDashboardImage = ["note1"]
                push?.arrParentingDashboardId = ["001"]
                push?.matchTitleSelect = self.matchTitleSelect
                push?.matchTitleShowSelect = str1
                push?.devesionIdCategory = dictevent["id_division"] as? String ?? ""
                self.navigationController?.pushViewController(push!, animated: true)
            }
            if str == "Basic Info on Emigration"
            {
                
                let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ParentingDashbaordId") as? ParentingDashbaord
                push?.matchCategory = dictevent["id_module"] as? String ?? ""
                push?.matchSubCategory = dictevent["id_category"] as? String ?? ""
                push?.arrParentingDashboardTitle = ["Articles"]
                push?.arrParentingDashboardImage = ["note1"]
                push?.arrParentingDashboardId = ["001"]
                push?.matchTitleSelect = self.matchTitleSelect
                push?.matchTitleShowSelect = str1
                push?.devesionIdCategory = dictevent["id_division"] as? String ?? ""
                self.navigationController?.pushViewController(push!, animated: true)
            }
            
        }
        if str1 == "Living Abroad"
        {
            if str == "Culture Adjustment"
            {
                
                let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ParentingDashbaordId") as? ParentingDashbaord
                push?.matchCategory = dictevent["id_module"] as? String ?? ""
                push?.matchSubCategory = dictevent["id_category"] as? String ?? ""
                push?.arrParentingDashboardTitle = ["Articles","Resources"]
                push?.arrParentingDashboardImage = ["note1","care"]
                push?.arrParentingDashboardId = ["001","012"]
                push?.matchTitleSelect = self.matchTitleSelect
                push?.matchTitleShowSelect = str1
                push?.devesionIdCategory = dictevent["id_division"] as? String ?? ""
                self.navigationController?.pushViewController(push!, animated: true)
                
            }
            if str == "Living Abroad"
            {
                
                let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ParentingDashbaordId") as? ParentingDashbaord
                push?.matchCategory = dictevent["id_module"] as? String ?? ""
                push?.matchSubCategory = dictevent["id_category"] as? String ?? ""
                push?.arrParentingDashboardTitle = ["Articles","Resources"]
                push?.arrParentingDashboardImage = ["note1","care"]
                push?.arrParentingDashboardId = ["001","012"]
                push?.matchTitleSelect = self.matchTitleSelect
                push?.devesionIdCategory = dictevent["id_division"] as? String ?? ""
                push?.matchTitleShowSelect = str1
                self.navigationController?.pushViewController(push!, animated: true)
            }
            if str == "Managing Change"
            {
                
                let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ParentingDashbaordId") as? ParentingDashbaord
                push?.matchCategory = dictevent["id_module"] as? String ?? ""
                push?.matchSubCategory = dictevent["id_category"] as? String ?? ""
                push?.arrParentingDashboardTitle = ["Articles","Resources"]
                push?.arrParentingDashboardImage = ["note1","care"]
                push?.arrParentingDashboardId = ["001","012"]
                push?.matchTitleSelect = self.matchTitleSelect
                push?.devesionIdCategory = dictevent["id_division"] as? String ?? ""
                push?.matchTitleShowSelect = str1
                self.navigationController?.pushViewController(push!, animated: true)
            }
            if str == "Mental Health"
            {
                
                let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ParentingDashbaordId") as? ParentingDashbaord
                push?.matchCategory = dictevent["id_module"] as? String ?? ""
                push?.matchSubCategory = dictevent["id_category"] as? String ?? ""
                push?.arrParentingDashboardTitle = ["Articles","Resources"]
                push?.arrParentingDashboardImage = ["note1","care"]
                push?.arrParentingDashboardId = ["001","012"]
                push?.matchTitleSelect = self.matchTitleSelect
                push?.devesionIdCategory = dictevent["id_division"] as? String ?? ""
                push?.matchTitleShowSelect = str1
                self.navigationController?.pushViewController(push!, animated: true)
            }
            if str == "Practical Tips and Info"
            {
                
                let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ParentingDashbaordId") as? ParentingDashbaord
                push?.matchCategory = dictevent["id_module"] as? String ?? ""
                push?.matchSubCategory = dictevent["id_category"] as? String ?? ""
                push?.arrParentingDashboardTitle = ["Articles"]
                push?.arrParentingDashboardImage = ["note1"]
                push?.arrParentingDashboardId = ["001"]
                push?.matchTitleSelect = self.matchTitleSelect
                push?.devesionIdCategory = dictevent["id_division"] as? String ?? ""
                push?.matchTitleShowSelect = str1
                self.navigationController?.pushViewController(push!, animated: true)
            }
            if str == "Safety"
            {
                
                let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ParentingDashbaordId") as? ParentingDashbaord
                push?.matchCategory = dictevent["id_module"] as? String ?? ""
                push?.matchSubCategory = dictevent["id_category"] as? String ?? ""
                push?.arrParentingDashboardTitle = ["Articles","Resources"]
                push?.arrParentingDashboardImage = ["note1","care"]
                push?.arrParentingDashboardId = ["001","012"]
                push?.devesionIdCategory = dictevent["id_division"] as? String ?? ""
                push?.matchTitleSelect = self.matchTitleSelect
                push?.matchTitleShowSelect = str1
                self.navigationController?.pushViewController(push!, animated: true)
            }
            if str == "Travel"
            {
                
                let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ParentingDashbaordId") as? ParentingDashbaord
                push?.matchCategory = dictevent["id_module"] as? String ?? ""
                push?.matchSubCategory = dictevent["id_category"] as? String ?? ""
                push?.arrParentingDashboardTitle = ["Articles","Resources"]
                push?.arrParentingDashboardImage = ["note1","care"]
                push?.arrParentingDashboardId = ["001","012"]
                push?.matchTitleSelect = self.matchTitleSelect
                push?.devesionIdCategory = dictevent["id_division"] as? String ?? ""
                push?.matchTitleShowSelect = str1
                self.navigationController?.pushViewController(push!, animated: true)
            }
            
        }
        if str1 == "Repatriation"
        {
            
            if str == "More on Repatriation"
            {
                
                let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ParentingDashbaordId") as? ParentingDashbaord
                push?.matchCategory = dictevent["id_module"] as? String ?? ""
                push?.matchSubCategory = dictevent["id_category"] as? String ?? ""
                push?.arrParentingDashboardTitle = ["Articles","Resources"]
                push?.arrParentingDashboardImage = ["note1","care"]
                push?.arrParentingDashboardId = ["001","012"]
                push?.matchTitleSelect = self.matchTitleSelect
                push?.devesionIdCategory = dictevent["id_division"] as? String ?? ""
                push?.matchTitleShowSelect = str1
                self.navigationController?.pushViewController(push!, animated: true)
            }
            
        }
        if str1 == "Families Abroad"
        {
            if str == "Couples"
            {
                
                let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ParentingDashbaordId") as? ParentingDashbaord
                push?.matchCategory = dictevent["id_module"] as? String ?? ""
                push?.matchSubCategory = dictevent["id_category"] as? String ?? ""
                push?.arrParentingDashboardTitle = ["Resources"]
                push?.arrParentingDashboardImage = ["care"]
                push?.arrParentingDashboardId = ["012"]
                push?.devesionIdCategory = dictevent["id_division"] as? String ?? ""
                push?.matchTitleSelect = self.matchTitleSelect
                push?.matchTitleShowSelect = str1
                self.navigationController?.pushViewController(push!, animated: true)
            }
            if str == "Practical Household"
            {
                
                let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ParentingDashbaordId") as? ParentingDashbaord
                push?.matchCategory = dictevent["id_module"] as? String ?? ""
                push?.matchSubCategory = dictevent["id_category"] as? String ?? ""
                push?.arrParentingDashboardTitle = ["Articles","Resources"]
                push?.arrParentingDashboardImage = ["note1","care"]
                push?.arrParentingDashboardId = ["001","012"]
                push?.devesionIdCategory = dictevent["id_division"] as? String ?? ""
                push?.matchTitleSelect = self.matchTitleSelect
                push?.matchTitleShowSelect = str1
                self.navigationController?.pushViewController(push!, animated: true)
            }
            if str == "Feeling at Home"
            {
                
                let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ParentingDashbaordId") as? ParentingDashbaord
                push?.matchCategory = dictevent["id_module"] as? String ?? ""
                push?.matchSubCategory = dictevent["id_category"] as? String ?? ""
                push?.arrParentingDashboardTitle = ["Articles","Resources"]
                push?.arrParentingDashboardImage = ["note1","care"]
                push?.arrParentingDashboardId = ["001","012"]
                push?.devesionIdCategory = dictevent["id_division"] as? String ?? ""
                push?.matchTitleSelect = self.matchTitleSelect
                push?.matchTitleShowSelect = str1
                self.navigationController?.pushViewController(push!, animated: true)
            }
            if str == "Keeping Connected"
            {
                
                let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ParentingDashbaordId") as? ParentingDashbaord
                push?.matchCategory = dictevent["id_module"] as? String ?? ""
                push?.matchSubCategory = dictevent["id_category"] as? String ?? ""
                push?.arrParentingDashboardTitle = ["Articles","Resources"]
                push?.arrParentingDashboardImage = ["note1","care"]
                push?.arrParentingDashboardId = ["001","012"]
                push?.matchTitleSelect = self.matchTitleSelect
                push?.devesionIdCategory = dictevent["id_division"] as? String ?? ""
                push?.matchTitleShowSelect = str1
                self.navigationController?.pushViewController(push!, animated: true)
            }
        }
        if str1 == "Working Abroad"
        {
            
        }
        if str1 == "Accomplished Employee"
        {
            
            if str == "Balancing Work and Family Life"
            {
                
                let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ParentingDashbaordId") as? ParentingDashbaord
                push?.matchCategory = dictevent["id_module"] as? String ?? ""
                push?.matchSubCategory = dictevent["id_category"] as? String ?? ""
                push?.arrParentingDashboardTitle = ["Articles","Audio","Online seminars"]
                push?.arrParentingDashboardImage = ["note1","music1","study2"]
                push?.arrParentingDashboardId = ["001","004","030"]
                push?.devesionIdCategory = dictevent["id_division"] as? String ?? ""
                push?.matchTitleSelect = self.matchTitleSelect
                push?.matchTitleShowSelect = str1
                self.navigationController?.pushViewController(push!, animated: true)
            }
            if str == "Being Part of a Team"
            {
                
                let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ParentingDashbaordId") as? ParentingDashbaord
                push?.matchCategory = dictevent["id_module"] as? String ?? ""
                push?.matchSubCategory = dictevent["id_category"] as? String ?? ""
                push?.arrParentingDashboardTitle = ["Articles","Online seminars"]
                push?.arrParentingDashboardImage = ["note1","study2"]
                push?.arrParentingDashboardId = ["001","030"]
                push?.devesionIdCategory = dictevent["id_division"] as? String ?? ""
                push?.matchTitleShowSelect = str1
                push?.matchTitleSelect = self.matchTitleSelect
                self.navigationController?.pushViewController(push!, animated: true)
            }
            if str == "Communication Skills"
            {
                
                let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ParentingDashbaordId") as? ParentingDashbaord
                push?.matchCategory = dictevent["id_module"] as? String ?? ""
                push?.matchSubCategory = dictevent["id_category"] as? String ?? ""
                push?.arrParentingDashboardTitle = ["Articles","Audio","Online seminars"]
                push?.arrParentingDashboardImage = ["note1","music1","study2"]
                push?.arrParentingDashboardId = ["001","004","030"]
                push?.devesionIdCategory = dictevent["id_division"] as? String ?? ""
                push?.matchTitleSelect = self.matchTitleSelect
                push?.matchTitleShowSelect = str1
                self.navigationController?.pushViewController(push!, animated: true)
            }
            
            if str == "Dealing with Difficult People"
            {
                
                let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ParentingDashbaordId") as? ParentingDashbaord
                push?.matchCategory = dictevent["id_module"] as? String ?? ""
                push?.matchSubCategory = dictevent["id_category"] as? String ?? ""
                push?.arrParentingDashboardTitle = ["Articles","Audio","Online seminars"]
                push?.arrParentingDashboardImage = ["note1","music1","study2"]
                push?.arrParentingDashboardId = ["001","004","030"]
                push?.matchTitleSelect = self.matchTitleSelect
                push?.devesionIdCategory = dictevent["id_division"] as? String ?? ""
                push?.matchTitleShowSelect = str1
                self.navigationController?.pushViewController(push!, animated: true)
            }
            if str == "Effective Business Travel"
            {
                
                let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ParentingDashbaordId") as? ParentingDashbaord
                push?.matchCategory = dictevent["id_module"] as? String ?? ""
                push?.matchSubCategory = dictevent["id_category"] as? String ?? ""
                push?.arrParentingDashboardTitle = ["Articles","Audio","provider search","Resource"]
                push?.arrParentingDashboardImage = ["note1","music1","Provider","care"]
                push?.arrParentingDashboardId = ["001","004","007","012"]
                push?.matchTitleSelect = self.matchTitleSelect
                push?.devesionIdCategory = dictevent["id_division"] as? String ?? ""
                push?.matchTitleShowSelect = str1
                self.navigationController?.pushViewController(push!, animated: true)
            }
            if str == "Giving and Receiving Feedback"
            {
                
                let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ParentingDashbaordId") as? ParentingDashbaord
                push?.matchCategory = dictevent["id_module"] as? String ?? ""
                push?.matchSubCategory = dictevent["id_category"] as? String ?? ""
                push?.arrParentingDashboardTitle = ["Articles","Audio"]
                push?.arrParentingDashboardImage = ["note1","music1"]
                push?.arrParentingDashboardId = ["001","004"]
                push?.matchTitleSelect = self.matchTitleSelect
                push?.devesionIdCategory = dictevent["id_division"] as? String ?? ""
                push?.matchTitleShowSelect = str1
                self.navigationController?.pushViewController(push!, animated: true)
            }
            if str == "Resolving Conflict"
            {
                
                let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ParentingDashbaordId") as? ParentingDashbaord
                push?.matchCategory = dictevent["id_module"] as? String ?? ""
                push?.matchSubCategory = dictevent["id_category"] as? String ?? ""
                push?.arrParentingDashboardTitle = ["Articles","Online seminars"]
                push?.arrParentingDashboardImage = ["note1","study2"]
                push?.arrParentingDashboardId = ["001","030"]
                push?.devesionIdCategory = dictevent["id_division"] as? String ?? ""
                push?.matchTitleSelect = self.matchTitleSelect
                push?.matchTitleShowSelect = str1
                self.navigationController?.pushViewController(push!, animated: true)
            }
            if str == "Tips for Success"
            {
                
                let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ParentingDashbaordId") as? ParentingDashbaord
                push?.matchCategory = dictevent["id_module"] as? String ?? ""
                push?.matchSubCategory = dictevent["id_category"] as? String ?? ""
                push?.arrParentingDashboardTitle = ["Articles","Online seminars","Resource"]
                push?.arrParentingDashboardImage = ["note1","study2","care"]
                push?.arrParentingDashboardId = ["001","030","012"]
                push?.matchTitleSelect = self.matchTitleSelect
                push?.devesionIdCategory = dictevent["id_division"] as? String ?? ""
                push?.matchTitleShowSelect = str1
                self.navigationController?.pushViewController(push!, animated: true)
            }
        }
        if str1 == "Effective Manager"
        {
            if str == "Managing Change"
            {
                
                let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ParentingDashbaordId") as? ParentingDashbaord
                push?.matchCategory = dictevent["id_module"] as? String ?? ""
                push?.matchSubCategory = dictevent["id_category"] as? String ?? ""
                push?.arrParentingDashboardTitle = ["Articles","Audio","Handbooks","Online seminars"]
                push?.arrParentingDashboardImage = ["note1","music1","Handbooks","study2"]
                push?.arrParentingDashboardId = ["001","002","004","030"]
                push?.matchTitleSelect = self.matchTitleSelect
                push?.matchTitleShowSelect = str1
                push?.devesionIdCategory = dictevent["id_division"] as? String ?? ""
                self.navigationController?.pushViewController(push!, animated: true)
            }
            if str == "Communication Skills"
            {
                
                let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ParentingDashbaordId") as? ParentingDashbaord
                push?.matchCategory = dictevent["id_module"] as? String ?? ""
                push?.matchSubCategory = dictevent["id_category"] as? String ?? ""
                push?.arrParentingDashboardTitle = ["Articles","Audio","Online seminars"]
                push?.arrParentingDashboardImage = ["note1","music1","study2"]
                push?.arrParentingDashboardId = ["001","002","030"]
                push?.matchTitleSelect = self.matchTitleSelect
                push?.matchTitleShowSelect = str1
                push?.devesionIdCategory = dictevent["id_division"] as? String ?? ""
                self.navigationController?.pushViewController(push!, animated: true)
            }
            if str == "Dealing With Difficult Customers"
            {
                
                let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ParentingDashbaordId") as? ParentingDashbaord
                push?.matchCategory = dictevent["id_module"] as? String ?? ""
                push?.matchSubCategory = dictevent["id_category"] as? String ?? ""
                push?.arrParentingDashboardTitle = ["Articles","Online seminars"]
                push?.arrParentingDashboardImage = ["note1","study2"]
                push?.arrParentingDashboardId = ["001","030"]
                push?.matchTitleSelect = self.matchTitleSelect
                push?.matchTitleShowSelect = str1
                push?.devesionIdCategory = dictevent["id_division"] as? String ?? ""
                self.navigationController?.pushViewController(push!, animated: true)
            }
            if str == "Dealing With Difficult Employees"
            {
                
                let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ParentingDashbaordId") as? ParentingDashbaord
                push?.matchCategory = dictevent["id_module"] as? String ?? ""
                push?.matchSubCategory = dictevent["id_category"] as? String ?? ""
                push?.arrParentingDashboardTitle = ["Articles","Online seminars"]
                push?.arrParentingDashboardImage = ["note1","study2"]
                push?.arrParentingDashboardId = ["001","030"]
                push?.matchTitleSelect = self.matchTitleSelect
                push?.matchTitleShowSelect = str1
                push?.devesionIdCategory = dictevent["id_division"] as? String ?? ""
                self.navigationController?.pushViewController(push!, animated: true)
            }
            if str == "Downsizing"
            {
                
                let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ParentingDashbaordId") as? ParentingDashbaord
                push?.matchCategory = dictevent["id_module"] as? String ?? ""
                push?.matchSubCategory = dictevent["id_category"] as? String ?? ""
                push?.arrParentingDashboardTitle = ["Articles"]
                push?.arrParentingDashboardImage = ["note1"]
                push?.arrParentingDashboardId = ["001"]
                push?.matchTitleSelect = self.matchTitleSelect
                push?.matchTitleShowSelect = str1
                push?.devesionIdCategory = dictevent["id_division"] as? String ?? ""
                self.navigationController?.pushViewController(push!, animated: true)
            }
            if str == "Employee Motivation and Recognition"
            {
                
                let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ParentingDashbaordId") as? ParentingDashbaord
                push?.matchCategory = dictevent["id_module"] as? String ?? ""
                push?.matchSubCategory = dictevent["id_category"] as? String ?? ""
                push?.arrParentingDashboardTitle = ["Articles"]
                push?.arrParentingDashboardImage = ["note1"]
                push?.arrParentingDashboardId = ["001"]
                push?.matchTitleSelect = self.matchTitleSelect
                push?.matchTitleShowSelect = str1
                push?.devesionIdCategory = dictevent["id_division"] as? String ?? ""
                self.navigationController?.pushViewController(push!, animated: true)
            }
            if str == "Evaluating Employees"
            {
                
                let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ParentingDashbaordId") as? ParentingDashbaord
                push?.matchCategory = dictevent["id_module"] as? String ?? ""
                push?.matchSubCategory = dictevent["id_category"] as? String ?? ""
                push?.arrParentingDashboardTitle = ["Articles","Online seminars"]
                push?.arrParentingDashboardImage = ["note1","study2"]
                push?.arrParentingDashboardId = ["001","030"]
                push?.matchTitleSelect = self.matchTitleSelect
                push?.matchTitleShowSelect = str1
                push?.devesionIdCategory = dictevent["id_division"] as? String ?? ""
                self.navigationController?.pushViewController(push!, animated: true)
            }
            if str == "Facilitating Work-Life Balance"
            {
                
                let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ParentingDashbaordId") as? ParentingDashbaord
                push?.matchCategory = dictevent["id_module"] as? String ?? ""
                push?.matchSubCategory = dictevent["id_category"] as? String ?? ""
                push?.arrParentingDashboardTitle = ["Articles","Online seminars"]
                push?.arrParentingDashboardImage = ["note1","study2"]
                push?.arrParentingDashboardId = ["001","030"]
                push?.matchTitleSelect = self.matchTitleSelect
                push?.matchTitleShowSelect = str1
                push?.devesionIdCategory = dictevent["id_division"] as? String ?? ""
                self.navigationController?.pushViewController(push!, animated: true)
            }
            if str == "Giving Feedback to Staff"
            {
                
                let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ParentingDashbaordId") as? ParentingDashbaord
                push?.matchCategory = dictevent["id_module"] as? String ?? ""
                push?.matchSubCategory = dictevent["id_category"] as? String ?? ""
                push?.arrParentingDashboardTitle = ["Articles"]
                push?.arrParentingDashboardImage = ["note1"]
                push?.arrParentingDashboardId = ["001"]
                push?.matchTitleSelect = self.matchTitleSelect
                push?.matchTitleShowSelect = str1
                push?.devesionIdCategory = dictevent["id_division"] as? String ?? ""
                self.navigationController?.pushViewController(push!, animated: true)
            }
            if str == "Leadership Skills"
            {
                
                let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ParentingDashbaordId") as? ParentingDashbaord
                push?.matchCategory = dictevent["id_module"] as? String ?? ""
                push?.matchSubCategory = dictevent["id_category"] as? String ?? ""
                push?.arrParentingDashboardTitle = ["Articles","Audio","Handbooks","Online seminars","Resource"]
                push?.arrParentingDashboardImage = ["note1","music1","Handbooks","study2","care"]
                push?.arrParentingDashboardId = ["001","002","004","030","012"]
                push?.matchTitleSelect = self.matchTitleSelect
                push?.matchTitleShowSelect = str1
                push?.devesionIdCategory = dictevent["id_division"] as? String ?? ""
                self.navigationController?.pushViewController(push!, animated: true)
            }
            if str == "Managing Virtual Staff"
            {
                
                let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ParentingDashbaordId") as? ParentingDashbaord
                push?.matchCategory = dictevent["id_module"] as? String ?? ""
                push?.matchSubCategory = dictevent["id_category"] as? String ?? ""
                push?.arrParentingDashboardTitle = ["Articles","Handbooks","Online seminars"]
                push?.arrParentingDashboardImage = ["note1","Handbooks","study2"]
                push?.arrParentingDashboardId = ["001","004","030"]
                push?.matchTitleSelect = self.matchTitleSelect
                push?.matchTitleShowSelect = str1
                push?.devesionIdCategory = dictevent["id_division"] as? String ?? ""
                self.navigationController?.pushViewController(push!, animated: true)
            }
            if str == "Understanding Workplace Substance Abuse"
            {
                
                let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ParentingDashbaordId") as? ParentingDashbaord
                push?.matchCategory = dictevent["id_module"] as? String ?? ""
                push?.matchSubCategory = dictevent["id_category"] as? String ?? ""
                push?.arrParentingDashboardTitle = ["Articles","Online seminars","Resource"]
                push?.arrParentingDashboardImage = ["note1","study2","Resource"]
                push?.arrParentingDashboardId = ["001","030","012"]
                push?.matchTitleSelect = self.matchTitleSelect
                push?.matchTitleShowSelect = str1
                push?.devesionIdCategory = dictevent["id_division"] as? String ?? ""
                self.navigationController?.pushViewController(push!, animated: true)
            }
            if str == "Understanding Workplace Violence"
            {
                
                let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ParentingDashbaordId") as? ParentingDashbaord
                push?.matchCategory = dictevent["id_module"] as? String ?? ""
                push?.matchSubCategory = dictevent["id_category"] as? String ?? ""
                push?.arrParentingDashboardTitle = ["Articles","Online seminars","Resource"]
                push?.arrParentingDashboardImage = ["note1","study2","Resource"]
                push?.arrParentingDashboardId = ["001","030","012"]
                push?.matchTitleSelect = self.matchTitleSelect
                push?.matchTitleShowSelect = str1
                push?.devesionIdCategory = dictevent["id_division"] as? String ?? ""
                self.navigationController?.pushViewController(push!, animated: true)
            }
        }
        if str1 == "Career Development"
        {
            if str == "Career Tips"
            {
                
                let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ParentingDashbaordId") as? ParentingDashbaord
                push?.matchCategory = dictevent["id_module"] as? String ?? ""
                push?.matchSubCategory = dictevent["id_category"] as? String ?? ""
                push?.arrParentingDashboardTitle = ["Articles","Online seminars"]
                push?.arrParentingDashboardImage = ["note1","study2"]
                push?.matchTitleSelect = self.matchTitleSelect
                push?.matchTitleShowSelect = str1
                push?.arrParentingDashboardId = ["001","030"]
                push?.devesionIdCategory = dictevent["id_division"] as? String ?? ""
                self.navigationController?.pushViewController(push!, animated: true)
            }
            if str == "Training and Continuing Education"
            {
                
                let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ParentingDashbaordId") as? ParentingDashbaord
                push?.matchCategory = dictevent["id_module"] as? String ?? ""
                push?.matchSubCategory = dictevent["id_category"] as? String ?? ""
                push?.arrParentingDashboardTitle = ["Articles","Online seminars"]
                push?.arrParentingDashboardImage = ["note1","study2"]
                push?.arrParentingDashboardId = ["001","030"]
                push?.matchTitleSelect = self.matchTitleSelect
                push?.matchTitleShowSelect = str1
                push?.devesionIdCategory = dictevent["id_division"] as? String ?? ""
                self.navigationController?.pushViewController(push!, animated: true)
            }
            if str == "Untraditional Work Options"
            {
                
                let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ParentingDashbaordId") as? ParentingDashbaord
                push?.matchCategory = dictevent["id_module"] as? String ?? ""
                push?.matchSubCategory = dictevent["id_category"] as? String ?? ""
                push?.arrParentingDashboardTitle = ["Articles","Online seminars"]
                push?.arrParentingDashboardImage = ["note1","study2"]
                push?.arrParentingDashboardId = ["001","030"]
                push?.matchTitleSelect = self.matchTitleSelect
                push?.matchTitleShowSelect = str1
                push?.devesionIdCategory = dictevent["id_division"] as? String ?? ""
                self.navigationController?.pushViewController(push!, animated: true)
            }
            if str == "Advancing Within Your Organization"
            {
                
                let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ParentingDashbaordId") as? ParentingDashbaord
                push?.matchCategory = dictevent["id_module"] as? String ?? ""
                push?.matchSubCategory = dictevent["id_category"] as? String ?? ""
                push?.arrParentingDashboardTitle = ["Articles","Online seminars"]
                push?.arrParentingDashboardImage = ["note1","study2"]
                push?.arrParentingDashboardId = ["001","030"]
                push?.matchTitleSelect = self.matchTitleSelect
                push?.matchTitleShowSelect = str1
                push?.devesionIdCategory = dictevent["id_division"] as? String ?? ""
                self.navigationController?.pushViewController(push!, animated: true)
            }
            if str == "Relocating for Work"
            {
                
                let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ParentingDashbaordId") as? ParentingDashbaord
                push?.matchCategory = dictevent["id_module"] as? String ?? ""
                push?.matchSubCategory = dictevent["id_category"] as? String ?? ""
                push?.arrParentingDashboardTitle = ["Articles"]
                push?.arrParentingDashboardImage = ["note1"]
                push?.arrParentingDashboardId = ["001"]
                push?.matchTitleSelect = self.matchTitleSelect
                push?.matchTitleShowSelect = str1
                push?.devesionIdCategory = dictevent["id_division"] as? String ?? ""
                self.navigationController?.pushViewController(push!, animated: true)
            }
        }
        if str1 == "Training and Development"
        {
            if str == "Continuing Education"
            {
                
                let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ParentingDashbaordId") as? ParentingDashbaord
                push?.matchCategory = dictevent["id_module"] as? String ?? ""
                push?.matchSubCategory = dictevent["id_category"] as? String ?? ""
                push?.arrParentingDashboardTitle = ["Articles"]
                push?.arrParentingDashboardImage = ["note1"]
                push?.arrParentingDashboardId = ["001"]
                push?.matchTitleSelect = self.matchTitleSelect
                push?.matchTitleShowSelect = str1
                push?.devesionIdCategory = dictevent["id_division"] as? String ?? ""
                self.navigationController?.pushViewController(push!, animated: true)
            }
            if str == "Developing a Training Plan"
            {
                
                let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ParentingDashbaordId") as? ParentingDashbaord
                push?.matchCategory = dictevent["id_module"] as? String ?? ""
                push?.matchSubCategory = dictevent["id_category"] as? String ?? ""
                push?.arrParentingDashboardTitle = ["Articles"]
                push?.arrParentingDashboardImage = ["note1"]
                push?.arrParentingDashboardId = ["001"]
                push?.matchTitleSelect = self.matchTitleSelect
                push?.matchTitleShowSelect = str1
                push?.devesionIdCategory = dictevent["id_division"] as? String ?? ""
                self.navigationController?.pushViewController(push!, animated: true)
            }
            if str == "Mentoring and Volunteering"
            {
                
                let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ParentingDashbaordId") as? ParentingDashbaord
                push?.matchCategory = dictevent["id_module"] as? String ?? ""
                push?.matchSubCategory = dictevent["id_category"] as? String ?? ""
                push?.arrParentingDashboardTitle = ["Articles","Resource"]
                push?.arrParentingDashboardImage = ["note1","care"]
                push?.arrParentingDashboardId = ["001","012"]
                push?.matchTitleSelect = self.matchTitleSelect
                push?.devesionIdCategory = dictevent["id_division"] as? String ?? ""
                push?.matchTitleShowSelect = str1
                self.navigationController?.pushViewController(push!, animated: true)
            }
            
        }
        if str1 == "Workplace Diversity"
        {
            if str == "Committing to Diversity"
            {
                
                let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ParentingDashbaordId") as? ParentingDashbaord
                push?.matchCategory = dictevent["id_module"] as? String ?? ""
                push?.matchSubCategory = dictevent["id_category"] as? String ?? ""
                push?.arrParentingDashboardTitle = ["Articles","Online seminars"]
                push?.arrParentingDashboardImage = ["note1","study2"]
                push?.arrParentingDashboardId = ["001","030"]
                push?.matchTitleSelect = self.matchTitleSelect
                push?.matchTitleShowSelect = str1
                push?.devesionIdCategory = dictevent["id_division"] as? String ?? ""
                self.navigationController?.pushViewController(push!, animated: true)
            }
            if str == "Respect and Tolerance"
            {
                
                let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ParentingDashbaordId") as? ParentingDashbaord
                push?.matchCategory = dictevent["id_module"] as? String ?? ""
                push?.matchSubCategory = dictevent["id_category"] as? String ?? ""
                push?.arrParentingDashboardTitle = ["Articles","Online seminars","Resource"]
                push?.arrParentingDashboardImage = ["note1","study2","care"]
                push?.arrParentingDashboardId = ["001","030","012"]
                push?.matchTitleSelect = self.matchTitleSelect
                push?.devesionIdCategory = dictevent["id_division"] as? String ?? ""
                push?.matchTitleShowSelect = str1
                self.navigationController?.pushViewController(push!, animated: true)
            }
            if str == "Diversity Issues"
            {
                
                let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ParentingDashbaordId") as? ParentingDashbaord
                push?.matchCategory = dictevent["id_module"] as? String ?? ""
                push?.matchSubCategory = dictevent["id_category"] as? String ?? ""
                push?.arrParentingDashboardTitle = ["Articles","Online seminars","Resource"]
                push?.arrParentingDashboardImage = ["note1","study2","care"]
                push?.arrParentingDashboardId = ["001","030","012"]
                push?.matchTitleSelect = self.matchTitleSelect
                push?.devesionIdCategory = dictevent["id_division"] as? String ?? ""
                push?.matchTitleShowSelect = str1
                self.navigationController?.pushViewController(push!, animated: true)
            }
            
        }
        if str1 == "Workplace Productivity"
        {
            if str == "Delegation"
            {
                
                let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ParentingDashbaordId") as? ParentingDashbaord
                push?.matchCategory = dictevent["id_module"] as? String ?? ""
                push?.matchSubCategory = dictevent["id_category"] as? String ?? ""
                push?.arrParentingDashboardTitle = ["Articles","Online seminars"]
                push?.arrParentingDashboardImage = ["note1","study2"]
                push?.arrParentingDashboardId = ["001","030"]
                push?.matchTitleSelect = self.matchTitleSelect
                push?.devesionIdCategory = dictevent["id_division"] as? String ?? ""
                push?.matchTitleShowSelect = str1
                self.navigationController?.pushViewController(push!, animated: true)
            }
            if str == "Effective Communication"
            {
                
                let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ParentingDashbaordId") as? ParentingDashbaord
                push?.matchCategory = dictevent["id_module"] as? String ?? ""
                push?.matchSubCategory = dictevent["id_category"] as? String ?? ""
                push?.arrParentingDashboardTitle = ["Articles","Online seminars"]
                push?.arrParentingDashboardImage = ["note1","study2"]
                push?.arrParentingDashboardId = ["001","030"]
                push?.matchTitleSelect = self.matchTitleSelect
                push?.devesionIdCategory = dictevent["id_division"] as? String ?? ""
                push?.matchTitleShowSelect = str1
                self.navigationController?.pushViewController(push!, animated: true)
            }
            if str == "Time Management and Organization"
            {
                
                let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ParentingDashbaordId") as? ParentingDashbaord
                push?.matchCategory = dictevent["id_module"] as? String ?? ""
                push?.matchSubCategory = dictevent["id_category"] as? String ?? ""
                push?.arrParentingDashboardTitle = ["Articles","Audio","Frequently Asked Questions","Online seminars"]
                push?.arrParentingDashboardImage = ["note1","music1","faq","study2"]
                push?.arrParentingDashboardId = ["001","002","013","030"]
                push?.matchTitleSelect = self.matchTitleSelect
                push?.devesionIdCategory = dictevent["id_division"] as? String ?? ""
                push?.matchTitleShowSelect = str1
                self.navigationController?.pushViewController(push!, animated: true)
            }
        }
        if str1 == "Workplace Safety"
        {
            if str == "Coping with Workplace Emergencies"
            {
                
                let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ParentingDashbaordId") as? ParentingDashbaord
                push?.matchCategory = dictevent["id_module"] as? String ?? ""
                push?.matchSubCategory = dictevent["id_category"] as? String ?? ""
                push?.arrParentingDashboardTitle = ["Articles","Online seminars","Resource"]
                push?.arrParentingDashboardImage = ["note1","study2","care"]
                push?.arrParentingDashboardId = ["001","030","012"]
                push?.matchTitleSelect = self.matchTitleSelect
                push?.devesionIdCategory = dictevent["id_division"] as? String ?? ""
                push?.matchTitleShowSelect = str1
                self.navigationController?.pushViewController(push!, animated: true)
            }
            
            if str == "Creating a Safe Workspace"
            {
                
                let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ParentingDashbaordId") as? ParentingDashbaord
                push?.matchCategory = dictevent["id_module"] as? String ?? ""
                push?.matchSubCategory = dictevent["id_category"] as? String ?? ""
                push?.arrParentingDashboardTitle = ["Articles","Online seminars"]
                push?.arrParentingDashboardImage = ["note1","study2"]
                push?.arrParentingDashboardId = ["001","030"]
                push?.matchTitleSelect = self.matchTitleSelect
                push?.devesionIdCategory = dictevent["id_division"] as? String ?? ""
                push?.matchTitleShowSelect = str1
                self.navigationController?.pushViewController(push!, animated: true)
            }
            if str == "Disaster Preparedness"
            {
                
                let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ParentingDashbaordId") as? ParentingDashbaord
                push?.matchCategory = dictevent["id_module"] as? String ?? ""
                push?.matchSubCategory = dictevent["id_category"] as? String ?? ""
                push?.arrParentingDashboardTitle = ["Articles","Online seminars"]
                push?.arrParentingDashboardImage = ["note1","study2"]
                push?.arrParentingDashboardId = ["001","030"]
                push?.matchTitleSelect = self.matchTitleSelect
                push?.devesionIdCategory = dictevent["id_division"] as? String ?? ""
                push?.matchTitleShowSelect = str1
                self.navigationController?.pushViewController(push!, animated: true)
            }
            if str == "Home Office Safety"
            {
                
                let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ParentingDashbaordId") as? ParentingDashbaord
                push?.matchCategory = dictevent["id_module"] as? String ?? ""
                push?.matchSubCategory = dictevent["id_category"] as? String ?? ""
                push?.arrParentingDashboardTitle = ["Articles"]
                push?.arrParentingDashboardImage = ["note1"]
                push?.arrParentingDashboardId = ["001"]
                 push?.devesionIdCategory = dictevent["id_division"] as? String ?? ""
                push?.matchTitleSelect = self.matchTitleSelect
                push?.matchTitleShowSelect = str1
                self.navigationController?.pushViewController(push!, animated: true)
            }
            if str == "Managing Stress"
            {
                
                let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ParentingDashbaordId") as? ParentingDashbaord
                push?.matchCategory = dictevent["id_module"] as? String ?? ""
                push?.matchSubCategory = dictevent["id_category"] as? String ?? ""
                push?.arrParentingDashboardTitle = ["Articles","Audio","Online seminars", "Resource"]
                push?.arrParentingDashboardImage = ["note1","music1","study2","care"]
                push?.arrParentingDashboardId = ["001","002","030","012"]
                push?.matchTitleSelect = self.matchTitleSelect
                push?.matchTitleShowSelect = str1
                 push?.devesionIdCategory = dictevent["id_division"] as? String ?? ""
                self.navigationController?.pushViewController(push!, animated: true)
            }
            if str == "Understanding Stress"
            {
                
                let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ParentingDashbaordId") as? ParentingDashbaord
                push?.matchCategory = dictevent["id_module"] as? String ?? ""
                push?.matchSubCategory = dictevent["id_category"] as? String ?? ""
                push?.arrParentingDashboardTitle = ["Articles","Audio","Online seminars", "Resource"]
                push?.arrParentingDashboardImage = ["note1","music1","study2","care"]
                push?.arrParentingDashboardId = ["001","002","030","012"]
                push?.matchTitleSelect = self.matchTitleSelect
                push?.matchTitleShowSelect = str1
                 push?.devesionIdCategory = dictevent["id_division"] as? String ?? ""
                self.navigationController?.pushViewController(push!, animated: true)
            }
            if str == "Wellness in the Workplace"
            {
                
                let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ParentingDashbaordId") as? ParentingDashbaord
                push?.matchCategory = dictevent["id_module"] as? String ?? ""
                push?.matchSubCategory = dictevent["id_category"] as? String ?? ""
                push?.arrParentingDashboardTitle = ["Articles","Audio","Frequently Asked Questions","Online seminars","Resource","Video"]
                push?.arrParentingDashboardImage = ["note1","music1","faq","study2","care","Videos"]
                push?.arrParentingDashboardId = ["001","002","013","030","012","045"]
                push?.matchTitleSelect = self.matchTitleSelect
                push?.matchTitleShowSelect = str1
                 push?.devesionIdCategory = dictevent["id_division"] as? String ?? ""
                self.navigationController?.pushViewController(push!, animated: true)
            }
            if str == "Workplace Violence"
            {
                
                let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ParentingDashbaordId") as? ParentingDashbaord
                push?.matchCategory = dictevent["id_module"] as? String ?? ""
                push?.matchSubCategory = dictevent["id_category"] as? String ?? ""
                push?.arrParentingDashboardTitle = ["Articles","Audio","Online seminars","Resource"]
                push?.arrParentingDashboardImage = ["note1","music1","study2","care"]
                push?.arrParentingDashboardId = ["001","002","030","012"]
                push?.matchTitleSelect = self.matchTitleSelect
                push?.matchTitleShowSelect = str1
                 push?.devesionIdCategory = dictevent["id_division"] as? String ?? ""
                self.navigationController?.pushViewController(push!, animated: true)
            }
        }
        if str1 == "Career Transition"
        {
            if str == "Age and Employment"
            {
                
                let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ParentingDashbaordId") as? ParentingDashbaord
                push?.matchCategory = dictevent["id_module"] as? String ?? ""
                push?.matchSubCategory = dictevent["id_category"] as? String ?? ""
                push?.arrParentingDashboardTitle = ["Articles"]
                push?.arrParentingDashboardImage = ["note1"]
                push?.arrParentingDashboardId = ["001"]
                push?.matchTitleSelect = self.matchTitleSelect
                push?.matchTitleShowSelect = str1
                 push?.devesionIdCategory = dictevent["id_division"] as? String ?? ""
                self.navigationController?.pushViewController(push!, animated: true)
            }
            if str == "Assessing Your Skills"
            {
                
                let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ParentingDashbaordId") as? ParentingDashbaord
                push?.matchCategory = dictevent["id_module"] as? String ?? ""
                push?.matchSubCategory = dictevent["id_category"] as? String ?? ""
                push?.arrParentingDashboardTitle = ["Articles","Resource"]
                push?.arrParentingDashboardImage = ["note1","care"]
                push?.arrParentingDashboardId = ["001","012"]
                push?.matchTitleSelect = self.matchTitleSelect
                push?.matchTitleShowSelect = str1
                 push?.devesionIdCategory = dictevent["id_division"] as? String ?? ""
                self.navigationController?.pushViewController(push!, animated: true)
            }
            if str == "Cover Letters and Resumes"
            {
                
                let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ParentingDashbaordId") as? ParentingDashbaord
                push?.matchCategory = dictevent["id_module"] as? String ?? ""
                push?.matchSubCategory = dictevent["id_category"] as? String ?? ""
                push?.arrParentingDashboardTitle = ["Articles"]
                push?.arrParentingDashboardImage = ["note1"]
                push?.arrParentingDashboardId = ["001"]
                push?.matchTitleSelect = self.matchTitleSelect
                push?.matchTitleShowSelect = str1
                 push?.devesionIdCategory = dictevent["id_division"] as? String ?? ""
                self.navigationController?.pushViewController(push!, animated: true)
            }
            if str == "Networking and Interviews"
            {
                
                let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ParentingDashbaordId") as? ParentingDashbaord
                push?.matchCategory = dictevent["id_module"] as? String ?? ""
                push?.matchSubCategory = dictevent["id_category"] as? String ?? ""
                push?.arrParentingDashboardTitle = ["Articles"]
                push?.arrParentingDashboardImage = ["note1"]
                push?.matchTitleSelect = self.matchTitleSelect
                push?.arrParentingDashboardId = ["001"]
                 push?.devesionIdCategory = dictevent["id_division"] as? String ?? ""
                push?.matchTitleShowSelect = str1
                self.navigationController?.pushViewController(push!, animated: true)
            }
            if str == "Changing Careers"
            {
                
                let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ParentingDashbaordId") as? ParentingDashbaord
                push?.matchCategory = dictevent["id_module"] as? String ?? ""
                push?.matchSubCategory = dictevent["id_category"] as? String ?? ""
                push?.arrParentingDashboardTitle = ["Articles","Audio"]
                push?.arrParentingDashboardImage = ["note1","music1"]
                push?.arrParentingDashboardId = ["001","002"]
                push?.matchTitleSelect = self.matchTitleSelect
                push?.matchTitleShowSelect = str1
                 push?.devesionIdCategory = dictevent["id_division"] as? String ?? ""
                self.navigationController?.pushViewController(push!, animated: true)
            }
            if str == "Preparing for Retirement"
            {
                
                let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ParentingDashbaordId") as? ParentingDashbaord
                push?.matchCategory = dictevent["id_module"] as? String ?? ""
                push?.matchSubCategory = dictevent["id_category"] as? String ?? ""
                push?.arrParentingDashboardTitle = ["Articles","Online seminars","Resource"]
                push?.arrParentingDashboardImage = ["note1","study2","care"]
                push?.arrParentingDashboardId = ["001","030","012"]
                push?.matchTitleSelect = self.matchTitleSelect
                push?.matchTitleShowSelect = str1
                 push?.devesionIdCategory = dictevent["id_division"] as? String ?? ""
                self.navigationController?.pushViewController(push!, animated: true)
            }
            if str == "Relocating for Work"
            {
                
                let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ParentingDashbaordId") as? ParentingDashbaord
                push?.matchCategory = dictevent["id_module"] as? String ?? ""
                push?.matchSubCategory = dictevent["id_category"] as? String ?? ""
                push?.arrParentingDashboardTitle = ["Articles"]
                push?.arrParentingDashboardImage = ["note1"]
                push?.arrParentingDashboardId = ["001"]
                push?.matchTitleShowSelect = str1
                 push?.devesionIdCategory = dictevent["id_division"] as? String ?? ""
                push?.matchTitleSelect = self.matchTitleSelect
                self.navigationController?.pushViewController(push!, animated: true)
            }
            if str == "Understanding FMLA"
            {
                
                let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ParentingDashbaordId") as? ParentingDashbaord
                push?.matchCategory = dictevent["id_module"] as? String ?? ""
                push?.matchSubCategory = dictevent["id_category"] as? String ?? ""
                push?.arrParentingDashboardTitle = ["Articles"]
                push?.arrParentingDashboardImage = ["note1"]
                push?.arrParentingDashboardId = ["001"]
                push?.matchTitleShowSelect = str1
                 push?.devesionIdCategory = dictevent["id_division"] as? String ?? ""
                push?.matchTitleSelect = self.matchTitleSelect
                self.navigationController?.pushViewController(push!, animated: true)
            }
            if str == "Coping with Job Loss"
            {
                
                let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ParentingDashbaordId") as? ParentingDashbaord
                push?.matchCategory = dictevent["id_module"] as? String ?? ""
                push?.matchSubCategory = dictevent["id_category"] as? String ?? ""
                push?.arrParentingDashboardTitle = ["Articles","Audio","Resource"]
                push?.arrParentingDashboardImage = ["note1","music1","care"]
                push?.arrParentingDashboardId = ["001","002","012"]
                push?.matchTitleSelect = self.matchTitleSelect
                push?.matchTitleShowSelect = str1
                 push?.devesionIdCategory = dictevent["id_division"] as? String ?? ""
                self.navigationController?.pushViewController(push!, animated: true)
            }
            if str == "Managing Change"
            {
                let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ParentingDashbaordId") as? ParentingDashbaord
                push?.matchCategory = dictevent["id_module"] as? String ?? ""
                push?.matchSubCategory = dictevent["id_category"] as? String ?? ""
                push?.arrParentingDashboardTitle = ["Articles","Audio","Online seminars"]
                push?.arrParentingDashboardImage = ["note1","music1","study2"]
                push?.arrParentingDashboardId = ["001","002","030"]
                push?.matchTitleSelect = self.matchTitleSelect
                push?.matchTitleShowSelect = str1
                 push?.devesionIdCategory = dictevent["id_division"] as? String ?? ""
                self.navigationController?.pushViewController(push!, animated: true)
            }
            
        }
        if str1 == "Consumer Tips"
        {
            if str == "Buying or Leasing a Car"
            {
                let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ParentingDashbaordId") as? ParentingDashbaord
                push?.matchCategory = dictevent["id_module"] as? String ?? ""
                push?.matchSubCategory = dictevent["id_category"] as? String ?? ""
                push?.arrParentingDashboardTitle = ["Articles","Calculators","Legal Forms","Resources"]
                push?.arrParentingDashboardImage = ["note1","note2","note2","care"]
                push?.matchTitleSelect = self.matchTitleSelect
                push?.matchTitleShowSelect = str1
                 push?.devesionIdCategory = dictevent["id_division"] as? String ?? ""
                push?.arrParentingDashboardId = ["001","034","006","012"]
                self.navigationController?.pushViewController(push!, animated: true)
            }
            if str == "Buying Electronics"
            {
                let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ParentingDashbaordId") as? ParentingDashbaord
                push?.matchCategory = dictevent["id_module"] as? String ?? ""
                push?.matchSubCategory = dictevent["id_category"] as? String ?? ""
                push?.arrParentingDashboardTitle = ["Articles"]
                push?.arrParentingDashboardImage = ["note1"]
                push?.matchTitleSelect = self.matchTitleSelect
                push?.matchTitleShowSelect = str1
                 push?.devesionIdCategory = dictevent["id_division"] as? String ?? ""
                push?.arrParentingDashboardId = ["001"]
                self.navigationController?.pushViewController(push!, animated: true)
            }
            if str == "Car Care"
            {
                let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ParentingDashbaordId") as? ParentingDashbaord
                push?.matchCategory = dictevent["id_module"] as? String ?? ""
                push?.matchSubCategory = dictevent["id_category"] as? String ?? ""
                push?.arrParentingDashboardTitle = ["Articles","Legal Forms","Resources"]
                push?.arrParentingDashboardImage = ["note1","note2","care"]
                push?.arrParentingDashboardId = ["001","006","012"]
                push?.matchTitleSelect = self.matchTitleSelect
                 push?.devesionIdCategory = dictevent["id_division"] as? String ?? ""
                push?.matchTitleShowSelect = str1
                self.navigationController?.pushViewController(push!, animated: true)
            }
            if str == "Gasoline"
            {
                let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ParentingDashbaordId") as? ParentingDashbaord
                push?.matchCategory = dictevent["id_module"] as? String ?? ""
                push?.matchSubCategory = dictevent["id_category"] as? String ?? ""
                push?.arrParentingDashboardTitle = ["Articles","Resources"]
                push?.arrParentingDashboardImage = ["note1","care"]
                push?.arrParentingDashboardId = ["001","012"]
                push?.matchTitleSelect = self.matchTitleSelect
                 push?.devesionIdCategory = dictevent["id_division"] as? String ?? ""
                push?.matchTitleShowSelect = str1
                self.navigationController?.pushViewController(push!, animated: true)
            }
            if str == "Health, Fitness and Nutrition"
            {
                let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ParentingDashbaordId") as? ParentingDashbaord
                push?.matchCategory = dictevent["id_module"] as? String ?? ""
                push?.matchSubCategory = dictevent["id_category"] as? String ?? ""
                push?.arrParentingDashboardTitle = ["Articles","Resources"]
                push?.arrParentingDashboardImage = ["note1","care"]
                push?.arrParentingDashboardId = ["001","012"]
                 push?.devesionIdCategory = dictevent["id_division"] as? String ?? ""
                push?.matchTitleShowSelect = str1
                push?.matchTitleSelect = self.matchTitleSelect
                self.navigationController?.pushViewController(push!, animated: true)
            }
            if str == "Privacy"
            {
                let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ParentingDashbaordId") as? ParentingDashbaord
                push?.matchCategory = dictevent["id_module"] as? String ?? ""
                push?.matchSubCategory = dictevent["id_category"] as? String ?? ""
                push?.arrParentingDashboardTitle = ["Articles","Resources"]
                push?.arrParentingDashboardImage = ["note1","care"]
                 push?.devesionIdCategory = dictevent["id_division"] as? String ?? ""
                push?.arrParentingDashboardId = ["001","012"]
                push?.matchTitleSelect = self.matchTitleSelect
                push?.matchTitleShowSelect = str1
                self.navigationController?.pushViewController(push!, animated: true)
            }
            if str == "Saving on Energy Costs"
            {
                let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ParentingDashbaordId") as? ParentingDashbaord
                push?.matchCategory = dictevent["id_module"] as? String ?? ""
                push?.matchSubCategory = dictevent["id_category"] as? String ?? ""
                push?.arrParentingDashboardTitle = ["Articles","Legal Forms","Resources"]
                push?.arrParentingDashboardImage = ["note1","note2","care"]
                push?.arrParentingDashboardId = ["001","006","012"]
                 push?.devesionIdCategory = dictevent["id_division"] as? String ?? ""
                push?.matchTitleSelect = self.matchTitleSelect
                push?.matchTitleShowSelect = str1
                self.navigationController?.pushViewController(push!, animated: true)
            }
            if str == "Shopping Safety"
            {
                let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ParentingDashbaordId") as? ParentingDashbaord
                push?.matchCategory = dictevent["id_module"] as? String ?? ""
                push?.matchSubCategory = dictevent["id_category"] as? String ?? ""
                push?.arrParentingDashboardTitle = ["Articles","Legal Forms","Resources"]
                push?.arrParentingDashboardImage = ["note1","note2","care"]
                push?.arrParentingDashboardId = ["001","006","012"]
                 push?.devesionIdCategory = dictevent["id_division"] as? String ?? ""
                push?.matchTitleSelect = self.matchTitleSelect
                push?.matchTitleShowSelect = str1
                self.navigationController?.pushViewController(push!, animated: true)
            }
            if str == "Saving Time"
            {
                let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ParentingDashbaordId") as? ParentingDashbaord
                push?.matchCategory = dictevent["id_module"] as? String ?? ""
                push?.matchSubCategory = dictevent["id_category"] as? String ?? ""
                push?.arrParentingDashboardTitle = ["Articles","Legal Forms","Online Seminars"]
                push?.arrParentingDashboardImage = ["note1","note2","study2"]
                push?.arrParentingDashboardId = ["001","006","030"]
                 push?.devesionIdCategory = dictevent["id_division"] as? String ?? ""
                push?.matchTitleSelect = self.matchTitleSelect
                push?.matchTitleShowSelect = str1
                self.navigationController?.pushViewController(push!, animated: true)
            }
            if str == "Saving Money"
            {
                let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ParentingDashbaordId") as? ParentingDashbaord
                push?.matchCategory = dictevent["id_module"] as? String ?? ""
                push?.matchSubCategory = dictevent["id_category"] as? String ?? ""
                push?.arrParentingDashboardTitle = ["Articles","Calculators","Online Seminars","Resources"]
                push?.arrParentingDashboardImage = ["note1","note2","study2","care"]
                push?.arrParentingDashboardId = ["001","034","030","012"]
                 push?.devesionIdCategory = dictevent["id_division"] as? String ?? ""
                push?.matchTitleSelect = self.matchTitleSelect
                push?.matchTitleShowSelect = str1
                self.navigationController?.pushViewController(push!, animated: true)
            }
        }
        if str1 == "Home Improvement"
        {
            if str == "Hiring Help"
            {
                let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ParentingDashbaordId") as? ParentingDashbaord
                push?.matchCategory = dictevent["id_module"] as? String ?? ""
                push?.matchSubCategory = dictevent["id_category"] as? String ?? ""
                 push?.devesionIdCategory = dictevent["id_division"] as? String ?? ""
                push?.arrParentingDashboardTitle = ["Articles","Legal Forms","Resources"]
                push?.arrParentingDashboardImage = ["note1","note2","care"]
                push?.arrParentingDashboardId = ["001","006","012"]
                push?.matchTitleSelect = self.matchTitleSelect
                push?.matchTitleShowSelect = str1
                self.navigationController?.pushViewController(push!, animated: true)
            }
            if str == "Energy Efficiency"
            {
                let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ParentingDashbaordId") as? ParentingDashbaord
                push?.matchCategory = dictevent["id_module"] as? String ?? ""
                push?.matchSubCategory = dictevent["id_category"] as? String ?? ""
                push?.arrParentingDashboardTitle = ["Articles","Resources"]
                 push?.devesionIdCategory = dictevent["id_division"] as? String ?? ""
                push?.arrParentingDashboardImage = ["note1","care"]
                push?.arrParentingDashboardId = ["001","012"]
                push?.matchTitleSelect = self.matchTitleSelect
                push?.matchTitleShowSelect = str1
                self.navigationController?.pushViewController(push!, animated: true)
            }
            if str == "Everyday Tips"
            {
                let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ParentingDashbaordId") as? ParentingDashbaord
                push?.matchCategory = dictevent["id_module"] as? String ?? ""
                push?.matchSubCategory = dictevent["id_category"] as? String ?? ""
                 push?.devesionIdCategory = dictevent["id_division"] as? String ?? ""
                push?.arrParentingDashboardTitle = ["Articles","Online Seminars"]
                push?.arrParentingDashboardImage = ["note1","study2"]
                push?.arrParentingDashboardId = ["001","030"]
                push?.matchTitleSelect = self.matchTitleSelect
                push?.matchTitleShowSelect = str1
                self.navigationController?.pushViewController(push!, animated: true)
            }
        }
        if str1 == "Home Buying or Selling"
        {
            if str == "Home Sales Professionals"
            {
                let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ParentingDashbaordId") as? ParentingDashbaord
                push?.matchCategory = dictevent["id_module"] as? String ?? ""
                 push?.devesionIdCategory = dictevent["id_division"] as? String ?? ""
                push?.matchSubCategory = dictevent["id_category"] as? String ?? ""
                push?.arrParentingDashboardTitle = ["Articles"]
                push?.arrParentingDashboardImage = ["note1"]
                push?.arrParentingDashboardId = ["001"]
                push?.matchTitleSelect = self.matchTitleSelect
                push?.matchTitleShowSelect = str1
                self.navigationController?.pushViewController(push!, animated: true)
            }
            
            if str == "Home Buying and Selling Process"
            {
                let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ParentingDashbaordId") as? ParentingDashbaord
                push?.matchCategory = dictevent["id_module"] as? String ?? ""
                push?.matchSubCategory = dictevent["id_category"] as? String ?? ""
                push?.arrParentingDashboardTitle = ["Articles","Calculators","Online Seminars"]
                push?.arrParentingDashboardImage = ["note1","note2","study2"]
                 push?.devesionIdCategory = dictevent["id_division"] as? String ?? ""
                push?.arrParentingDashboardId = ["001","034","030"]
                push?.matchTitleSelect = self.matchTitleSelect
                push?.matchTitleShowSelect = str1
                self.navigationController?.pushViewController(push!, animated: true)
            }
            if str == "Home Buying Tips"
            {
                let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ParentingDashbaordId") as? ParentingDashbaord
                push?.matchCategory = dictevent["id_module"] as? String ?? ""
                push?.matchSubCategory = dictevent["id_category"] as? String ?? ""
                push?.arrParentingDashboardTitle = ["Articles","Calculators","Legal Forms","Online Seminars"]
                push?.arrParentingDashboardImage = ["note1","note2","note2","study2"]
                push?.matchTitleSelect = self.matchTitleSelect
                push?.matchTitleShowSelect = str1
                 push?.devesionIdCategory = dictevent["id_division"] as? String ?? ""
                push?.arrParentingDashboardId = ["001","034","006","030"]
                self.navigationController?.pushViewController(push!, animated: true)
            }
            if str == "Mortgage Information"
            {
                let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ParentingDashbaordId") as? ParentingDashbaord
                push?.matchCategory = dictevent["id_module"] as? String ?? ""
                push?.matchSubCategory = dictevent["id_category"] as? String ?? ""
                push?.arrParentingDashboardTitle = ["Articles","Calculators","Legal Forms"]
                push?.arrParentingDashboardImage = ["note1","note2","note2"]
                push?.matchTitleSelect = self.matchTitleSelect
                push?.arrParentingDashboardId = ["001","034","006"]
                 push?.devesionIdCategory = dictevent["id_division"] as? String ?? ""
                push?.matchTitleShowSelect = str1
                self.navigationController?.pushViewController(push!, animated: true)
            }
        }
        if str1 == "Moving"
        {
            if str == "Movers and Storage"
            {
                let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ParentingDashbaordId") as? ParentingDashbaord
                push?.matchCategory = dictevent["id_module"] as? String ?? ""
                push?.matchSubCategory = dictevent["id_category"] as? String ?? ""
                push?.arrParentingDashboardTitle = ["Articles"]
                 push?.devesionIdCategory = dictevent["id_division"] as? String ?? ""
                push?.matchTitleSelect = self.matchTitleSelect
                push?.arrParentingDashboardImage = ["note1"]
                push?.arrParentingDashboardId = ["001"]
                push?.matchTitleShowSelect = str1
                self.navigationController?.pushViewController(push!, animated: true)
            }
            if str == "Moving Tips"
            {
                let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ParentingDashbaordId") as? ParentingDashbaord
                push?.matchCategory = dictevent["id_module"] as? String ?? ""
                push?.matchSubCategory = dictevent["id_category"] as? String ?? ""
                push?.arrParentingDashboardTitle = ["Articles"]
                 push?.devesionIdCategory = dictevent["id_division"] as? String ?? ""
                push?.arrParentingDashboardImage = ["note1"]
                push?.matchTitleShowSelect = str1
                push?.matchTitleSelect = self.matchTitleSelect
                push?.arrParentingDashboardId = ["001"]
                self.navigationController?.pushViewController(push!, animated: true)
            }
            if str == "Renting and Leasing"
            {
                let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ParentingDashbaordId") as? ParentingDashbaord
                push?.matchCategory = dictevent["id_module"] as? String ?? ""
                push?.matchSubCategory = dictevent["id_category"] as? String ?? ""
                push?.arrParentingDashboardTitle = ["Articles","Legal Forms"]
                push?.arrParentingDashboardImage = ["note1","note2"]
                 push?.devesionIdCategory = dictevent["id_division"] as? String ?? ""
                push?.matchTitleShowSelect = str1
                push?.matchTitleSelect = self.matchTitleSelect
                push?.arrParentingDashboardId = ["001","006"]
                self.navigationController?.pushViewController(push!, animated: true)
            }
        }
        if str1 == "Financial"
        {
            if str == "Bankruptcy"
            {
                let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ParentingDashbaordId") as? ParentingDashbaord
                push?.matchCategory = dictevent["id_module"] as? String ?? ""
                push?.matchSubCategory = dictevent["id_category"] as? String ?? ""
                push?.arrParentingDashboardTitle = ["Articles","Legal Forms","Resources"]
                push?.arrParentingDashboardImage = ["note1","note2","care"]
                push?.arrParentingDashboardId = ["001","006","012"]
                 push?.devesionIdCategory = dictevent["id_division"] as? String ?? ""
                push?.matchTitleSelect = self.matchTitleSelect
                push?.matchTitleShowSelect = str1
                self.navigationController?.pushViewController(push!, animated: true)
            }
            if str == "Buying or Selling a Home"
            {
                let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ParentingDashbaordId") as? ParentingDashbaord
                push?.matchCategory = dictevent["id_module"] as? String ?? ""
                push?.matchSubCategory = dictevent["id_category"] as? String ?? ""
                push?.arrParentingDashboardTitle = ["Articles","Legal Forms","Resources"]
                push?.arrParentingDashboardImage = ["note1","note2","care"]
                push?.arrParentingDashboardId = ["001","006","012"]
                 push?.devesionIdCategory = dictevent["id_division"] as? String ?? ""
                push?.matchTitleSelect = self.matchTitleSelect
                push?.matchTitleShowSelect = str1
                self.navigationController?.pushViewController(push!, animated: true)
            }
            if str == "Financial Tips"
            {
                let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ParentingDashbaordId") as? ParentingDashbaord
                push?.matchCategory = dictevent["id_module"] as? String ?? ""
                push?.matchSubCategory = dictevent["id_category"] as? String ?? ""
                push?.arrParentingDashboardTitle = ["Articles","Calculators","Legal Forms","Handbooks","Online seminars","Provider search","Resources"]
                push?.matchTitleSelect = self.matchTitleSelect
                 push?.devesionIdCategory = dictevent["id_division"] as? String ?? ""
                push?.matchTitleShowSelect = str1
                push?.arrParentingDashboardImage = ["note1","note2","note2","Handbooks","study2","Provider","care"]
                push?.arrParentingDashboardId = ["001","034","006","004","030","007","012"]
                self.navigationController?.pushViewController(push!, animated: true)
            }
            if str == "Credit"
            {
                let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ParentingDashbaordId") as? ParentingDashbaord
                push?.matchCategory = dictevent["id_module"] as? String ?? ""
                push?.matchSubCategory = dictevent["id_category"] as? String ?? ""
                 push?.devesionIdCategory = dictevent["id_division"] as? String ?? ""
                push?.arrParentingDashboardTitle = ["Articles","Legal Forms","Handbooks","Online seminars","Resources"]
                push?.matchTitleSelect = self.matchTitleSelect
                push?.matchTitleShowSelect = str1
                push?.arrParentingDashboardImage = ["note1","note2","Handbooks","study2","care"]
                push?.arrParentingDashboardId = ["001","006","004","030","012"]
                self.navigationController?.pushViewController(push!, animated: true)
            }
            if str == "Estate Planning"
            {
                let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ParentingDashbaordId") as? ParentingDashbaord
                push?.matchCategory = dictevent["id_module"] as? String ?? ""
                push?.matchSubCategory = dictevent["id_category"] as? String ?? ""
                push?.arrParentingDashboardTitle = ["Articles","Audio","Legal Forms","Online seminars","Resources"]
                push?.matchTitleShowSelect = str1
                push?.matchTitleSelect = self.matchTitleSelect
                 push?.devesionIdCategory = dictevent["id_division"] as? String ?? ""
                push?.arrParentingDashboardImage = ["note1","music1","note2","study2","care"]
                push?.arrParentingDashboardId = ["001","002","006","030","012"]
                self.navigationController?.pushViewController(push!, animated: true)
            }
            if str == "Financial Assistance"
            {
                let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ParentingDashbaordId") as? ParentingDashbaord
                push?.matchCategory = dictevent["id_module"] as? String ?? ""
                push?.matchSubCategory = dictevent["id_category"] as? String ?? ""
                push?.arrParentingDashboardTitle = ["Articles","Resources"]
                push?.arrParentingDashboardImage = ["note1","care"]
                push?.arrParentingDashboardId = ["001","012"]
                 push?.devesionIdCategory = dictevent["id_division"] as? String ?? ""
                push?.matchTitleShowSelect = str1
                push?.matchTitleSelect = self.matchTitleSelect
                self.navigationController?.pushViewController(push!, animated: true)
            }
            if str == "Financial Planning"
            {
                let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ParentingDashbaordId") as? ParentingDashbaord
                push?.matchCategory = dictevent["id_module"] as? String ?? ""
                push?.matchSubCategory = dictevent["id_category"] as? String ?? ""
                push?.arrParentingDashboardTitle = ["Articles","Handbooks","Online seminars","Provider search","Resources"]
                push?.matchTitleShowSelect = str1
                 push?.devesionIdCategory = dictevent["id_division"] as? String ?? ""
                push?.arrParentingDashboardImage = ["note1","Handbooks","study2","Provider","care"]
                push?.arrParentingDashboardId = ["001","004","030","007","012"]
                push?.matchTitleSelect = self.matchTitleSelect
                self.navigationController?.pushViewController(push!, animated: true)
            }
            if str == "Insurance"
            {
                let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ParentingDashbaordId") as? ParentingDashbaord
                push?.matchCategory = dictevent["id_module"] as? String ?? ""
                push?.matchSubCategory = dictevent["id_category"] as? String ?? ""
                push?.arrParentingDashboardTitle = ["Articles","Audio","Legal Forms","Resources"]
                push?.matchTitleShowSelect = str1
                push?.arrParentingDashboardImage = ["note1","music1","note2","care"]
                push?.arrParentingDashboardId = ["001","002","006","012"]
                push?.matchTitleSelect = self.matchTitleSelect
                 push?.devesionIdCategory = dictevent["id_division"] as? String ?? ""
                self.navigationController?.pushViewController(push!, animated: true)
            }
            if str == "Mortgage Information"
            {
                let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ParentingDashbaordId") as? ParentingDashbaord
                push?.matchCategory = dictevent["id_module"] as? String ?? ""
                push?.matchSubCategory = dictevent["id_category"] as? String ?? ""
                push?.arrParentingDashboardTitle = ["Articles","Calculators","Legal Forms","Handbooks","Resources"]
                push?.matchTitleShowSelect = str1
                 push?.devesionIdCategory = dictevent["id_division"] as? String ?? ""
                push?.arrParentingDashboardImage = ["note1","note2","note2","Handbooks","care"]
                push?.arrParentingDashboardId = ["001","034","006","004","012"]
                push?.matchTitleSelect = self.matchTitleSelect
                self.navigationController?.pushViewController(push!, animated: true)
            }
            if str == "Saving and Investing for College"
            {
                let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ParentingDashbaordId") as? ParentingDashbaord
                push?.matchCategory = dictevent["id_module"] as? String ?? ""
                push?.matchSubCategory = dictevent["id_category"] as? String ?? ""
                push?.arrParentingDashboardTitle = ["Articles","Resources"]
                push?.arrParentingDashboardImage = ["note1","care"]
                push?.arrParentingDashboardId = ["001","012"]
                push?.matchTitleShowSelect = str1
                 push?.devesionIdCategory = dictevent["id_division"] as? String ?? ""
                push?.matchTitleSelect = self.matchTitleSelect
                self.navigationController?.pushViewController(push!, animated: true)
            }
            if str == "Saving and Investing for Home Ownership"
            {
                let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ParentingDashbaordId") as? ParentingDashbaord
                push?.matchCategory = dictevent["id_module"] as? String ?? ""
                push?.matchSubCategory = dictevent["id_category"] as? String ?? ""
                push?.arrParentingDashboardTitle = ["Articles","Calculators","Legal Forms","Resources"]
                push?.matchTitleShowSelect = str1
                 push?.devesionIdCategory = dictevent["id_division"] as? String ?? ""
                push?.arrParentingDashboardImage = ["note1","note2","note2","care"]
                push?.arrParentingDashboardId = ["001","034","006","012"]
                push?.matchTitleSelect = self.matchTitleSelect
                self.navigationController?.pushViewController(push!, animated: true)
            }
            if str == "Saving and Investing for Retirement"
            {
                let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ParentingDashbaordId") as? ParentingDashbaord
                push?.matchCategory = dictevent["id_module"] as? String ?? ""
                push?.matchSubCategory = dictevent["id_category"] as? String ?? ""
                push?.arrParentingDashboardTitle = ["Articles","Calculators","Online seminars","Resources"]
                push?.matchTitleShowSelect = str1
                push?.arrParentingDashboardImage = ["note1","note2","study2","care"]
                push?.arrParentingDashboardId = ["001","034","030","012"]
                push?.matchTitleSelect = self.matchTitleSelect
                 push?.devesionIdCategory = dictevent["id_division"] as? String ?? ""
                self.navigationController?.pushViewController(push!, animated: true)
            }
            if str == "Taxes"
            {
                let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ParentingDashbaordId") as? ParentingDashbaord
                push?.matchCategory = dictevent["id_module"] as? String ?? ""
                push?.matchSubCategory = dictevent["id_category"] as? String ?? ""
                push?.arrParentingDashboardTitle = ["Articles","Resources"]
                push?.arrParentingDashboardImage = ["note1","care"]
                push?.arrParentingDashboardId = ["001","012"]
                push?.matchTitleShowSelect = str1
                 push?.devesionIdCategory = dictevent["id_division"] as? String ?? ""
                push?.matchTitleSelect = self.matchTitleSelect
                self.navigationController?.pushViewController(push!, animated: true)
            }
            if str == "Loans"
            {
                let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ParentingDashbaordId") as? ParentingDashbaord
                push?.matchCategory = dictevent["id_module"] as? String ?? ""
                push?.matchSubCategory = dictevent["id_category"] as? String ?? ""
                push?.arrParentingDashboardTitle = ["Articles"]
                push?.arrParentingDashboardImage = ["note1"]
                push?.matchTitleShowSelect = str1
                push?.arrParentingDashboardId = ["001"]
                 push?.devesionIdCategory = dictevent["id_division"] as? String ?? ""
                push?.matchTitleSelect = self.matchTitleSelect
                self.navigationController?.pushViewController(push!, animated: true)
            }
            if str == "Budgeting"
            {
                let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ParentingDashbaordId") as? ParentingDashbaord
                push?.matchCategory = dictevent["id_module"] as? String ?? ""
                push?.matchSubCategory = dictevent["id_category"] as? String ?? ""
                push?.arrParentingDashboardTitle = ["Articles","Handbooks","Online seminars"]
                push?.arrParentingDashboardImage = ["note1","Handbooks","study2"]
                push?.arrParentingDashboardId = ["001","004","030"]
                 push?.devesionIdCategory = dictevent["id_division"] as? String ?? ""
                push?.matchTitleSelect = self.matchTitleSelect
                push?.matchTitleShowSelect = str1
                self.navigationController?.pushViewController(push!, animated: true)
            }
        }
        if str1 == "Go Green"
        {
            if str == "Eco Travel"
            {
                let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ParentingDashbaordId") as? ParentingDashbaord
                push?.matchCategory = dictevent["id_module"] as? String ?? ""
                push?.matchSubCategory = dictevent["id_category"] as? String ?? ""
                push?.arrParentingDashboardTitle = ["Articles"]
                push?.arrParentingDashboardImage = ["note1"]
                 push?.devesionIdCategory = dictevent["id_division"] as? String ?? ""
                push?.arrParentingDashboardId = ["001"]
                push?.matchTitleShowSelect = str1
                push?.matchTitleSelect = self.matchTitleSelect
                self.navigationController?.pushViewController(push!, animated: true)
            }
            if str == "Eco Volunteer"
            {
                let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ParentingDashbaordId") as? ParentingDashbaord
                push?.matchCategory = dictevent["id_module"] as? String ?? ""
                push?.matchSubCategory = dictevent["id_category"] as? String ?? ""
                push?.arrParentingDashboardTitle = ["Articles","Resources","Volunteer services"]
                push?.arrParentingDashboardImage = ["note1","care","Medecine"]
                push?.arrParentingDashboardId = ["001","012","018"]
                 push?.devesionIdCategory = dictevent["id_division"] as? String ?? ""
                push?.matchTitleSelect = self.matchTitleSelect
                push?.matchTitleShowSelect = str1
                self.navigationController?.pushViewController(push!, animated: true)
            }
            if str == "Home"
            {
                let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ParentingDashbaordId") as? ParentingDashbaord
                push?.matchCategory = dictevent["id_module"] as? String ?? ""
                push?.matchSubCategory = dictevent["id_category"] as? String ?? ""
                push?.arrParentingDashboardTitle = ["Articles","Resources"]
                push?.arrParentingDashboardImage = ["note1","care"]
                push?.arrParentingDashboardId = ["001","012"]
                 push?.devesionIdCategory = dictevent["id_division"] as? String ?? ""
                push?.matchTitleShowSelect = str1
                push?.matchTitleSelect = self.matchTitleSelect
                self.navigationController?.pushViewController(push!, animated: true)
            }
            if str == "Transportation"
            {
                let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ParentingDashbaordId") as? ParentingDashbaord
                push?.matchCategory = dictevent["id_module"] as? String ?? ""
                push?.matchSubCategory = dictevent["id_category"] as? String ?? ""
                push?.arrParentingDashboardTitle = ["Articles","Resources"]
                push?.arrParentingDashboardImage = ["note1","care"]
                push?.arrParentingDashboardId = ["001","012"]
                 push?.devesionIdCategory = dictevent["id_division"] as? String ?? ""
                push?.matchTitleShowSelect = str1
                push?.matchTitleSelect = self.matchTitleSelect
                self.navigationController?.pushViewController(push!, animated: true)
            }
            if str == "Workplace"
            {
                let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ParentingDashbaordId") as? ParentingDashbaord
                push?.matchCategory = dictevent["id_module"] as? String ?? ""
                push?.matchSubCategory = dictevent["id_category"] as? String ?? ""
                push?.arrParentingDashboardTitle = ["Articles","Resources"]
                push?.arrParentingDashboardImage = ["note1","care"]
                 push?.devesionIdCategory = dictevent["id_division"] as? String ?? ""
                push?.arrParentingDashboardId = ["001","012"]
                push?.matchTitleShowSelect = str1
                push?.matchTitleSelect = self.matchTitleSelect
                self.navigationController?.pushViewController(push!, animated: true)
            }
            if str == "Other Green Issues"
            {
                let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ParentingDashbaordId") as? ParentingDashbaord
                push?.matchCategory = dictevent["id_module"] as? String ?? ""
                push?.matchSubCategory = dictevent["id_category"] as? String ?? ""
                push?.arrParentingDashboardTitle = ["Articles","Resources"]
                push?.arrParentingDashboardImage = ["note1","care"]
                push?.arrParentingDashboardId = ["001","012"]
                 push?.devesionIdCategory = dictevent["id_division"] as? String ?? ""
                push?.matchTitleShowSelect = str1
                push?.matchTitleSelect = self.matchTitleSelect
                self.navigationController?.pushViewController(push!, animated: true)
            }
        }
        if str1 == "Fraud and Theft"
        {
            if str == "Credit Fraud and Theft"
            {
                let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ParentingDashbaordId") as? ParentingDashbaord
                push?.matchCategory = dictevent["id_module"] as? String ?? ""
                push?.matchSubCategory = dictevent["id_category"] as? String ?? ""
                push?.arrParentingDashboardTitle = ["Articles","Legal Forms","Resources"]
                push?.arrParentingDashboardImage = ["note1","note2","care"]
                push?.arrParentingDashboardId = ["001","006","012"]
                 push?.devesionIdCategory = dictevent["id_division"] as? String ?? ""
                push?.matchTitleShowSelect = str1
                push?.matchTitleSelect = self.matchTitleSelect
                self.navigationController?.pushViewController(push!, animated: true)
            }
            if str == "Identity Theft"
            {
                let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ParentingDashbaordId") as? ParentingDashbaord
                push?.matchCategory = dictevent["id_module"] as? String ?? ""
                push?.matchSubCategory = dictevent["id_category"] as? String ?? ""
                push?.arrParentingDashboardTitle = ["Articles","Legal Forms","Resources"]
                push?.arrParentingDashboardImage = ["note1","note2","care"]
                 push?.devesionIdCategory = dictevent["id_division"] as? String ?? ""
                push?.arrParentingDashboardId = ["001","006","012"]
                push?.matchTitleSelect = self.matchTitleSelect
                push?.matchTitleShowSelect = str1
                self.navigationController?.pushViewController(push!, animated: true)
            }
            if str == "Internet Fraud"
            {
                let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ParentingDashbaordId") as? ParentingDashbaord
                push?.matchCategory = dictevent["id_module"] as? String ?? ""
                push?.matchSubCategory = dictevent["id_category"] as? String ?? ""
                push?.arrParentingDashboardTitle = ["Articles","Legal Forms","Resources"]
                push?.arrParentingDashboardImage = ["note1","note2","care"]
                push?.arrParentingDashboardId = ["001","006","012"]
                 push?.devesionIdCategory = dictevent["id_division"] as? String ?? ""
                push?.matchTitleShowSelect = str1
                push?.matchTitleSelect = self.matchTitleSelect
                self.navigationController?.pushViewController(push!, animated: true)
            }
            if str == "Loan Fraud"
            {
                let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ParentingDashbaordId") as? ParentingDashbaord
                push?.matchCategory = dictevent["id_module"] as? String ?? ""
                push?.matchSubCategory = dictevent["id_category"] as? String ?? ""
                push?.arrParentingDashboardTitle = ["Articles"]
                push?.arrParentingDashboardImage = ["note1"]
                 push?.devesionIdCategory = dictevent["id_division"] as? String ?? ""
                push?.matchTitleShowSelect = str1
                push?.arrParentingDashboardId = ["001"]
                push?.matchTitleSelect = self.matchTitleSelect
                self.navigationController?.pushViewController(push!, animated: true)
            }
            if str == "Mail Fraud"
            {
                let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ParentingDashbaordId") as? ParentingDashbaord
                push?.matchCategory = dictevent["id_module"] as? String ?? ""
                push?.matchSubCategory = dictevent["id_category"] as? String ?? ""
                push?.arrParentingDashboardTitle = ["Articles","Resources"]
                push?.arrParentingDashboardImage = ["note1","care"]
                push?.arrParentingDashboardId = ["001","012"]
                push?.matchTitleSelect = self.matchTitleSelect
                 push?.devesionIdCategory = dictevent["id_division"] as? String ?? ""
                push?.matchTitleShowSelect = str1
                self.navigationController?.pushViewController(push!, animated: true)
            }
            
            if str == "Telephone Fraud"
            {
                let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ParentingDashbaordId") as? ParentingDashbaord
                push?.matchCategory = dictevent["id_module"] as? String ?? ""
                push?.matchSubCategory = dictevent["id_category"] as? String ?? ""
                push?.arrParentingDashboardTitle = ["Articles"]
                push?.arrParentingDashboardImage = ["note1"]
                push?.arrParentingDashboardId = ["001"]
                 push?.devesionIdCategory = dictevent["id_division"] as? String ?? ""
                push?.matchTitleShowSelect = str1
                push?.matchTitleSelect = self.matchTitleSelect
                self.navigationController?.pushViewController(push!, animated: true)
            }
            if str == "Other Scams and Fraud"
            {
                let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ParentingDashbaordId") as? ParentingDashbaord
                push?.matchCategory = dictevent["id_module"] as? String ?? ""
                push?.matchSubCategory = dictevent["id_category"] as? String ?? ""
                push?.arrParentingDashboardTitle = ["Articles","Resources"]
                push?.arrParentingDashboardImage = ["note1","care"]
                 push?.devesionIdCategory = dictevent["id_division"] as? String ?? ""
                push?.arrParentingDashboardId = ["001","012"]
                push?.matchTitleSelect = self.matchTitleSelect
                push?.matchTitleShowSelect = str1
                self.navigationController?.pushViewController(push!, animated: true)
            }
        }
        if str1 == "Travel and Leisure Time"
        {
            if str == "Air Travel"
            {
                let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ParentingDashbaordId") as? ParentingDashbaord
                push?.matchCategory = dictevent["id_module"] as? String ?? ""
                push?.matchSubCategory = dictevent["id_category"] as? String ?? ""
                push?.arrParentingDashboardTitle = ["Articles","Audio","Resources"]
                push?.arrParentingDashboardImage = ["note1","music1","care"]
                 push?.devesionIdCategory = dictevent["id_division"] as? String ?? ""
                push?.arrParentingDashboardId = ["001","002","012"]
                push?.matchTitleSelect = self.matchTitleSelect
                push?.matchTitleShowSelect = str1
                self.navigationController?.pushViewController(push!, animated: true)
            }
            if str == "Customs and  Courtesy"
            {
                let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ParentingDashbaordId") as? ParentingDashbaord
                push?.matchCategory = dictevent["id_module"] as? String ?? ""
                push?.matchSubCategory = dictevent["id_category"] as? String ?? ""
                push?.arrParentingDashboardTitle = ["Articles"]
                push?.arrParentingDashboardImage = ["note1"]
                push?.arrParentingDashboardId = ["001"]
                 push?.devesionIdCategory = dictevent["id_division"] as? String ?? ""
                push?.matchTitleShowSelect = str1
                push?.matchTitleSelect = self.matchTitleSelect
                self.navigationController?.pushViewController(push!, animated: true)
            }
            if str == "Disability Travel Resources"
            {
                let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ParentingDashbaordId") as? ParentingDashbaord
                push?.matchCategory = dictevent["id_module"] as? String ?? ""
                push?.matchSubCategory = dictevent["id_category"] as? String ?? ""
                push?.arrParentingDashboardTitle = ["Resources"]
                 push?.devesionIdCategory = dictevent["id_division"] as? String ?? ""
                push?.arrParentingDashboardImage = ["care"]
                push?.arrParentingDashboardId = ["012"]
                push?.matchTitleShowSelect = str1
                push?.matchTitleSelect = self.matchTitleSelect
                self.navigationController?.pushViewController(push!, animated: true)
            }
            if str == "Family Fun"
            {
                let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ParentingDashbaordId") as? ParentingDashbaord
                push?.matchCategory = dictevent["id_module"] as? String ?? ""
                push?.matchSubCategory = dictevent["id_category"] as? String ?? ""
                push?.arrParentingDashboardTitle = ["Articles","Online seminars","Resources"]
                push?.arrParentingDashboardImage = ["note1","study2","care"]
                 push?.devesionIdCategory = dictevent["id_division"] as? String ?? ""
                push?.arrParentingDashboardId = ["001","030","012"]
                push?.matchTitleShowSelect = str1
                push?.matchTitleSelect = self.matchTitleSelect
                self.navigationController?.pushViewController(push!, animated: true)
            }
            if str == "Hobbies"
            {
                let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ParentingDashbaordId") as? ParentingDashbaord
                push?.matchCategory = dictevent["id_module"] as? String ?? ""
                push?.matchSubCategory = dictevent["id_category"] as? String ?? ""
                push?.arrParentingDashboardTitle = ["Articles","Online seminars","Resources"]
                push?.arrParentingDashboardImage = ["note1","study2","care"]
                 push?.devesionIdCategory = dictevent["id_division"] as? String ?? ""
                push?.arrParentingDashboardId = ["001","030","012"]
                push?.matchTitleShowSelect = str1
                push?.matchTitleSelect = self.matchTitleSelect
                self.navigationController?.pushViewController(push!, animated: true)
            }
            if str == "International Travel"
            {
                let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ParentingDashbaordId") as? ParentingDashbaord
                push?.matchCategory = dictevent["id_module"] as? String ?? ""
                push?.matchSubCategory = dictevent["id_category"] as? String ?? ""
                push?.arrParentingDashboardTitle = ["Articles","Audio","Legal Forms","Resources"]
                push?.arrParentingDashboardImage = ["note1","music1","note2","care"]
                 push?.devesionIdCategory = dictevent["id_division"] as? String ?? ""
                push?.arrParentingDashboardId = ["001","002","006","012"]
                push?.matchTitleSelect = self.matchTitleSelect
                push?.matchTitleShowSelect = str1
                self.navigationController?.pushViewController(push!, animated: true)
            }
            if str == "Learning at Any Age"
            {
                let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ParentingDashbaordId") as? ParentingDashbaord
                push?.matchCategory = dictevent["id_module"] as? String ?? ""
                push?.matchSubCategory = dictevent["id_category"] as? String ?? ""
                push?.arrParentingDashboardTitle = ["Articles","Resources"]
                push?.arrParentingDashboardImage = ["note1","care"]
                 push?.devesionIdCategory = dictevent["id_division"] as? String ?? ""
                push?.arrParentingDashboardId = ["001","012"]
                push?.matchTitleSelect = self.matchTitleSelect
                push?.matchTitleShowSelect = str1
                self.navigationController?.pushViewController(push!, animated: true)
            }
            if str == "Mentor or Volunteer"
            {
                let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ParentingDashbaordId") as? ParentingDashbaord
                push?.matchCategory = dictevent["id_module"] as? String ?? ""
                push?.matchSubCategory = dictevent["id_category"] as? String ?? ""
                push?.arrParentingDashboardTitle = ["Articles","Resources","Volunteer Services"]
                push?.arrParentingDashboardImage = ["note1","care","Medecine"]
                push?.arrParentingDashboardId = ["001","012","018"]
                 push?.devesionIdCategory = dictevent["id_division"] as? String ?? ""
                push?.matchTitleSelect = self.matchTitleSelect
                push?.matchTitleShowSelect = str1
                self.navigationController?.pushViewController(push!, animated: true)
            }
            if str == "Recreation"
            {
                let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ParentingDashbaordId") as? ParentingDashbaord
                push?.matchCategory = dictevent["id_module"] as? String ?? ""
                push?.matchSubCategory = dictevent["id_category"] as? String ?? ""
                push?.arrParentingDashboardTitle = ["Articles","Online seminars","Resources"]
                push?.arrParentingDashboardImage = ["note1","study2","care"]
                push?.arrParentingDashboardId = ["001","030","012"]
                 push?.devesionIdCategory = dictevent["id_division"] as? String ?? ""
                push?.matchTitleSelect = self.matchTitleSelect
                push?.matchTitleShowSelect = str1
                self.navigationController?.pushViewController(push!, animated: true)
            }
            if str == "Traveling with Children"
            {
                let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ParentingDashbaordId") as? ParentingDashbaord
                push?.matchCategory = dictevent["id_module"] as? String ?? ""
                push?.matchSubCategory = dictevent["id_category"] as? String ?? ""
                push?.arrParentingDashboardTitle = ["Articles","Online seminars","Resources"]
                push?.arrParentingDashboardImage = ["note1","study2","care"]
                push?.arrParentingDashboardId = ["001","030","012"]
                 push?.devesionIdCategory = dictevent["id_division"] as? String ?? ""
                push?.matchTitleShowSelect = str1
                push?.matchTitleSelect = self.matchTitleSelect
                self.navigationController?.pushViewController(push!, animated: true)
            }
            if str == "Traveling with Pets"
            {
                let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ParentingDashbaordId") as? ParentingDashbaord
                push?.matchCategory = dictevent["id_module"] as? String ?? ""
                push?.matchSubCategory = dictevent["id_category"] as? String ?? ""
                push?.arrParentingDashboardTitle = ["Articles"]
                 push?.devesionIdCategory = dictevent["id_division"] as? String ?? ""
                push?.arrParentingDashboardImage = ["note1"]
                push?.arrParentingDashboardId = ["001"]
                push?.matchTitleShowSelect = str1
                push?.matchTitleSelect = self.matchTitleSelect
                self.navigationController?.pushViewController(push!, animated: true)
            }
            if str == "Travel Safety"
            {
                let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ParentingDashbaordId") as? ParentingDashbaord
                push?.matchCategory = dictevent["id_module"] as? String ?? ""
                push?.matchSubCategory = dictevent["id_category"] as? String ?? ""
                push?.arrParentingDashboardTitle = ["Articles","Audio","Resources"]
                push?.arrParentingDashboardImage = ["note1","music1","care"]
                 push?.devesionIdCategory = dictevent["id_division"] as? String ?? ""
                push?.arrParentingDashboardId = ["001","002","012"]
                push?.matchTitleSelect = self.matchTitleSelect
                push?.matchTitleShowSelect = str1
                self.navigationController?.pushViewController(push!, animated: true)
            }
            if str == "More Travel and Leisure Tips"
            {
                let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ParentingDashbaordId") as? ParentingDashbaord
                push?.matchCategory = dictevent["id_module"] as? String ?? ""
                push?.matchSubCategory = dictevent["id_category"] as? String ?? ""
                push?.arrParentingDashboardTitle = ["Articles","Online seminars","Resources"]
                push?.arrParentingDashboardImage = ["note1","study2","care"]
                 push?.devesionIdCategory = dictevent["id_division"] as? String ?? ""
                push?.arrParentingDashboardId = ["001","030","012"]
                push?.matchTitleSelect = self.matchTitleSelect
                push?.matchTitleShowSelect = str1
                self.navigationController?.pushViewController(push!, animated: true)
            }
        }
        if str1 == "Pets"
        {
            if str == "Adoption and Selection"
            {
                let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ParentingDashbaordId") as? ParentingDashbaord
                push?.matchCategory = dictevent["id_module"] as? String ?? ""
                push?.matchSubCategory = dictevent["id_category"] as? String ?? ""
                push?.arrParentingDashboardTitle = ["Articles","Legal Forms","Handbooks","Provider search","Resources"]
                push?.arrParentingDashboardImage = ["note1","note2","Handbooks","Provider","care"]
                push?.arrParentingDashboardId = ["001","006","004","007","012"]
                 push?.devesionIdCategory = dictevent["id_division"] as? String ?? ""
                push?.matchTitleSelect = self.matchTitleSelect
                push?.matchTitleShowSelect = str1
                self.navigationController?.pushViewController(push!, animated: true)
            }
            if str == "Being an Advocate"
            {
                let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ParentingDashbaordId") as? ParentingDashbaord
                push?.matchCategory = dictevent["id_module"] as? String ?? ""
                push?.matchSubCategory = dictevent["id_category"] as? String ?? ""
                push?.arrParentingDashboardTitle = ["Articles","Handbooks","Resources"]
                push?.arrParentingDashboardImage = ["note1","Handbooks","care"]
                 push?.devesionIdCategory = dictevent["id_division"] as? String ?? ""
                push?.arrParentingDashboardId = ["001","004","012"]
                push?.matchTitleSelect = self.matchTitleSelect
                push?.matchTitleShowSelect = str1
                self.navigationController?.pushViewController(push!, animated: true)
            }
            if str == "Caring for Pets"
            {
                let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ParentingDashbaordId") as? ParentingDashbaord
                push?.matchCategory = dictevent["id_module"] as? String ?? ""
                push?.matchSubCategory = dictevent["id_category"] as? String ?? ""
                push?.arrParentingDashboardTitle = ["Articles","Handbooks","Resources"]
                push?.arrParentingDashboardImage = ["note1","Handbooks","care"]
                 push?.devesionIdCategory = dictevent["id_division"] as? String ?? ""
                push?.arrParentingDashboardId = ["001","004","012"]
                push?.matchTitleSelect = self.matchTitleSelect
                push?.matchTitleShowSelect = str1
                self.navigationController?.pushViewController(push!, animated: true)
            }
            if str == "Encouraging Good Behavior"
            {
                let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ParentingDashbaordId") as? ParentingDashbaord
                push?.matchCategory = dictevent["id_module"] as? String ?? ""
                push?.matchSubCategory = dictevent["id_category"] as? String ?? ""
                push?.arrParentingDashboardTitle = ["Articles","Handbooks","Resources"]
                push?.arrParentingDashboardImage = ["note1","Handbooks","care"]
                push?.arrParentingDashboardId = ["001","004","012"]
                push?.matchTitleSelect = self.matchTitleSelect
                push?.matchTitleShowSelect = str1
                push?.devesionIdCategory = dictevent["id_division"] as? String ?? ""
                           
                self.navigationController?.pushViewController(push!, animated: true)
            }
            if str == "Nutrition"
            {
                let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ParentingDashbaordId") as? ParentingDashbaord
                push?.matchCategory = dictevent["id_module"] as? String ?? ""
                push?.matchSubCategory = dictevent["id_category"] as? String ?? ""
                push?.arrParentingDashboardTitle = ["Articles","Handbooks","Resources"]
                push?.arrParentingDashboardImage = ["note1","Handbooks","care"]
                push?.arrParentingDashboardId = ["001","004","012"]
                push?.matchTitleSelect = self.matchTitleSelect
                push?.matchTitleShowSelect = str1
                push?.devesionIdCategory = dictevent["id_division"] as? String ?? ""
                           
                self.navigationController?.pushViewController(push!, animated: true)
            }
            if str == "Pet Sitters"
            {
                let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ParentingDashbaordId") as? ParentingDashbaord
                push?.matchCategory = dictevent["id_module"] as? String ?? ""
                push?.matchSubCategory = dictevent["id_category"] as? String ?? ""
                push?.arrParentingDashboardTitle = ["Articles","Legal Forms","Handbooks","Provider search","Resources"]
                push?.arrParentingDashboardImage = ["note1","note2","Handbooks","Provider","care"]
                push?.arrParentingDashboardId = ["001","006","004","007","012"]
                push?.matchTitleSelect = self.matchTitleSelect
                push?.matchTitleShowSelect = str1
                push?.devesionIdCategory = dictevent["id_division"] as? String ?? ""
                           
                self.navigationController?.pushViewController(push!, animated: true)
            }
            if str == "Pet Transportation"
            {
                let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ParentingDashbaordId") as? ParentingDashbaord
                push?.matchCategory = dictevent["id_module"] as? String ?? ""
                push?.matchSubCategory = dictevent["id_category"] as? String ?? ""
                push?.arrParentingDashboardTitle = ["Articles","Handbooks","Resources"]
                push?.arrParentingDashboardImage = ["note1","Handbooks","care"]
                push?.arrParentingDashboardId = ["001","004","012"]
                push?.matchTitleSelect = self.matchTitleSelect
                push?.devesionIdCategory = dictevent["id_division"] as? String ?? ""
                           
                push?.matchTitleShowSelect = str1
                self.navigationController?.pushViewController(push!, animated: true)
            }
            if str == "Safety"
            {
                let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ParentingDashbaordId") as? ParentingDashbaord
                push?.matchCategory = dictevent["id_module"] as? String ?? ""
                push?.matchSubCategory = dictevent["id_category"] as? String ?? ""
                push?.arrParentingDashboardTitle = ["Articles","Checklists","Handbooks","Resources"]
                push?.arrParentingDashboardImage = ["note1","checklists","Handbooks","care"]
                push?.arrParentingDashboardId = ["001","003","004","012"]
                push?.matchTitleSelect = self.matchTitleSelect
                push?.devesionIdCategory = dictevent["id_division"] as? String ?? ""
                           
                push?.matchTitleShowSelect = str1
                self.navigationController?.pushViewController(push!, animated: true)
            }
        }
        if str1 == "Safety"
        {
            if str == "Car Safety"
            {
                let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ParentingDashbaordId") as? ParentingDashbaord
                push?.matchCategory = dictevent["id_module"] as? String ?? ""
                push?.matchSubCategory = dictevent["id_category"] as? String ?? ""
                push?.arrParentingDashboardTitle = ["Articles","Audio","Resources"]
                push?.arrParentingDashboardImage = ["note1","music1","care"]
                push?.arrParentingDashboardId = ["001","002","012"]
                push?.devesionIdCategory = dictevent["id_division"] as? String ?? ""
                push?.matchTitleSelect = self.matchTitleSelect
                push?.matchTitleShowSelect = str1
                self.navigationController?.pushViewController(push!, animated: true)
            }
            if str == "Child Safety"
            {
                let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ParentingDashbaordId") as? ParentingDashbaord
                push?.matchCategory = dictevent["id_module"] as? String ?? ""
                push?.matchSubCategory = dictevent["id_category"] as? String ?? ""
                push?.arrParentingDashboardTitle = ["Articles","Audio","Onilne Seminars","Resources"]
                push?.arrParentingDashboardImage = ["note1","music1","study2","care"]
                push?.arrParentingDashboardId = ["001","002","030","012"]
                push?.matchTitleSelect = self.matchTitleSelect
                push?.devesionIdCategory = dictevent["id_division"] as? String ?? ""
                           
                push?.matchTitleShowSelect = str1
                self.navigationController?.pushViewController(push!, animated: true)
            }
            if str == "Home Safety"
            {
                let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ParentingDashbaordId") as? ParentingDashbaord
                push?.matchCategory = dictevent["id_module"] as? String ?? ""
                push?.matchSubCategory = dictevent["id_category"] as? String ?? ""
                push?.arrParentingDashboardTitle = ["Articles","Audio","Onilne Seminars","Resources"]
                push?.arrParentingDashboardImage = ["note1","music1","study2","care"]
                push?.arrParentingDashboardId = ["001","002","030","012"]
                push?.matchTitleSelect = self.matchTitleSelect
                push?.devesionIdCategory = dictevent["id_division"] as? String ?? ""
                           
                push?.matchTitleShowSelect = str1
                self.navigationController?.pushViewController(push!, animated: true)
            }
            if str == "Personal Safety"
            {
                let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ParentingDashbaordId") as? ParentingDashbaord
                push?.matchCategory = dictevent["id_module"] as? String ?? ""
                push?.matchSubCategory = dictevent["id_category"] as? String ?? ""
                push?.arrParentingDashboardTitle = ["Articles","Audio","Frequently Asked Questions","Onilne Seminars","Resources","Video"]
                push?.devesionIdCategory = dictevent["id_division"] as? String ?? ""
                           
                push?.arrParentingDashboardImage = ["note1","music1","faq","study2","care","Videos"]
                push?.matchTitleShowSelect = str1
                push?.arrParentingDashboardId = ["001","002","013","030","012","045"]
                push?.matchTitleSelect = self.matchTitleSelect
                self.navigationController?.pushViewController(push!, animated: true)
            }
            if str == "School and College Safety"
            {
                let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ParentingDashbaordId") as? ParentingDashbaord
                push?.matchCategory = dictevent["id_module"] as? String ?? ""
                push?.matchSubCategory = dictevent["id_category"] as? String ?? ""
                push?.arrParentingDashboardTitle = ["Articles","Onilne Seminars","Resources"]
                push?.arrParentingDashboardImage = ["note1","study2","care"]
                push?.arrParentingDashboardId = ["001","030","012"]
                push?.devesionIdCategory = dictevent["id_division"] as? String ?? ""
                push?.matchTitleSelect = self.matchTitleSelect
                push?.matchTitleShowSelect = str1
                self.navigationController?.pushViewController(push!, animated: true)
            }
            if str == "Travel Safety"
            {
                let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ParentingDashbaordId") as? ParentingDashbaord
                push?.matchCategory = dictevent["id_module"] as? String ?? ""
                push?.matchSubCategory = dictevent["id_category"] as? String ?? ""
                push?.arrParentingDashboardTitle = ["Articles","Frequently Asked Questions","Resources"]
                push?.arrParentingDashboardImage = ["note1","faq","care"]
                push?.arrParentingDashboardId = ["001","013","012"]
                push?.matchTitleSelect = self.matchTitleSelect
                push?.devesionIdCategory = dictevent["id_division"] as? String ?? ""
                push?.matchTitleShowSelect = str1
                self.navigationController?.pushViewController(push!, animated: true)
            }
            if str == "Work Safety"
            {
                let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ParentingDashbaordId") as? ParentingDashbaord
                push?.matchCategory = dictevent["id_module"] as? String ?? ""
                push?.matchSubCategory = dictevent["id_category"] as? String ?? ""
                push?.arrParentingDashboardTitle = ["Articles","Onilne Seminars"]
                push?.arrParentingDashboardImage = ["note1","study2"]
                push?.arrParentingDashboardId = ["001","030"]
                push?.matchTitleSelect = self.matchTitleSelect
                push?.devesionIdCategory = dictevent["id_division"] as? String ?? ""
                push?.matchTitleShowSelect = str1
                self.navigationController?.pushViewController(push!, animated: true)
            }
            if str == "Abuse - Child"
            {
                let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ParentingDashbaordId") as? ParentingDashbaord
                push?.matchCategory = dictevent["id_module"] as? String ?? ""
                push?.matchSubCategory = dictevent["id_category"] as? String ?? ""
                push?.arrParentingDashboardTitle = ["Articles","Resources"]
                push?.arrParentingDashboardImage = ["note1","care"]
                push?.arrParentingDashboardId = ["001","012"]
                push?.matchTitleSelect = self.matchTitleSelect
                push?.devesionIdCategory = dictevent["id_division"] as? String ?? ""
                push?.matchTitleShowSelect = str1
                self.navigationController?.pushViewController(push!, animated: true)
            }
            if str == "Abuse - Dating"
            {
                let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ParentingDashbaordId") as? ParentingDashbaord
                push?.matchCategory = dictevent["id_module"] as? String ?? ""
                push?.matchSubCategory = dictevent["id_category"] as? String ?? ""
                push?.arrParentingDashboardTitle = ["Articles","Resources"]
                push?.arrParentingDashboardImage = ["note1","care"]
                push?.arrParentingDashboardId = ["001","012"]
                push?.matchTitleSelect = self.matchTitleSelect
                push?.devesionIdCategory = dictevent["id_division"] as? String ?? ""
                push?.matchTitleShowSelect = str1
                self.navigationController?.pushViewController(push!, animated: true)
            }
            if str == "Abuse - Domestic"
            {
                let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ParentingDashbaordId") as? ParentingDashbaord
                push?.matchCategory = dictevent["id_module"] as? String ?? ""
                push?.matchSubCategory = dictevent["id_category"] as? String ?? ""
                push?.arrParentingDashboardTitle = ["Articles","Resources"]
                push?.arrParentingDashboardImage = ["note1","care"]
                push?.matchTitleSelect = self.matchTitleSelect
                push?.devesionIdCategory = dictevent["id_division"] as? String ?? ""
                push?.arrParentingDashboardId = ["001","012"]
                push?.matchTitleShowSelect = str1
                self.navigationController?.pushViewController(push!, animated: true)
            }
            if str == "Abuse - Elder"
            {
                let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ParentingDashbaordId") as? ParentingDashbaord
                push?.matchCategory = dictevent["id_module"] as? String ?? ""
                push?.matchSubCategory = dictevent["id_category"] as? String ?? ""
                push?.arrParentingDashboardTitle = ["Articles","Resources"]
                push?.arrParentingDashboardImage = ["note1","care"]
                push?.matchTitleSelect = self.matchTitleSelect
                push?.devesionIdCategory = dictevent["id_division"] as? String ?? ""
                push?.arrParentingDashboardId = ["001","012"]
                push?.matchTitleShowSelect = str1
                self.navigationController?.pushViewController(push!, animated: true)
            }
            if str == "Bullying"
            {
                let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ParentingDashbaordId") as? ParentingDashbaord
                push?.matchCategory = dictevent["id_module"] as? String ?? ""
                push?.matchSubCategory = dictevent["id_category"] as? String ?? ""
                push?.arrParentingDashboardTitle = ["Articles","Onilne Seminars","Resources"]
                push?.arrParentingDashboardImage = ["note1","study2","care"]
                push?.arrParentingDashboardId = ["001","030","012"]
                push?.matchTitleSelect = self.matchTitleSelect
                push?.devesionIdCategory = dictevent["id_division"] as? String ?? ""
                push?.matchTitleShowSelect = str1
                self.navigationController?.pushViewController(push!, animated: true)
            }
            if str == "Disaster Preparedness and Response"
            {
                let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ParentingDashbaordId") as? ParentingDashbaord
                push?.matchCategory = dictevent["id_module"] as? String ?? ""
                push?.matchSubCategory = dictevent["id_category"] as? String ?? ""
                push?.arrParentingDashboardTitle = ["Articles","Checklists","Frequently Asked Questions","Handbooks","Onilne Seminars","Resources"]
                push?.arrParentingDashboardImage = ["note1","checklists","faq","Handbooks","study2","care"]
                push?.arrParentingDashboardId = ["001","024","013","004","030","012"]
                push?.matchTitleSelect = self.matchTitleSelect
                push?.matchTitleShowSelect = str1
                push?.devesionIdCategory = dictevent["id_division"] as? String ?? ""
                self.navigationController?.pushViewController(push!, animated: true)
            }
            if str == "Terrorism and Violence"
            {
                let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ParentingDashbaordId") as? ParentingDashbaord
                push?.matchCategory = dictevent["id_module"] as? String ?? ""
                push?.matchSubCategory = dictevent["id_category"] as? String ?? ""
                push?.arrParentingDashboardTitle = ["Articles","Onilne Seminars","Resources"]
                push?.arrParentingDashboardImage = ["note1","study2","care"]
                push?.arrParentingDashboardId = ["001","030","012"]
                push?.matchTitleSelect = self.matchTitleSelect
                push?.devesionIdCategory = dictevent["id_division"] as? String ?? ""
                push?.matchTitleShowSelect = str1
                self.navigationController?.pushViewController(push!, animated: true)
            }
        }
        if str1 == "Errands Online"
        {
            if str == "Address Change and Mail Service"
            {
                let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ParentingDashbaordId") as? ParentingDashbaord
                push?.matchCategory = dictevent["id_module"] as? String ?? ""
                push?.matchSubCategory = dictevent["id_category"] as? String ?? ""
                push?.arrParentingDashboardTitle = ["Resources"]
                push?.arrParentingDashboardImage = ["care"]
                push?.arrParentingDashboardId = ["012"]
                push?.matchTitleShowSelect = str1
                push?.matchTitleSelect = self.matchTitleSelect
                push?.devesionIdCategory = dictevent["id_division"] as? String ?? ""
                self.navigationController?.pushViewController(push!, animated: true)
            }
            if str == "Banking"
            {
                let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ParentingDashbaordId") as? ParentingDashbaord
                push?.matchCategory = dictevent["id_module"] as? String ?? ""
                push?.matchSubCategory = dictevent["id_category"] as? String ?? ""
                push?.arrParentingDashboardTitle = ["Resources"]
                push?.arrParentingDashboardImage = ["care"]
                push?.arrParentingDashboardId = ["012"]
                push?.matchTitleShowSelect = str1
                push?.matchTitleSelect = self.matchTitleSelect
                push?.devesionIdCategory = dictevent["id_division"] as? String ?? ""
                self.navigationController?.pushViewController(push!, animated: true)
            }
            if str == "Government Agencies"
            {
                let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ParentingDashbaordId") as? ParentingDashbaord
                push?.matchCategory = dictevent["id_module"] as? String ?? ""
                push?.matchSubCategory = dictevent["id_category"] as? String ?? ""
                push?.arrParentingDashboardTitle = ["Resources"]
                push?.devesionIdCategory = dictevent["id_division"] as? String ?? ""
                push?.arrParentingDashboardImage = ["care"]
                push?.arrParentingDashboardId = ["012"]
                push?.matchTitleShowSelect = str1
                push?.matchTitleSelect = self.matchTitleSelect
                self.navigationController?.pushViewController(push!, animated: true)
            }
            if str == "Socializing and Recreation"
            {
                let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ParentingDashbaordId") as? ParentingDashbaord
                push?.matchCategory = dictevent["id_module"] as? String ?? ""
                push?.matchSubCategory = dictevent["id_category"] as? String ?? ""
                push?.arrParentingDashboardTitle = ["Resources"]
                push?.arrParentingDashboardImage = ["care"]
                push?.devesionIdCategory = dictevent["id_division"] as? String ?? ""
                push?.arrParentingDashboardId = ["012"]
                push?.matchTitleShowSelect = str1
                push?.matchTitleSelect = self.matchTitleSelect
                self.navigationController?.pushViewController(push!, animated: true)
            }
            if str == "Other Online Errands Helpers"
            {
                let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ParentingDashbaordId") as? ParentingDashbaord
                push?.matchCategory = dictevent["id_module"] as? String ?? ""
                push?.matchSubCategory = dictevent["id_category"] as? String ?? ""
                push?.arrParentingDashboardTitle = ["Resources"]
                push?.arrParentingDashboardImage = ["care"]
                push?.devesionIdCategory = dictevent["id_division"] as? String ?? ""
                push?.arrParentingDashboardId = ["012"]
                push?.matchTitleShowSelect = str1
                push?.matchTitleSelect = self.matchTitleSelect
                self.navigationController?.pushViewController(push!, animated: true)
            }
            if str == "Voter Information"
            {
                let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ParentingDashbaordId") as? ParentingDashbaord
                push?.matchCategory = dictevent["id_module"] as? String ?? ""
                push?.matchSubCategory = dictevent["id_category"] as? String ?? ""
                push?.arrParentingDashboardTitle = ["Resources"]
                push?.devesionIdCategory = dictevent["id_division"] as? String ?? ""
                push?.arrParentingDashboardImage = ["care"]
                push?.arrParentingDashboardId = ["012"]
                push?.matchTitleShowSelect = str1
                push?.matchTitleSelect = self.matchTitleSelect
                self.navigationController?.pushViewController(push!, animated: true)
            }
        }
        if str1 == "Legal Forms"
        {
            if str == "Personal Finance"
            {
                let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ParentingDashbaordId") as? ParentingDashbaord
                push?.matchCategory = dictevent["id_module"] as? String ?? ""
                push?.matchSubCategory = dictevent["id_category"] as? String ?? ""
                push?.arrParentingDashboardTitle = ["Legal Forms","Resources"]
                push?.arrParentingDashboardImage = ["note2","care"]
                push?.devesionIdCategory = dictevent["id_division"] as? String ?? ""
                push?.arrParentingDashboardId = ["006","012"]
                push?.matchTitleShowSelect = str1
                push?.matchTitleSelect = self.matchTitleSelect
                self.navigationController?.pushViewController(push!, animated: true)
            }
            
        }
        if str1 == "Legal"
        {
            if str == "Criminal Law"
            {
                let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ParentingDashbaordId") as? ParentingDashbaord
                push?.matchCategory = dictevent["id_module"] as? String ?? ""
                push?.matchSubCategory = dictevent["id_category"] as? String ?? ""
                push?.devesionIdCategory = dictevent["id_division"] as? String ?? ""
                push?.arrParentingDashboardTitle = ["Articles","Glossary","Legal Assist","Resources"]
                push?.arrParentingDashboardImage = ["note1","Glossary","note2","care"]
                push?.arrParentingDashboardId = ["001","009","065","012"]
                push?.matchTitleSelect = self.matchTitleSelect
                push?.matchTitleShowSelect = str1
                self.navigationController?.pushViewController(push!, animated: true)
            }
            if str == "Elder Law"
            {
                let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ParentingDashbaordId") as? ParentingDashbaord
                push?.matchCategory = dictevent["id_module"] as? String ?? ""
                push?.matchSubCategory = dictevent["id_category"] as? String ?? ""
                push?.devesionIdCategory = dictevent["id_division"] as? String ?? ""
                push?.arrParentingDashboardTitle = ["Articles","Glossary","Legal Assist","Resources"]
                push?.arrParentingDashboardImage = ["note1","Glossary","note2","care"]
                push?.arrParentingDashboardId = ["001","009","065","012"]
                push?.matchTitleSelect = self.matchTitleSelect
                push?.matchTitleShowSelect = str1
                self.navigationController?.pushViewController(push!, animated: true)
            }
            if str == "Estate Law"
            {
                let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ParentingDashbaordId") as? ParentingDashbaord
                push?.matchCategory = dictevent["id_module"] as? String ?? ""
                push?.matchSubCategory = dictevent["id_category"] as? String ?? ""
                push?.devesionIdCategory = dictevent["id_division"] as? String ?? ""
                push?.arrParentingDashboardTitle = ["Articles","Glossary","Legal Assist","Resources"]
                push?.arrParentingDashboardImage = ["note1","Glossary","note2","care"]
                push?.arrParentingDashboardId = ["001","009","065","012"]
                push?.matchTitleSelect = self.matchTitleSelect
                push?.matchTitleShowSelect = str1
                self.navigationController?.pushViewController(push!, animated: true)
            }
            if str == "Family and Divorce"
            {
                let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ParentingDashbaordId") as? ParentingDashbaord
                push?.matchCategory = dictevent["id_module"] as? String ?? ""
                push?.matchSubCategory = dictevent["id_category"] as? String ?? ""
                push?.devesionIdCategory = dictevent["id_division"] as? String ?? ""
                push?.arrParentingDashboardTitle = ["Articles","Glossary","Legal Assist","Legal fomrs","Resources"]
                push?.matchTitleShowSelect = str1
                push?.arrParentingDashboardImage = ["note1","Glossary","note2","note2","care"]
                push?.arrParentingDashboardId = ["001","009","065","006","012"]
                push?.matchTitleSelect = self.matchTitleSelect
                self.navigationController?.pushViewController(push!, animated: true)
            }
            if str == "Hiring a Lawyer"
            {
                let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ParentingDashbaordId") as? ParentingDashbaord
                push?.matchCategory = dictevent["id_module"] as? String ?? ""
                push?.matchSubCategory = dictevent["id_category"] as? String ?? ""
                push?.devesionIdCategory = dictevent["id_division"] as? String ?? ""
                push?.arrParentingDashboardTitle = ["Articles","Legal Assist","Resources"]
                push?.arrParentingDashboardImage = ["note1","note2","care"]
                push?.arrParentingDashboardId = ["001","065","012"]
                push?.matchTitleSelect = self.matchTitleSelect
                push?.matchTitleShowSelect = str1
                self.navigationController?.pushViewController(push!, animated: true)
            }
            if str == "Meeting with a Lawyer"
            {
                let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ParentingDashbaordId") as? ParentingDashbaord
                push?.matchCategory = dictevent["id_module"] as? String ?? ""
                push?.matchSubCategory = dictevent["id_category"] as? String ?? ""
                push?.devesionIdCategory = dictevent["id_division"] as? String ?? ""
                push?.arrParentingDashboardTitle = ["Articles","Glossary","Legal Assist","Resources"]
                push?.arrParentingDashboardImage = ["note1","Glossary","note2","care"]
                push?.arrParentingDashboardId = ["001","009","065","012"]
                push?.matchTitleSelect = self.matchTitleSelect
                push?.matchTitleShowSelect = str1
                self.navigationController?.pushViewController(push!, animated: true)
            }
            if str == "Real Estate"
            {
                let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ParentingDashbaordId") as? ParentingDashbaord
                push?.matchCategory = dictevent["id_module"] as? String ?? ""
                push?.matchSubCategory = dictevent["id_category"] as? String ?? ""
                push?.devesionIdCategory = dictevent["id_division"] as? String ?? ""
                push?.arrParentingDashboardTitle = ["Articles","Glossary","Legal Assist","Legal fomrs","Resources"]
                push?.arrParentingDashboardImage = ["note1","Glossary","note2","note2","care"]
                push?.arrParentingDashboardId = ["001","009","065","006","012"]
                push?.matchTitleSelect = self.matchTitleSelect
                push?.matchTitleShowSelect = str1
                self.navigationController?.pushViewController(push!, animated: true)
            }
            if str == "Bankruptcy"
            {
                let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ParentingDashbaordId") as? ParentingDashbaord
                push?.matchCategory = dictevent["id_module"] as? String ?? ""
                push?.matchSubCategory = dictevent["id_category"] as? String ?? ""
                push?.devesionIdCategory = dictevent["id_division"] as? String ?? ""
                push?.arrParentingDashboardTitle = ["Articles","Legal Assist"]
                push?.arrParentingDashboardImage = ["note1","note2"]
                push?.arrParentingDashboardId = ["001","065"]
                push?.matchTitleSelect = self.matchTitleSelect
                push?.matchTitleShowSelect = str1
                self.navigationController?.pushViewController(push!, animated: true)
            }
            if str == "Consumer Rights"
            {
                let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ParentingDashbaordId") as? ParentingDashbaord
                push?.matchCategory = dictevent["id_module"] as? String ?? ""
                push?.matchSubCategory = dictevent["id_category"] as? String ?? ""
                push?.devesionIdCategory = dictevent["id_division"] as? String ?? ""
                push?.arrParentingDashboardTitle = ["Articles","Legal Assist"]
                push?.arrParentingDashboardImage = ["note1","note2"]
                push?.arrParentingDashboardId = ["001","065"]
                push?.matchTitleSelect = self.matchTitleSelect
                push?.matchTitleShowSelect = str1
                self.navigationController?.pushViewController(push!, animated: true)
            }
            if str == "Courts and Mediation"
            {
                let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ParentingDashbaordId") as? ParentingDashbaord
                push?.matchCategory = dictevent["id_module"] as? String ?? ""
                push?.matchSubCategory = dictevent["id_category"] as? String ?? ""
                push?.devesionIdCategory = dictevent["id_division"] as? String ?? ""
                push?.arrParentingDashboardTitle = ["Articles","Legal Assist"]
                push?.arrParentingDashboardImage = ["note1","note2"]
                push?.arrParentingDashboardId = ["001","065"]
                push?.matchTitleSelect = self.matchTitleSelect
                push?.matchTitleShowSelect = str1
                self.navigationController?.pushViewController(push!, animated: true)
            }
            if str == "Discrimination"
            {
                let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ParentingDashbaordId") as? ParentingDashbaord
                push?.matchCategory = dictevent["id_module"] as? String ?? ""
                push?.devesionIdCategory = dictevent["id_division"] as? String ?? ""
                push?.matchSubCategory = dictevent["id_category"] as? String ?? ""
                push?.arrParentingDashboardTitle = ["Articles","Legal Assist"]
                push?.arrParentingDashboardImage = ["note1","note2"]
                push?.arrParentingDashboardId = ["001","065"]
                push?.matchTitleSelect = self.matchTitleSelect
                push?.matchTitleShowSelect = str1
                self.navigationController?.pushViewController(push!, animated: true)
            }
            if str == "Landlords and Property Management"
            {
                let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ParentingDashbaordId") as? ParentingDashbaord
                push?.matchCategory = dictevent["id_module"] as? String ?? ""
                push?.devesionIdCategory = dictevent["id_division"] as? String ?? ""
                push?.matchSubCategory = dictevent["id_category"] as? String ?? ""
                push?.arrParentingDashboardTitle = ["Articles","Legal Assist"]
                push?.arrParentingDashboardImage = ["note1","note2"]
                push?.arrParentingDashboardId = ["001","065"]
                push?.matchTitleSelect = self.matchTitleSelect
                push?.matchTitleShowSelect = str1
                self.navigationController?.pushViewController(push!, animated: true)
            }
            if str == "Renters' Rights"
            {
                let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ParentingDashbaordId") as? ParentingDashbaord
                push?.matchCategory = dictevent["id_module"] as? String ?? ""
                push?.devesionIdCategory = dictevent["id_division"] as? String ?? ""
                push?.matchSubCategory = dictevent["id_category"] as? String ?? ""
                push?.arrParentingDashboardTitle = ["Articles","Legal Assist"]
                push?.arrParentingDashboardImage = ["note1","note2"]
                push?.arrParentingDashboardId = ["001","065"]
                push?.matchTitleSelect = self.matchTitleSelect
                push?.matchTitleShowSelect = str1
                self.navigationController?.pushViewController(push!, animated: true)
            }
            if str == "Parenting and Adoption"
            {
                let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ParentingDashbaordId") as? ParentingDashbaord
                push?.matchCategory = dictevent["id_module"] as? String ?? ""
                push?.devesionIdCategory = dictevent["id_division"] as? String ?? ""
                push?.matchSubCategory = dictevent["id_category"] as? String ?? ""
                push?.arrParentingDashboardTitle = ["Articles","Legal Assist"]
                push?.arrParentingDashboardImage = ["note1","note2"]
                push?.arrParentingDashboardId = ["001","065"]
                push?.matchTitleSelect = self.matchTitleSelect
                push?.matchTitleShowSelect = str1
                self.navigationController?.pushViewController(push!, animated: true)
            }
            if str == "Social Security and Retirement"
            {
                let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ParentingDashbaordId") as? ParentingDashbaord
                push?.matchCategory = dictevent["id_module"] as? String ?? ""
                push?.devesionIdCategory = dictevent["id_division"] as? String ?? ""
                push?.matchSubCategory = dictevent["id_category"] as? String ?? ""
                push?.arrParentingDashboardTitle = ["Articles","Legal Assist"]
                push?.arrParentingDashboardImage = ["note1","note2"]
                push?.arrParentingDashboardId = ["001","065"]
                push?.matchTitleSelect = self.matchTitleSelect
                push?.matchTitleShowSelect = str1
                self.navigationController?.pushViewController(push!, animated: true)
            }
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 55
    }
    
}

extension CategoryViewController: UITableViewDelegate {
    
}

/*
 // MARK: - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
 // Get the new view controller using segue.destination.
 // Pass the selected object to the new view controller.
 }
 */

