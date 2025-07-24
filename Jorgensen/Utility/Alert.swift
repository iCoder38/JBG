//
//  Alert.swift
//  WaterTanker
//
//  Created by Shyam on 06/10/20.
//  Copyright © 2020 EVS. All rights reserved.
//

import UIKit

class Alert: NSObject {
    
    //MARK:- Show Tost Message...
    
    class func showTostMessage(message:String, delay:Double, controller:UIViewController!){
        let alert = UIAlertController(title: nil,
                                      message: message as String,
                                      preferredStyle: UIAlertController.Style.alert)
        alert.show()
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
            // do stuff 42 seconds later
            alert.dismiss(animated: true, completion: nil)
        }
        // Use
        //Alert.showTostMessage(message: "Server connection failed ! Please try later.", delay: 3.0, controller: self)
    }
    
    class func showAlert(alerttitle :String, alertmessage: String,ButtonTitle: String, viewController: UIViewController){
           let alertController = UIAlertController(title: alerttitle, message: alertmessage, preferredStyle: .alert)
           let okButtonOnAlertAction = UIAlertAction(title: ButtonTitle, style: .default)
           { (action) -> Void in
               //what happens when "ok" is pressed
           }
           alertController.addAction(okButtonOnAlertAction)
           alertController.show()
       }
}

extension Alert{
    class func createRequestBodyWith(parameters:[String:NSObject], filePathKey:String, boundary:String,fileName:NSString,image:UIImage) -> NSData{
        let body = NSMutableData()
        for (key, value) in parameters {
            body.appendString(string: "--\(boundary)\r\n")
            body.appendString(string: "Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n")
            body.appendString(string: "\(value)\r\n")
        }
        body.appendString(string: "--\(boundary)\r\n")
        let mimetype = "image/jpg"
        let defFileName = fileName as NSString
        let imageData = image.jpegData(compressionQuality: 0.5)
        body.appendString(string: "Content-Disposition: form-data; name=\"\(filePathKey)\"; filename=\"\(defFileName)\"\r\n")
        body.appendString(string: "Content-Type: \(mimetype)\r\n\r\n")
        body.append(imageData!)
        body.appendString(string: "\r\n")
        body.appendString(string: "--\(boundary)--\r\n")
        return body
    }

    class func generateBoundaryString() -> String {
        return "Boundary-\(NSUUID().uuidString)"
    }
    
    //MARK: - convert dictionary to json object string
    
    class func jsonStringWithJSONObject(dictionary:NSDictionary)->NSString {
        let data: NSData? = try? JSONSerialization.data(withJSONObject: dictionary, options: JSONSerialization.WritingOptions.prettyPrinted) as NSData
        var jsonStr: NSString?
        if data != nil {
            jsonStr = String(data: data! as Data, encoding: String.Encoding.utf8) as NSString?
        }
        return jsonStr!
    }
}
