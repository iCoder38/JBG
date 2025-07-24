//
//  Extension_Class.swift
//  Jorgensen
//
//  Created by Shyam on 30/09/20.
//  Copyright © 2020 EVS. All rights reserved.
//

import UIKit

extension Notification.Name {
    static let notificationList = Notification.Name("NotificationList")
}

extension UIColor {
    
    convenience init(_ red: CGFloat,_ green: CGFloat, _ blue: CGFloat, _ alpha: CGFloat = 1) {
        self.init(cgColor: UIColor.init(red: red/255.0, green: green/255.0, blue: blue/255.0, alpha: alpha).cgColor)
    }
    
    class func appButtonColors() -> UIColor{
        //Old color code is = #1D5BAA
        //New color code is = #0271b9
        return UIColor.init(named: "Button_Color")!
    }
    
    class func appNavigationColors() -> UIColor{
        //Old color code is = #3091F5
        //New color code is = #11a5ff
        return UIColor.init(named: "App_Color")!
    }
    
    class func appRedColors() -> UIColor{
        return UIColor.init(named: "Btn_Red_Color")!
    }
    
}

extension UITextField {
    func setLeftPaddingPoints(_ amount:CGFloat){
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.leftView = paddingView
        self.leftViewMode = .always
    }
    func setRightPaddingPoints(_ amount:CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.rightView = paddingView
        self.rightViewMode = .always
    }
}

extension UIAlertController {
    
    func show() {
        present(animated: true, completion: nil)
    }
    
    func present(animated: Bool, completion: (() -> Void)?) {
        if let rootVC = UIApplication.shared.keyWindow?.rootViewController {
            presentFromController(controller: rootVC, animated: animated, completion: completion)
        }
    }
    
    private func presentFromController(controller: UIViewController, animated: Bool, completion: (() -> Void)?) {
        if let navVC = controller as? UINavigationController,
            let visibleVC = navVC.visibleViewController {
            presentFromController(controller: visibleVC, animated: animated, completion: completion)
        }  else {
            controller.present(self, animated: animated, completion: completion);
        }
    }
    
    func addAction(title: String?, style: UIAlertAction.Style, handler: ((UIAlertAction) -> Void)?) {
        let alertAction = UIAlertAction(title: title, style: style, handler: handler)
        self.addAction(alertAction)
    }
}

//MARK : - NSMutableData

extension NSMutableData {
    
    func appendString(string: String) {
        let data = string.data(using: String.Encoding.utf8, allowLossyConversion: true)
        append(data!)
    }
}

extension UIImage {
    func resizeImage(targetSize: CGSize) -> UIImage? {
           let size = self.size
           
           let widthRatio  = targetSize.width  / size.width
           let heightRatio = targetSize.height / size.height
           
           // Figure out what our orientation is, and use that to form the rectangle
           var newSize: CGSize
           if(widthRatio > heightRatio) {
               newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
           } else {
               newSize = CGSize(width: size.width * widthRatio,  height: size.height * widthRatio)
           }
           
           // This is the rect that we've calculated out and this is what is actually used below
           let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
           
           // Actually do the resizing to the rect using the ImageContext stuff
           UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
           self.draw(in: rect)
           let newImage = UIGraphicsGetImageFromCurrentImageContext()
           UIGraphicsEndImageContext()
           
           return newImage
       }
}
