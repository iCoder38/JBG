//
//  Dashbaord.swift
//  Jorgensen
//
//  Created by Apple on 03/09/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import UIKit
import SideMenu
import SafariServices
import MessageUI

struct MenuOptionInfo {
    var name : String
    var icon : String
    var index : Int
    
    init(name : String, icon : String, index : Int) {
        self.name = name
        self.icon = icon
        self.index = index
    }
}

struct StaticBanner {
    let imageName: String  // ⬅️ from assets
    let name: String
    let link: String
}


let staticBanners: [StaticBanner] = [
    StaticBanner(imageName: "slider1", name: "JBG Clinic Care", link: "https://jorgensenbrooks.com/jbg-clinical-care/"),
    StaticBanner(imageName: "slider2", name: "JBG Personal Care", link: "https://jorgensenbrooks.com/jbg-personal-care/"),
    StaticBanner(imageName: "slider3", name: "JBG Employer Care", link: "https://jorgensenbrooks.com/jbg-employer-care/"),
    StaticBanner(imageName: "slider4", name: "Non-Emergency Feedback", link: "https://jorgensenbrooks.com/contact/")
]


struct BannerModel {
    let imageUrl: String
    let title: String
    let description: String
    let link: String
}

class Dashbaord: UIViewController, MFMailComposeViewControllerDelegate {
    
    var imageArr = [UIImage.init(named: "slide1.jpg"),
                    UIImage.init(named: "slide2.jpg"),
                    UIImage.init(named: "slide5.jpg"),
                    UIImage.init(named: "slide4.jpg"),
                    UIImage.init(named: "slide3.jpg"),
                    UIImage.init(named: "slide6.jpg"),
                    UIImage.init(named: "slide7.jpg")]
    
    var titleArr = ["August",
                    "COVID-19 Info",
                    "Racial Equity",
                    "Friendships and Your School-Age Child",
                    "Be a Friendship Coach for Your Child",
                    "Positive Parenting Tips: Teens",
                    "Positive Parenting Tips: Infants and Toddlers"]
    
    
    var linkArr = ["https://www.advantageengagement.com/p_content_detail.php?id_division=d00&id_module=m000&id_cr=100637",
                   "https://www.advantageengagement.com/p_content_detail.php?id_division=d00&id_module=m000&id_cr=99733",
                   "https://www.advantageengagement.com/p_content_detail.php?id_division=d00&id_module=m000&id_cr=100056",
                   "https://www.advantageengagement.com/p_content_detail.php?id_division=d00&id_module=m000&id_element=001&id_cr=100556",
                   "https://www.advantageengagement.com/p_content_detail.php?id_division=d00&id_module=m000&id_element=001&id_cr=100557",
                   "https://www.advantageengagement.com/p_content_detail.php?id_division=d00&id_module=m000&id_element=001&id_cr=100423",
                   "https://www.advantageengagement.com/p_content_detail.php?id_division=d00&id_module=m000&id_element=001&id_cr=100421"]
    
    
    var descArr = ["Immunization Awareness Month is highlighted in August.",
                   "Coronavirus disease 2019 (COVID-19) is a worldwide pandemic that has disrupted daily life.",
                   "Racial equity is important in today's world, and people may be wondering how they can offer support.",
                   "Friendships in the early school years are an important part of a child's social and emotional development.",
                   "Children aren't born knowing how to cooperate, share, and communicate. These are learned skills.",
                   "The following sections offer positive parenting tips for teens.",
                   "As a parent, you give your children a good start in life—you nurture, protect, and guide them."]
    
    
    var dashboardTitle:[MenuOptionInfo] = []
    
    @IBOutlet weak var descLabel: UILabel!
    @IBOutlet weak var titlelabel: UILabel!
    @IBOutlet weak var slideImage: UIImageView!
    @IBOutlet weak var labelImage: UIImageView!
    var i=Int()
    var j=Int()
    
    // MARK:- CUSTOM NAVIGATION BAR -
    @IBOutlet weak var navigationBar:UIView! {
        didSet {
            navigationBar.backgroundColor = NAVIGATION_BACKGROUND_COLOR
        }
    }
    @IBOutlet weak var headerBar:UIView! {
        didSet {
            headerBar.layer.cornerRadius = 8
            headerBar.clipsToBounds = true
        }
    }
    @IBOutlet weak var sliderView:UIView! {
        didSet {
            sliderView.backgroundColor = UIColor.clear
        }
    }
    
    @IBOutlet weak var staticSliderView:UIView! {
        didSet {
            staticSliderView.backgroundColor = UIColor.clear
        }
    }
    
    @IBOutlet weak var btnPhoneNumber:UIButton! {
        didSet {
            btnPhoneNumber.setTitle("Toll-free number: 888-520-5400", for: .normal)
            btnPhoneNumber.addTarget(self, action: #selector(phoneNumberClickMethod), for: .touchUpInside)
        }
    }
    @IBOutlet weak var btnEmail:UIButton! {
        didSet {
            btnEmail.setTitle("intake@jorgensenbrooks.com", for: .normal)
            btnEmail.addTarget(self, action: #selector(sendEmail), for: .touchUpInside)
            
        }
    }
    
    var scrollView: UIScrollView!
    var bannerTimer: Timer?
    var banners: [BannerModel] = []
    var currentIndex: Int = 0
    
    @objc func lableChange()
    {
        
        
        if j<titleArr.count
        {
            self.titlelabel.text=titleArr[j]
            self.descLabel.text=descArr[j]
            
            j+=1
        }
        else{
            j=0
            if j == 0
            {
                self.titlelabel.text=titleArr[j]
                self.descLabel.text=descArr[j]
            }
        }
    }
    
    @objc func imageChange()
    {
        
        
        if i<imageArr.count{
            
            self.slideImage.image = imageArr[i]
            i+=1
        }
        else
        {
            i=0
            if i == 0
            {
                self.slideImage.image = UIImage.init(named: "slide1.jpg")
                
            }
            
        }
    }
    
    // MARK:- CUSTOM NAVIGATION TITLE -
    @IBOutlet weak var lblNavigationTitle:UILabel! {
        didSet {
            lblNavigationTitle.text = "DASHBOARD"
        }
    }
    
    @IBOutlet weak var chatBack:UIButton!
    {
        didSet {
            chatBack.addTarget(self, action: #selector(chatClickMethod), for: .touchUpInside)
        }
    }
    
    @IBOutlet weak var callBack:UIButton! {
        didSet {
            callBack.addTarget(self, action: #selector(callClickMethod), for: .touchUpInside)
        }
    }
    
    @objc func callClickMethod() {
        
        if let url = URL(string: "telprompt://5205758623"), UIApplication.shared.canOpenURL(url) {
            if #available(iOS 10, *) {
                UIApplication.shared.open(url)
            } else {
                UIApplication.shared.openURL(url)
            }
        }
    }
    
    @objc func chatClickMethod() {
        
        guard let url = URL(string: "https://rms.workplaceoptions.com/anonymouschat/D509C30F-7FB2-431F-8646-8CBD8F945634/94026cbd-ef16-4a44-a88b-1dbe0764ece7/00000000-0000-0000-0000-000000000000/11e7a159-e5e5-4fe2-a57f-f8567597ecd3?id_company=165174188&name_company=Jorgensen%20Brooks") else {
            return //be safe
        }
        
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else {
            UIApplication.shared.openURL(url)
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
    
    
    
    @IBOutlet weak var btnMenu:UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        //self.sideBarMenuClick()
        // self.slideImage.image = UIImage.init(named: "slide1.jpg")
        // self.titlelabel.text = "August"
        // self.descLabel.text = "Immunization Awareness Month is highlighted in August."
        
        // self.slideImage.roundCorners([.topLeft, .topRight], radius: 10)
        
        // self.labelImage.roundCorners([.bottomLeft, .bottomRight], radius: 10)
        
        
        
        // Timer.scheduledTimer(timeInterval: 3.0, target: self, selector: #selector(imageChange), userInfo: nil, repeats: true)
        
        // Timer.scheduledTimer(timeInterval: 3.0, target: self, selector: #selector(lableChange), userInfo: nil, repeats: true)
        
        
        
        self.setUpLsitData()
        
        
    }
    
    func setupStaticSliderView() {
        staticSliderView.subviews.forEach { $0.removeFromSuperview() }
        
        let itemWidth = staticSliderView.frame.width
        let height = staticSliderView.frame.height
        
        // ScrollView
        let scrollView = UIScrollView(frame: staticSliderView.bounds)
        scrollView.isPagingEnabled = true
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.clipsToBounds = true
        scrollView.layer.cornerRadius = 8
        scrollView.tag = 999 // to access later
        staticSliderView.addSubview(scrollView)
        
        for (index, banner) in staticBanners.enumerated() {
            let originX = CGFloat(index) * itemWidth
            let container = UIView(frame: CGRect(x: originX, y: 0, width: itemWidth, height: height))
            container.clipsToBounds = true
            
            let imageView = UIImageView(frame: container.bounds)
            imageView.contentMode = .scaleAspectFill
            imageView.clipsToBounds = true
            imageView.isUserInteractionEnabled = true
            imageView.tag = index
            imageView.image = UIImage(named: banner.imageName)
            
            let labelHeight: CGFloat = 28
            let label = UILabel(frame: CGRect(x: 0, y: height - labelHeight, width: itemWidth, height: labelHeight))
            label.backgroundColor = UIColor.black.withAlphaComponent(0.7)
            label.textColor = .white
            label.font = UIFont.boldSystemFont(ofSize: 16)
            label.textAlignment = .center
            label.text = banner.name.uppercased()
            
            
            let tap = UITapGestureRecognizer(target: self, action: #selector(staticBannerTapped(_:)))
            imageView.addGestureRecognizer(tap)
            
            container.addSubview(imageView)
            container.addSubview(label)
            scrollView.addSubview(container)
        }
        
        scrollView.contentSize = CGSize(width: CGFloat(staticBanners.count) * itemWidth, height: height)
        
        // Add left arrow
        let leftButton = UIButton(type: .custom)
        leftButton.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        leftButton.tintColor = .white
        leftButton.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        leftButton.layer.cornerRadius = 16
        leftButton.frame = CGRect(x: 8, y: (height - 32) / 2, width: 32, height: 32)
        leftButton.addTarget(self, action: #selector(scrollLeft), for: .touchUpInside)
        staticSliderView.addSubview(leftButton)
        
        // Add right arrow
        let rightButton = UIButton(type: .custom)
        rightButton.setImage(UIImage(systemName: "chevron.right"), for: .normal)
        rightButton.tintColor = .white
        rightButton.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        rightButton.layer.cornerRadius = 16
        rightButton.frame = CGRect(x: itemWidth - 40, y: (height - 32) / 2, width: 32, height: 32)
        rightButton.addTarget(self, action: #selector(scrollRight), for: .touchUpInside)
        staticSliderView.addSubview(rightButton)
    }
    @objc func scrollLeft() {
        guard let scrollView = staticSliderView.viewWithTag(999) as? UIScrollView else { return }
        let currentOffset = scrollView.contentOffset.x
        let width = scrollView.frame.width
        let newOffset = max(currentOffset - width, 0)
        scrollView.setContentOffset(CGPoint(x: newOffset, y: 0), animated: true)
    }
    
    @objc func scrollRight() {
        guard let scrollView = staticSliderView.viewWithTag(999) as? UIScrollView else { return }
        let currentOffset = scrollView.contentOffset.x
        let width = scrollView.frame.width
        let maxOffset = scrollView.contentSize.width - width
        let newOffset = min(currentOffset + width, maxOffset)
        scrollView.setContentOffset(CGPoint(x: newOffset, y: 0), animated: true)
    }
    
    
    
    
    private var didSetupStaticSlider = false
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if !didSetupStaticSlider {
            setupStaticSliderView()
            didSetupStaticSlider = true
        }
    }
    
    @objc func staticBannerTapped(_ gesture: UITapGestureRecognizer) {
        guard let index = gesture.view?.tag, index < staticBanners.count else { return }
        let banner = staticBanners[index]
        if let url = URL(string: banner.link) {
            let safariVC = SFSafariViewController(url: url)
            safariVC.modalPresentationStyle = .overFullScreen
            present(safariVC, animated: true, completion: nil)
        }
    }
    
    
    @objc func phoneNumberClickMethod() {
        if let phoneURL = URL(string: "tel://888-520-5400"),
           UIApplication.shared.canOpenURL(phoneURL) {
            UIApplication.shared.open(phoneURL, options: [:], completionHandler: nil)
        }
        
    }
    
    @objc func sendEmail() {
        if let url = URL(string: "mailto:intake@jorgensenbrooks.com"),
           UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url)
        }
        
    }
    
    // Delegate method
    func mailComposeController(_ controller: MFMailComposeViewController,
                               didFinishWith result: MFMailComposeResult,
                               error: Error?) {
        controller.dismiss(animated: true)
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
    
    @IBAction func readMoreActions(_ sender : Any)
    {
        if i == 0 {
            let link: String = linkArr[0]
            if let url = URL(string: link) {
                UIApplication.shared.open(url)
            }
        }
        else
        {
            
            let link: String = linkArr[i-1]
            if let url = URL(string: link) {
                UIApplication.shared.open(url)
            }
        }
        
        
    }
    
    
    func fetchBannerList() {
        guard let url = URL(string: "https://demo4.evirtualservices.net/jbgapp/services/index") else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        let body = "action=bannerlist"
        request.httpBody = body.data(using: .utf8)
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        
        URLSession.shared.dataTask(with: request) { [weak self] data, _, error in
            guard let self = self, let data = data, error == nil else { return }
            do {
                if let json = try JSONSerialization.jsonObject(with: data) as? [String: Any],
                   let dataArray = json["data"] as? [[String: Any]] {
                    
                    print(dataArray as Any)
                    
                    self.banners = dataArray.compactMap { dict in
                        guard let img = dict["image"] as? String,
                              let title = dict["name"] as? String,
                              let desc = dict["description"] as? String,
                              let link = dict["link"] as? String else { return nil }
                        return BannerModel(imageUrl: img, title: title, description: desc, link: link)
                    }
                    DispatchQueue.main.async {
                        self.setupSliderScrollView()
                        self.startAutoScroll()
                    }
                }
            } catch {
                print("Error parsing banner JSON")
            }
        }.resume()
    }
    
    func setupSliderScrollView() {
        scrollView = UIScrollView(frame: sliderView.bounds)
        scrollView.isPagingEnabled = true
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.clipsToBounds = true
        scrollView.layer.cornerRadius = 8
        sliderView.addSubview(scrollView)
        
        let width = sliderView.frame.width
        let height = sliderView.frame.height
        
        for (index, banner) in banners.enumerated() {
            let container = UIView(frame: CGRect(x: CGFloat(index) * width, y: 0, width: width, height: height))
            container.clipsToBounds = true
            
            // 1. Banner Image
            let imageView = UIImageView(frame: container.bounds)
            imageView.contentMode = .scaleAspectFill
            imageView.clipsToBounds = true
            
            if let url = URL(string: banner.imageUrl) {
                URLSession.shared.dataTask(with: url) { data, _, _ in
                    if let data = data {
                        DispatchQueue.main.async {
                            imageView.image = UIImage(data: data)
                        }
                    }
                }.resume()
            }
            
            container.addSubview(imageView)
            
            // 2. Black overlay container
            let overlayHeight: CGFloat = 100
            let overlayView = UIView(frame: CGRect(x: 0, y: height - overlayHeight, width: width, height: overlayHeight))
            overlayView.backgroundColor = UIColor.black
            
            // 3. Title label
            let titleLabel = UILabel(frame: CGRect(x: 10, y: 8, width: width - 20, height: 22))
            titleLabel.text = banner.title
            titleLabel.font = UIFont.boldSystemFont(ofSize: 18)
            titleLabel.textColor = .white
            
            // 4. Description label
            let descLabel = UILabel(frame: CGRect(x: 10, y: 32, width: width - 20, height: 34))
            descLabel.text = banner.description
            descLabel.font = UIFont.systemFont(ofSize: 13)
            descLabel.textColor = .white
            descLabel.numberOfLines = 2
            
            // 5. Read more button
            let readMoreButton = UIButton(frame: CGRect(x: 10, y: 66, width: 120, height: 28))
            readMoreButton.setTitle("READ MORE", for: .normal)
            readMoreButton.backgroundColor = UIColor(red: 98/255, green: 198/255, blue: 77/255, alpha: 1)
            readMoreButton.layer.cornerRadius = 4
            readMoreButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 13)
            readMoreButton.tag = index
            readMoreButton.addTarget(self, action: #selector(readMoreTapped(_:)), for: .touchUpInside)
            
            overlayView.addSubview(titleLabel)
            overlayView.addSubview(descLabel)
            overlayView.addSubview(readMoreButton)
            container.addSubview(overlayView)
            scrollView.addSubview(container)
        }
        
        scrollView.contentSize = CGSize(width: CGFloat(banners.count) * width, height: height)
    }
    @objc func readMoreTapped(_ sender: UIButton) {
        let banner = banners[sender.tag]
        if let url = URL(string: banner.link) {
            let safariVC = SFSafariViewController(url: url)
            safariVC.modalPresentationStyle = .overFullScreen
            present(safariVC, animated: true, completion: nil)
        }
    }
    
    @objc func bannerTapped(_ gesture: UITapGestureRecognizer) {
        guard let index = gesture.view?.tag, index < banners.count else { return }
        let banner = banners[index]
        if let url = URL(string: banner.link) {
            let safariVC = SFSafariViewController(url: url)
            safariVC.modalPresentationStyle = .overFullScreen
            present(safariVC, animated: true, completion: nil)
        }
    }
    
    func startAutoScroll() {
        bannerTimer = Timer.scheduledTimer(timeInterval: 3.0, target: self, selector: #selector(scrollBanner), userInfo: nil, repeats: true)
    }
    
    @objc func scrollBanner() {
        guard banners.count > 1 else { return }
        currentIndex = (currentIndex + 1) % banners.count
        let width = scrollView.frame.width
        let offsetX = CGFloat(currentIndex) * width
        scrollView.setContentOffset(CGPoint(x: offsetX, y: 0), animated: true)
    }
    
    func setUpLsitData(){
        //var dashboardTitle = ["Parenting","Aging","Balancing","Thriving","Working","Living"]
        self.dashboardTitle.insert(MenuOptionInfo.init(name: "Parenting", icon: "parenting", index: 1), at: 0)
        self.dashboardTitle.append(MenuOptionInfo.init(name: "Aging", icon: "aging", index: 2))
        self.dashboardTitle.append(MenuOptionInfo.init(name: "Balancing", icon: "balancing", index: 3))
        self.dashboardTitle.append(MenuOptionInfo.init(name: "Thriving", icon: "thriving", index: 4))
        self.dashboardTitle.append(MenuOptionInfo.init(name: "Working", icon: "working", index: 5))
        self.dashboardTitle.append(MenuOptionInfo.init(name: "Living", icon: "living", index: 6))
        self.dashboardTitle.append(MenuOptionInfo.init(name: "International", icon: "International", index: 7))
        
        self.fetchBannerList()
    }
    
    @objc func sideBarMenuClick() {
        if revealViewController() != nil {
            btnMenu.addTarget(self.revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)), for: .touchUpInside)
            revealViewController().rearViewRevealWidth = 300
            view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
    }
    
    @IBAction func tapMenuActions(_ sender : Any){
        let menu = storyboard!.instantiateViewController(withIdentifier: "RightMenu") as! SideMenuNavigationController
        menu.menuWidth = self.view.frame.width
        menu.presentationStyle = .menuSlideIn
        present(menu, animated: true, completion: nil)
    }
}

extension Dashbaord: UICollectionViewDelegate {
    
    //UICollectionViewDatasource methods
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dashboardTitle.count
    }
    
    //Write Delegate Code Here
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "dashbaordCollectionCell", for: indexPath as IndexPath) as! DashbaordCollectionCell
        // MARK:- CELL CLASS -
        cell.layer.cornerRadius = 6
        cell.clipsToBounds = true
        cell.backgroundColor = .white
        cell.layer.borderColor = UIColor.clear.cgColor
        cell.layer.borderWidth = 0.6
        cell.viewCellBG.backgroundColor = APP_BUTTON_COLOR
        cell.lblTitle.text = dashboardTitle[indexPath.row].name
        cell.imgItem.image = UIImage.init(named: dashboardTitle[indexPath.row].icon)
        return cell
    }
}

extension Dashbaord: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.loadViewWithCurrentIndex(selectedIndex: indexPath.row)
    }
    
    // MARK:- DISMISS KEYBOARD -
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        if scrollView == self.clView {
            self.view.endEditing(true)
        }
    }
    
    func loadViewWithCurrentIndex(selectedIndex: Int) {
        let menuOption = dashboardTitle[selectedIndex]
        switch menuOption.index {
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
        default:
            let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "InternationalListViewController") as? InternationalListViewController
            self.navigationController?.pushViewController(push!, animated: true)
            break
        }
    }
}

extension Dashbaord: UICollectionViewDelegateFlowLayout {
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


class Colors {
    var gl:CAGradientLayer!
    
    init() {
        let colorTop = UIColor(red: 192.0 / 255.0, green: 38.0 / 255.0, blue: 42.0 / 255.0, alpha: 1.0).cgColor
        let colorBottom = UIColor(red: 35.0 / 255.0, green: 2.0 / 255.0, blue: 2.0 / 255.0, alpha: 1.0).cgColor
        
        self.gl = CAGradientLayer()
        self.gl.colors = [colorTop, colorBottom]
        self.gl.locations = [0.0, 1.0]
    }
}

extension UIImageView {
    public func roundCorners(_ corners: UIRectCorner, radius: CGFloat) {
        let maskPath = UIBezierPath(roundedRect: bounds,
                                    byRoundingCorners: corners,
                                    cornerRadii: CGSize(width: radius, height: radius))
        let shape = CAShapeLayer()
        shape.path = maskPath.cgPath
        layer.mask = shape
    }
}
