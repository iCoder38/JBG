//
//  WorkingListViewController.swift
//  Jorgensen
//
//  Created by Shyam on 28/10/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import UIKit
import IHProgressHUD

class WorkingListViewController: BaseViewController {
   
    let cellReuseIdentifier = "workingTableCell"
        var arrTitle = NSMutableArray()
           var sipagingEnable = true
           var dictevent = Dictionary<String , Any>()
         
    // MARK:- CUSTOM NAVIGATION BAR -
       @IBOutlet weak var navigationBar:UIView! {
           didSet {
               navigationBar.backgroundColor = NAVIGATION_BACKGROUND_COLOR
           }
       }
    
    @IBOutlet weak var iconImageview:UIImageView! {
             didSet {
              iconImageview.image = UIImage(named: "working")

                
             }
         }

       // MARK:- CUSTOM NAVIGATION TITLE -
       @IBOutlet weak var lblNavigationTitle:UILabel! {
           didSet {
               lblNavigationTitle.text = "WORKING"
               lblNavigationTitle.textColor = .white
           }
       }
       
       @IBOutlet weak var btnBack:UIButton! {
           didSet {
               btnBack.tintColor = .white
            btnBack.addTarget(self, action: #selector(self.tapBackVc(_:)), for: .touchUpInside)
           }
       }
    func loadMessages()
       {
           IHProgressHUD.show(withStatus: "Please wait...")
           let url = URL(string: "https://www.powerflexweb.com/api_content/common/read_mod.php")!
           var request = URLRequest(url: url)
           
           request.httpMethod = "POST"
           
           let body = "id_language=en-US&id_module=m034,m036,m455,m035,m037,m038,m039,m324&token=eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpZF9lYXAiOiIxNjUxIiwiaWRfY29tcGFueSI6MTY1MTI2NTY3fQ.FznzxAPBbFF9kI2Vd6G39P6kO431dztk8TN9VYir-jY&api_id=1651"
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
       
   
    override func viewDidLoad()
    {
        super.viewDidLoad()
        arrTitle = NSMutableArray()
        self.loadMessages()
        // Do any additional setup after loading the view.
    }
    


}

extension WorkingListViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrTitle.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:AgingDashboardTableCell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier) as! AgingDashboardTableCell
    
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
                   
                      
                       let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "CategoryViewController") as? CategoryViewController
                       push!.dictdetail =  dictevent as NSDictionary
                       push!.matchTitleSelect = str
                       push!.matchSelect =  dictevent["id_module"] as? String ?? ""
                       self.navigationController?.pushViewController(push!, animated: true)
                 
               
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
}

extension WorkingListViewController: UITableViewDelegate {
    
}
