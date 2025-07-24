//
//  CustomProgressViewController.swift
//  Cargills
//
//  Created by Shyam on 11/05/20.
//  Copyright © 2020 Razorse. All rights reserved.
//



import UIKit

let CustomProgressViewWindow = UIWindow.init(frame: UIScreen.main.bounds)
var customProgressViewCont : CustomProgressViewController!
var CustomProgressIsEnable : Bool = true

class CustomProgressViewController: UIViewController, UIViewControllerTransitioningDelegate {
    
    @IBOutlet weak var iconImg: UIImageView!
    @IBOutlet weak var bgImg: UIImageView!
    @IBOutlet weak var loader: UIActivityIndicatorView!
    @IBOutlet weak var lblLoaderStr: UILabel!
    
    var isHaveAlertView : Bool = false
    var dotCount : Int = 0
    var timer: Timer?
    
    
    static func setupProgressWindow() {
        CustomProgressViewWindow.backgroundColor = UIColor.clear
        customProgressViewCont = CustomProgressViewController(nibName: "CustomProgressViewController", bundle: nil)
        customProgressViewCont.view.backgroundColor = UIColor.clear
        customProgressViewCont.view.frame =  CustomProgressViewWindow.frame
        customProgressViewCont.view.isHidden = false
        CustomProgressViewWindow.rootViewController = customProgressViewCont
        CustomProgressViewWindow.makeKeyAndVisible()
        CustomProgressViewWindow.windowLevel = UIWindow.Level(rawValue: -5)
        CustomProgressViewWindow.clipsToBounds = true
    }
    
    static func showCustomProgressHud(loaderStr: String = "Please wait...") {
        if CustomProgressIsEnable == true {
            DispatchQueue.main.async {
                if CustomProgressViewWindow.windowLevel != UIWindow.Level(rawValue:CGFloat.greatestFiniteMagnitude) {
                    CustomProgressViewWindow.windowLevel = UIWindow.Level(rawValue: CGFloat.greatestFiniteMagnitude)
                    customProgressViewCont?.startTimer()
                    customProgressViewCont.lblLoaderStr.text = loaderStr
                }
            }
        }
    }
    
    static func hideCustomProgressHud() {
        if CustomProgressIsEnable == true {
            DispatchQueue.main.async {
                customProgressViewCont?.stopTimer()

                if customProgressViewCont?.isHaveAlertView == false {
                    CustomProgressViewWindow.windowLevel = UIWindow.Level(rawValue: -5)
                }
            }
        }
    }
    
    static func showViewInFullScreen(_ viewCont: UIViewController, animated flag: Bool = true) {
        if viewCont is UIAlertController {
            let alertController = (viewCont as! UIAlertController)
            alertController.transitioningDelegate = customProgressViewCont
            customProgressViewCont.isHaveAlertView = true
        }
        customProgressViewCont.bgImg.isHidden = true
        customProgressViewCont.iconImg.isHidden = true
        CustomProgressViewWindow.windowLevel = UIWindow.Level(rawValue: CGFloat.greatestFiniteMagnitude)
        customProgressViewCont.present(viewCont, animated: flag, completion: {
        })
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        CustomProgressViewWindow.windowLevel = UIWindow.Level(rawValue: -5)
        customProgressViewCont.isHaveAlertView = false
        return nil
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.alpha = 1.0
        blurEffectView.frame = bgImg.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        //bgImg.addSubview(blurEffectView)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func startTimer() {
        if timer == nil {
            self.bgImg.isHidden = false
            self.iconImg.isHidden = false
            self.iconImg.alpha = CGFloat(1.0)
            timer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(self.loop), userInfo: nil, repeats: true)
            self.loader.startAnimating()
        }
    }
    
    func stopTimer() {
        if timer != nil {
            self.bgImg.isHidden = true
            self.iconImg.isHidden = true
            timer?.invalidate()
            timer = nil
            self.loader.stopAnimating()
        }
    }
    
    @objc func loop() {
        if iconImg != nil {
            var newAlpga = 1.0
            if iconImg.alpha == 1.0 {
                newAlpga = 0.0
            }
            UIView.animate(withDuration: 0.5, delay: 0, options: UIView.AnimationOptions.curveEaseOut, animations: {
                self.iconImg.alpha = CGFloat(newAlpga)
                
            }, completion: nil)
        }
    }
}
