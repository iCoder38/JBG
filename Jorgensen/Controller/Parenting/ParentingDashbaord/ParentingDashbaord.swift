//
//  ParentingDashbaord.swift
//  Jorgensen
//
//  Created by Apple on 04/09/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import UIKit

class ParentingDashbaord: UIViewController
{
    var dictdetail:NSDictionary?
    
    var arrParentingDashboardTitle = [String]()
    var arrParentingDashboardImage = [String]()
    var arrParentingDashboardId = [String]()
    var matchTitleSelect:String!
     var matchTitleShowSelect:String!
    var matchCategory:String!
    var matchSubCategory:String!
    var devesionIdCategory:String!
    
    
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
        }
    }
    
    // MARK:- COLLECTION VIEW SETUP -
    @IBOutlet weak var clView: UICollectionView! {
        didSet {
               //collection
            clView!.dataSource = self
            clView!.delegate = self
            clView!.backgroundColor = .white
            clView.isPagingEnabled = true
        }
    }
    
    @IBOutlet weak var btnBack:UIButton! {
        didSet {
            btnBack.tintColor = .white
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        
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
    
    @objc func sideBarMenuClick()
    {
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

extension ParentingDashbaord: UICollectionViewDelegate {
    
    //UICollectionViewDatasource methods
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
         return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrParentingDashboardTitle.count
    }
    
    //Write Delegate Code Here
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "parentingDashbaordCollectionCell", for: indexPath as IndexPath) as! ParentingDashbaordCollectionCell
           
        
        // MARK:- CELL CLASS -
        cell.layer.cornerRadius = 6
        cell.clipsToBounds = true
        cell.backgroundColor = .white
        cell.layer.borderColor = UIColor.clear.cgColor
        cell.layer.borderWidth = 0.6
        
        cell.viewCellBG.backgroundColor = APP_BUTTON_COLOR
        
        cell.lblTitle.text = arrParentingDashboardTitle[indexPath.row]
        cell.imgTitle.image = UIImage(named: arrParentingDashboardImage[indexPath.row])
        
        return cell
    }
    
    
}

extension ParentingDashbaord: UICollectionViewDataSource
{
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
            let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ParentingArticlesId") as? ParentingArticles
             push?.matchTitleSelect = self.matchTitleSelect
             push?.matchCategory = self.matchCategory
             push?.devesionIdCategory = self.devesionIdCategory
             push?.matchSubCategory = self.matchSubCategory
             push?.matchTitleShowSelect = self.matchTitleShowSelect
                      
             push?.matchIdSelect = self.arrParentingDashboardId[indexPath.row]
             self.navigationController?.pushViewController(push!, animated: true)
       
        
    }
    
    // MARK:- DISMISS KEYBOARD -
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        if scrollView == self.clView {
            self.view.endEditing(true)
        }
    }
    
}

extension ParentingDashbaord: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        let cellSize = CGSize(width: (collectionView.bounds.width - (3 * 10))/2, height: 220.0)
        return cellSize
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat
    {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets
    {
        let sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        return sectionInset
    }
   
    
}
