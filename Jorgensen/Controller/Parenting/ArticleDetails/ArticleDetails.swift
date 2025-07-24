//
//  ArticleDetails.swift
//  Jorgensen
//
//  Created by Apple on 04/09/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import UIKit
import WebKit;

class ArticleDetails: UIViewController {
    
 var dictdetail:NSDictionary?
    
    // MARK:- CUSTOM NAVIGATION BAR -
    @IBOutlet weak var navigationBar:UIView! {
        didSet {
            navigationBar.backgroundColor = NAVIGATION_BACKGROUND_COLOR
        }
    }

    @IBOutlet weak var viewUnderNavigation:UIView! {
        didSet {
            viewUnderNavigation.backgroundColor = APP_BUTTON_COLOR
        }
    }
    
    @IBOutlet weak var viewBottom:UIView! {
        didSet {
            viewBottom.backgroundColor = APP_BUTTON_COLOR
        }
    }
    
    @IBOutlet weak var btnStarOne:UIButton! {
        didSet {
            btnStarOne.layer.cornerRadius = 15
            btnStarOne.clipsToBounds = true
        }
    }
    @IBOutlet weak var btnStarTwo:UIButton! {
        didSet {
            btnStarTwo.layer.cornerRadius = 15
            btnStarTwo.clipsToBounds = true
        }
    }
    @IBOutlet weak var btnStarThree:UIButton! {
        didSet {
            btnStarThree.layer.cornerRadius = 15
            btnStarThree.clipsToBounds = true
        }
    }
    @IBOutlet weak var btnStarFour:UIButton! {
        didSet {
            btnStarFour.layer.cornerRadius = 15
            btnStarFour.clipsToBounds = true
        }
    }
    @IBOutlet weak var btnStarFive:UIButton! {
        didSet {
            btnStarFive.layer.cornerRadius = 15
            btnStarFive.clipsToBounds = true
        }
    }
    
    // MARK:- CUSTOM NAVIGATION TITLE -
    @IBOutlet weak var lblNavigationTitle:UILabel! {
        didSet {
            lblNavigationTitle.text = ""
            lblNavigationTitle.textColor = .white
        }
    }
    
    @IBOutlet weak var btnBack:UIButton! {
        didSet {
            btnBack.tintColor = .white
        }
    }
    
    @IBOutlet weak var lblTitle:UILabel! {
        didSet {
            lblTitle.text = self.dictdetail!["title"] as? String ?? ""
        }
    }
    @IBOutlet weak var webView: WKWebView!
    @IBOutlet weak var txtView:UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        
       
//        let attr = try? NSAttributedString(htmlString: htmlString, font: UIFont.systemFont(ofSize: 34, weight: .regular))
//
//        txtView.attributedText = htmlString.htmlToAttributedString
//
        loadHTMLStringImage()
        
        
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
    
    func loadHTMLStringImage() -> Void {
        
        let htmlString = self.dictdetail!["body_combine"] as? String ?? ""
           webView.navigationDelegate = self as? WKNavigationDelegate
           webView.loadHTMLString(htmlString, baseURL: nil)
//
     
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


extension NSAttributedString {

    convenience init(htmlString html: String, font: UIFont? = nil, useDocumentFontSize: Bool = true) throws {
        let options: [NSAttributedString.DocumentReadingOptionKey : Any] = [
            .documentType: NSAttributedString.DocumentType.html,
            .characterEncoding: String.Encoding.utf8.rawValue
        ]

        let data = html.data(using: .utf8, allowLossyConversion: true)
        guard (data != nil), let fontFamily = font?.familyName, let attr = try? NSMutableAttributedString(data: data!, options: options, documentAttributes: nil) else {
            try self.init(data: data ?? Data(html.utf8), options: options, documentAttributes: nil)
            return
        }

        let fontSize: CGFloat? = useDocumentFontSize ? nil : font!.pointSize
        let range = NSRange(location: 0, length: attr.length)
        attr.enumerateAttribute(.font, in: range, options: .longestEffectiveRangeNotRequired) { attrib, range, _ in
            if let htmlFont = attrib as? UIFont {
                let traits = htmlFont.fontDescriptor.symbolicTraits
                var descrip = htmlFont.fontDescriptor.withFamily(fontFamily)

                if (traits.rawValue & UIFontDescriptor.SymbolicTraits.traitBold.rawValue) != 0 {
                    descrip = descrip.withSymbolicTraits(.traitBold)!
                }

                if (traits.rawValue & UIFontDescriptor.SymbolicTraits.traitItalic.rawValue) != 0 {
                    descrip = descrip.withSymbolicTraits(.traitItalic)!
                }

                attr.addAttribute(.font, value: UIFont(descriptor: descrip, size: fontSize ?? htmlFont.pointSize), range: range)
            }
        }

        self.init(attributedString: attr)
    }

}

extension String {
    var htmlToAttributedString: NSAttributedString? {
        guard let data = data(using: .utf8) else { return NSAttributedString() }
        do {
            return try NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding:String.Encoding.utf8.rawValue], documentAttributes: nil)
        } catch {
            return NSAttributedString()
        }
    }
    var htmlToString: String {
        return htmlToAttributedString?.string ?? ""
    }
}

//extension ArticleDetails: WKNavigationDelegate {
// func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
//    debugPrint("didCommit")
//}
// func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
//    debugPrint("didFinish")
//}
// func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
//    debugPrint("didFail")
//}
//    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
//        guard let url = navigationAction.request.url, let scheme = url.scheme, scheme.contains("http") else {
//               // This is not HTTP link - can be a local file or a mailto
//               decisionHandler(.cancel)
//               return
//           }
//        // This is a HTTP link
////        open(url)
//        decisionHandler(.allow)
//   }
//}
